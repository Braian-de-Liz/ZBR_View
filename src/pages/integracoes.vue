<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { siExpress, siFastify, siNestjs, siReact, siVuedotjs } from 'simple-icons'
import CodeBlock from '../components/CodeBlock.vue'
import { integrations, type IntegrationId } from '../data/integrations'

const logos: Record<IntegrationId, string> = {
  react: siReact.path,
  vue: siVuedotjs.path,
  fastify: siFastify.path,
  express: siExpress.path,
  nest: siNestjs.path
}

const route = useRoute()
const router = useRouter()

const isIntegrationId = (value: unknown): value is IntegrationId =>
  typeof value === 'string' && integrations.some((item) => item.id === value)

const activeTab = ref<IntegrationId>(
  isIntegrationId(route.query.framework) ? route.query.framework : 'react'
)

const active = computed(
  () => integrations.find((item) => item.id === activeTab.value) ?? integrations[0]!
)

watch(activeTab, (id) => {
  if (route.query.framework === id) return
  router.replace({ query: { ...route.query, framework: id } })
})

watch(
  () => route.query.framework,
  (value) => {
    if (isIntegrationId(value) && value !== activeTab.value) activeTab.value = value
  }
)

const tabsEl = ref<HTMLElement | null>(null)

const onKeydown = (event: KeyboardEvent) => {
  const keys = ['ArrowLeft', 'ArrowRight', 'Home', 'End']
  if (!keys.includes(event.key)) return

  event.preventDefault()

  const current = integrations.findIndex((item) => item.id === activeTab.value)
  let next = current

  if (event.key === 'ArrowRight') next = (current + 1) % integrations.length
  if (event.key === 'ArrowLeft') next = (current - 1 + integrations.length) % integrations.length
  if (event.key === 'Home') next = 0
  if (event.key === 'End') next = integrations.length - 1

  const target = integrations[next]
  if (!target) return

  activeTab.value = target.id

  const buttons = tabsEl.value?.querySelectorAll<HTMLButtonElement>('[role="tab"]')
  buttons?.[next]?.focus()
}
</script>

<template>
  <div class="page">
    <div class="container">
      <header class="page-head">
        <h1>Integrações oficiais</h1>
        <p class="lead">
          A ZBR entra no seu stack como qualquer schema Zod — sem adaptadores e sem configuração
          extra.
        </p>
      </header>

      <div class="tabs" ref="tabsEl" role="tablist" aria-label="Frameworks" @keydown="onKeydown">
        <button
          v-for="item in integrations"
          :id="`tab-${item.id}`"
          :key="item.id"
          type="button"
          role="tab"
          class="tab"
          :class="{ active: activeTab === item.id }"
          :aria-selected="activeTab === item.id"
          :aria-controls="`panel-${item.id}`"
          :tabindex="activeTab === item.id ? 0 : -1"
          @click="activeTab = item.id"
        >
          <svg class="tab-icon" viewBox="0 0 24 24" aria-hidden="true">
            <path :d="logos[item.id]" fill="currentColor" />
          </svg>
          <span class="tab-name">{{ item.name }}</span>
        </button>
      </div>

      <div
        :id="`panel-${activeTab}`"
        role="tabpanel"
        :aria-labelledby="`tab-${activeTab}`"
        tabindex="0"
        class="panel"
      >
        <CodeBlock
          :code="active.code"
          :filename="active.filename"
          :lang="active.lang"
          :label="active.label"
        />
      </div>
    </div>
  </div>
</template>

<style scoped>
.page {
  width: 100%;
  padding: calc(var(--nav-height) + clamp(2.5rem, 7vw, 4.5rem)) 0 var(--space-16);
}

.page-head {
  max-width: 640px;
  margin-bottom: var(--space-10);
}

.page-head h1 {
  font-size: clamp(2rem, 6vw, 3rem);
  font-weight: 500;
  letter-spacing: -0.04em;
}

.lead {
  margin-top: var(--space-4);
  color: var(--text-muted);
}

.tabs {
  display: flex;
  gap: var(--space-6);
  margin-bottom: var(--space-4);
  border-bottom: 1px solid var(--border);
  overflow-x: auto;
  scrollbar-width: none;
}

.tabs::-webkit-scrollbar {
  display: none;
}

.tab {
  display: inline-flex;
  align-items: center;
  gap: var(--space-2);
  margin-bottom: -1px;
  padding: 0 0 var(--space-3);
  border: 0;
  border-bottom: 1px solid transparent;
  background: transparent;
  color: var(--text-muted);
  font-size: var(--text-sm);
  white-space: nowrap;
  flex-shrink: 0;
  cursor: pointer;
  transition: color var(--fast) var(--ease);
}

.tab:hover {
  color: var(--text);
}

.tab.active {
  color: var(--text);
  border-bottom-color: var(--accent);
}

.tab-icon {
  width: 16px;
  height: 16px;
  flex-shrink: 0;
}

.panel {
  border-radius: var(--radius);
}

.panel:focus-visible {
  outline: 2px solid var(--accent);
  outline-offset: 4px;
}

@media (max-width: 720px) {
  .tabs {
    flex-wrap: wrap;
    overflow: visible;
    gap: var(--space-2) var(--space-5);
  }
}
</style>
