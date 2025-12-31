<template>
  <section class="py-16 sm:py-20 md:py-24 bg-slate-900">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Title -->
      <div class="text-center mb-12 md:mb-16">
        <h2 class="text-3xl sm:text-4xl md:text-5xl font-black text-white mb-4">
          {{ t('partners.testimonials.title') }}
        </h2>
        <div class="w-24 h-1 bg-neon-gradient mx-auto rounded-full"></div>
      </div>

      <!-- Testimonials Grid -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 lg:gap-8">
        <div
          v-for="(testimonial, index) in placeholderTestimonials"
          :key="index"
          class="bg-slate-800 rounded-xl p-6 border border-slate-700 hover:border-primary/50 transition-all duration-300 hover:shadow-xl"
        >
          <!-- Quote Icon -->
          <div class="mb-4">
            <span class="material-icons-outlined text-4xl text-primary/30">format_quote</span>
          </div>

          <!-- Testimonial Text -->
          <p class="text-gray-200 mb-6 leading-relaxed italic">
            "{{ testimonial.text }}"
          </p>

          <!-- Author Info -->
          <div class="flex items-center gap-4">
            <div class="w-12 h-12 bg-gradient-to-br from-primary/20 to-secondary/20 rounded-full flex items-center justify-center">
              <span class="material-icons-outlined text-primary">{{ testimonial.avatar || 'person' }}</span>
            </div>
            <div>
              <div class="font-bold text-white">
                {{ testimonial.name }}
              </div>
              <div class="text-sm text-gray-400">
                {{ testimonial.role }}, {{ testimonial.company }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

// Placeholder testimonials - será substituído por dados reais depois
const placeholderTestimonials = [
  {
    text: 'A parceria com a 323 Network nos permitiu alcançar exatamente o público que procurávamos: brasileiros qualificados e engajados nos EUA. Os resultados superaram nossas expectativas.',
    name: 'Maria Silva',
    role: 'CMO',
    company: 'Tech Brasil Inc.',
    avatar: 'person',
  },
  {
    text: 'Eventos bem organizados, público de qualidade e uma equipe super profissional. A 323 Network entende as necessidades das marcas e entrega resultados concretos.',
    name: 'João Santos',
    role: 'Diretor de Marketing',
    company: 'Company XYZ',
    avatar: 'person',
  },
  {
    text: 'Participar como patrocinador da 323 foi uma das melhores decisões que tomamos. A exposição da marca foi excelente e geramos leads qualificados em cada evento.',
    name: 'Ana Costa',
    role: 'Fundadora',
    company: 'StartUp ABC',
    avatar: 'person',
  },
]
</script>

