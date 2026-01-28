import { createRouter, createWebHistory } from 'vue-router'
import Home from './pages/home.vue'
import Playground from './pages/playground.vue'

const routes = [
  { path: '/', component: Home },
  { path: '/playground', component: Playground }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router;