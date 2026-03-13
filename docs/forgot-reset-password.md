# Fluxo de Recuperação de Senha (Forgot / Reset Password)

> Documentação técnica para replicação do fluxo em outros projetos Vue 3 + Supabase.

---

## 1. Visão Geral

O fluxo é dividido em **duas etapas**:

| Etapa | Rota | Componente | Descrição |
|-------|------|------------|-----------|
| 1 | `/forgot-password` | `ForgotPassword.vue` | Usuário informa o e-mail e recebe o link de recuperação |
| 2 | `/reset-password` | `ResetPassword.vue` | Usuário define a nova senha após clicar no link do e-mail |

O Supabase gerencia todo o envio de e-mail e a geração do token temporário.

---

## 2. Arquitetura de Arquivos

```
src/
├── views/
│   ├── ForgotPassword.vue       ← Etapa 1: solicitar recuperação
│   └── ResetPassword.vue        ← Etapa 2: definir nova senha
├── stores/
│   └── auth.ts                  ← Métodos resetPassword() e updatePassword()
├── router/
│   └── index.ts                 ← Rotas + guard especial para token de recovery
└── i18n/
    └── locales/
        ├── pt-BR.json           ← Chaves de tradução (namespace "auth")
        └── en-US.json
```

---

## 3. Roteamento (`router/index.ts`)

### 3.1 Definição das rotas

```ts
{
  path: '/forgot-password',
  name: 'ForgotPassword',
  component: () => import('@/views/ForgotPassword.vue'),
  meta: { requiresGuest: true },   // Apenas usuários não-logados
},
{
  path: '/reset-password',
  name: 'ResetPassword',
  component: () => import('@/views/ResetPassword.vue'),
  // SEM requiresGuest: o Supabase cria uma sessão temporária de recovery
},
```

> **⚠️ Atenção**: A rota `/reset-password` **não deve** ter `requiresGuest: true`, porque o Supabase abre uma sessão de autenticação temporária (tipo `recovery`) para permitir a troca de senha.

### 3.2 Guard especial para interceptar o token na raiz

O Supabase envia o e-mail com um link que redireciona para o **domínio raiz** (`/`) com o token no hash da URL. O guard intercepta isso e redireciona para `/reset-password` preservando o hash:

```ts
router.beforeEach(async (to, _from, next) => {
  if (to.path === '/' || to.path === '') {
    const hash = window.location.hash
    const hashParams = new URLSearchParams(hash.substring(1))
    const type = hashParams.get('type')
    const accessToken = hashParams.get('access_token')

    if (type === 'recovery' && accessToken) {
      next({
        path: '/reset-password',
        hash: hash,   // ← CRUCIAL: preservar o token no hash
        replace: true
      })
      return
    }
  }
  // ... restante do guard
})
```

### 3.3 Páginas que bypassam certas verificações do guard

As rotas abaixo são incluídas na lista de `publicLegalRoutes` para não serem redirecionadas por guard de termos/onboarding:

```ts
const publicLegalRoutes = [
  '/forgot-password',
  '/reset-password',
  // ...
]
```

E na verificação de `requiresGuest`, as páginas de password são excluídas do redirect para `/home`:

```ts
const publicPages = ['/forgot-password', '/reset-password']
const isPublicPage = publicPages.includes(to.path)

if (requiresGuest && authStore.user && !isPublicPage) {
  next({ name: 'Home' })
  return
}
```

---

## 4. Store de Autenticação (`stores/auth.ts`)

### 4.1 `resetPassword(email: string)`

Chama a API do Supabase para enviar o e-mail de recuperação.

