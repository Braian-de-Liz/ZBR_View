import { createApp } from 'vue'
import '@fontsource-variable/geist'
import '@fontsource-variable/jetbrains-mono'
import './style.css'
import App from './App.vue'
import router from './router'

const app = createApp(App)

app.use(router)
app.mount('#app')
