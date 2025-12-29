<template>
  <AppLayout>
    <div class="space-y-3 sm:space-y-4 md:space-y-6 lg:space-y-8 w-full overflow-x-hidden max-w-full">
      <header class="flex flex-col gap-2 sm:gap-3">
        <h1 class="text-white text-xl sm:text-2xl md:text-3xl font-bold">Meus Serviços</h1>
        <p class="text-gray-400 text-xs sm:text-sm md:text-base">Acompanhe os serviços que você contratou e seus status de atendimento.</p>
      </header>

      <div v-if="loading" class="flex justify-center py-8 sm:py-12 md:py-16 lg:py-20">
        <div class="animate-spin rounded-full h-8 w-8 sm:h-10 sm:w-10 md:h-12 md:w-12 border-b-2 border-primary"></div>
      </div>

      <div v-else-if="services.length === 0" class="bg-surface-dark/50 rounded-lg sm:rounded-xl md:rounded-2xl border border-white/10 backdrop-blur-sm px-3 sm:px-4 md:px-6 lg:px-8 py-8 sm:py-12 md:py-16 lg:py-20 text-center flex flex-col items-center gap-3 sm:gap-4">
        <div class="size-12 sm:size-16 rounded-full bg-white/5 flex items-center justify-center">
          <span class="material-symbols-outlined text-gray-500 text-3xl sm:text-4xl md:text-5xl">shopping_bag</span>
        </div>
        <div>
          <h3 class="text-white text-base sm:text-lg md:text-xl font-bold mb-1 sm:mb-2">Nenhum serviço contratado</h3>
          <p class="text-gray-400 text-xs sm:text-sm md:text-base">Você ainda não contratou nenhum serviço.</p>
        </div>
        <RouterLink to="/servicos">
          <button class="flex items-center justify-center rounded-lg h-9 sm:h-10 md:h-12 px-4 sm:px-6 bg-gradient-to-r from-primary to-secondary text-black text-xs sm:text-sm md:text-base font-bold transition-all shadow-[0_0_20px_rgba(0,243,255,0.3)] hover:shadow-[0_0_40px_rgba(0,243,255,0.5)] hover:scale-105">
            Explorar Serviços
          </button>
        </RouterLink>
      </div>

      <div v-else class="space-y-3 sm:space-y-4 md:space-y-6">
        <div 
          v-for="item in services" 
          :key="item.id"
          class="bg-surface-dark/50 border border-white/10 rounded-lg sm:rounded-xl p-4 sm:p-6 flex flex-col gap-4 sm:gap-6 hover:border-primary/30 transition-all group"
        >
          <div class="flex items-start gap-3 sm:gap-4">
            <div class="size-10 sm:size-12 md:size-14 rounded-lg bg-primary/10 flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-white transition-all shrink-0">
              <span class="material-symbols-outlined text-lg sm:text-xl md:text-2xl">{{ getIcon(item.service?.categoria) }}</span>
            </div>
            <div class="flex-1 flex flex-col gap-1.5 sm:gap-2 min-w-0">
              <div class="flex items-center gap-2 flex-wrap">
                <h3 class="text-white text-sm sm:text-base md:text-lg font-bold truncate">{{ item.service?.nome }}</h3>
                <span :class="getStatusClasses(item.request?.status)">
                  {{ getStatusLabel(item.request?.status) }}
                </span>
                <span v-if="item.payment?.status === 'completed'" class="text-[10px] font-bold px-2 py-1 rounded-full uppercase tracking-wider bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-500">
                  Pago
                </span>
              </div>
              <p v-if="item.service?.descricao" class="text-gray-400 text-xs sm:text-sm line-clamp-2">
                {{ item.service.descricao }}
              </p>
              <div class="flex flex-wrap items-center gap-3 sm:gap-4 mt-1">
                <div class="flex items-center gap-1.5 text-xs sm:text-sm text-gray-400">
                  <span class="material-symbols-outlined text-base">calendar_today</span>
                  <span>Contratado em {{ formatDate(item.payment?.created_at || item.request?.created_at) }}</span>
                </div>
                <div v-if="item.payment" class="flex items-center gap-1.5 text-xs sm:text-sm text-gray-400">
                  <span class="material-symbols-outlined text-base">payments</span>
                  <span>{{ formatPrice(item.payment.amount, item.payment.currency) }}</span>
                </div>
              </div>
            </div>
          </div>

          <div class="flex items-center gap-2 sm:gap-3 pt-2 sm:pt-3 border-t border-white/10">
            <button 
              @click="viewDetails(item)"
              class="flex items-center gap-1.5 sm:gap-2 rounded-lg border border-white/10 hover:border-primary/50 hover:bg-white/5 px-3 sm:px-4 py-1.5 sm:py-2 text-xs sm:text-sm font-medium text-gray-300 hover:text-white transition-colors"
            >
              <span class="material-symbols-outlined text-base sm:text-lg">visibility</span>
              Ver Detalhes
            </button>
            <a 
              v-if="item.request?.status === 'pendente' || item.request?.status === 'em_andamento'"
              :href="getWhatsAppLink(item)"
              target="_blank"
              class="flex items-center gap-1.5 sm:gap-2 rounded-lg bg-green-500/10 hover:bg-green-500/20 border border-green-500/20 hover:border-green-500/40 px-3 sm:px-4 py-1.5 sm:py-2 text-xs sm:text-sm font-medium text-green-400 hover:text-green-300 transition-colors"
            >
              <span class="material-symbols-outlined text-base sm:text-lg">chat</span>
              Falar com Suporte
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- Details Modal -->
    <Modal
      v-if="selectedService"
      v-model="showDetailsModal"
      :title="'Detalhes do Serviço'"
    >
      <div class="flex flex-col gap-4 sm:gap-6">
        <div class="flex items-center justify-between flex-wrap gap-3">
          <div class="flex flex-col">
            <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Serviço</span>
            <span class="text-base sm:text-lg font-bold text-white">{{ selectedService.service?.nome }}</span>
          </div>
          <div class="flex gap-2 flex-wrap">
            <span :class="getStatusClasses(selectedService.request?.status)">
              {{ getStatusLabel(selectedService.request?.status) }}
            </span>
            <span v-if="selectedService.payment?.status === 'completed'" class="text-[10px] font-bold px-2.5 py-1 rounded-full uppercase tracking-wider bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-500">
              Pago
            </span>
          </div>
        </div>

        <div v-if="selectedService.service?.descricao" class="flex flex-col gap-1.5">
          <span class="text-xs font-bold text-gray-400 uppercase tracking-widest">Descrição</span>
          <p class="text-sm text-gray-300 leading-relaxed">{{ selectedService.service.descricao }}</p>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3 sm:gap-4">
          <div class="flex flex-col p-3 sm:p-4 rounded-lg bg-white/5 border border-white/10">
            <span class="text-[10px] font-bold text-gray-400 uppercase mb-1">Data da Contratação</span>
            <span class="text-sm font-medium text-white">{{ formatDate(selectedService.payment?.created_at || selectedService.request?.created_at) }}</span>
          </div>
          <div v-if="selectedService.request?.updated_at" class="flex flex-col p-3 sm:p-4 rounded-lg bg-white/5 border border-white/10">
            <span class="text-[10px] font-bold text-gray-400 uppercase mb-1">Última Atualização</span>
            <span class="text-sm font-medium text-white">{{ formatDate(selectedService.request.updated_at) }}</span>
          </div>
        </div>

        <div v-if="selectedService.payment" class="p-3 sm:p-4 rounded-lg bg-white/5 border border-white/10 space-y-2">
          <span class="text-xs font-bold text-gray-400 uppercase tracking-widest">Informações de Pagamento</span>
          <div class="flex justify-between items-center text-sm">
            <span class="text-gray-400">Valor Pago</span>
            <span class="text-white font-medium">{{ formatPrice(selectedService.payment.amount, selectedService.payment.currency) }}</span>
          </div>
          <div class="flex justify-between items-center text-sm">
            <span class="text-gray-400">Método</span>
            <span class="text-white font-medium capitalize">{{ selectedService.payment.payment_method === 'card' ? 'Cartão' : selectedService.payment.payment_method?.toUpperCase() }}</span>
          </div>
          <div class="flex justify-between items-center text-sm">
            <span class="text-gray-400">Status do Pagamento</span>
            <span class="text-green-400 font-medium">Concluído</span>
          </div>
        </div>

        <div v-if="selectedService.request?.mensagem" class="flex flex-col gap-1.5">
          <span class="text-xs font-bold text-gray-400 uppercase tracking-widest">Sua Mensagem</span>
          <div class="p-3 sm:p-4 rounded-lg bg-white/5 border-l-4 border-primary text-sm text-gray-300 italic">
            "{{ selectedService.request.mensagem }}"
          </div>
        </div>

        <div class="p-3 sm:p-4 rounded-xl bg-primary/5 border border-primary/10 flex items-start gap-3 sm:gap-4">
          <span class="material-symbols-outlined text-primary text-lg sm:text-xl">info</span>
          <div class="flex flex-col gap-1">
            <h4 class="text-sm font-bold text-white">O que acontece agora?</h4>
            <p class="text-xs text-gray-400 leading-relaxed">
              <template v-if="selectedService.request?.status === 'pendente'">
                Seu pagamento foi confirmado e sua solicitação está na fila de atendimento. O parceiro responsável entrará em contato em até 48h úteis.
              </template>
              <template v-else-if="selectedService.request?.status === 'em_andamento'">
                Seu serviço está sendo atendido. O parceiro pode entrar em contato a qualquer momento para atualizações.
              </template>
              <template v-else-if="selectedService.request?.status === 'concluido'">
                Seu serviço foi concluído. Se precisar de suporte adicional, entre em contato conosco.
              </template>
            </p>
          </div>
        </div>
      </div>
    </Modal>
  </AppLayout>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useSupabase } from '@/composables/useSupabase'