```ts
async function resetPassword(email: string) {
  loading.value = true
  error.value = null
  try {
    const { error: resetError } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/reset-password`,
      // ↑ URL para onde o Supabase vai redirecionar após o clique no link
    })
    if (resetError) throw resetError
    return { success: true }
  } catch (err: any) {
    error.value = err.message
    return { success: false, error: err.message }
  } finally {
    loading.value = false
  }
}
```

**Pontos importantes:**
- `redirectTo` deve apontar para `/reset-password` do seu domínio
- O retorno é sempre `{ success: boolean }` — nunca lança exceção para o componente
- `loading` e `error` são reativos (ref do Pinia) e controlam o estado na UI

### 4.2 `updatePassword(newPassword: string)`

Salva a nova senha na sessão de recovery ativa.

```ts
async function updatePassword(newPassword: string) {
  loading.value = true
  error.value = null
  try {
    const { error: updateError } = await supabase.auth.updateUser({
      password: newPassword,
    })
    if (updateError) throw updateError
    return { success: true }
  } catch (err: any) {
    error.value = err.message
    return { success: false, error: err.message }
  } finally {
    loading.value = false
  }
}
```

**Comportamento após sucesso no `ResetPassword.vue`:**
1. Seta `passwordUpdated = true` (mostra mensagem de sucesso)
2. Chama `authStore.signOut()` para encerrar a sessão temporária de recovery
3. Redireciona para `/login` após 3 segundos

**Comportamento após falha:**
- Exibe mensagem de erro (sem redirecionar)
- Também faz `signOut()` para evitar que a sessão de recovery permaneça ativa

---

## 5. Componente `ForgotPassword.vue`

### 5.1 Estado local

```ts
const email = ref('')
const emailSent = ref(false)
const resendingEmail = ref(false)
const resendCooldown = ref(0)
let resendCooldownTimer: ReturnType<typeof setInterval> | null = null
```

### 5.2 Pré-preenchimento do e-mail via query string

Suporta chegar com `?email=usuario@example.com` na URL (útil para deep-links):

```ts
onMounted(() => {
  const emailFromQuery = route.query.email as string
  if (emailFromQuery) {
    email.value = emailFromQuery
  }
})
```

### 5.3 Fluxo principal

```ts
async function handleResetPassword() {
  if (!email.value.trim()) return

  const result = await authStore.resetPassword(email.value)
  if (result.success) {
    emailSent.value = true
    startResendCooldown()   // Inicia cooldown de 60s para reenvio
  }
}
```

### 5.4 Reenvio com cooldown de 60 segundos

```ts
async function handleResendEmail() {
  if (!email.value.trim() || resendCooldown.value > 0) return

  resendingEmail.value = true
  try {
    const result = await authStore.resetPassword(email.value)
    if (result.success) {
      startResendCooldown()
    }
  } finally {
    resendingEmail.value = false
  }
}

function startResendCooldown() {
  resendCooldown.value = 60
  if (resendCooldownTimer) clearInterval(resendCooldownTimer)

  resendCooldownTimer = setInterval(() => {
    resendCooldown.value--
    if (resendCooldown.value <= 0) {
      clearInterval(resendCooldownTimer!)
      resendCooldownTimer = null
    }
  }, 1000)
}

// Limpeza do timer no unmount para evitar memory leak
onUnmounted(() => {
  if (resendCooldownTimer) {
    clearInterval(resendCooldownTimer)
    resendCooldownTimer = null
  }
})
```

### 5.5 Estados da UI

| Estado | Condição | O que é exibido |
|--------|----------|-----------------|
| Formulário | `!emailSent` | Input de e-mail + botão "Enviar Link" |
| Sucesso | `emailSent` | Mensagem de confirmação + botão reenviar (com cooldown) |
| Erro | `authStore.error && !emailSent` | Banner de erro vermelho |
| Loading | `authStore.loading` | Botão desabilitado com spinner |

---

## 6. Componente `ResetPassword.vue`

### 6.1 Estado local

```ts
const password = ref('')
const confirmPassword = ref('')
const passwordUpdated = ref(false)
const errorMessage = ref<string | null>(null)

