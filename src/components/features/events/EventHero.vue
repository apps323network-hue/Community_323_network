<template>
  <section class="rounded-xl overflow-hidden relative shadow-2xl shadow-secondary/10 border border-white/5">
    <div
      class="absolute inset-0 bg-cover bg-center"
      :style="{ backgroundImage: `url('${event.image || defaultImage}')` }"
    ></div>
    <div class="absolute inset-0 bg-gradient-to-r from-background-dark via-background-dark/90 to-primary/20"></div>
    <div class="relative z-10 p-8 lg:p-16 flex flex-col lg:flex-row gap-10 items-center lg:items-start justify-between">
      <div class="flex flex-col gap-6 max-w-2xl text-center lg:text-left">
        <div class="inline-flex items-center gap-2 self-center lg:self-start bg-black/40 backdrop-blur-md border border-secondary/50 rounded-full px-4 py-1 shadow-[0_0_10px_rgba(0,240,255,0.2)]">
          <span class="w-2 h-2 rounded-full bg-secondary animate-pulse shadow-[0_0_5px_#00f0ff]"></span>
          <span class="text-secondary text-xs font-bold uppercase tracking-wider text-glow-blue">Evento Destaque</span>
        </div>
        <h1 class="text-white text-4xl lg:text-7xl font-black leading-tight tracking-[-0.033em]">
          {{ event.titulo }}
          <span v-if="event.subtitulo" class="bg-clip-text text-transparent bg-neon-gradient">
            {{ event.subtitulo }}
          </span>
        </h1>
        <p class="text-white/80 text-lg font-normal leading-relaxed max-w-xl">
          {{ event.descricao }}
        </p>
        <div class="flex flex-wrap gap-4 justify-center lg:justify-start mt-4">
          <Button variant="primary" size="lg" @click="$emit('register')">
            Inscreva-se Agora
          </Button>
          <Button variant="outline" size="lg" @click="$emit('learn-more')">
            Saber Mais
          </Button>
        </div>
      </div>
      <CountdownTimer v-if="event.data_hora" :target-date="event.data_hora" />
    </div>
  </section>
</template>

<script setup lang="ts">
import Button from '@/components/ui/Button.vue'
import CountdownTimer from './CountdownTimer.vue'

interface Event {
  id: string
  titulo: string
  subtitulo?: string
  descricao: string
  data_hora: string
  image?: string
}

interface Props {
  event: Event
}

defineProps<Props>()

defineEmits<{
  register: []
  'learn-more': []
}>()

const defaultImage = 'https://lh3.googleusercontent.com/aida-public/AB6AXuCpF7y6V9dwK_2EG1TFRJYFnteTF9DUheFpMSRi7B1UeVgWJdGZSTVnDhIFFFZEbd-yJ0U5VsAGWYTXDQVMK12fAoXlycF_WwwGaQe51e11QG9hDyZ-2zxKqn6hSVqmapvFUml9ZWi7egykXJBs2p5sNtDSs1EXyi3P4ujhYXOnUb96ff5xXIB1eVrZ9X_uC36cGnCYiVT9sjn43zayx2QqOTpPCLUYaLOIa7XzlusG7N9HI5GmTkBHG5gr-izyB_FgT1QsQIMLFGOZ'
</script>

