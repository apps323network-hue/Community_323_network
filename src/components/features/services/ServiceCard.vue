<template>
  <div class="group relative flex flex-col justify-between gap-4 rounded-xl border border-slate-200 bg-white p-6 transition-all duration-300 hover:-translate-y-1 hover:border-primary/50 hover:shadow-[0_0_30px_-10px_rgba(244,37,244,0.15)] shadow-sm">
    <!-- Badge -->
    <div
      v-if="service.badge"
      class="absolute top-4 right-4 z-10"
    >
      <span
        :class="[
          'text-[10px] font-bold px-2 py-0.5 rounded uppercase tracking-wide',
          service.badge.variant === 'primary'
            ? 'bg-primary text-white shadow-[0_0_10px_rgba(244,37,244,0.4)]'
            : 'bg-secondary text-black shadow-[0_0_10px_rgba(0,243,255,0.4)]'
        ]"
      >
        {{ service.badge.text }}
      </span>
    </div>

    <!-- Arrow on hover -->
    <div class="absolute top-0 right-0 p-4 opacity-0 group-hover:opacity-100 transition-opacity">
      <span class="material-symbols-outlined text-primary">arrow_outward</span>
    </div>

    <div>
      <!-- Icon -->
      <div class="mb-4 inline-flex items-center justify-center rounded-lg border border-slate-100 bg-slate-50 p-3 text-secondary-dark group-hover:bg-primary group-hover:text-white group-hover:shadow-[0_0_15px_rgba(244,37,244,0.4)] transition-all duration-300">
        <span class="material-symbols-outlined text-[32px]">{{ service.icon }}</span>
      </div>

      <!-- Title -->
      <h3 class="text-slate-900 text-xl font-bold leading-tight mb-2">
        {{ service.title }}
      </h3>

      <!-- Description -->
      <p class="text-slate-600 text-sm font-normal leading-relaxed">
        {{ service.description }}
      </p>
    </div>

    <!-- Button -->
    <button
      class="mt-2 w-full rounded-lg border border-primary/30 bg-transparent py-2.5 text-center text-sm font-bold text-primary transition-all duration-300 group-hover:bg-primary group-hover:text-white hover:shadow-[0_0_15px_rgba(244,37,244,0.3)]"
      @click="$emit('view-details', service.id)"
    >
      Ver Detalhes
    </button>
  </div>
</template>

<script setup lang="ts">
interface Service {
  id: number
  title: string
  description: string
  icon: string
  category: string
  badge?: {
    text: string
    variant: 'primary' | 'secondary'
  } | null
}

defineProps<{
  service: Service
}>()

defineEmits<{
  'view-details': [id: number]
}>()
</script>