const passwordMismatch = computed(() =>
  password.value && confirmPassword.value && password.value !== confirmPassword.value
)
```

### 6.2 Validação do token ao montar (`onMounted`)

Esta é a lógica mais crítica do fluxo. O Supabase pode retornar erros **tanto no hash** quanto na **query string**:

```ts
onMounted(async () => {
  // 1. Verificar erros via query string (vue-router)
  const queryError = route.query.error as string
  const queryErrorDesc = route.query.error_description as string

  // 2. Verificar erros via hash (URLSearchParams manual)
  const hashParams = new URLSearchParams(window.location.hash.substring(1))
  const hashError = hashParams.get('error')
  const hashErrorDesc = hashParams.get('error_description')

  const error = queryError || hashError
  const errorDescription = queryErrorDesc || hashErrorDesc

  if (error) {
    let message = 'Link inválido ou expirado.'
    if (errorDescription) {
      const desc = errorDescription.toLowerCase()
      if (desc.includes('expired')) {
        message = 'O link de recuperação expirou ou já foi utilizado...'
      } else if (desc.includes('invalid')) {
        message = 'O link de recuperação é inválido...'
      }
    }
    errorMessage.value = message
    // Redirecionar após 7 segundos
    setTimeout(() => router.push('/login'), 7000)
    return
  }

  // 3. Verificar se há access_token no hash
  const accessToken = hashParams.get('access_token')
  const type = hashParams.get('type')

  if (!accessToken && !error) {
    errorMessage.value = 'Link de recuperação inválido ou não detectado...'
    setTimeout(() => router.push('/login'), 5000)
  } else if (accessToken && type !== 'recovery') {
    errorMessage.value = 'Tipo de autenticação inválido para esta página.'
  }
})
```

> **Por que verificar hash e query string?**
> O Supabase pode passar o token tanto no fragmento da URL (`#access_token=...`) quanto em parâmetros de query, dependendo da versão e configuração. A lógica cobre ambos os casos.

### 6.3 Mensagens de erro amigáveis

```ts
function getErrorMessage(error: any): string {
  const errorMsg = error?.message || error || 'Erro desconhecido'

  if (errorMsg.toLowerCase().includes('same') || errorMsg.toLowerCase().includes('igual')) {
    return 'A nova senha deve ser diferente da senha atual.'
  }
  if (errorMsg.toLowerCase().includes('weak') || errorMsg.toLowerCase().includes('fraca')) {
    return 'A senha é muito fraca. Use uma senha mais forte.'
  }
  if (errorMsg.toLowerCase().includes('invalid') || errorMsg.toLowerCase().includes('inválido')) {
    return 'A senha informada é inválida. Tente novamente.'
  }
  return errorMsg
}
```

### 6.4 Submissão do formulário

```ts
async function handleUpdatePassword() {
  if (passwordMismatch.value || !password.value) return

  errorMessage.value = null
  authStore.error = null

  try {
    const result = await authStore.updatePassword(password.value)

    if (result.success) {
      passwordUpdated.value = true
      await authStore.signOut()                      // Encerra sessão de recovery
      setTimeout(() => router.push('/login'), 3000)  // Redireciona após 3s
    } else {
      errorMessage.value = getErrorMessage(result.error)
      await authStore.signOut()  // Encerra sessão mesmo em caso de falha
    }
  } catch (error: any) {
    errorMessage.value = getErrorMessage(error)
    await authStore.signOut()
  }
}
```

### 6.5 Estados da UI

| Estado | Condição | O que é exibido |
|--------|----------|-----------------|
| Formulário | `!passwordUpdated` | 2 inputs de senha + botão |
| Senha não coincide | `passwordMismatch` | Texto de erro inline + botão desabilitado |
| Erro de token | `errorMessage && !passwordUpdated` | Banner de erro + redirect automático |
| Sucesso | `passwordUpdated` | Banner verde + botão "Ir para Login" |
| Loading | `authStore.loading` | Botão desabilitado com spinner |

