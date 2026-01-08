# 🚀 Guia de Implementação: American Dream → 323 Network

**O que fazer no American Dream para integrar pagamentos**

---

## 📋 Checklist Rápido

- [ ] **Passo 1**: Obter a API Key compartilhada do 323 Network
- [ ] **Passo 2**: Criar função helper `syncPaymentTo323Network()`
- [ ] **Passo 3**: Integrar no webhook do Stripe (Card/Pix)
- [ ] **Passo 4**: Integrar na aprovação de comprovante Zelle
- [ ] **Passo 5**: Testar com pagamento real

---

## 🔑 Passo 1: Configurar API Key

**No projeto American Dream**, adicione a variável de ambiente:

```bash
# .env ou variáveis de ambiente do Supabase
AMERICAN_DREAM_SHARED_API_KEY=seu_token_aqui  # ⚠️ PRECISA GERAR (veja abaixo)
SUPABASE_323_NETWORK_URL=https://pgdvbanwumqjmqeybqnw.supabase.co  # ✅ Já tem valor
```

### Valores das Variáveis:

| Variável | Valor | Status |
|----------|-------|--------|
| `SUPABASE_323_NETWORK_URL` | `https://pgdvbanwumqjmqeybqnw.supabase.co` | ✅ Já configurado |
| `AMERICAN_DREAM_SHARED_API_KEY` | `[GERAR TOKEN]` | ⚠️ Precisa criar |

### Como Gerar o Token `AMERICAN_DREAM_SHARED_API_KEY`:

**Opção 1: Terminal (Linux/Mac)**
```bash
openssl rand -hex 32
```

**Opção 2: PowerShell (Windows)**
```powershell
[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Minimum 0 -Maximum 256 }))
```

**Opção 3: Gerador Online**
- https://www.uuidgenerator.net/
- Ou qualquer gerador de token aleatório

**⚠️ IMPORTANTE**: 
- Este token deve ser o MESMO nos dois projetos (323 Network e American Dream)
- Configure primeiro no 323 Network (Supabase Dashboard > Edge Functions > Secrets)
- Depois configure no American Dream com o mesmo valor

---

## 📦 Passo 2: Criar Função Helper

Crie o arquivo `utils/syncPaymentTo323Network.ts` (ou similar):

```typescript
/**
 * Sincroniza pagamento do American Dream com o 323 Network
 */

interface SyncPaymentPayload {
  user_id: string // UUID do usuário no 323 Network (lead.user_id)
  payment_id: string // ID do pagamento no American Dream
  lead_id?: string // ID do lead no American Dream
  amount: number // Valor em centavos (ex: 10000 = $100.00)
  currency?: string // 'USD' ou 'BRL' (padrão: 'USD')
  payment_method: 'card' | 'pix' | 'zelle'
  status: 'completed' | 'pending' | 'failed'
  stripe_session_id?: string
  stripe_payment_intent_id?: string
  metadata?: Record<string, any>
}

export async function syncPaymentTo323Network(payload: SyncPaymentPayload) {
  const SUPABASE_323_NETWORK_URL = Deno.env.get('SUPABASE_323_NETWORK_URL') || 
    'https://pgdvbanwumqjmqeybqnw.supabase.co'
  
  const API_KEY = Deno.env.get('AMERICAN_DREAM_SHARED_API_KEY')
  
  if (!API_KEY) {
    throw new Error('AMERICAN_DREAM_SHARED_API_KEY not configured')
  }

  try {
    const response = await fetch(
      `${SUPABASE_323_NETWORK_URL}/functions/v1/sync-american-dream-payment`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${API_KEY}`
        },
        body: JSON.stringify(payload)
      }
    )

    if (!response.ok) {
      const error = await response.json()
      console.error('Error syncing payment:', error)
      throw new Error(`Failed to sync payment: ${error.error || response.statusText}`)
    }

    const result = await response.json()
    console.log('✅ Payment synced successfully to 323 Network:', result)
    return result
  } catch (error) {
    console.error('❌ Error syncing payment to 323 Network:', error)
    // Não falhar o fluxo principal se a sincronização falhar
    // Apenas logar o erro para debug
    throw error
  }
}
```

---

## 💳 Passo 3: Integrar no Webhook do Stripe

**Localização**: Edge Function ou handler do webhook do Stripe no American Dream

**Quando chamar**: Quando o pagamento via Stripe (Card ou Pix) for confirmado

```typescript
// Exemplo: No webhook handler do Stripe
import { syncPaymentTo323Network } from '../utils/syncPaymentTo323Network.ts'

