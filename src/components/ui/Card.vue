<template>
  <div :class="cardClasses">
    <slot />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  variant?: 'default' | 'dark' | 'glass' | 'white'
  hover?: boolean
  glow?: 'blue' | 'pink' | 'mixed' | null
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'default',
  hover: false,
  glow: null,
})

const cardClasses = computed(() => {
  const base = 'rounded-xl border transition-all duration-300'

  const variants = {
    default: 'bg-white dark:bg-surface-dark border-slate-200 dark:border-white/5 shadow-sm dark:shadow-none',
    dark: 'bg-surface-dark border-white/10',
    glass: 'bg-surface-dark/80 backdrop-blur border-white/10',
    white: 'bg-white border-slate-200 shadow-sm',
  }

  const glows = {
    blue: 'hover:shadow-neon-blue dark:hover:shadow-neon-blue hover:shadow-light-secondary dark:hover:border-secondary/50 hover:border-secondary/30',
    pink: 'hover:shadow-neon-pink dark:hover:shadow-neon-pink hover:shadow-light-primary dark:hover:border-primary/50 hover:border-primary/30',
    mixed: 'hover:shadow-neon-mixed dark:hover:shadow-neon-mixed hover:shadow-light-primary dark:hover:border-primary/30 hover:border-primary/30',
  }

  return [
    base,
    variants[props.variant],
    props.hover && 'hover:-translate-y-2',
    props.glow && glows[props.glow],
  ].filter(Boolean).join(' ')
})
</script>

