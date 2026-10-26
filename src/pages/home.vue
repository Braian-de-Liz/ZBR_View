<script setup lang="ts">
import { computed, onBeforeUnmount, ref } from 'vue'
import { Check, Copy } from 'lucide-vue-next'
import { zbr } from 'br_standards_with_zod'
import CodeBlock from '../components/CodeBlock.vue'

const INSTALL_COMMAND = 'npm install br_standards_with_zod'

const copied = ref(false)
let resetTimer: number | undefined

const copyInstall = async () => {
  try {
    await navigator.clipboard.writeText(INSTALL_COMMAND)
    copied.value = true
    window.clearTimeout(resetTimer)
    resetTimer = window.setTimeout(() => (copied.value = false), 1800)
  } catch {
    /* área de transferência indisponível */
  }
}

const regexCode = String.raw`// regex "de internet"
const CPF = /^\d{3}\.?\d{3}\.?\d{3}-?\d{2}$/

CPF.test('111.111.111-11') // true
CPF.test('123.456.789-00') // true
// nenhum dos dois CPFs é válido`

const zbrCode = `import { zbr } from 'br_standards_with_zod'

const cpf = zbr.cpf()

cpf.safeParse('111.111.111-11').success // false
cpf.safeParse('123.456.789-00').success // false
cpf.parse('123.456.789-09') // "12345678909"`

const validators = [
  {
    call: 'zbr.cpf()',
    input: '123.456.789-09',
    checks: 'dígitos verificadores; rejeita sequências repetidas',
    schema: zbr.cpf()
  },
  {
    call: 'zbr.cnpj()',
    input: '11.222.333/0001-81',
    checks: 'dígitos verificadores do CNPJ',
    schema: zbr.cnpj()
  },
  {
    call: 'zbr.rg()',
    input: '12.345.678-9',
    checks: 'formato e tamanho; remove a pontuação',
    schema: zbr.rg()
  },
  {
    call: 'zbr.cep()',
    input: '88010-000',
    checks: 'oito dígitos, com ou sem hífen',
    schema: zbr.cep()
  },
  {
    call: 'zbr.tel()',
    input: '(47) 99999-8888',
    checks: 'DDD real; fixo ou celular',
    schema: zbr.tel()
  }
]

// As saídas da tabela vêm da própria biblioteca, não são texto fixo.
const rows = validators.map((item) => {
  const result = item.schema.safeParse(item.input)
  return { call: item.call, input: item.input, checks: item.checks, output: result.success ? String(result.data) : '—' }
})

const tabs = [
  {
    id: 'validacao',
    label: 'Validação',
    filename: 'validacao.ts',
    code: `import { zbr } from 'br_standards_with_zod'

// Valida e sanitiza: "123.456.789-09" -> "12345678909"
const cpf = zbr.cpf().parse('123.456.789-09')

// Telefones validados com DDDs brasileiros reais
const tel = zbr.tel().parse('(47) 99999-8888')

// CEP: aceita com ou sem máscara
const cep = zbr.cep().parse('88010-000')`
  },
  {
    id: 'mensagens',
    label: 'Mensagens',
    filename: 'mensagens.ts',
    code: `import { zbr } from 'br_standards_with_zod'

// A mensagem é o primeiro argumento do validador
const cep = zbr.cep('CEP não encontrado em nossa base')

const result = cep.safeParse('00000-000')

if (!result.success) {
  console.log(result.error.issues[0].message)
  // "CEP não encontrado em nossa base"
}`
  },
  {
    id: 'schema',
    label: 'Schema Zod',
    filename: 'user-schema.ts',
    code: `import { z } from 'zod'
import { zbr } from 'br_standards_with_zod'

export const userSchema = z.object({
  name: z.string().min(3),
  documento: zbr.cpf('CPF inválido'),
  contato: zbr.tel('Telefone inválido'),
  endereco_cep: zbr.cep()
})

export type User = z.infer<typeof userSchema>`
  }
] as const