import AppLayout from '@/components/layout/AppLayout.vue'
import Modal from '@/components/ui/Modal.vue'
import { RouterLink } from 'vue-router'

const { supabase } = useSupabase()
const loading = ref(true)
const services = ref<any[]>([])

const showDetailsModal = ref(false)
const selectedService = ref<any>(null)

async function fetchServices() {
  try {
    loading.value = true
    const { data: { user } } = await supabase.auth.getUser()
    
    if (!user) return

    // Buscar pagamentos concluídos com informações do serviço e solicitação
    // Especificando a foreign key correta para evitar ambiguidade
    const { data, error } = await supabase
      .from('service_payments')
      .select(`
        id,
        amount,
        currency,
        payment_method,
        status,
        created_at,
        service_id,
        service_request_id,
        services!service_payments_service_id_fkey (
          id,
          nome,
          descricao,
          categoria
        ),
        service_requests!service_payments_service_request_id_fkey (
          id,
          status,
          mensagem,
          created_at,
          updated_at
        )
      `)
      .eq('user_id', user.id)
      .eq('status', 'completed')
      .order('created_at', { ascending: false })
    
    if (error) {
      console.error('Erro na query:', error)
      throw error
    }
    
    // Transformar os dados para facilitar o uso no template
    services.value = (data || []).map((payment: any) => {
      // O Supabase pode retornar os relacionamentos como objeto ou array
      const service = Array.isArray(payment.services) 
        ? payment.services[0] 
        : payment.services
      
      const request = Array.isArray(payment.service_requests) 
        ? payment.service_requests[0] 
        : payment.service_requests
      
      return {
        id: payment.id,
        payment: {
          id: payment.id,
          amount: payment.amount,
          currency: payment.currency,
          payment_method: payment.payment_method,
          status: payment.status,
          created_at: payment.created_at
        },
        service: service || null,
        request: request || null
      }
    })
  } catch (error) {
    console.error('Erro ao buscar serviços:', error)
  } finally {
    loading.value = false
  }
}

