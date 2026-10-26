<script setup lang="ts">
import { computed, onBeforeUnmount, ref } from 'vue'
import { Check, Copy } from 'lucide-vue-next'
import hljs from 'highlight.js/lib/core'
import bash from 'highlight.js/lib/languages/bash'
import javascript from 'highlight.js/lib/languages/javascript'
import typescript from 'highlight.js/lib/languages/typescript'
import xml from 'highlight.js/lib/languages/xml'

hljs.registerLanguage('bash', bash)
hljs.registerLanguage('javascript', javascript)
hljs.registerLanguage('typescript', typescript)
hljs.registerLanguage('xml', xml)

const props = withDefaults(
  defineProps<{
    code: string
    filename?: string
    lang?: string
    label?: string
  }>(),
  {
    filename: 'exemplo.ts',
    lang: 'ts',
    label: 'TypeScript'
  }
)

const grammar = computed(() => {
  if (props.lang === 'vue') return 'xml'
  if (props.lang === 'bash' || props.lang === 'sh') return 'bash'
  if (props.lang === 'js' || props.lang === 'jsx') return 'javascript'
  return 'typescript'
})

const highlighted = computed(() => {
  const source = props.code.replace(/^\n+|\n+$/g, '')
  return hljs.highlight(source, { language: grammar.value }).value
})

const copied = ref(false)
let resetTimer: number | undefined

const copy = async () => {
  const text = props.code.replace(/^\n+|\n+$/g, '')

  try {
    if (navigator.clipboard?.writeText) {
      await navigator.clipboard.writeText(text)
    } else {
      const area = document.createElement('textarea')
      area.value = text
      area.setAttribute('readonly', '')
      area.style.position = 'fixed'
      area.style.opacity = '0'
      document.body.appendChild(area)
      area.select()
      document.execCommand('copy')
      document.body.removeChild(area)
    }

    copied.value = true
    window.clearTimeout(resetTimer)
    resetTimer = window.setTimeout(() => (copied.value = false), 1800)
  } catch {
    /* área de transferência indisponível */
  }
}

onBeforeUnmount(() => window.clearTimeout(resetTimer))
</script>

<template>
  <figure class="code-block">
    <figcaption class="code-bar">
      <span class="filename">{{ filename }}</span>

      <span class="spacer"></span>

      <button type="button" class="copy-btn" :class="{ copied }" @click="copy">
        <Check v-if="copied" :size="14" aria-hidden="true" />
        <Copy v-else :size="14" aria-hidden="true" />
        <span>{{ copied ? 'Copiado' : 'Copiar' }}</span>
      </button>
    </figcaption>

    <pre class="code-scroll"><code class="hljs" v-html="highlighted"></code></pre>
  </figure>
</template>

<style scoped>
.code-block {
  margin: 0;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  background: var(--bg-soft);
  overflow: hidden;
}

.code-bar {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  padding: 8px var(--space-4);
  border-bottom: 1px solid var(--border);
}

.filename {
  font-family: var(--font-mono);
  font-size: var(--text-xs);
  color: var(--text-faint);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.spacer {
  flex: 1;
}

.copy-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 3px 6px;
  border: 0;
  border-radius: var(--radius-sm);
  background: transparent;
  color: var(--text-faint);
  font-family: var(--font-mono);
  font-size: var(--text-xs);
  cursor: pointer;
  transition: color var(--fast) var(--ease);
}

.copy-btn:hover {
  color: var(--text);
}

.copy-btn.copied {
  color: var(--success);
}

.code-scroll {
  margin: 0;
  padding: var(--space-4) var(--space-5);
  overflow-x: auto;
  font-size: 0.8125rem;
  line-height: 1.75;
  tab-size: 2;
}

.code-scroll code {
  display: block;
  white-space: pre;
}

@media (max-width: 520px) {
  .code-scroll {
    padding: var(--space-4);
    font-size: 0.75rem;
  }
}
</style>