---

## 7. Design e Layout

### 7.1 Estrutura visual (ambos os componentes)

```
┌─────────────────────┬─────────────────────┐
│   LADO ESQUERDO     │   LADO DIREITO       │
│   (lg: visível)     │   (sempre visível)   │
│                     │                      │
│  Logo + título      │  ← Voltar ao login   │
│  Texto decorativo   │  Título do form      │
│  Blobs animados     │  Formulário          │
│                     │  Mensagens de status │
└─────────────────────┴─────────────────────┘
```

- Layout **split-screen** responsivo: `hidden lg:flex w-1/2` para o lado esquerdo
- No mobile: apenas o lado direito (formulário), com blobs de fundo visíveis

### 7.2 Animação dos blobs de fundo

```css
@keyframes pulse-glow {
  0%, 100% { opacity: 0.8; filter: blur(40px); transform: scale(1); }
  50%      { opacity: 0.5; filter: blur(60px); transform: scale(1.1); }
}
.animate-glow {
  animation: pulse-glow 5s infinite;
}
```

### 7.3 Efeito Glass (lado esquerdo - ForgotPassword)

```css
.glass {
  background: rgba(15, 23, 42, 0.6);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.05);
}
```

### 7.4 Inputs (Tailwind)

```html
<input class="block w-full pl-10 pr-3 py-3.5
              border border-slate-300 dark:border-slate-700
              rounded-xl
              bg-white dark:bg-slate-900/50
              text-slate-900 dark:text-white
              focus:outline-none focus:ring-1 focus:ring-primary focus:border-primary
              focus:shadow-[0_0_15px_rgba(6,182,212,0.3)]
              transition-all duration-300 sm:text-sm" />
```

- Ícone SVG posicionado com `absolute inset-y-0 left-0 pl-3`
- Sombra colorida no foco (`focus:shadow-[...]`) para destaque visual
- Suporte a dark mode nativo via classes `dark:`

---

## 8. Internacionalização (i18n)

### 8.1 Setup

```ts
import { useI18n } from 'vue-i18n'
const { t } = useI18n()
```

### 8.2 Chaves usadas no `ForgotPassword.vue`

| Chave | pt-BR |
|-------|-------|
| `auth.forgotPasswordTitle` | Recuperar Senha |
| `auth.forgotPasswordDescription` | Digite seu email e enviaremos um link... |
| `auth.forgotPasswordHeading` | Esqueceu sua senha? |
| `auth.forgotPasswordSubtitle` | Não se preocupe! Enviaremos instruções... |
| `auth.backToLogin` | Voltar para login |
| `auth.emailSentTitle` | Email enviado! |
| `auth.emailSentMessage` | Verifique sua caixa de entrada... |
| `auth.emailNotReceived` | O email não chegou? |
| `auth.requestAgain` | Solicite novamente |
| `auth.requestAgainIn` | Solicite novamente em {seconds}s |
| `auth.sendResetLink` | Enviar Link de Recuperação |
| `auth.email` | E-mail |
| `auth.error` | Erro |
| `auth.copyright` | © 2025 (323) Network... |

### 8.3 Chaves usadas no `ResetPassword.vue`

| Chave | pt-BR |
|-------|-------|
| `auth.resetPasswordTitle` | Nova Senha |
| `auth.resetPasswordDescription` | Digite sua nova senha para continuar. |
| `auth.createNewPassword` | Redefinir Senha |
| `auth.createNewPasswordSubtitle` | Digite sua nova senha abaixo. |
| `auth.newPassword` | Nova Senha |
| `auth.confirmPassword` | Confirmar Nova Senha |
| `auth.passwordPlaceholder` | •••••••• |
| `auth.confirmPasswordPlaceholder` | •••••••• |
| `auth.changePassword` | Redefinir Senha |
| `auth.passwordChangedTitle` | Senha atualizada! |
| `auth.passwordChangedMessage` | Sua senha foi redefinida com sucesso... |
| `auth.goToLogin` | Ir para Login |
| `auth.passwordsDoNotMatch` | As senhas não coincidem |
| `auth.backToLogin` | Voltar para login |
| `auth.error` | Erro |
| `auth.copyright` | © 2025 (323) Network... |

