import { useI18n } from 'vue-i18n'

export function useLocale() {
    const { locale, t } = useI18n()

    const setLocale = (newLocale: string) => {
        locale.value = newLocale
        localStorage.setItem('locale', newLocale)
    }

    const availableLocales = [
        { code: 'pt-BR', name: 'Português', flag: '🇧🇷' },
        { code: 'en-US', name: 'English', flag: '🇺🇸' },
    ]

    return {
        locale, // Retornar o locale reativo diretamente
        setLocale,
        availableLocales,
        t,
    }
}
