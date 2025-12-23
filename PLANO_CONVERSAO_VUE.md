# 🚀 PLANO DE CONVERSÃO PARA VUE.JS
## Guia Passo a Passo para Converter HTML/CSS → Vue.js

---

## 📦 FASE 1: SETUP INICIAL

### 1.1 Criar Projeto Vue.js

```bash
npm create vue@latest 323-network
cd 323-network
npm install
```

**Opções**:
- ✅ TypeScript: Sim
- ✅ Router: Sim
- ✅ Pinia: Sim
- ✅ Vitest: Não (por enquanto)
- ✅ ESLint: Sim

### 1.2 Instalar Dependências

```bash
# Tailwind CSS
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# Outras dependências
npm install @vueuse/core
npm install @supabase/supabase-js
```

### 1.3 Configurar Tailwind CSS

**`tailwind.config.js`**:
```javascript
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary: '#f425f4',        // Neon Pink
        'primary-hover': '#d920d9',
        secondary: '#00f0ff',      // Neon Cyan
        'secondary-hover': '#00cce6',
        'background-light': '#f8f5f8',
        'background-dark': '#050508',
        'surface-dark': '#12121A',
        'surface-lighter': '#1E1E2A',
        'surface-card': '#18181b',
        'border-dark': '#3d183d',
      },
      fontFamily: {
        display: ['Plus Jakarta Sans', 'sans-serif'],
        sans: ['Inter', 'sans-serif'],
        body: ['Outfit', 'sans-serif'],
      },
      boxShadow: {
        'neon-blue': '0 0 15px rgba(0, 240, 255, 0.4), 0 0 30px rgba(0, 240, 255, 0.2)',
        'neon-pink': '0 0 15px rgba(244, 37, 244, 0.4), 0 0 30px rgba(244, 37, 244, 0.2)',
        'glow-primary': '0 0 20px rgba(244, 37, 244, 0.5)',
        'glow-secondary': '0 0 20px rgba(0, 240, 255, 0.5)',
      },
      backgroundImage: {
        'neon-gradient': 'linear-gradient(135deg, #f425f4 0%, #00f0ff 100%)',
        'neon-gradient-rev': 'linear-gradient(135deg, #00f0ff 0%, #f425f4 100%)',
      },
    },
  },
  plugins: [],
}
```

**`src/assets/css/main.css`**:
```css
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;700;800&display=swap');
@import url('https://fonts.googleapis.com/icon?family=Material+Icons+Outlined');
@import url('https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap');

@tailwind base;
@tailwind components;
@tailwind utilities;

@layer utilities {
  .text-glow-blue {
    text-shadow: 0 0 10px rgba(0, 240, 255, 0.6);
  }
  .text-glow-pink {
    text-shadow: 0 0 10px rgba(244, 37, 244, 0.6);
  }
  .neon-text-gradient {
    background: linear-gradient(to right, #f425f4, #00f0ff);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }
}

/* Scrollbar customizado */
::-webkit-scrollbar {
  width: 8px;
}
::-webkit-scrollbar-track {
  background: #050508;
}
::-webkit-scrollbar-thumb {
  background: #333;
  border-radius: 4px;
}
::-webkit-scrollbar-thumb:hover {
  background: #555;
}
```

### 1.4 Estrutura de Pastas

```
src/
├── assets/
│   ├── css/
│   │   └── main.css
│   └── images/
├── components/
│   ├── layout/
│   │   ├── AppHeader.vue
│   │   ├── AppSidebar.vue
│   │   └── AppFooter.vue
│   ├── ui/
│   │   ├── Button.vue
│   │   ├── Card.vue
│   │   ├── Input.vue
│   │   ├── Badge.vue
│   │   └── Avatar.vue
│   └── features/
│       ├── feed/
│       │   ├── PostCard.vue
│       │   └── PostForm.vue
│       ├── members/
│       │   └── MemberCard.vue
│       ├── events/
│       │   └── EventCard.vue
│       └── services/
│           └── ServiceCard.vue
├── views/
│   ├── Home.vue
│   ├── Login.vue
│   ├── Members.vue
│   ├── Events.vue
│   ├── Services.vue
│   ├── Benefits.vue
│   └── Profile.vue
├── router/
│   └── index.js
├── stores/
│   ├── auth.js
│   └── user.js
├── composables/
│   └── useSupabase.js
└── main.js
```

