<template>
  <div class="absolute inset-0 bg-background-dark/90 backdrop-blur-sm rounded-2xl flex flex-col items-center justify-center gap-4 z-10 p-6">
    <div class="size-16 rounded-full bg-primary/20 border border-primary/50 flex items-center justify-center">
      <span class="material-symbols-outlined text-primary text-[32px]">lock</span>
    </div>
    <div class="text-center">
      <h4 class="text-white font-bold text-lg mb-2">Benefício Bloqueado</h4>
      <p class="text-gray-400 text-sm mb-4">
        Este benefício está disponível apenas para membros do plano <span class="text-primary font-bold">{{ requiredPlan }}</span>
      </p>
      <Button variant="primary" size="sm" @click="$emit('upgrade')">
        Fazer Upgrade
      </Button>
    </div>
  </div>
</template>

<script setup lang="ts">
import Button from '@/components/ui/Button.vue'

interface Props {
  requiredPlan: 'Member' | 'Premium'
}

defineProps<Props>()

defineEmits<{
  upgrade: []
}>()
</script>

