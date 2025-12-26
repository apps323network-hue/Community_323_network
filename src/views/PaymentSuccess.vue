<template>
  <AppLayout hideSidebars>
    <div class="min-h-[60vh] flex flex-col items-center justify-center px-4">
      <!-- Loading State -->
      <div v-if="loading" class="flex flex-col items-center gap-4">
        <div class="w-12 h-12 border-4 border-secondary border-t-transparent rounded-full animate-spin"></div>
        <p class="text-gray-400">Verificando pagamento...</p>
      </div>

      <!-- Success State -->
      <div v-else-if="paymentStatus === 'completed'" class="flex flex-col items-center text-center max-w-md">
        <div class="w-20 h-20 rounded-full bg-gradient-to-r from-secondary to-primary flex items-center justify-center mb-6 shadow-[0_0_40px_rgba(0,243,255,0.4)]">
          <span class="material-symbols-outlined text-4xl text-black">check</span>
        </div>
        <h1 class="text-3xl font-bold text-white mb-3">Pagamento Confirmado!</h1>
        <p class="text-gray-400 mb-6">
          Seu pagamento foi processado com sucesso. O parceiro responsável entrará em contato em breve para iniciar o atendimento.
        </p>
        <div v-if="serviceName" class="p-4 rounded-lg bg-white/5 border border-white/10 w-full mb-6">
          <p class="text-xs text-gray-500 mb-1">Serviço contratado</p>
          <p class="text-white font-bold">{{ serviceName }}</p>
        </div>
        <div class="flex gap-4">
          <RouterLink
            to="/meus-pedidos"
            class="px-6 py-3 rounded-lg bg-gradient-to-r from-primary to-secondary text-black font-bold transition-all hover:shadow-[0_0_20px_rgba(244,37,244,0.4)]"
          >
            Ver Meus Pedidos
          </RouterLink>
          <RouterLink
            to="/servicos"
            class="px-6 py-3 rounded-lg border border-white/10 text-gray-300 hover:bg-white/5 transition-colors"
          >
            Voltar aos Serviços
          </RouterLink>
        </div>
      </div>

      <!-- Pending State (PIX) -->
      <div v-else-if="paymentStatus === 'pending'" class="flex flex-col items-center text-center max-w-md">
        <div class="w-20 h-20 rounded-full bg-yellow-500/20 border border-yellow-500/50 flex items-center justify-center mb-6">
          <span class="material-symbols-outlined text-4xl text-yellow-500">schedule</span>
        </div>
        <h1 class="text-3xl font-bold text-white mb-3">Aguardando Pagamento</h1>
        <p class="text-gray-400 mb-6">
          Seu pagamento via PIX está sendo processado. Assim que for confirmado, você receberá uma notificação.
        </p>
        <RouterLink
          to="/meus-pedidos"
          class="px-6 py-3 rounded-lg bg-gradient-to-r from-primary to-secondary text-black font-bold"
        >
          Ver Meus Pedidos
        </RouterLink>
      </div>

      <!-- Error State -->
      <div v-else class="flex flex-col items-center text-center max-w-md">
        <div class="w-20 h-20 rounded-full bg-red-500/20 border border-red-500/50 flex items-center justify-center mb-6">
          <span class="material-symbols-outlined text-4xl text-red-500">error</span>
        </div>
        <h1 class="text-3xl font-bold text-white mb-3">Erro na Verificação</h1>
        <p class="text-gray-400 mb-6">
          Não foi possível verificar seu pagamento. Caso tenha completado o pagamento, aguarde alguns minutos e verifique seu email.
        </p>
        <RouterLink
          to="/servicos"
          class="px-6 py-3 rounded-lg bg-gradient-to-r from-primary to-secondary text-black font-bold"
        >
          Tentar Novamente
        </RouterLink>
      </div>
    </div>
  </AppLayout>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, RouterLink } from 'vue-router'
import { useSupabase } from '@/composables/useSupabase'
import AppLayout from '@/components/layout/AppLayout.vue'

const route = useRoute()
const { supabase } = useSupabase()

const loading = ref(true)
const paymentStatus = ref<'completed' | 'pending' | 'error'>('error')
const serviceName = ref('')

onMounted(async () => {
  const sessionId = route.query.session_id as string
  
  if (!sessionId) {
    loading.value = false
    return
  }

  try {
    // Buscar pagamento pelo session_id
    const { data: payment, error } = await supabase
      .from('service_payments')
      .select(`
        *,
        services:service_id (nome)
      `)
      .eq('stripe_session_id', sessionId)
      .single()

    if (error || !payment) {
      console.error('Pagamento não encontrado:', error)
      paymentStatus.value = 'error'
      return
    }

    paymentStatus.value = payment.status as 'completed' | 'pending' | 'error'
    serviceName.value = payment.services?.nome || ''

  } catch (error) {
    console.error('Erro ao verificar pagamento:', error)
    paymentStatus.value = 'error'
  } finally {
    loading.value = false
  }
})
</script>
