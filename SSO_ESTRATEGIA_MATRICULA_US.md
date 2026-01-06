# 🔐 Estratégia de SSO: Integração 323 Network ↔ Matrícula US

**Data**: 2026-01-02  
**Status**: 📋 Planejamento  
**Contexto**: Matrícula US é plataforma estabelecida com **160 usuários ativos** (159 perfis únicos)

### **📊 Análise do Projeto Matrícula US:**

**Project ID**: `fitpynguasqqutuhzifx`  
**Project URL**: `https://fitpynguasqqutuhzifx.supabase.co`  
**Região**: `us-west-1`  
**Status**: `ACTIVE_HEALTHY`

**Estrutura de Autenticação:**
- ✅ Usa **Supabase Auth nativo** (`auth.users`)
- ✅ Tabela de perfis: `user_profiles` (160 registros)
- ✅ Relacionamento: `user_profiles.user_id` → `auth.users.id`
- ✅ Campos principais: `email`, `full_name`, `phone`, `country`, etc.

**Sistema:**
- Plataforma completa de bolsas de estudo
- Sistema de pagamentos (Stripe, Zelle)
- Gestão de documentos e aplicações
- Sistema de recompensas/afiliados
- Integração com universidades

---

## ⚠️ **CONSTRAINTS IMPORTANTES**

### **Por que NÃO podemos usar JWT Compartilhado:**

1. **160 usuários ativos** - Mudar JWT Secret quebraria todas as sessões
2. **Plataforma estabelecida** - Não podemos causar downtime
3. **Sistema em produção** - Qualquer mudança pode afetar usuários
4. **Risco alto** - Similar ao que aconteceu com American Dream (mas pior)
5. **Supabase Auth nativo** - Mudar JWT Secret afetaria toda a autenticação do sistema

### **O que precisamos:**
- ✅ Integração que **não requer mudanças** no Matrícula US
- ✅ **Zero downtime** para usuários existentes
- ✅ **Seguro** e confiável
- ✅ **Simples** de implementar e manter

---

## 🎯 **ESTRATÉGIAS RECOMENDADAS**

### **⭐ Opção 1: Edge Function de Validação (RECOMENDADA)**

#### **Como Funciona:**

```
┌─────────────────┐                    ┌──────────────────┐
│  323 Network    │                    │  Matrícula US    │
│                 │                    │                  │
│  User logado    │                    │  User clica      │
│  → Token JWT    │                    │  "Login com      │
│                 │                    │   323 Network"   │
└────────┬────────┘                    └────────┬─────────┘
         │                                       │
         │ 1. Redireciona com token              │
         │    ?token=xxx&returnTo=...            │
         └───────────────────────────────────────┘
                                               │
                                               ▼
         ┌───────────────────────────────────────────┐
         │  Matrícula US recebe token                 │
         │  Chama API do 323 Network:                 │
         │  POST /functions/v1/validate-user          │
         │  Headers: { Authorization: "Bearer xxx" }  │
         └───────────────────────────────────────────┘
                                               │
                                               ▼
         ┌───────────────────────────────────────────┐
         │  Edge Function valida token                │
         │  Retorna: {                                │
         │    valid: true,                            │
         │    user: { id, email, name, ... }          │
         │  }                                         │
         └───────────────────────────────────────────┘
                                               │
                                               ▼
         ┌───────────────────────────────────────────┐
         │  Matrícula US cria sessão própria         │
         │  com dados do usuário                     │
         └───────────────────────────────────────────┘
```

#### **Implementação no 323 Network:**

**1. Criar Edge Function: `validate-user-for-external`**

```typescript
// supabase/functions/validate-user-for-external/index.ts
import { serve } from "https://deno.land/std@0.190.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Obter token do header Authorization
    const authHeader = req.headers.get('Authorization')
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return new Response(
        JSON.stringify({ error: 'Missing or invalid Authorization header' }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 401,
        }
      )
    }

    const token = authHeader.replace('Bearer ', '')
    
    // Criar cliente Supabase com Service Role Key
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    
    const supabase = createClient(supabaseUrl, supabaseServiceKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    })

    // Validar token e obter usuário
    const { data: { user }, error } = await supabase.auth.getUser(token)

    if (error || !user) {
      return new Response(
        JSON.stringify({ valid: false, error: 'Invalid token' }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 401,
        }
      )
    }

    // Buscar profile do usuário
    const { data: profile } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.id)
      .single()

    // Retornar dados do usuário (sem informações sensíveis)
    // Formato compatível com Matrícula US (user_profiles)
    return new Response(
      JSON.stringify({
        valid: true,
        user: {
          id: user.id,
          email: user.email,
          email_confirmed: user.email_confirmed_at ? true : false,
          // Matrícula US usa 'full_name', então retornamos compatível
          full_name: profile?.first_name && profile?.last_name 
            ? `${profile.first_name} ${profile.last_name}`
            : profile?.first_name || user.email?.split('@')[0] || 'User',
          first_name: profile?.first_name || null,
          last_name: profile?.last_name || null,
          phone: profile?.phone || null,
          country: profile?.country || null,
          created_at: user.created_at,
        },
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    )
  } catch (error) {
    console.error('Error validating user:', error)
    return new Response(
      JSON.stringify({ valid: false, error: 'Internal server error' }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500,
      }
    )
  }
})
```

