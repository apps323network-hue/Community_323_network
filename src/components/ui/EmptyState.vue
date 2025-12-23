<template>
  <div class="flex flex-col items-center justify-center py-12 px-4 text-center">
    <div
      v-if="icon"
      class="mb-4 p-4 rounded-full bg-slate-100 dark:bg-surface-lighter text-slate-400 dark:text-gray-500"
    >
      <span class="material-symbols-outlined text-[48px]">{{ icon }}</span>
    </div>
    <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-2">
      {{ title }}
    </h3>
    <p class="text-slate-600 dark:text-gray-400 max-w-md mb-6">
      {{ description }}
    </p>
    <slot name="action">
      <Button v-if="actionLabel" :variant="actionVariant" @click="$emit('action')">
        {{ actionLabel }}
      </Button>
    </slot>
  </div>
</template>

<script setup lang="ts">
import Button from './Button.vue'

interface Props {
  icon?: string
  title: string
  description: string
  actionLabel?: string
  actionVariant?: 'primary' | 'secondary' | 'outline' | 'ghost'
}

withDefaults(defineProps<Props>(), {
  icon: 'inbox',
  actionVariant: 'primary',
})

defineEmits<{
  action: []
}>()
</script>

