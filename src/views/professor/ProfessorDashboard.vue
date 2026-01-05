<template>
  <AppLayout>
    <div class="w-full max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- Header Overlay with Stats -->
      <div class="relative overflow-hidden rounded-3xl bg-slate-900 mb-10 p-8 sm:p-12 shadow-2xl">
        <!-- Abstract Background Shapes -->
        <div class="absolute top-0 right-0 -translate-y-1/2 translate-x-1/4 w-96 h-96 bg-secondary/20 blur-[120px] rounded-full"></div>
        <div class="absolute bottom-0 left-0 translate-y-1/2 -translate-x-1/4 w-64 h-64 bg-primary/10 blur-[80px] rounded-full"></div>
        
        <div class="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-6">
          <div>
            <div class="flex items-center gap-3 text-secondary mb-4">
              <div class="bg-secondary/10 p-2 rounded-lg">
                <span class="material-symbols-outlined text-2xl">school</span>
              </div>
              <span class="text-sm font-black uppercase tracking-[0.2em]">Área do Professor</span>
            </div>
            <h1 class="text-4xl sm:text-5xl font-black text-white mb-4 leading-tight">
              Seja bem-vindo,<br/>
              <span class="text-transparent bg-clip-text bg-gradient-to-r from-secondary to-secondary/60">Professor</span>
            </h1>
            <p class="text-slate-400 max-w-xl text-lg font-medium leading-relaxed">
              Aqui você gerencia seus programas de treinamento, acompanha o progresso dos alunos e organiza todo o material didático.
            </p>
          </div>

          <!-- Quick Stats Overlay -->
          <div class="flex gap-4 sm:gap-6">
            <div class="hidden sm:block bg-white/5 backdrop-blur-xl border border-white/10 rounded-2xl p-6 min-w-[120px] text-center">
              <p class="text-3xl font-black text-white mb-1">{{ myPrograms.length }}</p>
              <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Programas</p>
            </div>
            <div class="bg-white/5 backdrop-blur-xl border border-white/10 rounded-2xl p-6 min-w-[120px] text-center">
              <p class="text-3xl font-black text-white mb-1">{{ totalStudents }}</p>
              <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Alunos</p>
            </div>
            <div class="bg-white/5 backdrop-blur-xl border border-white/10 rounded-2xl p-6 min-w-[120px] text-center">
              <p class="text-3xl font-black text-white mb-1">{{ totalLessons }}</p>
              <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Aulas</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Programs Grid Section -->
      <div class="mb-10">
        <div class="flex items-center justify-between mb-8">
          <h2 class="text-2xl font-black text-slate-900 dark:text-white flex items-center gap-3">
            <span class="w-2 h-8 bg-secondary rounded-full"></span>
            Meus Programas
          </h2>
          <button
            @click="showCreateModal = true"
            class="px-8 py-4 bg-secondary text-black font-black rounded-2xl hover:bg-secondary/90 transition-all shadow-lg shadow-secondary/20 flex items-center gap-2"
          >
            <span class="material-symbols-outlined">add_circle</span>
            Criar Novo Programa
          </button>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <div v-for="i in 3" :key="i" class="h-80 bg-slate-200 dark:bg-white/5 animate-pulse rounded-3xl"></div>
        </div>

        <!-- Empty State -->
        <div v-else-if="myPrograms.length === 0" class="text-center py-24 bg-white dark:bg-surface-dark rounded-[32px] border border-slate-200 dark:border-white/5 shadow-xl">
          <div class="bg-secondary/10 p-10 rounded-full w-fit mx-auto mb-8 border border-secondary/20">
            <span class="material-symbols-outlined text-7xl text-secondary">import_contacts</span>
          </div>
          <h3 class="text-2xl font-black text-slate-900 dark:text-white mb-3">Nenhum programa atribuído</h3>
          <p class="text-slate-600 dark:text-gray-400 text-lg max-w-md mx-auto">
            Você ainda não possui programas sob sua gestão. Entre em contato com a administração para ser habilitado.
          </p>
        </div>

        <!-- Programs Card Grid -->
        <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <div
            v-for="program in myPrograms"
            :key="program.id"
            class="group relative bg-white dark:bg-surface-dark rounded-[32px] border border-slate-200 dark:border-white/5 overflow-hidden hover:shadow-2xl hover:shadow-secondary/10 transition-all duration-500 hover:-translate-y-2 flex flex-col h-full"
          >
            <!-- Thumbnail & Badge -->
            <div class="relative h-48 overflow-hidden">
              <img
                :src="program.thumbnail_url || '/program_placeholder.png'"
                :alt="getProgramTitle(program)"
                class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
              />
              <div class="absolute inset-0 bg-gradient-to-t from-slate-900/80 to-transparent"></div>
              <div class="absolute top-4 left-4">
                <span class="px-3 py-1 bg-secondary text-black text-[10px] font-black rounded-full uppercase tracking-tighter">
                  Ativo
                </span>
              </div>
            </div>

            <!-- Card Content -->
            <div class="p-6 flex-1 flex flex-col">
              <h3 class="text-xl font-black text-slate-900 dark:text-white mb-3 line-clamp-1 group-hover:text-secondary transition-colors">
                {{ getProgramTitle(program) }}
              </h3>
              <p class="text-sm text-slate-600 dark:text-gray-400 line-clamp-2 mb-6 font-medium leading-relaxed">
                {{ getProgramDescription(program) }}
              </p>

              <!-- Stats Row -->
              <div class="grid grid-cols-3 gap-4 py-4 border-t border-slate-100 dark:border-white/5 mb-6">
                <div class="text-center">
                  <p class="text-lg font-black text-slate-900 dark:text-white">{{ program.modulesCount || 0 }}</p>
                  <p class="text-[10px] font-bold text-slate-500 uppercase">Módulos</p>
                </div>
                <div class="text-center">
                  <p class="text-lg font-black text-slate-900 dark:text-white">{{ program.lessonsCount || 0 }}</p>
                  <p class="text-[10px] font-bold text-slate-500 uppercase">Aulas</p>
                </div>
                <div class="text-center">
                  <p class="text-lg font-black text-slate-900 dark:text-white">{{ program.studentsCount || 0 }}</p>
                  <p class="text-[10px] font-bold text-slate-500 uppercase">Alunos</p>
                </div>
              </div>

              <!-- Button Actions -->
              <div class="mt-auto space-y-3">
                <button
                  @click.stop="$router.push(`/professor/programa/${program.id}`)"
                  class="w-full py-4 bg-secondary text-black font-black rounded-2xl hover:bg-secondary/90 transition-all flex items-center justify-center gap-2 shadow-lg shadow-secondary/20"
                >
                  <span class="material-symbols-outlined text-xl">edit_document</span>
                  Gerenciar Conteúdo
                </button>
                <button
                  @click.stop="$router.push(`/programas/${program.id}`)"
                  class="w-full py-3 bg-slate-100 dark:bg-white/5 text-slate-900 dark:text-white font-bold rounded-2xl hover:bg-slate-200 dark:hover:bg-white/10 transition-all text-sm"
                >
                  Visualizar como Aluno
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Create Program Modal -->
    <div
      v-if="showCreateModal"
      class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4"
      @click.self="closeCreateModal"
    >
      <div class="bg-white dark:bg-surface-dark rounded-3xl max-w-3xl w-full shadow-2xl border border-slate-200 dark:border-white/10 max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white dark:bg-surface-dark px-8 py-6 border-b border-slate-200 dark:border-white/10 flex items-center justify-between z-10">
          <h3 class="text-2xl font-black text-slate-900 dark:text-white">Criar Novo Programa</h3>
          <button
            @click="closeCreateModal"
            class="text-slate-600 dark:text-gray-400 hover:text-slate-900 dark:hover:text-white transition-colors p-2 hover:bg-slate-100 dark:hover:bg-white/5 rounded-xl"
          >
            <span class="material-symbols-outlined">close</span>
          </button>
        </div>

        <form @submit.prevent="createProgram" class="p-8 space-y-6">
          <!-- Thumbnail Upload -->
          <div>
            <label class="block text-sm font-black text-slate-700 dark:text-gray-300 mb-3 uppercase tracking-wider">
              Imagem de Capa
            </label>
            <div class="relative border-2 border-dashed border-slate-300 dark:border-white/10 rounded-2xl p-8 text-center hover:border-secondary transition-colors">
              <input
                type="file"
                accept="image/*"
                @change="handleThumbnailSelect"
                class="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
              />
              <div v-if="!thumbnailPreview" class="space-y-2">
                <span class="material-symbols-outlined text-5xl text-slate-400">image</span>
                <p class="text-sm font-bold text-slate-600 dark:text-gray-400">Clique ou arraste uma imagem</p>
              </div>
              <img v-else :src="thumbnailPreview" class="max-h-48 mx-auto rounded-xl" />
            </div>
          </div>

          <!-- Title PT -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-black text-slate-700 dark:text-gray-300 mb-2 uppercase tracking-wider">
                Título (Português) *
              </label>
              <input
                v-model="newProgram.title_pt"
                type="text"
                required
                class="w-full px-4 py-3 rounded-xl border border-slate-200 dark:border-white/10 bg-white dark:bg-black/40 text-slate-900 dark:text-white focus:ring-2 focus:ring-secondary outline-none transition-all font-medium"
                placeholder="Ex: Programa de Liderança Executiva"
              />
            </div>

            <!-- Title EN -->
            <div>
              <label class="block text-sm font-black text-slate-700 dark:text-gray-300 mb-2 uppercase tracking-wider">
                Título (Inglês) *
              </label>
              <input
                v-model="newProgram.title_en"
                type="text"
                required
                class="w-full px-4 py-3 rounded-xl border border-slate-200 dark:border-white/10 bg-white dark:bg-black/40 text-slate-900 dark:text-white focus:ring-2 focus:ring-secondary outline-none transition-all font-medium"
                placeholder="Ex: Executive Leadership Program"
              />
            </div>
          </div>

          <!-- Short Description PT -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-black text-slate-700 dark:text-gray-300 mb-2 uppercase tracking-wider">
                Descrição Curta (PT) *
              </label>
              <textarea
                v-model="newProgram.short_description_pt"
                rows="3"
                required
                class="w-full px-4 py-3 rounded-xl border border-slate-200 dark:border-white/10 bg-white dark:bg-black/40 text-slate-900 dark:text-white focus:ring-2 focus:ring-secondary outline-none transition-all font-medium resize-none"
                placeholder="Descrição breve do programa..."
              ></textarea>
            </div>

            <!-- Short Description EN -->
            <div>
              <label class="block text-sm font-black text-slate-700 dark:text-gray-300 mb-2 uppercase tracking-wider">
                Descrição Curta (EN) *
              </label>
              <textarea
                v-model="newProgram.short_description_en"
                rows="3"
                required
                class="w-full px-4 py-3 rounded-xl border border-slate-200 dark:border-white/10 bg-white dark:bg-black/40 text-slate-900 dark:text-white focus:ring-2 focus:ring-secondary outline-none transition-all font-medium resize-none"
                placeholder="Brief program description..."
              ></textarea>
            </div>
          </div>

          <!-- Full Description PT -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-black text-slate-700 dark:text-gray-300 mb-2 uppercase tracking-wider">
                Descrição Completa (PT)
              </label>
              <textarea
                v-model="newProgram.full_description_pt"
                rows="5"
                class="w-full px-4 py-3 rounded-xl border border-slate-200 dark:border-white/10 bg-white dark:bg-black/40 text-slate-900 dark:text-white focus:ring-2 focus:ring-secondary outline-none transition-all font-medium resize-none"
              ></textarea>
            </div>

            <!-- Full Description EN -->
            <div>
              <label class="block text-sm font-black text-slate-700 dark:text-gray-300 mb-2 uppercase tracking-wider">
                Descrição Completa (EN)
              </label>
              <textarea
                v-model="newProgram.full_description_en"
                rows="5"
                class="w-full px-4 py-3 rounded-xl border border-slate-200 dark:border-white/10 bg-white dark:bg-black/40 text-slate-900 dark:text-white focus:ring-2 focus:ring-secondary outline-none transition-all font-medium resize-none"
              ></textarea>
            </div>
          </div>

          <!-- Actions -->
          <div class="flex items-center justify-end gap-4 pt-6 border-t border-slate-200 dark:border-white/10">
            <button
              type="button"
              @click="closeCreateModal"
              class="px-8 py-3 bg-slate-100 dark:bg-white/5 text-slate-900 dark:text-white font-bold rounded-xl hover:bg-slate-200 dark:hover:bg-white/10 transition-all"
            >
              Cancelar
            </button>
            <button
              type="submit"
              :disabled="creatingProgram"
              class="px-8 py-3 bg-secondary text-black font-black rounded-xl hover:bg-secondary/90 transition-all shadow-lg hover:shadow-secondary/20 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {{ creatingProgram ? 'Criando...' : 'Criar Programa' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </AppLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useLocale } from '@/composables/useLocale'
