import { createRouter, createWebHistory } from 'vue-router'

const SITE_NAME = 'ZBR Standards'

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('../pages/home.vue'),
    meta: {
      title: `${SITE_NAME} — Validação de documentos brasileiros com Zod`,
      description:
        'Valide CPF, CNPJ, RG, CEP e telefone com Zod, usando algoritmos oficiais e sanitização automática.'
    }
  },
  {
    path: '/playground',
    name: 'playground',
    component: () => import('../pages/playground.vue'),
    meta: {
      title: `Playground — ${SITE_NAME}`,
      description: 'Teste CPF, CNPJ, RG, CEP e telefone em tempo real, direto no navegador.'
    }
  },
  {
    path: '/integracoes',
    name: 'integracoes',
    component: () => import('../pages/integracoes.vue'),
    meta: {
      title: `Integrações — ${SITE_NAME}`,
      description: 'Exemplos prontos de integração com React Hook Form, Vue 3, Fastify, Express e NestJS.'
    }
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'not-found',
    component: () => import('../pages/not-found.vue'),
    meta: {
      title: `Página não encontrada — ${SITE_NAME}`,
      description: 'A página que você procura não existe.'
    }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, _from, savedPosition) {
    if (savedPosition) return savedPosition
    if (to.hash) return { el: to.hash, behavior: 'smooth' }
    return { top: 0 }
  }
})

router.afterEach((to) => {
  const title = typeof to.meta.title === 'string' ? to.meta.title : SITE_NAME
  const description = typeof to.meta.description === 'string' ? to.meta.description : ''

  document.title = title

  const tag = document.querySelector('meta[name="description"]')
  if (tag && description) tag.setAttribute('content', description)
})

export default router
