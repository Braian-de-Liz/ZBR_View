import { createRouter, createWebHistory } from 'vue-router'
import Home from './pages/home.vue'
import Playground from './pages/playground.vue'
import Integracoes from './pages/integracaoes.vue' 

const routes = [
  { path: '/', component: Home },
  { path: '/playground', component: Playground },
  { path: '/integracoes', component: Integracoes }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router;