<template>
  <section class="py-16 sm:py-20 md:py-24 bg-white">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Title -->
      <div class="text-center mb-12 md:mb-16">
        <h2 class="text-3xl sm:text-4xl md:text-5xl font-black text-slate-900 mb-4">
          {{ t('partners.about.title') }}
        </h2>
        <div class="w-24 h-1 bg-neon-gradient mx-auto rounded-full"></div>
      </div>

      <!-- Description -->
      <div class="max-w-4xl mx-auto mb-12">
        <p class="text-lg sm:text-xl text-slate-700 leading-relaxed mb-6">
          {{ t('partners.about.description1') }}
        </p>
        <p class="text-lg sm:text-xl text-slate-700 leading-relaxed">
          {{ t('partners.about.description2') }}
        </p>
      </div>

      <!-- What We Do -->
      <div class="mt-16">
        <h3 class="text-2xl sm:text-3xl font-bold text-slate-900 mb-8 text-center">
          {{ t('partners.about.whatWeDo') }}
        </h3>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div
            v-for="(item, index) in whatWeDoItems"
            :key="index"
            class="bg-slate-50 rounded-xl p-6 border border-slate-200 hover:border-primary/50 transition-all duration-300 hover:shadow-lg"
          >
            <div class="w-12 h-12 bg-gradient-to-br from-primary to-secondary rounded-lg flex items-center justify-center mb-4">
              <span class="material-icons-outlined text-white text-2xl">{{ item.icon }}</span>
            </div>
            <h4 class="text-lg font-bold text-slate-900 mb-2">
              {{ t(`partners.about.items.${item.key}.title`) }}
            </h4>
            <p class="text-slate-600 text-sm leading-relaxed">
              {{ t(`partners.about.items.${item.key}.description`) }}
            </p>
          </div>
        </div>
      </div>

      <!-- Statistics -->
      <div class="mt-16 grid grid-cols-2 md:grid-cols-4 gap-6">
        <div
          v-for="(stat, index) in statistics"
          :key="index"
          class="text-center bg-slate-50 rounded-xl p-6 border border-slate-200"
        >
          <div class="text-3xl sm:text-4xl md:text-5xl font-black bg-clip-text text-transparent bg-neon-gradient mb-2">
            {{ stat.value }}
          </div>
          <div class="text-sm sm:text-base text-slate-600 font-medium">
            {{ t(`partners.about.stats.${stat.key}`) }}
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

const whatWeDoItems = [
  { key: 'artists', icon: 'mic' },
  { key: 'events', icon: 'event' },
  { key: 'projects', icon: 'rocket_launch' },
  { key: 'content', icon: 'campaign' },
]

const statistics = [
  { key: 'members', value: '500+' },
  { key: 'events', value: '50+' },
  { key: 'cities', value: '10+' },
  { key: 'years', value: '3+' },
]
</script>

