<template>
  <div class="bg-surface-dark/80 backdrop-blur rounded-2xl p-6 border border-input-border hover:border-secondary/30 transition-colors flex flex-col items-center text-center relative overflow-hidden group">
    <div class="absolute top-0 left-0 w-full h-28 bg-gradient-to-b from-primary/20 via-secondary/10 to-transparent opacity-60"></div>
    <div class="relative mt-6 mb-4">
      <div class="size-32 rounded-full p-[3px] bg-gradient-to-br from-secondary via-white to-primary shadow-[0_0_20px_rgba(255,0,153,0.3)]">
        <Avatar
          :src="profile.avatar"
          :name="profile.nome"
          size="2xl"
          class="border-4 border-surface-dark relative z-10"
        />
      </div>
      <button
        v-if="editable"
        class="absolute bottom-1 right-1 bg-surface-dark text-white p-2.5 rounded-full border border-secondary hover:bg-secondary hover:text-surface-dark transition-all shadow-[0_0_10px_rgba(0,240,255,0.5)] z-20"
        @click="$emit('edit-avatar')"
      >
        <span class="material-symbols-outlined text-[18px]">photo_camera</span>
      </button>
    </div>
    <h2 class="text-2xl font-bold text-white">{{ profile.nome }}</h2>
    <p class="text-neon-gradient font-semibold text-sm mt-1 uppercase tracking-wider">
      {{ profile.area_atuacao }}
    </p>
    <div v-if="profile.verified" class="mt-3 flex items-center gap-1 bg-secondary/10 text-secondary px-3 py-1 rounded-full text-xs font-semibold border border-secondary/30 shadow-[0_0_8px_rgba(0,240,255,0.15)]">
      <span class="material-symbols-outlined text-[14px]">verified</span>
      <span>Verificado</span>
    </div>
    <p class="text-text-muted text-sm mt-4 px-2">
      Membro desde {{ formatDate(profile.membro_desde) }} <br/>
      {{ profile.cidade }}, {{ profile.pais }}
    </p>
    <div class="w-full h-px bg-gradient-to-r from-transparent via-input-border to-transparent my-6"></div>
    <ProfileStats :stats="stats" />
  </div>
</template>

<script setup lang="ts">
import Avatar from '@/components/ui/Avatar.vue'
import ProfileStats from './ProfileStats.vue'

interface Profile {
  id: string
  nome: string
  area_atuacao: string
  cidade: string
  pais: string
  avatar: string
  verified?: boolean
  membro_desde: string
}

interface Stats {
  profileViews?: number
  connections?: number
  posts?: number
  events?: number
}

interface Props {
  profile: Profile
  stats?: Stats
  editable?: boolean
}

withDefaults(defineProps<Props>(), {
  editable: false,
  stats: () => ({
    profileViews: 0,
    connections: 0,
    posts: 0,
    events: 0,
  }),
})

defineEmits<{
  'edit-avatar': []
}>()

function formatDate(date: string) {
  const d = new Date(date)
  return d.getFullYear()
}
</script>