import { supabase } from '@/lib/supabase'
import AppLayout from '@/components/layout/AppLayout.vue'

const { locale: currentLocale } = useLocale()

const myPrograms = ref<any[]>([])
const loading = ref(true)

// Create program modal state
const showCreateModal = ref(false)
const creatingProgram = ref(false)
const thumbnailFile = ref<File | null>(null)
const thumbnailPreview = ref<string | null>(null)
const newProgram = ref({
  title_pt: '',
  title_en: '',
  short_description_pt: '',
  short_description_en: '',
  full_description_pt: '',
  full_description_en: ''
})

const totalStudents = computed(() => {
  return myPrograms.value.reduce((sum, p) => sum + (p.studentsCount || 0), 0)
})

const totalLessons = computed(() => {
  return myPrograms.value.reduce((sum, p) => sum + (p.lessonsCount || 0), 0)
})

const getProgramTitle = (program: any) => {
  return currentLocale.value === 'pt-BR' ? program.title_pt : program.title_en
}

const getProgramDescription = (program: any) => {
  return currentLocale.value === 'pt-BR' ? program.short_description_pt : program.short_description_en
}

function handleThumbnailSelect(event: Event) {
  const target = event.target as HTMLInputElement
  if (target.files && target.files.length > 0) {
    thumbnailFile.value = target.files[0]
    
    // Create preview
    const reader = new FileReader()
    reader.onload = (e) => {
      thumbnailPreview.value = e.target?.result as string
    }
    reader.readAsDataURL(thumbnailFile.value)
  }
}

