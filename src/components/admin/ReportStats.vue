<template>
  <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
    <div class="bg-surface-dark rounded-xl p-6 border border-white/10 hover:border-white/20 transition-all group">
      <div class="flex items-center justify-between mb-4">
        <span class="text-white/70 text-sm font-medium">Total</span>
        <div class="p-2 bg-white/5 rounded-lg">
          <span class="material-symbols-outlined text-white/50 text-xl">report</span>
        </div>
      </div>
      <div class="text-4xl font-black text-white mb-1">{{ stats.total }}</div>
      <div class="text-xs text-white/40">Reports recebidos</div>
    </div>

    <div class="bg-surface-dark rounded-xl p-6 border border-white/10 hover:border-white/20 transition-all group">
      <div class="flex items-center justify-between mb-4">
        <span class="text-white/70 text-sm font-medium">Pendentes</span>
        <div class="p-2 bg-white/5 rounded-lg">
          <span class="material-symbols-outlined text-white/50 text-xl">schedule</span>
        </div>
      </div>
      <div class="text-4xl font-black text-white mb-1">{{ stats.pending }}</div>
      <div v-if="stats.pending > 0" class="text-xs text-yellow-400/70 font-medium">Requer atenção</div>
      <div v-else class="text-xs text-white/40">Nenhum pendente</div>
    </div>

    <div class="bg-surface-dark rounded-xl p-6 border border-white/10 hover:border-white/20 transition-all group">
      <div class="flex items-center justify-between mb-4">
        <span class="text-white/70 text-sm font-medium">Resolvidos Hoje</span>
        <div class="p-2 bg-white/5 rounded-lg">
          <span class="material-symbols-outlined text-white/50 text-xl">check_circle</span>
        </div>
      </div>
      <div class="text-4xl font-black text-white mb-1">{{ stats.resolvedToday }}</div>
      <div class="text-xs text-white/40">Resolvidos hoje</div>
    </div>

    <div class="bg-surface-dark rounded-xl p-6 border border-white/10 hover:border-white/20 transition-all group">
      <div class="flex items-center justify-between mb-4">
        <span class="text-white/70 text-sm font-medium">Resolvidos</span>
        <div class="p-2 bg-white/5 rounded-lg">
          <span class="material-symbols-outlined text-white/50 text-xl">done_all</span>
        </div>
      </div>
      <div class="text-4xl font-black text-white mb-1">{{ stats.resolved }}</div>
      <div class="text-xs text-white/40">Total resolvidos</div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { ReportStats } from '@/types/admin'

interface Props {
  stats: ReportStats
}

defineProps<Props>()
</script>

