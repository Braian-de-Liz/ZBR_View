<script setup lang="ts">
import { ArrowUpRight } from 'lucide-vue-next'

const year = new Date().getFullYear()
</script>

<template>
  <footer class="footer">
    <div class="container footer-row">
      <p class="footer-brand">
        <span class="mono">zbr/standards</span>
        Esquemas Zod para os padrões brasileiros.
      </p>

      <nav class="footer-links" aria-label="Rodapé">
        <router-link to="/playground">Playground</router-link>
        <router-link to="/integracoes">Integrações</router-link>
        <a
          href="https://github.com/Braian-de-Liz/br_standards_with_ZOD"
          target="_blank"
          rel="noopener noreferrer"
        >
          GitHub<ArrowUpRight :size="12" aria-hidden="true" />
        </a>
        <a
          href="https://www.npmjs.com/package/br_standards_with_zod"
          target="_blank"
          rel="noopener noreferrer"
        >
          npm<ArrowUpRight :size="12" aria-hidden="true" />
        </a>
      </nav>
    </div>

    <div class="container footer-bottom">
      <p>© {{ year }} · MIT · por Braian de Liz</p>
    </div>
  </footer>
</template>

<style scoped>
.footer {
  margin-top: auto;
  padding-top: var(--space-10);
  border-top: 1px solid var(--border);
}

.footer-row {
  display: flex;
  flex-wrap: wrap;
  align-items: baseline;
  justify-content: space-between;
  gap: var(--space-4) var(--space-8);
}

.footer-brand {
  color: var(--text-muted);
  font-size: var(--text-sm);
}

.mono {
  margin-right: var(--space-3);
  font-family: var(--font-mono);
  font-weight: 600;
  color: var(--text);
}

.footer-links {
  display: flex;
  flex-wrap: wrap;
  gap: var(--space-2) var(--space-6);
}

.footer-links a {
  display: inline-flex;
  align-items: center;
  gap: 2px;
  color: var(--text-muted);
  font-size: var(--text-sm);
  transition: color var(--fast) var(--ease);
}

.footer-links a:hover {
  color: var(--accent);
}

.footer-bottom {
  padding-block: var(--space-6) var(--space-8);
  color: var(--text-faint);
  font-family: var(--font-mono);
  font-size: var(--text-xs);
}
</style>