function closeCreateModal() {
  showCreateModal.value = false
  newProgram.value = {
    title_pt: '',
    title_en: '',
    short_description_pt: '',
    short_description_en: '',
    full_description_pt: '',
    full_description_en: ''
  }
  thumbnailFile.value = null
  thumbnailPreview.value = null
}

async function createProgram() {
  creatingProgram.value = true
  
  try {
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) return

    let thumbnailUrl = null

    // Upload thumbnail if provided
    if (thumbnailFile.value) {
      const fileExt = thumbnailFile.value.name.split('.').pop()
      const fileName = `${Math.random().toString(36).substring(2)}.${fileExt}`
      const filePath = `program-thumbnails/${fileName}`

      const { error: uploadError } = await supabase.storage
        .from('program-materials')
        .upload(filePath, thumbnailFile.value)

      if (uploadError) throw uploadError

      const { data: { publicUrl } } = supabase.storage
        .from('program-materials')
        .getPublicUrl(filePath)

      thumbnailUrl = publicUrl
    }

    // Create program
    const { data: program, error: programError } = await supabase
      .from('programs')
      .insert({
        ...newProgram.value,
        thumbnail_url: thumbnailUrl,
        status: 'draft',
        created_by: user.id
      })
      .select()
      .single()

    if (programError) throw programError

    // Assign professor to program
    const { error: assignError } = await supabase
      .from('program_professors')
      .insert({
        program_id: program.id,
        professor_id: user.id
      })

    if (assignError) throw assignError

    // Refresh programs list
    await fetchProfessorPrograms()
    
    closeCreateModal()
  } catch (error) {
    console.error('Error creating program:', error)
    alert('Erro ao criar programa. Tente novamente.')
  } finally {
    creatingProgram.value = false
  }
}

