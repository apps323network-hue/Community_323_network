<template>
  <div class="relative">
    <input
      v-model="searchQuery"
      type="text"
      placeholder="Buscar posts..."
      class="w-full bg-white dark:bg-surface-lighter border border-slate-200 dark:border-white/10 rounded-full px-5 py-3 pl-12 text-sm focus:ring-2 focus:ring-primary focus:border-transparent text-slate-900 dark:text-white placeholder-gray-500 transition-all"
      @input="handleSearch"
    />
    <span class="absolute left-4 top-1/2 -translate-y-1/2 material-icons-outlined text-gray-400 text-lg">
      search
    </span>
    <button
      v-if="searchQuery"
      class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 hover:text-primary transition-colors"
      @click="clearSearch"
    >
      <span class="material-icons-outlined text-lg">close</span>
    </button>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

const searchQuery = ref('')
let searchTimeout: ReturnType<typeof setTimeout> | null = null

const emit = defineEmits<{
  'search-change': [query: string]
}>()

function handleSearch() {
  // Debounce search
  if (searchTimeout) {
    clearTimeout(searchTimeout)
  }
  
  searchTimeout = setTimeout(() => {
    emit('search-change', searchQuery.value.trim())
  }, 300)
}

function clearSearch() {
  searchQuery.value = ''
  emit('search-change', '')
}

watch(() => searchQuery.value, () => {
  if (!searchQuery.value) {
    emit('search-change', '')
  }
})
</script>

