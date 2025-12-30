<template>
  <section class="py-16 sm:py-20 md:py-24 bg-white">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Title -->
      <div class="text-center mb-12 md:mb-16">
        <h2 class="text-3xl sm:text-4xl md:text-5xl font-black text-slate-900 mb-4">
          {{ t('partners.benefits.title') }}
        </h2>
        <p class="text-lg text-slate-600 max-w-2xl mx-auto">
          {{ t('partners.benefits.description') }}
        </p>
        <div class="w-24 h-1 bg-neon-gradient mx-auto rounded-full mt-4"></div>
      </div>

      <!-- Benefits Grid -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 lg:gap-8">
        <div
          v-for="(benefit, index) in benefits"
          :key="index"
          class="bg-slate-50 rounded-xl p-6 border border-slate-200 hover:border-primary/50 transition-all duration-300 hover:shadow-xl"
        >
          <div class="w-14 h-14 bg-gradient-to-br from-primary to-secondary rounded-lg flex items-center justify-center mb-4">
            <span class="material-icons-outlined text-white text-3xl">{{ benefit.icon }}</span>
          </div>
          <h3 class="text-xl font-bold text-slate-900 mb-2">
            {{ t(`partners.benefits.items.${benefit.key}.title`) }}
          </h3>
          <p class="text-slate-600 leading-relaxed">
            {{ t(`partners.benefits.items.${benefit.key}.description`) }}
          </p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

const benefits = [
  { key: 'niche', icon: 'target' },
  { key: 'purchasing', icon: 'trending_up' },
  { key: 'regular', icon: 'event_repeat' },
  { key: 'activation', icon: 'qr_code_scanner' },
]
</script>