async function handleStripeWebhook(event: Stripe.Event) {
  // ... seu código existente de processamento do webhook ...

  if (event.type === 'checkout.session.completed' || 
      event.type === 'checkout.session.async_payment_succeeded') {
    
    const session = event.data.object as Stripe.Checkout.Session
    
    // 1. Obter dados do pagamento do American Dream
    const { data: payment, error: paymentError } = await supabase
      .from('payments')
      .select('*, leads(*)')
      .eq('stripe_session_id', session.id)
      .single()
    
    if (paymentError || !payment) {
      console.error('Payment not found:', paymentError)
      return // Continuar processamento normal mesmo se não encontrar
    }

    const lead = payment.leads
    
    // 2. Verificar se o lead tem user_id (sincronizado via SSO)
    if (!lead?.user_id) {
      console.warn('Lead does not have user_id - skipping 323 Network sync')
      return // Não sincronizar se não tiver user_id
    }

    // 3. Determinar método de pagamento
    const paymentMethod = session.payment_method_types?.includes('pix') 
      ? 'pix' 
      : 'card'

    // 4. Sincronizar com 323 Network
    try {
      await syncPaymentTo323Network({
        user_id: lead.user_id, // UUID do usuário no 323 Network
        payment_id: payment.id,
        lead_id: lead.id,
        amount: payment.amount, // Já deve estar em centavos
        currency: payment.currency || 'USD',
        payment_method: paymentMethod,
        status: 'completed',
        stripe_session_id: session.id,
        stripe_payment_intent_id: typeof session.payment_intent === 'string' 
          ? session.payment_intent 
          : (session.payment_intent as any)?.id,
        metadata: {
          american_dream_payment_id: payment.id,
          lead_id: lead.id,
          stripe_session_id: session.id
        }
      })
    } catch (error) {
      // Logar erro mas não falhar o processamento do webhook
      console.error('Failed to sync payment to 323 Network:', error)
      // Opcional: Enviar notificação ou criar log de erro
    }
  }
}
```

---

## 💵 Passo 4: Integrar na Aprovação de Zelle

**Localização**: Função/endpoint que aprova comprovante de Zelle manualmente

**Quando chamar**: Quando um admin aprovar um comprovante de pagamento Zelle

```typescript
// Exemplo: Função de aprovação de comprovante Zelle
import { syncPaymentTo323Network } from '../utils/syncPaymentTo323Network.ts'

async function approveZellePayment(paymentProofId: string) {
  // 1. Obter dados do comprovante e pagamento
  const { data: paymentProof, error: proofError } = await supabase
    .from('payment_proofs')
    .select('*, payments(*, leads(*))')
    .eq('id', paymentProofId)
    .single()
  
  if (proofError || !paymentProof) {
    throw new Error('Payment proof not found')
  }

  const payment = paymentProof.payments
  const lead = payment.leads

  // 2. Atualizar status do pagamento no American Dream
  const { error: updateError } = await supabase
    .from('payments')
    .update({ 
      status: 'completed',
      updated_at: new Date().toISOString()
    })
    .eq('id', payment.id)

  if (updateError) {
    throw new Error(`Failed to update payment: ${updateError.message}`)
  }

  // 3. Verificar se o lead tem user_id
  if (!lead?.user_id) {
    console.warn('Lead does not have user_id - skipping 323 Network sync')
    return // Não sincronizar se não tiver user_id
  }

  // 4. Sincronizar com 323 Network
  try {
    await syncPaymentTo323Network({
      user_id: lead.user_id, // UUID do usuário no 323 Network
      payment_id: payment.id,
      lead_id: lead.id,
      amount: payment.amount, // Já deve estar em centavos
      currency: payment.currency || 'USD',
      payment_method: 'zelle',
      status: 'completed',
      metadata: {
        american_dream_payment_id: payment.id,
        lead_id: lead.id,
        zelle_proof_id: paymentProof.id,
        approved_at: new Date().toISOString()
      }
    })
  } catch (error) {
    // Logar erro mas não falhar a aprovação
    console.error('Failed to sync Zelle payment to 323 Network:', error)
    // Opcional: Enviar notificação ou criar log de erro
  }
}
```

---

## 🧪 Passo 5: Testar

### Teste 1: Verificar se a função helper funciona

```typescript
// Teste manual (pode criar um endpoint de teste temporário)
import { syncPaymentTo323Network } from '../utils/syncPaymentTo323Network.ts'