type TabId = (typeof tabs)[number]['id']
const activeTab = ref<TabId>('validacao')

const activeExample = computed(() => tabs.find((tab) => tab.id === activeTab.value) ?? tabs[0])

onBeforeUnmount(() => window.clearTimeout(resetTimer))
</script>

<template>
  <div class="page">
    <section class="hero container">
      <p class="eyebrow">br_standards_with_zod · Zod 3 e 4</p>

      <h1>Validação de documentos brasileiros para o Zod.</h1>

      <p class="lead">
        CPF, CNPJ, RG, CEP e telefone com os algoritmos oficiais. O valor sai sanitizado, sem
        máscara, pronto para o banco.
      </p>

      <div class="install">
        <code class="install-command"
          ><span class="prompt" aria-hidden="true">$</span> {{ INSTALL_COMMAND }}</code
        >
        <button
          type="button"
          class="install-copy"
          :class="{ copied }"
          :aria-label="copied ? 'Comando copiado' : 'Copiar comando de instalação'"
          @click="copyInstall"
        >
          <Check v-if="copied" :size="15" aria-hidden="true" />
          <Copy v-else :size="15" aria-hidden="true" />
        </button>
      </div>

      <p class="hero-links">
        <router-link to="/playground" class="link-strong">Testar no playground →</router-link>
        <router-link to="/integracoes">Ver integrações</router-link>
      </p>
    </section>

    <section class="section container" aria-labelledby="regex-title">
      <h2 id="regex-title">Regex valida o formato. O CPF precisa de conta.</h2>
      <p class="section-sub">
        Uma regex aceita <code>111.111.111-11</code>. Os dois últimos dígitos de CPF e CNPJ são
        calculados a partir dos anteriores, e é isso que o ZBR confere.
      </p>

      <div class="compare">
        <div>
          <p class="compare-label">Antes</p>
          <CodeBlock :code="regexCode" filename="regex.ts" lang="ts" />
        </div>
        <div>
          <p class="compare-label compare-label--accent">Com ZBR</p>
          <CodeBlock :code="zbrCode" filename="zbr.ts" lang="ts" />
        </div>
      </div>
    </section>

    <section class="section container" aria-labelledby="validators-title">
      <h2 id="validators-title">Cinco validadores</h2>
      <p class="section-sub">
        Cada um é um schema Zod comum. As saídas abaixo são geradas pela própria biblioteca.
      </p>

      <div class="table-wrap">
        <table class="table">
          <thead>
            <tr>
              <th scope="col">Validador</th>
              <th scope="col">Entrada</th>
              <th scope="col">Saída</th>
              <th scope="col">O que confere</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="row in rows" :key="row.call">
              <th scope="row">{{ row.call }}</th>
              <td>{{ row.input }}</td>
              <td class="out">{{ row.output }}</td>
              <td class="checks">{{ row.checks }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <section class="section container" aria-labelledby="usage-title">
      <h2 id="usage-title">Uso</h2>

      <div class="tabs" role="tablist" aria-label="Exemplos de uso">
        <button
          v-for="tab in tabs"
          :key="tab.id"
          type="button"
          role="tab"
          class="tab"
          :class="{ active: activeTab === tab.id }"
          :aria-selected="activeTab === tab.id"
          @click="activeTab = tab.id"
        >
          {{ tab.label }}
        </button>
      </div>

      <CodeBlock :code="activeExample.code" :filename="activeExample.filename" lang="ts" />
    </section>
  </div>
</template>

<style scoped>
.page {
  width: 100%;
  padding-top: var(--nav-height);
}

.hero {
  padding-block: clamp(3.5rem, 10vw, 7rem) clamp(2.5rem, 6vw, 4rem);
}

.hero h1 {
  max-width: 14ch;
  margin-top: var(--space-5);
  font-size: clamp(2.5rem, 8vw, 4.75rem);
  font-weight: 500;
  letter-spacing: -0.045em;
  line-height: 1.02;
}

.lead {
  max-width: 52ch;
  margin-top: var(--space-6);
  color: var(--text-muted);
  font-size: var(--text-lg);
  line-height: 1.6;
}

.install {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--space-3);
  width: fit-content;
  max-width: 100%;
  margin-top: var(--space-8);
  padding: 8px 8px 8px var(--space-4);
  border: 1px solid var(--border-strong);
  border-radius: var(--radius);
  background: var(--bg-soft);
}

