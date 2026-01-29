<script setup lang="ts">
import { ref, computed } from 'vue'
import { zbr } from 'br_standards_with_zod' 

const documento = ref('')
const tipo = ref('cpf') 

const resultado = computed(() => {
  if (!documento.value) return null
  
  const validators: Record<string, any> = {
    cpf: zbr.cpf(),
    cnpj: zbr.cnpj(),
    rg: zbr.rg() 
  }

  return validators[tipo.value]?.safeParse(documento.value)
})

const limpar = () => documento.value = ''
</script>

<template>
  <div class="playground-page">
    <div class="glass-card">
      <header class="card-header">
        <h1>Playground Interativo</h1>
        <p class="desc">Validação em tempo real com algoritmos oficiais.</p>
      </header>

      <div class="controls">
        <div class="input-group select-box">
          <label>Tipo de Documento</label>
          <select v-model="tipo" @change="limpar">
            <option value="cpf">CPF (Pessoa Física)</option>
            <option value="cnpj">CNPJ (Empresa)</option>
            <option value="rg">RG (Registro Geral - SP)</option>
          </select>
        </div>

        <div class="input-group input-box">
          <label>Número do {{ tipo.toUpperCase() }}</label>
          <input 
            v-model="documento" 
            :placeholder="`Ex: ${tipo === 'cpf' ? '000.000.000-00' : '00.000.000/0001-00'}`"
            autofocus
          />
        </div>
      </div>

      <div class="result-area">
        <transition name="fade" mode="out-in">
          <div v-if="!documento" class="waiting" key="waiting">
            Aguardando entrada de dados...
          </div>
          
          <div v-else-if="resultado?.success" class="status-box valid" key="valid">
            <span class="icon">✅</span>
            <div class="msg">
              <strong>Válido!</strong>
              <span>O {{ tipo.toUpperCase() }} informado está correto.</span>
            </div>
          </div>

          <div v-else class="status-box invalid" key="invalid">
            <span class="icon">❌</span>
            <div class="msg">
              <strong>Inválido</strong>
              <span>{{ resultado?.error.errors[0].message }}</span>
            </div>
          </div>
        </transition>
      </div>
    </div>
  </div>
</template>

<style scoped>
.playground-page {
  min-height: calc(100vh - 64px); 
  display: flex;
  justify-content: center;
  align-items: center;
  /* Padding responsivo: menos nas laterais em telas pequenas */
  padding: clamp(1rem, 5vw, 2rem);
  background: #0f172a; 
  box-sizing: border-box;
}

.glass-card {
  background: #1e293b;
  border: 1px solid #334155;
  /* Padding interno reduzido para mobile */
  padding: clamp(1.5rem, 5vw, 3rem);
  border-radius: 24px;
  width: 100%;
  max-width: 800px; /* Reduzi de 1200px para ficar mais elegante e centralizado */
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
}

.card-header {
  text-align: center;
  margin-bottom: 2rem;
}

h1 { 
  color: #f8fafc; 
  margin-bottom: 0.5rem; 
  font-size: clamp(1.4rem, 5vw, 1.8rem); 
}

.desc { 
  color: #94a3b8; 
  font-size: clamp(0.9rem, 3vw, 1rem); 
}

/* Layout dos controles: lado a lado no desktop, empilhado no mobile */
.controls { 
  display: grid;
  grid-template-columns: 1fr 2fr; /* O input ganha mais espaço que o select */
  gap: 1.5rem; 
}

.input-group { 
  display: flex; 
  flex-direction: column; 
  gap: 0.6rem; 
}

label { 
  color: #38bdf8; 
  font-size: 0.7rem; 
  font-weight: 700; 
  text-transform: uppercase; 
  letter-spacing: 0.05em;
}

select, input {
  background: #0f172a;
  border: 1px solid #334155;
  padding: 0.8rem 1rem;
  border-radius: 12px;
  color: white;
  font-size: 1rem;
  transition: all 0.2s ease;
  width: 100%;
  box-sizing: border-box;
}

select:focus, input:focus {
  outline: none;
  border-color: #38bdf8;
  box-shadow: 0 0 0 4px rgba(56, 189, 248, 0.15);
}

.result-area { 
  margin-top: 2rem; 
  min-height: 80px; /* Reduzi um pouco para não sobrar tanto espaço vazio */
}

.waiting { 
  color: #475569; 
  text-align: center; 
  border: 2px dashed #334155; 
  padding: 1.5rem; 
  border-radius: 12px;
  font-style: italic;
  font-size: 0.9rem;
}

.status-box {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem 1.25rem;
  border-radius: 16px;
}

.status-box.valid { 
  background: rgba(34, 197, 94, 0.1); 
  border: 1px solid rgba(34, 197, 94, 0.3); 
  color: #4ade80; 
}

.status-box.invalid { 
  background: rgba(239, 68, 68, 0.1); 
  border: 1px solid rgba(239, 68, 68, 0.3); 
  color: #f87171; 
}

.msg { display: flex; flex-direction: column; }
.msg strong { font-size: 0.95rem; }
.msg span { font-size: 0.8rem; opacity: 0.8; }

/* MEDIA QUERIES PARA CELULAR */
@media (max-width: 650px) {
  .controls {
    grid-template-columns: 1fr; /* Empilha os campos */
    gap: 1rem;
  }
  
  .playground-page {
    padding-top: 5rem; /* Espaço para a nav fixa no mobile */
    align-items: flex-start; /* No mobile, melhor começar do topo */
  }

  .glass-card {
    padding: 1.5rem 1.25rem;
  }
}

/* Transições */
.fade-enter-active, .fade-leave-active { transition: opacity 0.2s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>