function getStatusLabel(status: string) {
  switch (status) {
    case 'pendente': return 'Pendente'
    case 'em_andamento': return 'Em Andamento'
    case 'concluido': return 'Concluído'
    default: return status || 'Pendente'
  }
}

function getStatusClasses(status: string) {
  const base = 'text-[10px] font-bold px-2 py-1 rounded-full uppercase tracking-wider'
  switch (status) {
    case 'pendente': return `${base} bg-yellow-100 text-yellow-700 dark:bg-yellow-900/30 dark:text-yellow-500`
    case 'em_andamento': return `${base} bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-500`
    case 'concluido': return `${base} bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-500`
    default: return `${base} bg-slate-100 text-slate-700 dark:bg-slate-800 dark:text-slate-300`
  }
}

function getIcon(category: string) {
  switch (category) {
    case 'legal': return 'gavel'
    case 'finance': return 'account_balance'
    case 'mentoring': return 'school'
    case 'marketing': return 'campaign'
    default: return 'shopping_bag'
  }
}

function formatDate(date: string) {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('pt-BR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  })
}

function formatPrice(cents: number, currency: string = 'USD'): string {
  const amount = cents / 100
  if (currency === 'BRL') {
    return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(amount)
  }
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(amount)
}

function viewDetails(service: any) {
  selectedService.value = service
  showDetailsModal.value = true
}

function getWhatsAppLink(item: any) {
  const message = encodeURIComponent(`Olá! Contratei o serviço "${item.service?.nome}" e gostaria de acompanhar o status.`)
  return `https://wa.me/5511999999999?text=${message}`
}

onMounted(() => {
  fetchServices()
})
</script>

