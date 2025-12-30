<template>
  <section class="py-16 sm:py-20 md:py-24 bg-gradient-to-br from-primary/10 via-secondary/10 to-primary/10 dark:from-primary/5 dark:via-secondary/5 dark:to-primary/5">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
      <h2 class="text-3xl sm:text-4xl md:text-5xl font-black text-slate-900 dark:text-white mb-6">
        {{ t('partners.namingRights.title') }}
      </h2>
      <p class="text-lg sm:text-xl text-slate-700 dark:text-gray-300 mb-8 leading-relaxed">
        {{ t('partners.namingRights.description') }}
      </p>
      <ul class="text-left max-w-2xl mx-auto space-y-4 mb-10">
        <li class="flex items-start gap-3">
          <span class="material-icons-outlined text-primary dark:text-secondary text-xl flex-shrink-0 mt-0.5">check_circle</span>
          <span class="text-slate-700 dark:text-gray-300">{{ t('partners.namingRights.benefit1') }}</span>
        </li>
        <li class="flex items-start gap-3">
          <span class="material-icons-outlined text-primary dark:text-secondary text-xl flex-shrink-0 mt-0.5">check_circle</span>
          <span class="text-slate-700 dark:text-gray-300">{{ t('partners.namingRights.benefit2') }}</span>
        </li>
        <li class="flex items-start gap-3">
          <span class="material-icons-outlined text-primary dark:text-secondary text-xl flex-shrink-0 mt-0.5">check_circle</span>
          <span class="text-slate-700 dark:text-gray-300">{{ t('partners.namingRights.benefit3') }}</span>
        </li>
      </ul>
      <Button
        variant="primary"
        size="lg"
        @click="scrollToContact"
      >
        <span class="material-icons-outlined mr-2">handshake</span>
        {{ t('partners.namingRights.cta') }}
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