**2. Configurar Secrets:**
- `SUPABASE_URL`: URL do projeto 323 Network
- `SUPABASE_SERVICE_ROLE_KEY`: Service Role Key do 323 Network

**3. Deploy:**
```bash
supabase functions deploy validate-user-for-external
```

#### **Implementação no Matrícula US (lado deles):**

```typescript
// Exemplo de como Matrícula US pode usar
async function loginWith323Network(token: string) {
  try {
    // Chamar Edge Function do 323 Network
    const response = await fetch(
      'https://pgdvbanwumqjmqeybqnw.supabase.co/functions/v1/validate-user-for-external',
      {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      }
    )

    const data = await response.json()

    if (data.valid && data.user) {
      // Buscar usuário existente por email no Matrícula US
      const { data: existingUser } = await supabase
        .from('auth.users')
        .select('id')
        .eq('email', data.user.email)
        .single()

      let userId

      if (existingUser) {
        // Usuário já existe - usar ID existente
        userId = existingUser.id
        
        // Atualizar user_profiles se necessário
        await supabase
          .from('user_profiles')
          .update({
            full_name: data.user.full_name,
            phone: data.user.phone,
            country: data.user.country,
            updated_at: new Date().toISOString(),
          })
          .eq('user_id', userId)
      } else {
        // Criar novo usuário no Supabase Auth
        const { data: newUser, error: createError } = await supabase.auth.admin.createUser({
          email: data.user.email,
          email_confirm: data.user.email_confirmed,
          user_metadata: {
            full_name: data.user.full_name,
            source: '323-network',
            external_id: data.user.id, // ID do 323 Network
          },
        })

        if (createError) throw createError
        userId = newUser.user.id

        // Criar user_profiles
        await supabase
          .from('user_profiles')
          .insert({
            user_id: userId,
            email: data.user.email,
            full_name: data.user.full_name,
            phone: data.user.phone,
            country: data.user.country,
          })
      }

      // Criar sessão no Matrícula US usando Supabase Auth
      const { data: session, error: sessionError } = await supabase.auth.signInWithPassword({
        email: data.user.email,
        // Como não temos senha, precisamos usar admin API ou criar sessão diretamente
      })

      // Alternativa: usar admin API para criar sessão
      const { data: sessionData } = await supabase.auth.admin.generateLink({
        type: 'magiclink',
        email: data.user.email,
      })

      return { success: true, userId, session: sessionData }
    }

    return { success: false, error: 'Invalid token' }
  } catch (error) {
    console.error('Error validating 323 Network token:', error)
    return { success: false, error: 'Validation failed' }
  }
}
```

#### **Vantagens:**
- ✅ **Zero mudanças** no sistema do Matrícula US (só adiciona chamada API)
- ✅ **Não quebra** sistema existente
- ✅ **Seguro** (validação server-side)
- ✅ **Simples** de implementar
- ✅ **Reversível** (pode desativar a qualquer momento)

#### **Desvantagens:**
- ⚠️ Requer que Matrícula US faça chamada HTTP (latência mínima)
- ⚠️ Depende de API estar disponível

---

### **Opção 2: OAuth 2.0 / OIDC (Se Matrícula US suportar)**

#### **Como Funciona:**
- 323 Network atua como **OAuth Provider**
- Matrícula US atua como **OAuth Client**
- Fluxo OAuth padrão

#### **Implementação:**
1. Configurar 323 Network como OAuth Provider
2. Matrícula US registra como OAuth Client
3. Fluxo de autorização OAuth padrão

#### **Vantagens:**
- ✅ Padrão da indústria
- ✅ Muito seguro
- ✅ Escalável

#### **Desvantagens:**
- ⚠️ Requer que Matrícula US suporte OAuth
- ⚠️ Mais complexo de implementar
- ⚠️ Pode ser overkill para este caso

---

### **Opção 3: Magic Link / Token Temporário**

#### **Como Funciona:**
1. Usuário clica "Login com 323 Network" no Matrícula US
2. Redireciona para 323 Network
3. 323 Network gera token temporário único (válido 5-10 min)
4. Redireciona de volta para Matrícula US com token
5. Matrícula US valida token via API
6. Cria sessão própria

#### **Vantagens:**
- ✅ Token temporário (mais seguro)
- ✅ Simples de implementar
- ✅ Não requer mudanças grandes