---

## 🔨 FASE 2: COMPONENTES BASE

### 2.1 Button Component

**`src/components/ui/Button.vue`**:
```vue
<template>
  <button
    :class="buttonClasses"
    :disabled="disabled || loading"
    @click="$emit('click', $event)"
  >
    <span v-if="loading" class="spinner"></span>
    <slot />
  </button>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  variant: {
    type: String,
    default: 'primary',
    validator: (v) => ['primary', 'secondary', 'outline', 'ghost'].includes(v)
  },
  size: {
    type: String,
    default: 'md',
    validator: (v) => ['sm', 'md', 'lg'].includes(v)
  },
  disabled: Boolean,
  loading: Boolean,
  fullWidth: Boolean
})

const emit = defineEmits(['click'])

const buttonClasses = computed(() => {
  const base = 'font-bold rounded-lg transition-all duration-300 transform hover:-translate-y-0.5'
  
  const variants = {
    primary: 'bg-neon-gradient text-black hover:shadow-neon-pink',
    secondary: 'bg-secondary text-black hover:shadow-neon-blue',
    outline: 'bg-transparent border border-secondary text-secondary hover:bg-secondary hover:text-black',
    ghost: 'bg-transparent text-white hover:bg-white/10'
  }
  
  const sizes = {
    sm: 'px-4 py-2 text-sm',
    md: 'px-6 py-3 text-base',
    lg: 'px-8 py-4 text-lg'
  }
  
  return [
    base,
    variants[props.variant],
    sizes[props.size],
    props.fullWidth && 'w-full',
    props.disabled && 'opacity-50 cursor-not-allowed'
  ].filter(Boolean).join(' ')
})
</script>
```

### 2.2 Card Component

**`src/components/ui/Card.vue`**:
```vue
<template>
  <div :class="cardClasses">
    <slot />
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  variant: {
    type: String,
    default: 'default',
    validator: (v) => ['default', 'dark', 'glass'].includes(v)
  },
  hover: Boolean,
  glow: {
    type: String,
    validator: (v) => !v || ['blue', 'pink', 'mixed'].includes(v)
  }
})

const cardClasses = computed(() => {
  const base = 'rounded-xl border transition-all duration-300'
  
  const variants = {
    default: 'bg-white dark:bg-surface-dark border-gray-200 dark:border-white/5',
    dark: 'bg-surface-dark border-white/10',
    glass: 'bg-surface-dark/80 backdrop-blur border-white/10'
  }
  
  const glows = {
    blue: 'hover:shadow-neon-blue hover:border-secondary/50',
    pink: 'hover:shadow-neon-pink hover:border-primary/50',
    mixed: 'hover:shadow-neon-blue hover:shadow-neon-pink'
  }
  
  return [
    base,
    variants[props.variant],
    props.hover && 'hover:-translate-y-2',
    props.glow && glows[props.glow]
  ].filter(Boolean).join(' ')
})
</script>
```

---

## 📄 FASE 3: CONVERSÃO DE PÁGINAS

### 3.1 Estratégia de Conversão

Para cada página HTML:

1. **Criar View Component** (`src/views/NomeDaPagina.vue`)
2. **Extrair seções** em componentes menores
3. **Converter classes Tailwind** (já estão prontas)
4. **Adicionar lógica Vue** (v-if, v-for, @click, etc.)
5. **Integrar com stores/composables**

### 3.2 Exemplo: Home.vue

