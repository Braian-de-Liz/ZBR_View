<script setup lang="ts">
import { computed, onBeforeUnmount, ref } from 'vue'
import { Check, Copy } from 'lucide-vue-next'
import { zbr } from 'br_standards_with_zod'
import type { ZodTypeAny } from 'zod'

type Tipo = 'cpf' | 'cnpj' | 'rg' | 'cep' | 'telefone'

const tipos: { id: Tipo; label: string; placeholder: string }[] = [
  { id: 'cpf', label: 'CPF — Pessoa Física', placeholder: '000.000.000-00' },
  { id: 'cnpj', label: 'CNPJ — Empresa', placeholder: '00.000.000/0001-00' },
  { id: 'rg', label: 'RG — Registro Geral', placeholder: '00.000.000-0' },
  { id: 'cep', label: 'CEP — Código Postal', placeholder: '00000-000' },
  { id: 'telefone', label: 'Telefone — Fixo ou celular', placeholder: '(00) 00000-0000' }
]

const validators: Record<Tipo, ZodTypeAny> = {
  cpf: zbr.cpf(),
  cnpj: zbr.cnpj(),
  rg: zbr.rg(),
  cep: zbr.cep(),
  telefone: zbr.tel()
}

const onlyDigits = (value: string, max: number) => value.replace(/\D/g, '').slice(0, max)

const maskers: Record<Tipo, (value: string) => string> = {
  cpf: (value) =>
    onlyDigits(value, 11)
      .replace(/(\d{3})(\d)/, '$1.$2')
      .replace(/(\d{3})(\d)/, '$1.$2')
      .replace(/(\d{3})(\d{1,2})$/, '$1-$2'),
  cnpj: (value) =>
    onlyDigits(value, 14)
      .replace(/^(\d{2})(\d)/, '$1.$2')
      .replace(/^(\d{2})\.(\d{3})(\d)/, '$1.$2.$3')
      .replace(/\.(\d{3})(\d)/, '.$1/$2')
      .replace(/(\d{4})(\d)/, '$1-$2'),
  cep: (value) => onlyDigits(value, 8).replace(/(\d{5})(\d)/, '$1-$2'),
  telefone: (value) => {
    const digits = onlyDigits(value, 11)
    if (digits.length <= 2) return digits.replace(/(\d{2})/, '($1')
    if (digits.length <= 6) return digits.replace(/(\d{2})(\d+)/, '($1) $2')
    if (digits.length <= 10) return digits.replace(/(\d{2})(\d{4})(\d+)/, '($1) $2-$3')
    return digits.replace(/(\d{2})(\d{5})(\d+)/, '($1) $2-$3')
  },
  rg: (value) => value.replace(/[^0-9A-Za-z.\-/]/g, '').slice(0, 15)
}

const exemplos: Partial<Record<Tipo, string>> = {
  cpf: '123.456.789-09',
  cnpj: '11.222.333/0001-81',
  cep: '88010-000',
  telefone: '(47) 99999-8888'
}

const tipo = ref<Tipo>('cpf')
const documento = ref('')

const copied = ref(false)
let resetTimer: number | undefined

const tipoAtual = computed(() => tipos.find((item) => item.id === tipo.value) ?? tipos[0])
const exemplo = computed(() => exemplos[tipo.value])

const resultado = computed(() => {
  const value = documento.value.trim()
  if (!value) return null
  return validators[tipo.value].safeParse(value)
})

const onInput = (event: Event) => {
  const target = event.target as HTMLInputElement
  documento.value = maskers[tipo.value](target.value)
  if (copied.value) copied.value = false
}

const limpar = () => {
  documento.value = ''
  copied.value = false
}

const aplicarExemplo = () => {
  const sample = exemplo.value
  if (!sample) return
  documento.value = sample
  copied.value = false
}

const trocarTipo = () => {
  limpar()
}

