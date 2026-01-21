import { ref } from 'vue'
import { toast } from 'vue-sonner'
import { useI18n } from 'vue-i18n'

export interface ShareOptions {
    url: string
    title: string
    description?: string
    imageUrl?: string
    type?: 'program' | 'event'
    id?: string
    lang?: string
}

export function useShare() {
    const { t, locale } = useI18n()
    const isSharing = ref(false)

    const getFullUrl = (path: string): string => {
        const baseUrl = window.location.origin
        return `${baseUrl}${path.startsWith('/') ? path : `/${path}`}`
    }

    const getSocialUrl = (options: ShareOptions): string => {
        // If we have type and id, we use the Edge Function for better social previews
        if (options.type && options.id) {
            const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
            if (supabaseUrl) {
                const previewUrl = new URL(`${supabaseUrl}/functions/v1/share-preview`)
                previewUrl.searchParams.set('type', options.type)
                previewUrl.searchParams.set('id', options.id)
                previewUrl.searchParams.set('lang', options.lang || locale.value.split('-')[0])
                return previewUrl.toString()
            }
        }
        return getFullUrl(options.url)
    }

    const shareToWhatsApp = (options: ShareOptions) => {
        const shareUrl = getSocialUrl(options)
        const text = `${options.title}\n\n${options.description || ''}\n\n${shareUrl}`
        const whatsappUrl = `https://wa.me/?text=${encodeURIComponent(text)}`

        window.open(whatsappUrl, '_blank', 'noopener,noreferrer')
    }

    const shareToInstagram = (options: ShareOptions) => {
        // For Instagram we copy the REAL app URL as it's better for bios
        copyToClipboard(options)
        toast.info(t('share.instagramInstructions'), {
            description: t('share.instagramInstructionsDesc'),
            duration: 5000,
        })
    }

    const copyToClipboard = async (options: ShareOptions) => {
        const fullUrl = getFullUrl(options.url)

        try {
            await navigator.clipboard.writeText(fullUrl)
            toast.success(t('share.linkCopied'))
        } catch (err) {
            // Fallback for older browsers
            const textArea = document.createElement('textarea')
            textArea.value = fullUrl
            textArea.style.position = 'fixed'
            textArea.style.left = '-999999px'
            document.body.appendChild(textArea)
            textArea.select()

            try {
                document.execCommand('copy')
                toast.success(t('share.linkCopied'))
            } catch (e) {
                toast.error(t('share.copyFailed'))
            }

            document.body.removeChild(textArea)
        }
    }

    const shareNative = async (options: ShareOptions) => {
        const shareUrl = getSocialUrl(options)

        if (!navigator.share) {
            // Fallback to copy if native share not supported
            await copyToClipboard(options)
            return
        }

        isSharing.value = true

        try {
            await navigator.share({
                title: options.title,
                text: options.description,
                url: shareUrl,
            })
        } catch (err: any) {
            // User cancelled or error occurred
            if (err.name !== 'AbortError') {
                console.error('Error sharing:', err)
                toast.error(t('share.shareFailed'))
            }
        } finally {
            isSharing.value = false
        }
    }

    const canUseNativeShare = (): boolean => {
        return typeof navigator !== 'undefined' && !!navigator.share
    }

    return {
        isSharing,
        shareToWhatsApp,
        shareToInstagram,
        copyToClipboard,
        shareNative,
        canUseNativeShare,
    }
}