async function fetchProfessorPrograms() {
  loading.value = true

  try {
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) return

    // Get programs assigned to this professor
    const { data: assignments } = await supabase
      .from('program_professors')
      .select('program_id')
      .eq('professor_id', user.id)

    if (!assignments || assignments.length === 0) {
      loading.value = false
      return
    }

    const programIds = assignments.map(a => a.program_id)

    // Fetch program details
    const { data: programs } = await supabase
      .from('programs')
      .select('*')
      .in('id', programIds)

    if (!programs) {
      loading.value = false
      return
    }

    // Fetch counts for each program
    for (const program of programs) {
      // Modules count
      const { count: modulesCount } = await supabase
        .from('program_modules')
        .select('*', { count: 'exact', head: true })
        .eq('program_id', program.id)

      // Lessons count
      const { count: lessonsCount } = await supabase
        .from('program_lessons')
        .select('*', { count: 'exact', head: true })
        .eq('program_id', program.id)

      // Students count
      const { count: studentsCount } = await supabase
        .from('program_enrollments')
        .select('*', { count: 'exact', head: true })
        .eq('program_id', program.id)

      program.modulesCount = modulesCount || 0
      program.lessonsCount = lessonsCount || 0
      program.studentsCount = studentsCount || 0
    }

    myPrograms.value = programs
  } catch (error) {
    console.error('Error fetching professor programs:', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchProfessorPrograms()
})
</script>
