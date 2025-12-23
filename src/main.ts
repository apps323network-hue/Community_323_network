import './assets/css/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'

// Tema é inicializado automaticamente no composable
import './composables/useTheme'

const app = createApp(App)

app.use(createPinia())
app.use(router)

app.mount('#app')

