<template>
  <section class="py-16 sm:py-20 md:py-24 bg-slate-900">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
      <h2 class="text-3xl sm:text-4xl md:text-5xl font-black text-white mb-6">
        {{ t('partners.cta.title') }}
      </h2>
      <p class="text-lg sm:text-xl text-gray-300 mb-10 leading-relaxed">
        {{ t('partners.cta.description') }}
      </p>
      <Button
        variant="primary"
        size="lg"
        @click="scrollToContact"
      >
        <span class="material-icons-outlined mr-2">chat</span>
        {{ t('partners.cta.button') }}
      </Button>
    </div>
  </section>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n'
import Button from '@/components/ui/Button.vue'

const { t } = useI18n()

function scrollToContact() {
  const contactSection = document.getElementById('contact-form')
  if (contactSection) {
    contactSection.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }
}
</script>