const copyValue = async () => {
  const result = resultado.value
  if (!result?.success) return

  try {
    await navigator.clipboard.writeText(String(result.data))
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
  <div class="page">
    <div class="container">
      <header class="page-head">
        <h1>Playground</h1>
        <p class="lead">
          Valide documentos brasileiros em tempo real, com os mesmos algoritmos da biblioteca.
        </p>
      </header>

      <div class="tool">
        <section class="panel" aria-labelledby="entrada-title">
          <div class="panel-head">
            <h2 id="entrada-title">Entrada</h2>
          </div>

          <div class="field">
            <label for="tipo">Tipo de documento</label>
            <div class="select-wrap">
              <select id="tipo" v-model="tipo" @change="trocarTipo">
                <option v-for="item in tipos" :key="item.id" :value="item.id">{{ item.label }}</option>
              </select>
            </div>
          </div>

          <div class="field">
            <label for="documento">Documento</label>
            <input
              id="documento"
              :value="documento"
              :placeholder="tipoAtual?.placeholder"
              :inputmode="tipo === 'rg' ? 'text' : 'numeric'"
              autocomplete="off"
              autocapitalize="off"
              spellcheck="false"
              class="doc-input"
              @input="onInput"
            />
          </div>

          <div class="form-actions">
            <button type="button" class="btn ghost" @click="limpar">
              Limpar
            </button>
            <button v-if="exemplo" type="button" class="btn ghost" @click="aplicarExemplo">
              Usar exemplo
            </button>
          </div>
        </section>

        <section class="panel result-panel" aria-labelledby="resultado-title">
          <div class="panel-head">
            <h2 id="resultado-title">Resultado</h2>
            <span class="tag">{{ tipo.toUpperCase() }}</span>
          </div>

          <div class="result-body" aria-live="polite">
            <div v-if="!resultado" class="empty">
              <p>Digite um documento para validar.</p>
            </div>

            <template v-else>
              <div class="status" :class="resultado.success ? 'ok' : 'err'">
                <span class="status-mark" aria-hidden="true">{{ resultado.success ? '✓' : '✕' }}</span>
                <div class="status-text">
                  <strong>{{ resultado.success ? 'Válido' : 'Inválido' }}</strong>
                  <span>{{ resultado.success ? 'Documento conferido' : 'Falhou na validação' }}</span>
                </div>
              </div>

              <div v-if="resultado.success" class="output">
                <p class="output-label">Valor sanitizado</p>
                <div class="output-row">
                  <code>{{ resultado.data }}</code>
                  <button
                    type="button"
                    class="copy-btn"
                    :class="{ copied }"
                    :aria-label="copied ? 'Valor copiado' : 'Copiar valor sanitizado'"
                    @click="copyValue"
                  >
                    <Check v-if="copied" :size="15" aria-hidden="true" />
                    <Copy v-else :size="15" aria-hidden="true" />
                  </button>
                </div>
                <p class="output-hint">Pronto para gravar no banco — sem máscara.</p>
              </div>

              <div v-else class="output">
                <p class="output-label">Mensagem do Zod</p>
                <p class="message">{{ resultado.error.issues[0]?.message }}</p>
              </div>
            </template>
          </div>
        </section>
      </div>

      <p class="footnote">
        Nada sai do seu navegador. A validação usa a própria
        <code>br_standards_with_zod</code>.
      </p>
    </div>
  </div>
</template>

<style scoped>
.page {
  width: 100%;
  padding: calc(var(--nav-height) + clamp(2.5rem, 7vw, 4.5rem)) 0 var(--space-16);
}

.page-head {
  max-width: 620px;
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

.tool {
  display: grid;
  grid-template-columns: 1fr 1fr;
  border-top: 1px solid var(--border);
  border-bottom: 1px solid var(--border);
}

.panel {
  display: flex;
  flex-direction: column;
  padding: var(--space-8) 0;
}

.panel:first-child {
  padding-right: var(--space-8);
  border-right: 1px solid var(--border);
}

.panel:last-child {
  padding-left: var(--space-8);
}

.panel-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--space-3);
  margin-bottom: var(--space-6);
}

.panel-head h2 {
  font-family: var(--font-mono);
  font-size: var(--text-xs);
  font-weight: 400;
  letter-spacing: 0;
  color: var(--text-faint);
}

.field {
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
  margin-bottom: var(--space-5);
}

label {
  color: var(--text-muted);
  font-size: var(--text-sm);
}

.select-wrap {
  position: relative;
}

.select-wrap::after {
  content: '';
  position: absolute;
  top: 50%;
  right: 14px;
  width: 6px;
  height: 6px;
  border-right: 1px solid var(--text-muted);
  border-bottom: 1px solid var(--text-muted);
  transform: translateY(-70%) rotate(45deg);
  pointer-events: none;
}

select,
.doc-input {
  width: 100%;
  padding: 11px var(--space-4);
  border: 1px solid var(--border-strong);
  border-radius: var(--radius);
  background: var(--bg-soft);
  color: var(--text);
  font-family: var(--font-sans);
  font-size: var(--text-sm);
  transition: border-color var(--fast) var(--ease);
}

select {
  appearance: none;
  padding-right: var(--space-10);
  cursor: pointer;
}

select option {
  background: var(--surface);
  color: var(--text);
}

.doc-input {
  font-family: var(--font-mono);
  font-size: var(--text-base);
}

select:focus,
.doc-input:focus {
  outline: none;
  border-color: var(--accent);
}

.doc-input::placeholder {
  color: var(--text-faint);
}

.form-actions {
  display: flex;
  flex-wrap: wrap;
  gap: var(--space-6);
  margin-top: auto;
  padding-top: var(--space-2);
}

.btn {
  padding: 0;
  border: 0;
  background: transparent;
  color: var(--text-muted);
  font-size: var(--text-sm);
  text-decoration: underline;
  text-decoration-color: var(--border-strong);
  text-underline-offset: 4px;
  cursor: pointer;
  transition: color var(--fast) var(--ease), text-decoration-color var(--fast) var(--ease);
}

.btn:hover {
  color: var(--text);
  text-decoration-color: var(--accent);
}

.tag {
  font-family: var(--font-mono);
  font-size: var(--text-xs);
  color: var(--accent);
}

.result-body {
  display: flex;
  flex-direction: column;
  gap: var(--space-5);
  flex: 1;
}

.empty {
  display: flex;
  flex: 1;
  align-items: center;
  min-height: 140px;
  color: var(--text-faint);
}

.empty p {
  font-size: var(--text-sm);
}

.status {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  font-family: var(--font-mono);
}

.status-mark {
  font-size: var(--text-lg);
  line-height: 1;
}

.status.ok {
  color: var(--success);
}

.status.err {
  color: var(--danger);
}

.status-text {
  display: flex;
  flex-direction: column;
  line-height: 1.35;
}

.status-text strong {
  font-size: var(--text-base);
  font-weight: 600;
}

.status-text span {
  font-size: var(--text-xs);
  color: var(--text-faint);
}

.output {
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
}

.output-label {
  font-family: var(--font-mono);
  font-size: var(--text-xs);
  color: var(--text-faint);
}

.output-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--space-3);
  padding: var(--space-3) var(--space-4);
  border: 1px solid var(--border-strong);
  border-radius: var(--radius);
  background: var(--bg-soft);
}

.output-row code {
  font-size: var(--text-base);
  color: var(--text);
  word-break: break-all;
}

.copy-btn {
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

.copy-btn:hover {
  color: var(--text);
}

.copy-btn.copied {
  color: var(--success);
}

.message {
  padding: var(--space-3) var(--space-4);
  border-left: 2px solid var(--danger);
  background: var(--bg-soft);
  color: var(--text-muted);
  font-size: var(--text-sm);
}

.output-hint {
  font-size: var(--text-xs);
  color: var(--text-faint);
}

.footnote {
  margin-top: var(--space-6);
  color: var(--text-faint);
  font-size: var(--text-xs);
}

.footnote code {
  color: var(--text-muted);
}

@media (max-width: 820px) {
  .tool {
    grid-template-columns: 1fr;
  }

  .panel:first-child {
    padding-right: 0;
    border-right: 0;
    border-bottom: 1px solid var(--border);
  }

  .panel:last-child {
    padding-left: 0;
  }

  .empty {
    min-height: 100px;
  }
}
</style>
