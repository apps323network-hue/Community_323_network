<template>
  <Card variant="white" class="p-0 overflow-hidden shadow-sm hover:shadow-md transition-shadow dark:bg-surface-dark dark:border-gray-800">
    <!-- Pinned Badge -->
    <div v-if="post.fixado" class="px-5 pt-4 pb-2">
      <Badge variant="primary" size="sm">
        <span class="material-icons-outlined text-[14px] mr-1">push_pin</span>
        Fixado
      </Badge>
    </div>

    <!-- Post Header -->
    <div class="p-6 dark:p-6 flex justify-between items-start border-b border-slate-200 dark:border-gray-800">
      <div class="flex gap-3">
        <div class="relative">
          <div class="absolute -inset-0.5 bg-gradient-to-b from-primary to-purple-600 rounded-full blur opacity-50"></div>
          <Avatar
            :src="authorAvatar"
            :name="authorName"
            size="md"
            class="relative border-2 border-white"
          />
        </div>
        <div>
          <h4 class="font-bold text-base text-gray-900 dark:text-white hover:text-primary dark:hover:text-secondary transition-colors cursor-pointer">
            {{ authorName }}
          </h4>
          <p class="text-xs text-gray-400">
            {{ authorRole }} • <span class="text-secondary">{{ formatTime(post.created_at) }}</span>
          </p>
        </div>
      </div>
      <button class="text-gray-500 dark:text-gray-400 hover:text-white transition-colors">
        <span class="material-icons-outlined">more_horiz</span>
      </button>
    </div>

    <!-- Post Content -->
    <div class="px-6 py-5">
      <p class="text-sm text-gray-900 dark:text-gray-300 leading-relaxed whitespace-pre-line">
        {{ post.conteudo }}
      </p>
      <div v-if="hashtags.length" class="mt-3 flex flex-wrap gap-2">
        <span
          v-for="tag in hashtags"
          :key="tag"
          class="text-secondary hover:text-primary transition-colors cursor-pointer font-medium text-sm"
        >
          {{ tag }}
        </span>
      </div>
    </div>

    <!-- Post Image -->
    <div v-if="post.image_url" class="mt-2 relative h-72 bg-gray-900 group overflow-hidden rounded-xl">
      <img
        :alt="'Imagem do post'"
        :src="post.image_url"
        class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
      />
      <div class="absolute inset-0 bg-black/0 group-hover:bg-black/10 transition-colors"></div>
    </div>

    <!-- Post Actions -->
    <div class="px-6 py-4 border-t border-slate-200 dark:border-gray-800 flex justify-between items-center text-gray-400">
      <div class="flex gap-6">
        <button
          class="flex items-center gap-2 text-sm hover:text-primary dark:hover:text-secondary transition-all group"
          :class="post.isLiked ? 'text-primary dark:text-secondary' : ''"
          @click="handleToggleLike"
        >
          <span class="material-icons-outlined group-hover:scale-110 transition-transform">
            {{ post.isLiked ? 'favorite' : 'favorite_border' }}
          </span>
          <span class="font-medium">{{ post.likes_count || 0 }}</span>
        </button>
        <button
          class="flex items-center gap-2 text-sm hover:text-secondary transition-all group"
          @click="handleToggleComments"
        >
          <span class="material-icons-outlined group-hover:scale-110 transition-transform">chat_bubble_outline</span>
          <span class="font-medium">{{ post.comments_count || 0 }}</span>
        </button>
      </div>
      <button class="flex items-center gap-1.5 text-sm hover:text-white transition-colors" @click="$emit('share', post.id)">
        <span class="material-icons-outlined">share</span>
      </button>
    </div>

    <!-- Comments Section -->
    <div v-if="showCommentsSection" class="border-t border-slate-200 dark:border-gray-800 bg-slate-50 dark:bg-surface-lighter">
      <div v-if="post.comments && post.comments.length > 0" class="px-6 pt-4 pb-2">
        <PostComment
          v-for="comment in post.comments"
          :key="comment.id"
          :comment="comment"
          @edit="(id) => $emit('edit-comment', id)"
          @delete="(id) => $emit('delete-comment', id)"
        />
      </div>
      <slot name="comment-form" />
    </div>
  </Card>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { usePosts } from '@/composables/usePosts'
import Card from '@/components/ui/Card.vue'
import Avatar from '@/components/ui/Avatar.vue'
import Badge from '@/components/ui/Badge.vue'
import PostComment from './PostComment.vue'
import type { Post } from '@/types/posts'

interface Props {
  post: Post
  showComments?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  showComments: false,
})

const emit = defineEmits<{
  'toggle-comments': [postId: string]
  'share': [postId: string]
  'edit-comment': [commentId: string]
  'delete-comment': [commentId: string]
}>()

const { toggleLike, loadComments } = usePosts()
const commentsLoaded = ref(false)
const showCommentsSection = ref(props.showComments)

// Computed for author display
const authorName = computed(() => props.post.author?.nome || 'Usuário')
const authorRole = computed(() => {
  const area = props.post.author?.area_atuacao
  return area && area.trim() ? area : 'Membro'
})
const authorAvatar = computed(() => props.post.author?.avatar_url || '')

// Extract hashtags from content
const hashtags = computed(() => {
  const matches = props.post.conteudo.match(/#\w+/g)
  return matches || []
})

async function handleToggleLike() {
  try {
    await toggleLike(props.post.id)
  } catch (error) {
    console.error('Error toggling like:', error)
  }
}

async function handleToggleComments() {
  showCommentsSection.value = !showCommentsSection.value
  
  if (showCommentsSection.value && !commentsLoaded.value && !props.post.comments) {
    try {
      await loadComments(props.post.id)
      commentsLoaded.value = true
    } catch (error) {
      console.error('Error loading comments:', error)
    }
  }
  
  emit('toggle-comments', props.post.id)
}

function formatTime(date: string) {
  const now = new Date()
  const postDate = new Date(date)
  const diffInSeconds = Math.floor((now.getTime() - postDate.getTime()) / 1000)

  if (diffInSeconds < 60) return 'agora'
  if (diffInSeconds < 3600) return `${Math.floor(diffInSeconds / 60)}min atrás`
  if (diffInSeconds < 86400) return `${Math.floor(diffInSeconds / 3600)}h atrás`
  if (diffInSeconds < 604800) return `${Math.floor(diffInSeconds / 86400)}d atrás`
  return postDate.toLocaleDateString('pt-BR')
}
</script>

