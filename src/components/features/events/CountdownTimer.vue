<template>
  <div class="flex flex-col items-center gap-4 bg-black/40 backdrop-blur-xl p-6 rounded-2xl border border-white/10 shadow-[0_0_30px_rgba(244,37,244,0.15)]">
    <p class="text-secondary text-sm font-bold uppercase tracking-widest mb-2 text-glow-blue">Começa em</p>
    <div class="flex gap-3 text-center">
      <div class="flex flex-col gap-2">
        <div class="flex size-16 items-center justify-center rounded-lg bg-surface-dark border border-primary/50 shadow-[0_0_10px_rgba(244,37,244,0.2)]">
          <p class="text-primary text-2xl font-bold font-display">{{ days }}</p>
        </div>
        <p class="text-white/60 text-xs">Dias</p>
      </div>
      <div class="flex flex-col gap-2">
        <div class="flex size-16 items-center justify-center rounded-lg bg-surface-dark border border-secondary/50 shadow-[0_0_10px_rgba(0,240,255,0.2)]">
          <p class="text-secondary text-2xl font-bold font-display">{{ hours }}</p>
        </div>
        <p class="text-white/60 text-xs">Horas</p>
      </div>
      <div class="flex flex-col gap-2">
        <div class="flex size-16 items-center justify-center rounded-lg bg-surface-dark border border-primary/50 shadow-[0_0_10px_rgba(244,37,244,0.2)]">
          <p class="text-primary text-2xl font-bold font-display">{{ minutes }}</p>
        </div>
        <p class="text-white/60 text-xs">Min</p>
      </div>
      <div class="flex flex-col gap-2">
        <div class="flex size-16 items-center justify-center rounded-lg bg-surface-dark border border-secondary/50 shadow-[0_0_10px_rgba(0,240,255,0.2)]">
          <p class="text-secondary text-2xl font-bold font-display">{{ seconds }}</p>
        </div>
        <p class="text-white/60 text-xs">Seg</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

interface Props {
  targetDate: string | Date
}

const props = defineProps<Props>()

const days = ref(0)
const hours = ref(0)
const minutes = ref(0)
const seconds = ref(0)

let intervalId: number | null = null

function updateCountdown() {
  const now = new Date().getTime()
  const target = new Date(props.targetDate).getTime()
  const distance = target - now

  if (distance < 0) {
    days.value = 0
    hours.value = 0
    minutes.value = 0
    seconds.value = 0
    if (intervalId) {
      clearInterval(intervalId)
    }
    return
  }

  days.value = Math.floor(distance / (1000 * 60 * 60 * 24))
  hours.value = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
  minutes.value = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60))
  seconds.value = Math.floor((distance % (1000 * 60)) / 1000)
}

onMounted(() => {
  updateCountdown()
  intervalId = window.setInterval(updateCountdown, 1000)
})

onUnmounted(() => {
  if (intervalId) {
    clearInterval(intervalId)
  }
})
</script>

