<template>
  <span :class="badgeClasses">
    <slot />
  </span>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  variant?: 'primary' | 'secondary' | 'success' | 'warning'
  size?: 'sm' | 'md'
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  size: 'md',
})

const badgeClasses = computed(() => {
  const base = 'inline-flex items-center font-semibold rounded-full border uppercase tracking-wider'

  const variants = {
    primary: 'bg-primary text-white dark:bg-primary/10 dark:text-primary border border-primary/20 dark:border-primary/20 shadow-[0_0_10px_rgba(244,37,244,0.4)] dark:shadow-glow-primary',
    secondary: 'bg-secondary text-black dark:bg-secondary/10 dark:text-secondary border border-secondary/20 dark:border-secondary/20 shadow-[0_0_10px_rgba(0,243,255,0.4)] dark:shadow-glow-secondary',
    success: 'bg-green-500/10 text-green-400 border-green-500/20',
    warning: 'bg-yellow-500/10 text-yellow-400 border-yellow-500/20',
  }

  const sizes = {
    sm: 'px-2 py-0.5 text-[10px]',
    md: 'px-3 py-1 text-xs',
  }

  return [
    base,
    variants[props.variant],
    sizes[props.size],
  ].join(' ')
})
</script>

