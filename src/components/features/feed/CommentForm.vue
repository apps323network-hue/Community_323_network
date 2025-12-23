<template>
  <div class="px-6 py-4 border-t border-slate-200 dark:border-gray-800 bg-white dark:bg-surface-lighter">
    <div class="flex gap-3">
      <Avatar :src="userAvatar" :name="userName" size="sm" :border="false" class="flex-shrink-0" />
      <div class="flex-1">
        <input
          v-model="content"
          class="w-full bg-slate-50 dark:bg-surface-dark border border-slate-200 dark:border-gray-700/50 rounded-full px-4 py-2 text-sm focus:ring-2 focus:ring-primary focus:border-transparent text-gray-900 dark:text-white placeholder-gray-400 dark:placeholder-gray-500 transition-all"
          placeholder="Escreva um comentário..."
          type="text"
          @keyup.enter="handleSubmit"
        />
      </div>
      <Button
        variant="primary"
        size="sm"
        :disabled="!content.trim() || loading"
        :loading="loading"
        @click="handleSubmit"
      >
        Enviar
      </Button>
    </div>
    <div v-if="error" class="mt-2 text-xs text-red-500">{{ error }}</div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { useUserStore } from '@/stores/user'
import { usePosts } from '@/composables/usePosts'
import Avatar from '@/components/ui/Avatar.vue'
import Button from '@/components/ui/Button.vue'

interface Props {
  postId: string
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'comment-added': []
}>()

const authStore = useAuthStore()
const userStore = useUserStore()
const { addComment } = usePosts()

const content = ref('')
const loading = ref(false)
const error = ref<string | null>(null)

const userName = computed(() => userStore.profile?.nome || authStore.user?.email?.split('@')[0] || 'Usuário')
const userAvatar = computed(() => userStore.profile?.avatar_url || authStore.user?.user_metadata?.avatar_url || '')

async function handleSubmit() {
  if (!content.value.trim() || loading.value) return

  loading.value = true
  error.value = null

  try {
    await addComment({
      post_id: props.postId,
      conteudo: content.value.trim(),
    })

    content.value = ''
    emit('comment-added')
  } catch (err: any) {
    error.value = err.message || 'Erro ao adicionar comentário. Tente novamente.'
    console.error('Error adding comment:', err)
  } finally {
    loading.value = false
  }
}
</script>

