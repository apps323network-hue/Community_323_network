import { ref } from 'vue'

type Theme = 'light' | 'dark'

const theme = ref<Theme>('dark')

// Inicializar tema imediatamente
if (typeof window !== 'undefined') {
  const savedTheme = localStorage.getItem('theme') as Theme | null
  const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
  const initialTheme = savedTheme || (systemPrefersDark ? 'dark' : 'light')
  
  theme.value = initialTheme
  const html = document.documentElement
  if (initialTheme === 'dark') {
    html.classList.add('dark')
  } else {
    html.classList.remove('dark')
  }
}

export function useTheme() {
  const setTheme = (newTheme: Theme) => {
    theme.value = newTheme
    const html = document.documentElement
    
    if (newTheme === 'dark') {
      html.classList.add('dark')
    } else {
      html.classList.remove('dark')
    }
    
    localStorage.setItem('theme', newTheme)
  }

  const toggleTheme = () => {
    setTheme(theme.value === 'dark' ? 'light' : 'dark')
  }

  return {
    theme,
    setTheme,
    toggleTheme,
  }
}