// Substitua pelos valores reais
const testResult = await syncPaymentTo323Network({
  user_id: 'uuid-do-usuario-323-network',
  payment_id: 'test-payment-123',
  lead_id: 'uuid-do-lead',
  amount: 10000, // $100.00
  currency: 'USD',
  payment_method: 'card',
  status: 'completed'
})

console.log('Test result:', testResult)
```

### Teste 2: Verificar no 323 Network

1. Fazer login no 323 Network com o usuário de teste
2. Ir para "Meus Serviços"
3. Verificar se o pagamento aparece com badge "American Dream"

---

## ⚠️ Pontos Importantes

### 1. **User ID do 323 Network**

O `user_id` deve ser o UUID do usuário no **323 Network**, não no American Dream.

- ✅ **Correto**: `lead.user_id` (já sincronizado via SSO)
- ❌ **Errado**: `auth.users.id` do American Dream

**Como verificar**: 
- O campo `leads.user_id` no American Dream deve corresponder ao `auth.users.id` no 323 Network
- Se o lead não tiver `user_id`, significa que o usuário não foi sincronizado via SSO ainda

### 2. **Valor em Centavos**

O `amount` deve estar em **centavos**:
- ✅ `10000` = $100.00
- ✅ `5000` = $50.00
- ❌ `100` = $1.00 (errado se for $100)

### 3. **Tratamento de Erros**

A sincronização **não deve falhar** o fluxo principal de pagamento:
- Use `try/catch` para capturar erros
- Logue os erros para debug
- Continue o processamento normal mesmo se a sincronização falhar

### 4. **Idempotência**

A Edge Function é idempotente:
- Se você chamar com o mesmo `payment_id` várias vezes, não cria duplicatas
- Pode chamar novamente se houver dúvida se foi sincronizado

---

## 🔍 Debugging

### Verificar se está funcionando:

1. **Logs no American Dream**:
   - Verificar console.log da função `syncPaymentTo323Network`
   - Verificar se está chamando a URL correta

2. **Logs no 323 Network**:
   - Acessar Supabase Dashboard > Edge Functions > `sync-american-dream-payment` > Logs
   - Verificar se está recebendo as requisições

3. **Verificar no banco**:
   ```sql
   -- No 323 Network (Supabase SQL Editor)
   SELECT * FROM service_payments 
   WHERE source = 'american_dream' 
   ORDER BY created_at DESC 
   LIMIT 10;
   ```

### Erros Comuns:

**"User not found in 323 Network"**
- Causa: `lead.user_id` não existe ou está incorreto
- Solução: Verificar se o SSO está funcionando e sincronizando usuários

**"Invalid API key"**
- Causa: API key não configurada ou incorreta
- Solução: Verificar variável `AMERICAN_DREAM_SHARED_API_KEY` em ambos os projetos

**"Missing required fields"**
- Causa: Algum campo obrigatório não está sendo enviado
- Solução: Verificar se todos os campos estão no payload

---

## 📞 Suporte

Se tiver problemas:
1. Verificar logs da Edge Function no Supabase Dashboard do 323 Network
2. Verificar logs do webhook do Stripe no American Dream
3. Verificar se o `lead.user_id` está preenchido
4. Testar a função helper manualmente primeiro

---

## ✅ Checklist Final

Antes de considerar completo:

- [ ] API key configurada no American Dream
- [ ] Função `syncPaymentTo323Network()` criada
- [ ] Integração no webhook Stripe implementada
- [ ] Integração na aprovação Zelle implementada
- [ ] Testado com pagamento real via Stripe (Card)
- [ ] Testado com pagamento real via Stripe (Pix)
- [ ] Testado com aprovação manual de Zelle
- [ ] Verificado aparecimento em "Meus Serviços" do 323 Network
- [ ] Tratamento de erros implementado (não falha fluxo principal)

---

**Última atualização**: 2026-01-02

