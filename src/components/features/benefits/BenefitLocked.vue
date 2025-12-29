<template>
  <div class="absolute inset-0 bg-background-dark/90 backdrop-blur-sm rounded-2xl flex flex-col items-center justify-center gap-4 z-10 p-6">
    <div class="size-16 rounded-full bg-primary/20 border border-primary/50 flex items-center justify-center">
      <span class="material-symbols-outlined text-primary text-[32px]">lock</span>
    </div>
    <div class="text-center">
      <h4 class="text-white font-bold text-lg mb-2">{{ t('benefits.benefitLocked') }}</h4>
      <p class="text-gray-400 text-sm mb-4">
        {{ t('benefits.benefitLockedDesc', { plan: requiredPlan }) }}
      </p>
      <Button variant="primary" size="sm" @click="$emit('upgrade')">
        {{ t('benefits.upgradeNow') }}
      </Button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n'
import Button from '@/components/ui/Button.vue'

const { t } = useI18n()

interface Props {
  requiredPlan: 'Member' | 'Premium'
}

defineProps<Props>()

defineEmits<{
  upgrade: []
}>()
</script>

