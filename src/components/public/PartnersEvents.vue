<template>
  <section class="py-16 sm:py-20 md:py-24 bg-slate-900">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Title -->
      <div class="text-center mb-12 md:mb-16">
        <h2 class="text-3xl sm:text-4xl md:text-5xl font-black text-white mb-4">
          {{ t('partners.events.title') }}
        </h2>
        <p class="text-lg text-gray-300 max-w-2xl mx-auto">
          {{ t('partners.events.description') }}
        </p>
        <div class="w-24 h-1 bg-neon-gradient mx-auto rounded-full mt-4"></div>
      </div>

      <!-- Events Grid -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 lg:gap-8">
        <div
          v-for="(event, index) in placeholderEvents"
          :key="index"
          class="bg-slate-800 rounded-xl overflow-hidden border border-slate-700 hover:border-primary/50 transition-all duration-300 hover:shadow-xl group"
        >
          <!-- Event Image -->
          <div class="relative h-48 bg-gradient-to-br from-primary/20 to-secondary/20 overflow-hidden">
            <img
              v-if="event.image"
              :src="event.image"
              :alt="event.title"
              class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300"
            />
            <div
              v-else
              class="absolute inset-0 flex items-center justify-center"
            >
              <span class="material-icons-outlined text-6xl text-primary/30">event</span>
            </div>
          </div>

          <!-- Event Content -->
          <div class="p-6">
            <div class="flex items-center gap-2 mb-2">
              <span class="material-icons-outlined text-primary text-sm">calendar_month</span>
              <span class="text-sm text-gray-300 font-medium">
                {{ event.date }}
              </span>
            </div>
            <h3 class="text-xl font-bold text-white mb-2">
              {{ event.title }}
            </h3>
            <div class="flex items-center gap-2 mb-4">
              <span class="material-icons-outlined text-gray-400 text-sm">location_on</span>
              <span class="text-sm text-gray-300">
                {{ event.location }}
              </span>
            </div>
            <div class="flex items-center justify-between">
              <div class="flex items-center gap-2">
                <span class="material-icons-outlined text-gray-400 text-sm">people</span>
                <span class="text-sm text-gray-300">
                  {{ event.attendees }} {{ t('partners.events.attendees') }}
                </span>
              </div>
              <span
                class="px-3 py-1 bg-primary/20 text-primary rounded-full text-xs font-bold"
              >
                {{ event.type }}
              </span>
            </div>
          </div>
        </div>
      </div>

      <!-- Empty State (quando não houver eventos) -->
      <div
        v-if="placeholderEvents.length === 0"
        class="text-center py-12"
      >
        <span class="material-icons-outlined text-6xl text-gray-600 mb-4 block">event_busy</span>
        <p class="text-gray-400">
          {{ t('partners.events.noEvents') }}
        </p>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

// Eventos com imagens reais
const placeholderEvents = [
  {
    title: 'Networking Event - Los Angeles',
    date: '15 Jan 2025',
    location: 'Los Angeles, California',
    attendees: 150,
    type: 'Presencial',
    image: '/event-griffith-DJdTtNs_.jpg',
  },
  {
    title: 'Workshop: American Dream',
    date: '22 Jan 2025',
    location: 'Los Angeles, California',
    attendees: 80,
    type: 'Presencial',
    image: '/event-speaker1-Dcs9GXUv.jpg',
  },
  {
    title: 'Showcase: Brazilian Artists',
    date: '5 Feb 2025',
    location: 'Los Angeles, California',
    attendees: 200,
    type: 'Presencial',
    image: '/event-group1-D5Kh4W-j.jpg',
  },
]
</script>

