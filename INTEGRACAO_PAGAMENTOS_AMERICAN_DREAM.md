# 💳 Integração de Pagamentos: American Dream → 323 Network

**Data**: 2026-01-02  
**Status**: ✅ Implementado

---

## 📋 Resumo

Esta integração permite que pagamentos realizados no **American Dream** apareçam automaticamente na página **"Meus Serviços"** do **323 Network**, proporcionando uma experiência unificada para os usuários.

---

## 🎯 Como Funciona

Quando um aluno paga no American Dream (primeira parte ou qualquer pagamento), o sistema:

1. **Detecta o pagamento confirmado** (via Stripe webhook, Zelle manual, etc.)
2. **Chama a Edge Function** `sync-american-dream-payment` do 323 Network
3. **Cria um registro** na tabela `service_payments` do 323 Network
4. **Aparece automaticamente** na página "Meus Serviços" do usuário

---

## 🔧 Implementação no American Dream

### 1. Configurar API Key Compartilhada

No projeto **323 Network** (Supabase), configure uma variável de ambiente:

```bash
AMERICAN_DREAM_SHARED_API_KEY=seu_token_secreto_aqui
```

**⚠️ IMPORTANTE**: Este token deve ser compartilhado entre os dois projetos para autenticação.

### 2. Chamar a Edge Function Quando Pagamento é Confirmado

O American Dream deve chamar a Edge Function em **3 cenários**:

#### **A) Pagamento via Stripe (Card ou Pix)**

Quando o webhook do Stripe confirmar o pagamento:

```typescript
// Exemplo: No webhook handler do Stripe no American Dream
async function handleStripeWebhook(event: Stripe.Event) {
  if (event.type === 'checkout.session.completed' || 
      event.type === 'checkout.session.async_payment_succeeded') {
    
    const session = event.data.object as Stripe.Checkout.Session
    
    // Obter dados do pagamento do American Dream
    const payment = await getPaymentFromDatabase(session.metadata.payment_id)
    const lead = await getLeadFromDatabase(payment.lead_id)
    
    // Obter user_id do 323 Network (via SSO)
    const userId323Network = lead.user_id // Já sincronizado via SSO
    
    // Chamar Edge Function do 323 Network
    await syncPaymentTo323Network({
      user_id: userId323Network,
      payment_id: payment.id,
      lead_id: lead.id,
      amount: payment.amount, // em centavos
      currency: payment.currency || 'USD',
      payment_method: session.payment_method_types[0] === 'card' ? 'card' : 'pix',
      status: 'completed',
      stripe_session_id: session.id,
      stripe_payment_intent_id: session.payment_intent as string,
      metadata: {
        american_dream_payment_id: payment.id,
        lead_id: lead.id
      }
    })
  }
}
```

#### **B) Pagamento via Zelle (Manual)**

Quando um comprovante de Zelle é aprovado manualmente:

```typescript
// Exemplo: Quando admin aprova comprovante de Zelle
async function approveZellePayment(paymentProofId: string) {
  const paymentProof = await getPaymentProof(paymentProofId)
  const payment = await getPayment(paymentProof.payment_id)
  const lead = await getLead(payment.lead_id)
  
  // Atualizar status do pagamento no American Dream
  await updatePaymentStatus(payment.id, 'completed')
  
  // Obter user_id do 323 Network (via SSO)
  const userId323Network = lead.user_id
  
  // Chamar Edge Function do 323 Network
  await syncPaymentTo323Network({
    user_id: userId323Network,
    payment_id: payment.id,
    lead_id: lead.id,
    amount: payment.amount,
    currency: payment.currency || 'USD',
    payment_method: 'zelle',
    status: 'completed',
    metadata: {
      american_dream_payment_id: payment.id,
      lead_id: lead.id,
      zelle_proof_id: paymentProof.id
    }
  })
}
```

#### **C) Função Helper para Sincronização**

Crie uma função helper no American Dream:

```typescript
// utils/syncPaymentTo323Network.ts
const SUPABASE_323_NETWORK_URL = 'https://seu-projeto-323-network.supabase.co'
const AMERICAN_DREAM_API_KEY = process.env.AMERICAN_DREAM_SHARED_API_KEY

interface SyncPaymentPayload {
  user_id: string // UUID do usuário no 323 Network
  payment_id: string // ID do pagamento no American Dream
  lead_id?: string // ID do lead no American Dream
  amount: number // Valor em centavos
  currency?: string // 'USD' ou 'BRL'
  payment_method: 'card' | 'pix' | 'zelle'
  status: 'completed' | 'pending' | 'failed'
  stripe_session_id?: string
  stripe_payment_intent_id?: string
  metadata?: Record<string, any>
}

export async function syncPaymentTo323Network(payload: SyncPaymentPayload) {
  try {
    const response = await fetch(
      `${SUPABASE_323_NETWORK_URL}/functions/v1/sync-american-dream-payment`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${AMERICAN_DREAM_API_KEY}`
        },
        body: JSON.stringify(payload)
      }
    )

    if (!response.ok) {
      const error = await response.json()
      throw new Error(`Failed to sync payment: ${error.error}`)
    }

    const result = await response.json()
    console.log('Payment synced successfully:', result)
    return result
  } catch (error) {
    console.error('Error syncing payment to 323 Network:', error)
    throw error
  }
}
```

---

## 📊 Estrutura de Dados

### Payload da Edge Function

```typescript
{
  user_id: string          // UUID do usuário no 323 Network (obtido via SSO)
  payment_id: string       // ID do pagamento no American Dream
  lead_id?: string         // ID do lead no American Dream (opcional)
  amount: number           // Valor em centavos (ex: 10000 = $100.00)
  currency?: string        // 'USD' ou 'BRL' (padrão: 'USD')
  payment_method: string   // 'card' | 'pix' | 'zelle'
  status: string           // 'completed' | 'pending' | 'failed'
  stripe_session_id?: string      // Se pagamento via Stripe
  stripe_payment_intent_id?: string // Se pagamento via Stripe
  metadata?: object        // Dados adicionais (opcional)
}
```

### Resposta da Edge Function

**Sucesso:**
```json
{
  "success": true,
  "message": "Payment synced successfully",
  "payment_id": "uuid-do-pagamento-323-network",
  "service_request_id": "uuid-do-service-request",
  "status": "created"
}
```

**Erro:**
```json
{
  "success": false,
  "error": "Mensagem de erro"
}
```

---

## 🔐 Autenticação

A Edge Function aceita autenticação via:

1. **API Key Compartilhada** (recomendado):
   - Configurar `AMERICAN_DREAM_SHARED_API_KEY` no 323 Network
   - Enviar no header: `Authorization: Bearer {API_KEY}`

2. **Token JWT Compartilhado** (alternativa):
   - Usar o mesmo JWT Secret compartilhado do SSO
   - Enviar token JWT válido no header

---

## 🎨 Visualização no 323 Network

Os pagamentos do American Dream aparecem na página **"Meus Serviços"** com:

- ✅ **Badge "American Dream"** (azul) para identificar origem
- ✅ **Método de pagamento** (Card, Pix ou Zelle)
- ✅ **Valor pago** e data
- ✅ **Status** do serviço

---

## ⚠️ Pontos Importantes

### 1. **User ID do 323 Network**

O `user_id` deve ser o UUID do usuário no **323 Network**, não no American Dream. Como o SSO já sincroniza usuários, o `lead.user_id` no American Dream deve corresponder ao `auth.users.id` no 323 Network.

### 2. **Idempotência**

A Edge Function é **idempotente**: se você chamar com o mesmo `payment_id` (via `external_payment_id`), ela atualizará o registro existente ao invés de criar duplicado.

### 3. **Status do Pagamento**

- ✅ **`completed`**: Pagamento confirmado (aparece em "Meus Serviços")
- ⏳ **`pending`**: Pagamento pendente (não aparece ainda)
- ❌ **`failed`**: Pagamento falhou (não aparece)

### 4. **Métodos de Pagamento Suportados**

- ✅ **Card** (via Stripe)
- ✅ **Pix** (via Stripe)
- ✅ **Zelle** (manual, após aprovação de comprovante)

---

## 🧪 Testando a Integração

### 1. Teste Manual

```bash
curl -X POST https://seu-projeto-323-network.supabase.co/functions/v1/sync-american-dream-payment \
  -H "Authorization: Bearer {AMERICAN_DREAM_SHARED_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "uuid-do-usuario-323-network",
    "payment_id": "uuid-pagamento-american-dream",
    "lead_id": "uuid-lead-american-dream",
    "amount": 10000,
    "currency": "USD",
    "payment_method": "card",
    "status": "completed",
    "stripe_session_id": "cs_test_...",
    "stripe_payment_intent_id": "pi_..."
  }'
```

### 2. Verificar no 323 Network

1. Fazer login no 323 Network
2. Ir para "Meus Serviços"
3. Verificar se o pagamento aparece com badge "American Dream"

---

## 📝 Checklist de Implementação no American Dream

- [ ] Configurar `AMERICAN_DREAM_SHARED_API_KEY` no 323 Network
- [ ] Criar função helper `syncPaymentTo323Network()` no American Dream
- [ ] Integrar chamada no webhook do Stripe (Card/Pix)
- [ ] Integrar chamada na aprovação de comprovante Zelle
- [ ] Testar com pagamento real
- [ ] Verificar aparecimento em "Meus Serviços" do 323 Network

---

## 🔄 Fluxo Completo

```
1. Aluno paga no American Dream
   ↓
2. American Dream processa pagamento
   (Stripe webhook OU aprovação Zelle)
   ↓
3. American Dream chama Edge Function
   POST /functions/v1/sync-american-dream-payment
   ↓
4. 323 Network cria registro em service_payments
   ↓
5. Aluno vê pagamento em "Meus Serviços"
   (com badge "American Dream")
```

---

## 🆘 Troubleshooting

### Erro: "User not found in 323 Network"

**Causa**: O `user_id` não existe no 323 Network ou não está sincronizado via SSO.

**Solução**: 
- Verificar se o lead tem `user_id` preenchido no American Dream
- Verificar se o SSO está funcionando corretamente
- Sincronizar usuário antes de processar pagamento

### Erro: "Invalid API key"

**Causa**: A API key não está configurada ou está incorreta.

**Solução**:
- Verificar variável `AMERICAN_DREAM_SHARED_API_KEY` no 323 Network
- Verificar se está sendo enviada corretamente no header

### Pagamento não aparece em "Meus Serviços"

**Causa**: Status não é `completed` ou erro na sincronização.

**Solução**:
- Verificar logs da Edge Function
- Verificar se o status é `completed`
- Verificar se o `user_id` está correto

---

## 📞 Suporte

Para dúvidas ou problemas, verificar:
1. Logs da Edge Function no Supabase Dashboard
2. Logs do webhook do Stripe no American Dream
3. Tabela `service_payments` no 323 Network

---

**Última atualização**: 2026-01-02

