<template>
  <div class="relative group w-full">
    <div
      :class="[
        'flex items-center rounded-lg border transition-all duration-300',
        'bg-white dark:bg-input-bg border-slate-200 dark:border-input-border',
        'focus-within:border-primary dark:focus-within:border-secondary',
        'focus-within:shadow-[0_0_15px_rgba(244,37,244,0.2)] dark:focus-within:shadow-neon-blue',
        sizeClasses
      ]"
    >
      <div class="flex items-center justify-center pl-3 pr-2 text-slate-400 dark:text-gray-500 group-focus-within:text-primary dark:group-focus-within:text-secondary transition-colors">
        <span class="material-symbols-outlined text-[20px]">search</span>
      </div>
      <input
        :id="inputId"
        :type="type"
        :value="modelValue"
        :placeholder="placeholder"
        :disabled="disabled"
        :class="[
          'flex-1 w-full bg-transparent border-none text-slate-900 dark:text-white',
          'placeholder:text-slate-400 dark:placeholder:text-gray-500',
          'focus:outline-none focus:ring-0',
          'disabled:opacity-50 disabled:cursor-not-allowed',
          inputSizeClasses
        ]"
        @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
        @focus="$emit('focus', $event)"
        @blur="$emit('blur', $event)"
        @keyup.enter="$emit('search', modelValue)"
      />
      <button
        v-if="modelValue && clearable"
        class="pr-3 text-slate-400 hover:text-primary dark:hover:text-secondary transition-colors"
        @click="clearSearch"
        type="button"
      >
        <span class="material-symbols-outlined text-[18px]">close</span>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  modelValue: string
  placeholder?: string
  disabled?: boolean
  clearable?: boolean
  size?: 'sm' | 'md' | 'lg'
  type?: string
}

const props = withDefaults(defineProps<Props>(), {
  placeholder: 'Buscar...',
  disabled: false,
  clearable: true,
  size: 'md',
  type: 'text',
})

defineEmits<{
  'update:modelValue': [value: string]
  focus: [event: FocusEvent]
  blur: [event: FocusEvent]
  search: [query: string]
}>()

const inputId = computed(() => `search-${Math.random().toString(36).substr(2, 9)}`)

const sizeClasses = computed(() => {
  const sizes = {
    sm: 'h-9',
    md: 'h-10',
    lg: 'h-12',
  }
  return sizes[props.size]
})

const inputSizeClasses = computed(() => {
  const sizes = {
    sm: 'text-sm px-2',
    md: 'text-base px-3',
    lg: 'text-lg px-4',
  }
  return sizes[props.size]
})

function clearSearch() {
  // @ts-ignore
  props.modelValue = ''
}
</script>