**Estrutura**:
```vue
<template>
  <div class="min-h-screen bg-background-light dark:bg-background-dark">
    <AppHeader />
    
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
        <!-- Sidebar Esquerda -->
        <div class="lg:col-span-3">
          <ProfileSidebar />
          <NavigationMenu />
        </div>
        
        <!-- Feed Central -->
        <div class="lg:col-span-6">
          <PostForm />
          <FeaturedEvent />
          <PostCard v-for="post in posts" :key="post.id" :post="post" />
        </div>
        
        <!-- Sidebar Direita -->
        <div class="lg:col-span-3">
          <UpcomingEvents />
          <FeaturedMembers />
        </div>
      </div>
    </main>
    
    <AppFooter />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import AppHeader from '@/components/layout/AppHeader.vue'
import AppFooter from '@/components/layout/AppFooter.vue'
// ... outros imports

const posts = ref([])
// ... lógica
</script>
```

---

## 🔄 FASE 4: INTEGRAÇÃO

### 4.1 Vue Router

**`src/router/index.js`**:
```javascript
import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import Login from '../views/Login.vue'
import Members from '../views/Members.vue'
import Events from '../views/Events.vue'
import Services from '../views/Services.vue'
import Benefits from '../views/Benefits.vue'
import Profile from '../views/Profile.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/membros',
    name: 'Members',
    component: Members
  },
  {
    path: '/eventos',
    name: 'Events',
    component: Events
  },
  {
    path: '/servicos',
    name: 'Services',
    component: Services
  },
  {
    path: '/beneficios',
    name: 'Benefits',
    component: Benefits
  },
  {
    path: '/perfil',
    name: 'Profile',
    component: Profile,
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// Guard de autenticação
router.beforeEach((to, from, next) => {
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth)
  const isAuthenticated = /* verificar auth */
  
  if (requiresAuth && !isAuthenticated) {
    next('/login')
  } else {
    next()
  }
})

export default router
```

### 4.2 Pinia Store (Auth)

**`src/stores/auth.js`**:
```javascript
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { supabase } from '@/composables/useSupabase'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const loading = ref(false)
  
  const signIn = async (email, password) => {
    loading.value = true
    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password
      })
      if (error) throw error
      user.value = data.user
      return { success: true }
    } catch (error) {
      return { success: false, error: error.message }
    } finally {
      loading.value = false
    }
  }
  
  const signUp = async (email, password, userData) => {
    // ... implementar
  }
  
  const signOut = async () => {
    // ... implementar
  }
  
  return {
    user,
    loading,
    signIn,
    signUp,
    signOut
  }
})
```

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### Setup
- [ ] Projeto Vue.js criado
- [ ] Tailwind CSS configurado
- [ ] Fontes importadas
- [ ] Estrutura de pastas criada

### Componentes Base
- [ ] Button
- [ ] Card
- [ ] Input
- [ ] Badge
- [ ] Avatar

### Layout
- [ ] AppHeader
- [ ] AppSidebar
- [ ] AppFooter

### Páginas
- [ ] Home
- [ ] Login
- [ ] Members
- [ ] Events
- [ ] Services
- [ ] Benefits
- [ ] Profile

### Integração
- [ ] Vue Router configurado
- [ ] Pinia stores criados
- [ ] Supabase integrado
- [ ] Autenticação funcionando

---

## 🎯 ORDEM DE IMPLEMENTAÇÃO SUGERIDA

1. **Setup** (1-2 dias)
   - Projeto Vue.js
   - Tailwind CSS
   - Estrutura base

2. **Componentes Base** (2-3 dias)
   - UI components
   - Layout components

3. **Páginas Principais** (1 semana)
   - Home
   - Login
   - Members

4. **Páginas Secundárias** (3-4 dias)
   - Events
   - Services
   - Benefits
   - Profile

5. **Integração** (1 semana)
   - Supabase
   - Autenticação
   - CRUD operations

---

**Plano criado em**: 2024  
**Estimativa total**: 3-4 semanas  
**Status**: Pronto para execução

