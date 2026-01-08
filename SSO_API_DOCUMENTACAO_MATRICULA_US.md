# 🔐 Documentação da API SSO - Matrícula US

**Versão**: 1.0  
**Data**: 2026-01-02  
**Endpoint**: `https://pgdvbanwumqjmqeybqnw.supabase.co/functions/v1/validate-user-for-external`

---

## 📋 Visão Geral

Esta API permite que o Matrícula US valide tokens JWT emitidos pelo 323 Network, permitindo Single Sign-On (SSO) entre as duas plataformas.

### Fluxo de Autenticação

1. Usuário logado no 323 Network acessa página de serviços
2. Clica no serviço "Matrícula US"
3. 323 Network redireciona para Matrícula US com token JWT na URL
4. Matrícula US recebe token e chama esta API para validar
5. API retorna dados do usuário
6. Matrícula US cria/busca usuário e cria sessão

---

## 🔗 Endpoint

```
POST https://pgdvbanwumqjmqeybqnw.supabase.co/functions/v1/validate-user-for-external
```

---

## 📤 Request

### Headers

```
Authorization: Bearer {jwt_token}
Content-Type: application/json
```

### Body

Não é necessário enviar body. O token JWT deve estar no header `Authorization`.

### Exemplo (cURL)

```bash
curl -X POST \
  'https://pgdvbanwumqjmqeybqnw.supabase.co/functions/v1/validate-user-for-external' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' \
  -H 'Content-Type: application/json'
```

### Exemplo (JavaScript/TypeScript)

```typescript
const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'

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
```

---

## 📥 Response

### Sucesso (200 OK)

```json
{
  "valid": true,
  "user": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "user@example.com",
    "email_confirmed": true,
    "full_name": "João Silva",
    "first_name": "João",
    "last_name": "Silva",
    "phone": "+1234567890",
    "country": "USA",
    "created_at": "2024-01-01T00:00:00.000Z"
  }
}
```

### Erro - Token Inválido (401 Unauthorized)

```json
{
  "valid": false,
  "error": "Invalid or expired token"
}
```

### Erro - Header Ausente (401 Unauthorized)

```json
{
  "valid": false,
  "error": "Missing or invalid Authorization header"
}
```

### Erro - Servidor (500 Internal Server Error)

```json
{
  "valid": false,
  "error": "Internal server error",
  "details": "Error message details"
}
```

---

## 📊 Códigos de Status HTTP

| Código | Descrição | Quando Ocorre |
|--------|-----------|---------------|
| `200` | Sucesso | Token válido e usuário encontrado |
| `401` | Não Autorizado | Token inválido, expirado ou header ausente |
| `500` | Erro Interno | Erro no servidor ao processar requisição |

---

## 🔒 Segurança

### Validação do Token

- Token JWT é validado usando Service Role Key do 323 Network
- Token deve estar ativo e não expirado
- Validação é feita server-side (nunca confie no frontend)

### Dados Retornados

**✅ Incluídos:**
- ID do usuário
- Email
- Nome completo
- Primeiro nome
- Sobrenome
- Telefone (se disponível)
- País (se disponível)
- Data de criação

**❌ NUNCA Incluídos:**
- Senha
- Tokens internos
- Dados sensíveis
- Chaves de API

### CORS

- API aceita requisições de qualquer origem (`*`)
- Em produção, pode ser restrito ao domínio do Matrícula US

### Rate Limiting

- Atualmente não há rate limiting implementado
- Pode ser adicionado no futuro se necessário

---

## ⚠️ Tratamento de Erros

### Token Inválido ou Expirado

```typescript
if (!data.valid) {
  if (data.error === 'Invalid or expired token') {
    // Redirecionar usuário para fazer login novamente no 323 Network
    window.location.href = 'https://323network.com/login?redirect=...'
  }
}
```

### Usuário Não Encontrado

Se o token for válido mas o usuário não existir na tabela `profiles`, a API ainda retornará dados básicos do `auth.users` (email, ID, etc.).

### Erro de Rede

```typescript
try {
  const response = await fetch(...)
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`)
  }
  const data = await response.json()
} catch (error) {
  console.error('Erro ao validar token:', error)
  // Tratar erro (ex: mostrar mensagem ao usuário)
}
```

---

## 📝 Notas Importantes

1. **Token Expiração**: Tokens JWT do Supabase expiram após 1 hora. Se o token estiver expirado, o usuário precisará fazer login novamente no 323 Network.

2. **Validação Server-Side**: Sempre valide o token no servidor do Matrícula US. Não confie apenas no frontend.

3. **Criação de Usuário**: Após validar o token, você deve criar ou buscar o usuário no Matrícula US usando os dados retornados.

4. **Sessão**: Após criar/buscar usuário, crie uma sessão no Supabase do Matrícula US usando `supabase.auth.setSession()` ou similar.

---

## 🔄 Fluxo Completo de Integração

Veja o arquivo `SSO_EXEMPLO_IMPLEMENTACAO_MATRICULA_US.md` para exemplo completo de código.

---

## 📞 Suporte

Para dúvidas ou problemas, entre em contato com a equipe do 323 Network.

