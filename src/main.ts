import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './index' // Removemos o comentário (as barras //)

const app = createApp(App)

app.use(router) // Ligamos o roteador aqui
app.mount('#app') // Ligamos o site apenas UMA vez