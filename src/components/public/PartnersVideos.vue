<template>
  <section 
    id="videos"
    ref="sectionRef"
    class="py-16 sm:py-20 md:py-24 bg-slate-900 dark:bg-background-dark overflow-hidden"
  >
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Title -->
      <div 
        ref="headerRef"
        class="text-center mb-12 md:mb-16 section-header"
        :class="{ 'revealed': headerVisible }"
      >
        <h2 class="text-3xl sm:text-4xl md:text-5xl font-black text-white mb-4">
          {{ t('partners.videos.title') }}
        </h2>
        <p class="text-lg text-gray-300 max-w-2xl mx-auto">
          {{ t('partners.videos.description') }}
        </p>
        <div class="w-24 h-1 bg-neon-gradient mx-auto rounded-full mt-4"></div>
      </div>

      <!-- Videos Grid -->
      <div 
        ref="gridRef"
        class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 lg:gap-8"
      >
        <div
          v-for="(video, index) in placeholderVideos"
          :key="index"
          class="video-card bg-slate-800 dark:bg-surface-lighter rounded-xl overflow-hidden border border-slate-700 dark:border-slate-800 hover:border-primary/50 transition-all duration-300 hover:shadow-xl hover:shadow-primary/10 group cursor-pointer"
          :class="{ 'revealed': cardsVisible }"
          :style="{ transitionDelay: `${index * 120}ms` }"
          @click="openVideo(video.url)"
        >
          <!-- Video Thumbnail -->
          <div class="relative aspect-video bg-gradient-to-br from-primary/20 to-secondary/20 overflow-hidden">
            <div class="absolute inset-0 flex items-center justify-center">
              <span class="material-icons-outlined text-6xl text-primary/30">play_circle</span>
            </div>
            <div
              v-if="video.thumbnail"
              class="absolute inset-0 bg-cover bg-center opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              :style="{ backgroundImage: `url(${video.thumbnail})` }"
            ></div>
            <!-- Play Button Overlay -->
            <div class="absolute inset-0 flex items-center justify-center bg-black/0 group-hover:bg-black/30 transition-colors duration-300">
              <div class="w-16 h-16 bg-white/90 rounded-full flex items-center justify-center group-hover:scale-110 transition-transform duration-300">
                <span class="material-icons-outlined text-primary text-3xl ml-1">play_arrow</span>
              </div>
            </div>
          </div>

          <!-- Video Info -->
          <div class="p-6">
            <h3 class="text-lg font-bold text-white mb-2 line-clamp-2">
              {{ video.title }}
            </h3>
            <p class="text-sm text-gray-300 line-clamp-2">
              {{ video.description }}
            </p>
            <div class="mt-4 flex items-center gap-2 text-xs text-gray-400">
              <span class="material-icons-outlined text-sm">calendar_month</span>
              <span>{{ video.date }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Empty State -->
      <div
        v-if="placeholderVideos.length === 0"
        class="text-center py-12"
      >
        <span class="material-icons-outlined text-6xl text-gray-600 mb-4 block">videocam_off</span>
        <p class="text-gray-400">
          {{ t('partners.videos.noVideos') }}
        </p>
      </div>
    </div>

    <!-- Video Modal -->
    <Modal
      v-model="videoModalOpen"
      :title="selectedVideoTitle"
    >
      <div class="aspect-video w-full">
        <iframe
          v-if="selectedVideoUrl"
          :src="selectedVideoUrl"
          class="w-full h-full rounded-lg"
          frameborder="0"
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
          allowfullscreen
        ></iframe>
      </div>
    </Modal>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useI18n } from 'vue-i18n'
import Modal from '@/components/ui/Modal.vue'

const { t } = useI18n()

const sectionRef = ref<HTMLElement | null>(null)
const headerRef = ref<HTMLElement | null>(null)
const gridRef = ref<HTMLElement | null>(null)

const headerVisible = ref(false)
const cardsVisible = ref(false)

let observer: IntersectionObserver | null = null

const videoModalOpen = ref(false)
const selectedVideoUrl = ref<string | null>(null)
const selectedVideoTitle = ref('')

// Placeholder videos - será substituído por dados reais depois
const placeholderVideos = [
  {
    title: 'Networking Event Highlights - Los Angeles',
    description: 'Veja os melhores momentos do nosso evento de networking em Los Angeles',
    date: 'Jan 2025',
    url: null as string | null,
    thumbnail: null as string | null,
  },
  {
    title: 'Workshop: Como Construir o American Dream',
    description: 'Palestra completa sobre oportunidades para brasileiros nos EUA',
    date: 'Dez 2024',
    url: null as string | null,
    thumbnail: null as string | null,
  },
  {
    title: 'Showcase: Artistas Brasileiros',
    description: 'Apresentação dos talentos brasileiros na cena americana',
    date: 'Nov 2024',
    url: null as string | null,
    thumbnail: null as string | null,
  },
]

function openVideo(url: string | null) {
  if (!url) return
  selectedVideoUrl.value = url
  selectedVideoTitle.value = placeholderVideos.find(v => v.url === url)?.title || ''
  videoModalOpen.value = true
}

onMounted(() => {
  observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          if (entry.target === headerRef.value) {
            headerVisible.value = true
          }
          if (entry.target === gridRef.value) {
            cardsVisible.value = true
          }
          observer?.unobserve(entry.target)
        }
      })
    },
    { threshold: 0.15 }
  )

  if (headerRef.value) observer.observe(headerRef.value)
  if (gridRef.value) observer.observe(gridRef.value)
})

onUnmounted(() => {
  observer?.disconnect()
})
</script>

<style scoped>
/* Section header reveal - horizontal slide with blur */
.section-header {
  opacity: 0;
  transform: translateX(60px);
  filter: blur(12px);
  transition: opacity 0.9s cubic-bezier(0.16, 1, 0.3, 1),
              transform 0.9s cubic-bezier(0.16, 1, 0.3, 1),
              filter 0.9s cubic-bezier(0.16, 1, 0.3, 1);
}

.section-header.revealed {
  opacity: 1;
  transform: translateX(0);
  filter: blur(0);
}

/* Video card - 3D rotate entrance with blur */
.video-card {
  opacity: 0;
  transform: perspective(1000px) rotateY(15deg) translateZ(-50px);
  filter: blur(8px);
  transition: opacity 0.8s cubic-bezier(0.16, 1, 0.3, 1),
              transform 0.8s cubic-bezier(0.16, 1, 0.3, 1),
              filter 0.8s cubic-bezier(0.16, 1, 0.3, 1),
              border-color 0.3s ease,
              box-shadow 0.3s ease;
  transform-style: preserve-3d;
}

.video-card.revealed {
  opacity: 1;
  transform: perspective(1000px) rotateY(0) translateZ(0);
  filter: blur(0);
}

/* Card hover effects */
.video-card:hover {
  transform: translateY(-10px) scale(1.02);
}

/* Glow effect on hover */
.video-card:hover {
  box-shadow: 0 20px 40px -10px rgba(var(--color-primary-rgb, 234, 98, 29), 0.3);
}

/* Reduce motion for accessibility */
@media (prefers-reduced-motion: reduce) {
  .section-header,
  .video-card {
    opacity: 1;
    transform: none;
    filter: none;
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
  }
}
</style>

