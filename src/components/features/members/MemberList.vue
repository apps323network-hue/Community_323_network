<template>
  <div>
    <!-- Grid View -->
    <div
      v-if="viewMode === 'grid'"
      class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8"
    >
      <MemberCard
        v-for="member in members"
        :key="member.id"
        :member="member"
        variant="featured"
        @connect="$emit('connect', $event)"
        @chat="$emit('chat', $event)"
      />
    </div>

    <!-- List View -->
    <div
      v-else
      class="bg-white dark:bg-card-dark rounded-2xl shadow-sm border border-gray-200 dark:border-white/5 overflow-hidden"
    >
      <MemberCard
        v-for="member in members"
        :key="member.id"
        :member="member"
        variant="list"
        @connect="$emit('connect', $event)"
        @chat="$emit('chat', $event)"
      />
    </div>

    <!-- Empty State -->
    <EmptyState
      v-if="members.length === 0"
      icon="people"
      title="Nenhum membro encontrado"
      description="Tente ajustar os filtros de busca para encontrar mais membros."
    />

    <!-- Pagination -->
    <div v-if="showPagination && totalPages > 1" class="mt-8 flex justify-center gap-2">
      <button
        v-for="page in totalPages"
        :key="page"
        :class="[
          'px-4 py-2 rounded-lg transition-all',
          currentPage === page
            ? 'bg-primary text-white shadow-[0_0_15px_rgba(244,37,244,0.4)]'
            : 'bg-white dark:bg-surface-dark border border-slate-200 dark:border-white/10 text-slate-600 dark:text-gray-400 hover:border-primary'
        ]"
        @click="$emit('page-change', page)"
      >
        {{ page }}
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import MemberCard from './MemberCard.vue'
import EmptyState from '@/components/ui/EmptyState.vue'

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
  members: Member[]
  viewMode?: 'grid' | 'list'
  showPagination?: boolean
  currentPage?: number
  totalPages?: number
}

withDefaults(defineProps<Props>(), {
  viewMode: 'grid',
  showPagination: false,
  currentPage: 1,
  totalPages: 1,
})

defineEmits<{
  connect: [memberId: string]
  chat: [memberId: string]
  'page-change': [page: number]
}>()
</script>

