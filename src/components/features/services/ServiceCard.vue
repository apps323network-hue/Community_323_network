<template>
  <div class="group relative flex flex-col justify-between gap-4 rounded-xl border border-white/10 bg-surface-dark/50 backdrop-blur-sm p-6 transition-all duration-300 hover:-translate-y-1 hover:border-secondary/50 hover:shadow-[0_0_30px_-5px_rgba(0,243,255,0.15)]">
    <!-- Featured Badge -->
    <div
      v-if="service.destaque"
      class="absolute top-4 right-4 z-10 opacity-100 group-hover:opacity-0 transition-opacity"
    >
      <span class="bg-primary/20 text-primary text-[10px] font-bold px-2 py-0.5 rounded uppercase tracking-wide border border-primary/20 shadow-[0_0_10px_rgba(244,37,244,0.3)]">
        Destaque
      </span>
    </div>

    <!-- Arrow on hover -->
    <div class="absolute top-0 right-0 p-4 opacity-0 group-hover:opacity-100 transition-opacity z-20">
      <span class="material-symbols-outlined text-secondary">arrow_outward</span>
    </div>

    <div>
      <!-- Icon based on category or default -->
      <div class="mb-4 inline-flex items-center justify-center rounded-lg border border-white/10 bg-white/5 p-3 text-secondary shadow-[0_0_10px_rgba(0,243,255,0.1)] group-hover:bg-secondary group-hover:text-black group-hover:shadow-[0_0_20px_rgba(0,243,255,0.6)] transition-all duration-300">
        <span class="material-symbols-outlined text-[32px]">{{ getIcon(service.categoria) }}</span>
      </div>

      <!-- Title -->
      <h3 class="text-white text-xl font-bold leading-tight mb-2">
        {{ service.nome }}
      </h3>

      <!-- Description -->
      <p class="text-gray-400 text-sm font-normal leading-relaxed mb-4 line-clamp-2">
        {{ service.descricao }}
      </p>

      <!-- Price Section -->
      <div v-if="service.preco" class="flex items-baseline gap-2 mb-4">
        <span class="text-2xl font-bold text-white">{{ formatPrice(service.preco, service.moeda) }}</span>
        <span class="text-xs text-gray-500 uppercase">{{ service.moeda || 'USD' }}</span>
      </div>

      <!-- Benefit Section -->
      <div v-if="service.beneficio_membro" class="flex flex-col gap-1.5 p-3 rounded-lg bg-secondary/5 border border-secondary/20 group-hover:bg-secondary/10 transition-colors">
        <div class="flex items-center gap-1.5 text-secondary">
          <span class="material-symbols-outlined text-[18px]">workspace_premium</span>
          <span class="text-xs font-bold uppercase tracking-wider">Benefício Membro</span>
        </div>
        <p class="text-gray-300 text-xs font-medium leading-relaxed">
          {{ service.beneficio_membro }}
        </p>
      </div>
    </div>

    <!-- Button -->
    <button
      class="mt-2 w-full rounded-lg py-2.5 text-center text-sm font-bold transition-all duration-300"
      :class="service.preco 
        ? 'bg-gradient-to-r from-primary to-secondary text-black hover:shadow-[0_0_20px_rgba(244,37,244,0.4)]' 
        : 'border border-secondary/50 bg-transparent text-secondary group-hover:bg-secondary group-hover:text-black hover:shadow-[0_0_15px_rgba(0,243,255,0.4)]'"
      @click="$emit('request-service', service)"
    >
      {{ service.preco ? 'Contratar Serviço' : 'Solicitar Atendimento' }}
    </button>
  </div>
</template>

<script setup lang="ts">
interface Service {
  id: string
  nome: string
  descricao: string
  categoria: string
  beneficio_membro: string
  destaque: boolean
  parceiro_id: string
  preco?: number
  moeda?: string
}

defineProps<{
  service: Service
}>()

defineEmits<{
  'request-service': [service: Service]
}>()

function getIcon(category: string) {
  switch (category) {
    case 'legal': return 'domain'
    case 'finance': return 'account_balance'
    case 'mentoring': return 'badge'
    case 'marketing': return 'campaign'
    default: return 'hub'
  }
}

function formatPrice(cents: number, currency: string = 'USD'): string {
  const amount = cents / 100
  if (currency === 'BRL') {
    return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(amount)
  }
  return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(amount)
}
</script>
