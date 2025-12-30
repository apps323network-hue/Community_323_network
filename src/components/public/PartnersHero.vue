<template>
  <section class="relative min-h-[90vh] flex items-center justify-center overflow-hidden bg-slate-50 dark:bg-background-dark">
    <!-- Background Effects -->
    <div
      class="absolute inset-0 bg-[url('https://grainy-gradients.vercel.app/noise.svg')] opacity-20 z-0"
    ></div>
    <div
      class="absolute top-[-10%] left-[-10%] w-[600px] h-[600px] bg-secondary/20 rounded-full mix-blend-screen filter blur-[120px] animate-glow z-0"
    ></div>
    <div
      class="absolute bottom-[-10%] right-[-10%] w-[600px] h-[600px] bg-primary/20 rounded-full mix-blend-screen filter blur-[120px] animate-glow z-0"
      style="animation-delay: 2.5s"
    ></div>

    <!-- Content -->
    <div class="relative z-10 max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 text-center py-20">
      <h1 class="text-4xl sm:text-5xl md:text-6xl lg:text-7xl font-black text-slate-900 dark:text-white mb-6 leading-tight">
        {{ t('partners.hero.title') }}
        <br />
        <span class="text-transparent bg-clip-text bg-gradient-to-r from-primary via-blue-400 to-secondary neon-text">
          {{ t('partners.hero.subtitle') }}
        </span>
      </h1>
      <p class="text-lg sm:text-xl md:text-2xl text-slate-600 dark:text-gray-300 mb-12 max-w-3xl mx-auto leading-relaxed">
        {{ t('partners.hero.description') }}
      </p>
    </div>

    <!-- Scroll Indicator -->
    <div class="absolute bottom-8 left-1/2 transform -translate-x-1/2 z-10 animate-bounce">
      <span class="material-icons-outlined text-slate-400 dark:text-gray-500 text-3xl">keyboard_arrow_down</span>
    </div>
</section>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n'

const { t } = useI18n()
</script>

<style scoped>
@keyframes glow {
  0%, 100% {
    opacity: 0.3;
  }
  50% {
    opacity: 0.6;
  }
}

.animate-glow {
  animation: glow 4s ease-in-out infinite;
}
</style>