---

## 9. Dependências e Componentes Reutilizáveis

| Componente | Localização | Função |
|-----------|-------------|--------|
| `Button` | `@/components/ui/Button.vue` | Botão com variantes `primary`/`outline`, prop `:loading`, `:disabled`, `full-width` |
| `AnimatedThemeToggler` | `@/components/ui/AnimatedThemeToggler.vue` | Toggle entre dark/light mode |
| `LanguageSwitcher` | `@/components/ui/LanguageSwitcher.vue` | Troca de idioma (en/pt) |
| `AppHeader` | `@/components/layout/AppHeader.vue` | Header do app (usado no `ResetPassword.vue` com `:show-navigation="false"`) |

---

## 10. Fluxo Completo (Diagrama)

```
Usuário clica em "Esqueceu a senha?"
          │
          ▼
   /forgot-password
          │
Preenche e-mail → handleResetPassword()
          │
          ▼
supabase.auth.resetPasswordForEmail(email, { redirectTo: '/reset-password' })
          │
          ▼
  [Supabase envia e-mail]
          │
          ▼
 emailSent = true → UI mostra confirmação
          │
          ▼
  [Usuário clica no link do e-mail]
          │
          ▼
 Supabase redireciona para:
 https://seudominio.com/#access_token=...&type=recovery
          │
          ▼
 router guard intercepta "/" com type=recovery
          │
          ▼
 next({ path: '/reset-password', hash: '...' })
          │
          ▼
   /reset-password
          │
 onMounted(): verifica hash, valida token
          │
   ┌──────┴──────┐
   │ Token OK    │ Token Inválido/Expirado
   │             │
   ▼             ▼
 Formulário  errorMessage + redirect(7s) → /login
  de senha
     │
Preenche nova senha → handleUpdatePassword()
     │
     ▼
supabase.auth.updateUser({ password })
     │
     ▼
 passwordUpdated = true
 authStore.signOut()     ← encerra sessão de recovery
 redirect(3s) → /login
```

---

## 11. Checklist para Replicar em Outro Projeto

- [ ] Criar `ForgotPassword.vue` com form de e-mail e lógica de cooldown de 60s
- [ ] Criar `ResetPassword.vue` com form de nova senha e validação do hash
- [ ] Adicionar `resetPassword()` e `updatePassword()` ao auth store (Pinia)
- [ ] Configurar rotas `/forgot-password` (com `requiresGuest`) e `/reset-password` (sem guard)
- [ ] Adicionar guard no `beforeEach` para interceptar `type=recovery` na rota `/`
- [ ] Adicionar `/forgot-password` e `/reset-password` à lista de `publicLegalRoutes` e `publicPages`
- [ ] Configurar `redirectTo` no Supabase apontando para `${origin}/reset-password`
- [ ] No painel do Supabase, verificar se o domínio está na lista de URL允许 (Site URL + Redirect URLs)
- [ ] Adicionar as chaves de i18n no namespace `auth`
- [ ] Garantir que o `Button` component suporte prop `:loading` e `:disabled`
- [ ] Limpar o `setInterval` do cooldown no `onUnmounted`

---

## 12. Configuração no Painel Supabase

No painel **Authentication > URL Configuration**:

| Campo | Valor |
|-------|-------|
| **Site URL** | `https://seudominio.com` |
| **Redirect URLs** | `https://seudominio.com/reset-password` |

> Se não configurar o Redirect URL, o Supabase bloqueará o redirecionamento por segurança.
