<template>
  <div class="w-full">
    <!-- Tab Headers -->
    <div class="flex border-b border-slate-200 dark:border-white/10 overflow-x-auto no-scrollbar">
      <button
        v-for="(tab, index) in tabs"
        :key="tab.id || index"
        :class="[
          'flex items-center gap-2 px-4 py-3 text-sm font-medium transition-all duration-300',
          'border-b-2 border-transparent',
          'text-slate-600 dark:text-gray-400',
          'hover:text-primary dark:hover:text-secondary',
          activeTab === (tab.id || index) && [
            'text-primary dark:text-secondary',
            'border-primary dark:border-secondary',
            'font-bold'
          ]
        ]"
        @click="$emit('update:modelValue', tab.id || index)"
      >
        <span v-if="tab.icon" class="material-symbols-outlined text-[20px]">{{ tab.icon }}</span>
        {{ tab.label }}
        <Badge v-if="tab.badge" :variant="tab.badgeVariant || 'primary'" size="sm">
          {{ tab.badge }}
        </Badge>
      </button>
    </div>

    <!-- Tab Content -->
    <div class="mt-4">
      <slot :name="`tab-${activeTab}`" :tab="activeTab">
        <slot />
      </slot>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import Badge from './Badge.vue'

interface Tab {
  id?: string | number
  label: string
  icon?: string
  badge?: string | number
  badgeVariant?: 'primary' | 'secondary' | 'success' | 'warning'
}

interface Props {
  modelValue: string | number
  tabs: Tab[]
}

const props = defineProps<Props>()

defineEmits<{
  'update:modelValue': [value: string | number]
}>()

const activeTab = computed(() => props.modelValue)
</script>

<style scoped>
.no-scrollbar::-webkit-scrollbar {
  display: none;
}
.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}
</style>

