<template>
  <div class="bg-white p-6 rounded-lg border border-slate-200 flex flex-col gap-4 shadow-sm hover:shadow-md transition-shadow">
    <!-- Stars -->
    <div class="flex gap-1 text-primary text-sm drop-shadow-sm">
      <span
        v-for="i in 5"
        :key="i"
        class="material-symbols-outlined text-[16px]"
        :class="i <= Math.floor(testimonial.rating) ? 'fill-current' : i === Math.ceil(testimonial.rating) && testimonial.rating % 1 !== 0 ? 'fill-current opacity-50' : ''"
      >
        {{ i <= Math.floor(testimonial.rating) ? 'star' : i === Math.ceil(testimonial.rating) && testimonial.rating % 1 !== 0 ? 'star_half' : 'star' }}
      </span>
    </div>

    <!-- Text -->
    <p class="text-slate-600 text-sm italic">
      "{{ testimonial.text }}"
    </p>

    <!-- Author -->
    <div class="flex items-center gap-3 mt-auto pt-2">
      <div
        class="size-8 rounded-full bg-slate-200 bg-cover bg-center ring-2 ring-primary/20"
        :style="{ backgroundImage: `url('${testimonial.avatar}')` }"
      ></div>
      <div>
        <p class="text-slate-900 text-xs font-bold">{{ testimonial.name }}</p>
        <p class="text-slate-500 text-[10px]">{{ testimonial.role }}</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Testimonial {
  id: number
  name: string
  role: string
  text: string
  rating: number
  avatar: string
}

defineProps<{
  testimonial: Testimonial
}>()
</script>