.install-command {
  font-size: var(--text-sm);
  white-space: nowrap;
  overflow-x: auto;
  scrollbar-width: none;
}

.install-command::-webkit-scrollbar {
  display: none;
}

.prompt {
  margin-right: 6px;
  color: var(--accent);
  user-select: none;
}

.install-copy {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  flex-shrink: 0;
  border: 0;
  border-radius: var(--radius-sm);
  background: transparent;
  color: var(--text-faint);
  cursor: pointer;
  transition: color var(--fast) var(--ease);
}

.install-copy:hover {
  color: var(--text);
}

.install-copy.copied {
  color: var(--success);
}

.hero-links {
  display: flex;
  flex-wrap: wrap;
  gap: var(--space-2) var(--space-6);
  margin-top: var(--space-6);
  font-size: var(--text-sm);
  color: var(--text-muted);
}

.hero-links a {
  text-decoration: underline;
  text-decoration-color: var(--border-strong);
  text-underline-offset: 4px;
  transition: color var(--fast) var(--ease), text-decoration-color var(--fast) var(--ease);
}

.hero-links a:hover {
  color: var(--text);
  text-decoration-color: var(--accent);
}

.hero-links .link-strong {
  color: var(--accent);
  text-decoration-color: var(--accent-line);
}

.section {
  padding-block: var(--space-16);
  border-top: 1px solid var(--border);
}

.section h2 {
  max-width: 24ch;
  font-size: clamp(1.5rem, 4vw, 2.25rem);
  font-weight: 500;
}

.section-sub {
  max-width: 60ch;
  margin-top: var(--space-4);
  color: var(--text-muted);
}

.section-sub code {
  color: var(--text);
  font-size: 0.9em;
}

.compare {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-6);
  margin-top: var(--space-10);
  align-items: start;
}

.compare > div {
  min-width: 0;
}

.compare-label {
  margin-bottom: var(--space-2);
  font-family: var(--font-mono);
  font-size: var(--text-xs);
  color: var(--text-faint);
}

.compare-label--accent {
  color: var(--accent);
}

.table-wrap {
  margin-top: var(--space-8);
  overflow-x: auto;
}

.table {
  width: 100%;
  min-width: 640px;
  border-collapse: collapse;
  text-align: left;
}

.table th,
.table td {
  padding: var(--space-4) var(--space-4) var(--space-4) 0;
  border-bottom: 1px solid var(--border);
  font-size: var(--text-sm);
  vertical-align: baseline;
}

.table thead th {
  padding-top: 0;
  font-weight: 400;
  color: var(--text-faint);
}

.table tbody th,
.table td:nth-child(2),
.table .out {
  font-family: var(--font-mono);
  font-size: 0.8125rem;
}

.table tbody th {
  font-weight: 500;
  color: var(--accent);
}

.table .out {
  color: var(--text);
}

.table td:nth-child(2),
.table .checks {
  color: var(--text-muted);
}

.tabs {
  display: flex;
  flex-wrap: wrap;
  gap: var(--space-6);
  margin-block: var(--space-6) var(--space-4);
  border-bottom: 1px solid var(--border);
}

.tab {
  margin-bottom: -1px;
  padding: 0 0 var(--space-3);
  border: 0;
  border-bottom: 1px solid transparent;
  background: transparent;
  color: var(--text-muted);
  font-size: var(--text-sm);
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

@media (max-width: 820px) {
  .compare {
    grid-template-columns: 1fr;
  }

  .section {
    padding-block: var(--space-12);
  }
}
</style>
