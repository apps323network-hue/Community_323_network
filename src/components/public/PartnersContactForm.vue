<template>
  <section id="contact-form" class="py-16 sm:py-20 md:py-24 bg-white">
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Title -->
      <div class="text-center mb-12">
        <h2 class="text-3xl sm:text-4xl md:text-5xl font-black text-slate-900 mb-4">
          {{ t('partners.contact.title') }}
        </h2>
        <p class="text-lg text-slate-600">
          {{ t('partners.contact.description') }}
        </p>
        <div class="w-24 h-1 bg-neon-gradient mx-auto rounded-full mt-4"></div>
      </div>

      <!-- Form -->
      <form @submit.prevent="handleSubmit" class="space-y-6">
        <!-- Name -->
        <div>
          <label for="name" class="block text-sm font-bold text-slate-900 mb-2">
            {{ t('partners.contact.name') }} <span class="text-primary">*</span>
          </label>
          <input
            id="name"
            v-model="form.name"
            type="text"
            required
            :placeholder="t('partners.contact.namePlaceholder')"
            class="w-full px-4 py-3 border border-slate-200 rounded-xl bg-white text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all duration-300"
          />
        </div>

        <!-- Company -->
        <div>
          <label for="company" class="block text-sm font-bold text-slate-900 mb-2">
            {{ t('partners.contact.company') }} <span class="text-primary">*</span>
          </label>
          <input
            id="company"
            v-model="form.company"
            type="text"
            required
            :placeholder="t('partners.contact.companyPlaceholder')"
            class="w-full px-4 py-3 border border-slate-200 rounded-xl bg-white text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all duration-300"
          />
        </div>

        <!-- Email -->
        <div>
          <label for="email" class="block text-sm font-bold text-slate-900 mb-2">
            {{ t('partners.contact.email') }} <span class="text-primary">*</span>
          </label>
          <input
            id="email"
            v-model="form.email"
            type="email"
            required
            :placeholder="t('partners.contact.emailPlaceholder')"
            class="w-full px-4 py-3 border border-slate-200 rounded-xl bg-white text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all duration-300"
          />
        </div>

        <!-- Phone (Optional) -->
        <div>
          <label for="phone" class="block text-sm font-bold text-slate-900 mb-2">
            {{ t('partners.contact.phone') }}
          </label>
          <input
            id="phone"
            v-model="form.phone"
            type="tel"
            :placeholder="t('partners.contact.phonePlaceholder')"
            class="w-full px-4 py-3 border border-slate-200 rounded-xl bg-white text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all duration-300"
          />
        </div>

        <!-- Subject -->
        <div>
          <label for="subject" class="block text-sm font-bold text-slate-900 mb-2">
            {{ t('partners.contact.subject') }} <span class="text-primary">*</span>
          </label>
          <select
            id="subject"
            v-model="form.subject"
            required
            class="w-full px-4 py-3 border border-slate-200 rounded-xl bg-white text-slate-900 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all duration-300"
          >
            <option value="">{{ t('partners.contact.subjectPlaceholder') }}</option>
            <option value="sponsorship">{{ t('partners.contact.subjects.sponsorship') }}</option>
            <option value="partnership">{{ t('partners.contact.subjects.partnership') }}</option>
            <option value="naming">{{ t('partners.contact.subjects.naming') }}</option>
            <option value="other">{{ t('partners.contact.subjects.other') }}</option>
          </select>
        </div>

        <!-- Message -->
        <div>
          <label for="message" class="block text-sm font-bold text-slate-900 mb-2">
            {{ t('partners.contact.message') }} <span class="text-primary">*</span>
          </label>
          <textarea
            id="message"
            v-model="form.message"
            required
            rows="6"
            :placeholder="t('partners.contact.messagePlaceholder')"
            class="w-full px-4 py-3 border border-slate-200 rounded-xl bg-white text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all duration-300 resize-none"
          ></textarea>
        </div>

        <!-- Submit Button -->
        <div class="pt-4">
          <Button
            type="submit"
            variant="primary"
            size="lg"
            :full-width="true"
            :loading="submitting"
          >
            <span class="material-icons-outlined mr-2">send</span>
            {{ t('partners.contact.submit') }}
          </Button>
        </div>
      </form>

      <!-- Alternative Contact -->
      <div class="mt-12 pt-12 border-t border-slate-200 text-center">
        <p class="text-slate-600 mb-4">
          {{ t('partners.contact.alternative') }}
        </p>
        <div class="flex flex-col sm:flex-row gap-4 justify-center">
          <a
            :href="`https://wa.me/13239791990`"
            target="_blank"
            rel="noopener noreferrer"
            class="inline-flex items-center justify-center gap-2 px-6 py-3 bg-green-500 hover:bg-green-600 text-white rounded-lg font-bold transition-all duration-300 transform hover:-translate-y-0.5"
          >
            <span class="material-icons-outlined">chat</span>
            {{ t('partners.contact.whatsapp') }}
          </a>
          <a
            href="mailto:admin@323network.com"
            class="inline-flex items-center justify-center gap-2 px-6 py-3 bg-white border border-slate-200 hover:border-primary text-slate-900 rounded-lg font-bold transition-all duration-300 transform hover:-translate-y-0.5"
          >
            <span class="material-icons-outlined">email</span>
            admin@323network.com
          </a>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { toast } from 'vue-sonner'
import Button from '@/components/ui/Button.vue'
import { sendPartnerContactEmail } from '@/lib/emails'

const { t } = useI18n()

const submitting = ref(false)

const form = ref({
  name: '',
  company: '',
  email: '',
  phone: '',
  subject: '',
  message: '',
})

async function handleSubmit() {
  if (!form.value.name || !form.value.company || !form.value.email || !form.value.subject || !form.value.message) {
    toast.error('Por favor, preencha todos os campos obrigatórios')
    return
  }

  submitting.value = true

  try {
    const result = await sendPartnerContactEmail({
      name: form.value.name,
      company: form.value.company,
      email: form.value.email,
      phone: form.value.phone || undefined,
      subject: form.value.subject,
      message: form.value.message,
    })

    if (result.success) {
      toast.success('Mensagem enviada com sucesso!', {
        description: 'Entraremos em contato em breve.',
        duration: 5000,
      })
      
      // Reset form
      form.value = {
        name: '',
        company: '',
        email: '',
        phone: '',
        subject: '',
        message: '',
      }
    } else {
      throw new Error(result.error?.message || 'Erro ao enviar mensagem')
    }
  } catch (error: any) {
    console.error('Error submitting contact form:', error)
    toast.error('Erro ao enviar mensagem', {
      description: error.message || 'Por favor, tente novamente mais tarde.',
      duration: 5000,
    })
  } finally {
    submitting.value = false
  }
}
</script>

