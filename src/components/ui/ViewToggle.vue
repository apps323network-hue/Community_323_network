<template>
  <div class="flex items-center gap-2 p-1 rounded-lg bg-slate-100 dark:bg-surface-lighter border border-slate-200 dark:border-white/10">
    <button
      :class="[
        'p-2 rounded-md transition-all',
        modelValue === 'grid'
          ? 'bg-white dark:bg-surface-dark text-primary dark:text-secondary shadow-sm'
          : 'text-slate-600 dark:text-gray-400 hover:text-primary dark:hover:text-secondary'
      ]"
      @click="$emit('update:modelValue', 'grid')"
      title="Visualização em grade"
    >
      <span class="material-symbols-outlined text-[20px]">grid_view</span>
    </button>
    <button
      :class="[
        'p-2 rounded-md transition-all',
        modelValue === 'list'
          ? 'bg-white dark:bg-surface-dark text-primary dark:text-secondary shadow-sm'
          : 'text-slate-600 dark:text-gray-400 hover:text-primary dark:hover:text-secondary'
      ]"
      @click="$emit('update:modelValue', 'list')"
      title="Visualização em lista"
    >
      <span class="material-symbols-outlined text-[20px]">view_list</span>
    </button>
  </div>
</template>

<script setup lang="ts">
interface Props {
  modelValue: 'grid' | 'list'
}

defineProps<Props>()

defineEmits<{
  'update:modelValue': [value: 'grid' | 'list']
}>()
</script>

