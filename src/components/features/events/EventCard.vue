<template>
  <div
    class="group flex flex-col bg-surface-card rounded-xl overflow-hidden border border-white/5 hover:border-primary transition-all duration-300 hover:-translate-y-2 hover:shadow-neon-pink"
  >
    <!-- Event Image -->
    <div class="relative h-52 overflow-hidden">
      <div
        class="absolute top-3 left-3 bg-black/80 backdrop-blur-md px-3 py-2 rounded-lg border z-10 flex flex-col items-center text-center min-w-[60px] shadow-lg"
        :class="dateBorderClass"
      >
        <span class="text-xs text-white/90 uppercase font-bold tracking-wider">{{ month }}</span>
        <span class="text-2xl font-black drop-shadow-[0_0_5px_rgba(244,37,244,0.8)]" :class="dateTextClass">
          {{ day }}
        </span>
      </div>
      <div
        class="w-full h-full bg-cover bg-center transition-transform duration-700 group-hover:scale-110"
        :style="{ backgroundImage: `url('${event.image || defaultImage}')` }"
      ></div>
      <div class="absolute inset-0 bg-gradient-to-t from-surface-card via-surface-card/20 to-transparent"></div>
      <div
        class="absolute bottom-0 left-0 w-full h-1 transition-opacity duration-300 opacity-0 group-hover:opacity-100"
        :class="gradientClass"
      ></div>
    </div>

    <!-- Event Content -->
    <div class="p-6 flex flex-col flex-1 gap-4 relative">
      <div class="flex items-center justify-between">
        <Badge :variant="getBadgeVariant(event.tipo)" size="sm">
          {{ getTypeLabel(event.tipo) }}
        </Badge>
        <span class="text-white/60 text-xs font-semibold flex items-center gap-1">
          <span class="material-symbols-outlined text-sm">schedule</span>
          {{ formatTime(event.data_hora) }}
        </span>
      </div>
      <h4 class="text-white text-xl font-bold leading-tight group-hover:text-primary transition-colors">
        {{ event.titulo }}
      </h4>
      <p class="text-white/60 text-sm line-clamp-2">
        {{ event.descricao }}
      </p>
      <div class="flex items-center gap-2 text-white/80 text-sm mt-auto">
        <span
          class="material-symbols-outlined text-lg"
          :class="event.tipo === 'webinar' ? 'text-secondary' : 'text-primary'"
        >
          {{ event.tipo === 'webinar' ? 'videocam' : 'location_on' }}
        </span>
        <span>{{ event.local || 'Online' }}</span>
      </div>
      <div class="pt-5 mt-2 border-t border-white/5">
        <Button
          variant="outline"
          size="sm"
          full-width
          :class="buttonClass"
          @click="$emit('rsvp', event.id)"
        >
          {{ event.confirmed ? 'Confirmado' : 'Confirmar Presença' }}
          <span class="material-symbols-outlined text-sm ml-2">
            {{ event.confirmed ? 'check' : 'arrow_forward' }}
          </span>
        </Button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import Badge from '@/components/ui/Badge.vue'
import Button from '@/components/ui/Button.vue'

interface Event {
  id: string
  titulo: string
  descricao: string
  data_hora: string
  tipo: 'presencial' | 'webinar'
  local?: string
  image?: string
  confirmed?: boolean
}

interface Props {
  event: Event
}

const props = defineProps<Props>()

defineEmits<{
  rsvp: [eventId: string]
}>()

const defaultImage = 'https://lh3.googleusercontent.com/aida-public/AB6AXuB-u5Zx9B1ufuRQza0zf7uYahLuxs9YfCr9vaanB9L6kghOvagzIVyr4ClrfT4g0Bf8JnW-f0HNM_VLI_mmNf8JHIrkKgB7Z7dyGGGNB6W0DZaLnu6ZZk8BWVcZQ5Z-XEcXjAngRKO2QS5AN8sZcvf5Ye5O5LypBMDVPukbsrznycibYw7rZuIRbUGpuVBhs3B6-EdBV_rTUhtak54JZpy6USBXCbM8P_PSF9O-45KNDI6zPf2mO6yadg-JkjVjmmqMRRoaJlk1u8dg'

const eventDate = computed(() => new Date(props.event.data_hora))

const month = computed(() => {
  const months = ['JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN', 'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ']
  return months[eventDate.value.getMonth()]
})

const day = computed(() => eventDate.value.getDate())

const dateBorderClass = computed(() => {
  return day.value % 2 === 0
    ? 'border-secondary/30'
    : 'border-primary/30'
})

const dateTextClass = computed(() => {
  return day.value % 2 === 0
    ? 'text-secondary'
    : 'text-primary'
})

const gradientClass = computed(() => {
  if (props.event.tipo === 'webinar') {
    return 'bg-gradient-to-r from-secondary to-transparent'
  }
  return 'bg-gradient-to-r from-primary to-transparent'
})

const buttonClass = computed(() => {
  if (props.event.confirmed) {
    return 'bg-primary/20 text-primary border-primary/50'
  }
  return 'bg-transparent hover:bg-primary text-primary hover:text-white border-primary hover:border-transparent'
})

function getTypeLabel(tipo: string) {
  const labels = {
    presencial: 'Presencial',
    webinar: 'Webinar',
  }
  return labels[tipo as keyof typeof labels] || 'Evento'
}

function getBadgeVariant(tipo: string): 'primary' | 'secondary' {
  return tipo === 'webinar' ? 'secondary' : 'primary'
}

function formatTime(date: string) {
  const eventDate = new Date(date)
  return eventDate.toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' })
}
</script>

