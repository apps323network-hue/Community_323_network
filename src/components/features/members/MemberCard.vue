<template>
  <!-- Versão Destacada (Featured) -->
  <div
    v-if="variant === 'featured'"
    class="relative group rounded-2xl overflow-hidden bg-white dark:bg-card-dark border border-gray-200 dark:border-white/5 shadow-xl hover:border-primary/50 dark:hover:border-primary/50 hover:shadow-neon-blue transition-all duration-500 hover:-translate-y-2"
  >
    <div class="h-28 bg-gradient-to-r from-blue-700 via-blue-500 to-primary opacity-90 group-hover:opacity-100 transition-opacity"></div>
    <div class="px-6 pb-6 relative">
      <div class="absolute -top-14 left-6">
        <div class="h-28 w-28 rounded-2xl p-1 bg-white dark:bg-card-dark shadow-2xl ring-2 ring-transparent group-hover:ring-primary/50 transition-all">
          <Avatar
            :src="member.avatar"
            :name="member.nome"
            size="xl"
            class="rounded-xl"
          />
        </div>
      </div>
      <div class="pt-16">
        <div class="flex justify-between items-start mb-3">
          <div>
            <h3 class="text-xl font-bold text-gray-900 dark:text-white group-hover:text-primary transition-colors">
              {{ member.nome }}
            </h3>
            <p class="text-sm text-primary font-bold tracking-wide uppercase">
              {{ member.area_atuacao }}
            </p>
          </div>
          <button class="text-gray-400 hover:text-white hover:scale-110 transition-transform">
            <span class="material-icons">bookmark_border</span>
          </button>
        </div>
        <p v-if="member.descricao" class="text-sm text-gray-500 dark:text-gray-300 mb-5 line-clamp-2 leading-relaxed">
          {{ member.descricao }}
        </p>
        <div v-if="member.tags && member.tags.length" class="flex flex-wrap gap-2 mb-8">
          <Badge
            v-for="tag in member.tags"
            :key="tag"
            variant="primary"
            size="sm"
          >
            {{ tag }}
          </Badge>
        </div>
        <div class="flex gap-3">
          <Button
            variant="primary"
            size="sm"
            class="flex-1"
            @click="$emit('connect', member.id)"
          >
            Conectar
          </Button>
          <button
            class="p-2.5 rounded-xl border border-gray-700 hover:border-secondary hover:bg-secondary/10 hover:text-secondary hover:shadow-neon-pink text-gray-400 transition-all duration-300"
            @click="$emit('chat', member.id)"
          >
            <span class="material-icons text-xl">chat_bubble_outline</span>
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Versão Lista (List) -->
  <div
    v-else
    class="group p-4 sm:p-6 border-b border-gray-100 dark:border-white/5 hover:bg-white/5 dark:hover:bg-surface-lighter/50 transition-all duration-300 flex flex-col sm:flex-row items-center gap-4 hover:shadow-[inset_0_0_20px_rgba(0,195,255,0.05)]"
  >
    <div class="relative">
      <Avatar
        :src="member.avatar"
        :name="member.nome"
        size="lg"
        :class="[
          'border-2 transition-shadow duration-300',
          member.online
            ? 'border-secondary group-hover:shadow-[0_0_15px_rgba(255,0,230,0.5)]'
            : 'border-gray-600 group-hover:border-white'
        ]"
      />
      <div
        v-if="member.online"
        class="absolute bottom-0 right-0 h-4 w-4 bg-green-500 border-2 border-white dark:border-card-dark rounded-full shadow-[0_0_10px_rgba(34,197,94,0.6)]"
      ></div>
    </div>
    <div class="flex-1 text-center sm:text-left">
      <h3 class="text-lg font-bold text-gray-900 dark:text-white group-hover:text-secondary dark:group-hover:text-primary transition-colors">
        {{ member.nome }}
      </h3>
      <p class="text-sm text-gray-500 dark:text-gray-400">
        {{ member.area_atuacao }} • {{ member.cidade }}, {{ member.pais }}
      </p>
    </div>
    <div class="flex gap-3 w-full sm:w-auto">
      <Button
        v-if="!member.connectionStatus || member.connectionStatus === 'none'"
        variant="outline"
        size="sm"
        class="flex-1 sm:flex-none"
        @click="$emit('connect', member.id)"
      >
        Conectar
      </Button>
      <button
        v-else-if="member.connectionStatus === 'pending'"
        class="flex-1 sm:flex-none px-6 py-2.5 rounded-lg bg-white/5 border border-white/10 text-gray-400 cursor-default text-sm font-semibold tracking-wide shadow-inner"
        disabled
      >
        Pendente
      </button>
      <button
        v-else
        class="flex-1 sm:flex-none px-6 py-2.5 rounded-lg border border-primary/40 text-primary bg-primary/5 text-sm font-bold"
        disabled
      >
        Conectado
      </button>
      <button
        class="px-3 py-2.5 rounded-lg border border-gray-800 bg-card-dark text-gray-400 hover:text-secondary hover:border-secondary hover:bg-secondary/10 hover:shadow-neon-pink transition-all duration-300"
        @click="$emit('chat', member.id)"
      >
        <span class="material-icons text-sm">chat</span>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import Avatar from '@/components/ui/Avatar.vue'
import Badge from '@/components/ui/Badge.vue'
import Button from '@/components/ui/Button.vue'

interface Member {
  id: string
  nome: string
  area_atuacao: string
  cidade: string
  pais: string
  avatar: string
  descricao?: string
  tags?: string[]
  online?: boolean
  connectionStatus?: 'none' | 'pending' | 'connected'
}

interface Props {
  member: Member
  variant?: 'featured' | 'list'
}

withDefaults(defineProps<Props>(), {
  variant: 'list',
})

defineEmits<{
  connect: [memberId: string]
  chat: [memberId: string]
}>()
</script>

