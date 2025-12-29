import { createI18n } from 'vue-i18n'
import ptBR from './locales/pt-BR.json'
import enUS from './locales/en-US.json'

const i18n = createI18n({
    legacy: false,
    locale: 'pt-BR', // Default locale
    fallbackLocale: 'pt-BR',
    messages: {
        'pt-BR': ptBR,
        'en-US': enUS,
    },
})

// Restaurar locale do localStorage após criação
if (typeof window !== 'undefined') {
    const savedLocale = localStorage.getItem('locale')
    if (savedLocale && (savedLocale === 'pt-BR' || savedLocale === 'en-US')) {
        i18n.global.locale.value = savedLocale
    }
}

export default i18n