#### **Desvantagens:**
- ⚠️ Token na URL (menos seguro que header)
- ⚠️ Requer redirecionamento

---

## 📋 **PLANO DE IMPLEMENTAÇÃO (Opção 1 - Recomendada)**

### **Fase 1: Preparação (323 Network)**
- [ ] Criar Edge Function `validate-user-for-external`
- [ ] Configurar secrets necessários
- [ ] Deploy da Edge Function
- [ ] Testar validação de tokens
- [ ] Documentar API (endpoint, formato de resposta)

### **Fase 2: Integração (Matrícula US)**
- [ ] Matrícula US adiciona botão "Login com 323 Network"
- [ ] Implementar chamada à Edge Function
- [ ] Criar/buscar usuário no Matrícula US
- [ ] Criar sessão própria
- [ ] Testar fluxo completo

### **Fase 3: Testes e Documentação**
- [ ] Testar com usuários reais
- [ ] Validar segurança
- [ ] Documentar para usuários finais
- [ ] Monitorar logs e erros

---

## 🔒 **SEGURANÇA**

### **Boas Práticas:**
1. **Rate Limiting**: Limitar chamadas à Edge Function
2. **CORS**: Configurar CORS adequadamente
3. **Logs**: Registrar tentativas de validação
4. **Timeout**: Tokens expiram automaticamente
5. **Validação**: Sempre validar token server-side

### **Dados Retornados:**
- ✅ ID do usuário
- ✅ Email
- ✅ Nome
- ✅ Telefone (se disponível)
- ❌ Senha (nunca)
- ❌ Tokens internos (nunca)

---

## 📊 **COMPARAÇÃO DAS OPÇÕES**

| Critério | Opção 1 (Edge Function) | Opção 2 (OAuth) | Opção 3 (Magic Link) |
|----------|------------------------|-----------------|----------------------|
| **Complexidade** | ⭐⭐ Baixa | ⭐⭐⭐⭐ Alta | ⭐⭐⭐ Média |
| **Segurança** | ⭐⭐⭐⭐ Alta | ⭐⭐⭐⭐⭐ Muito Alta | ⭐⭐⭐ Média |
| **Mudanças no Matrícula US** | ⭐ Mínimas | ⭐⭐⭐ Médias | ⭐⭐ Baixas |
| **Tempo de Implementação** | ⭐⭐ Rápido | ⭐⭐⭐⭐ Lento | ⭐⭐⭐ Médio |
| **Manutenibilidade** | ⭐⭐⭐⭐ Alta | ⭐⭐⭐ Média | ⭐⭐⭐ Média |

---

## 🎯 **RECOMENDAÇÃO FINAL**

**⭐ Usar Opção 1: Edge Function de Validação**

**Motivos:**
1. ✅ Mais simples de implementar
2. ✅ Requer mudanças mínimas no Matrícula US
3. ✅ Seguro o suficiente para o caso de uso
4. ✅ Rápido de implementar
5. ✅ Fácil de manter e debugar

---

## 📝 **PRÓXIMOS PASSOS**

1. **✅ CONFIRMADO - Matrícula US:**
   - ✅ Tecnologia: **Supabase** (mesmo que 323 Network!)
   - ✅ Project ID: `fitpynguasqqutuhzifx`
   - ✅ Estrutura: `auth.users` + `user_profiles`
   - ✅ 160 usuários ativos
   - ⏳ Pendente: Confirmar se podem fazer chamadas HTTP para API externa
   - ⏳ Pendente: Confirmar disponibilidade de desenvolvedor para integração

2. **Implementar Edge Function no 323 Network:**
   - Criar função de validação
   - Testar localmente
   - Deploy em produção

3. **Documentar API:**
   - Endpoint
   - Formato de request/response
   - Exemplos de código
   - Tratamento de erros

4. **Coordenar com Matrícula US:**
   - Fornecer documentação
   - Ajudar na implementação
   - Testar juntos

---

---

## ✅ **INFORMAÇÕES CONFIRMADAS**

### **Matrícula US:**
- ✅ **Tecnologia**: Supabase (mesmo stack do 323 Network!)
- ✅ **Project ID**: `fitpynguasqqutuhzifx`
- ✅ **Estrutura de Auth**: Supabase Auth nativo
- ✅ **Tabela de Perfis**: `user_profiles` (160 registros)
- ✅ **Campos principais**: `user_id`, `email`, `full_name`, `phone`, `country`

### **Vantagem Adicional:**
Como ambos usam **Supabase**, podemos:
- ✅ Usar a mesma biblioteca (`@supabase/supabase-js`)
- ✅ Estrutura similar facilita integração
- ✅ Possível usar Service Role Key para criar usuários diretamente (se necessário)

---

**Status**: 📋 Análise completa - Pronto para implementação da Edge Function no 323 Network

