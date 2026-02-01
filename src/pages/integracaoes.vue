<script setup lang="ts">
import { ref } from 'vue'

const activeTab = ref('react')

const tabs = [
  { id: 'react', name: 'React Hook Form' },
  { id: 'vue', name: 'Vue 3' },
  { id: 'fastify', name: 'Fastify' },
  { id: 'express', name: 'Express' },
  { id: 'nest', name: 'NestJS' }
]

const codeExamples: Record<string, string> = {
  react: `import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { zbr } from 'br_standards_with_zod';
import { z } from 'zod';

const schema = z.object({
  documento: zbr.cpf("CPF inválido"),
  telefone: zbr.tel("Celular inválido")
});

export function Register() {
  const { register, handleSubmit, formState: { errors } } = useForm({
    resolver: zodResolver(schema)
  });

  return (
    <form onSubmit={handleSubmit(data => console.log(data))}>
      <input {...register("documento")} placeholder="000.000.000-00" />
      {errors.documento && <span>{errors.documento.message}</span>}
      <button>Enviar</button>
    </form>
  );
}`,
  vue: `<script setup lang="ts">
import { z } from 'zod';
import { zbr } from 'br_standards_with_zod';
import { ref } from 'vue';

const schema = z.object({
  cep: zbr.cep("CEP não encontrado")
});

const form = ref({ cep: '' });
const error = ref('');

const validate = () => {
  const result = schema.safeParse(form.value);
  if (!result.success) {
    error.value = result.error.errors[0].message;
  } else {
    error.value = '';
    console.log("Dados limpos:", result.data);
  }
};
<\/script>

<template>
  <input v-model="form.cep" @blur="validate" placeholder="00000-000" />
  <p v-if="error">{{ error }}</p>
</template>`,
  fastify: `import Fastify from 'fastify';
import { z } from 'zod';
import { zbr } from 'br_standards_with_zod';

const app = Fastify();

const userSchema = z.object({
  cpf: zbr.cpf(),
  cep: zbr.cep()
});

app.post('/user', async (request, reply) => {
  // O ZBR valida e já limpa as máscaras automaticamente
  const data = userSchema.parse(request.body);
  return { message: "Validado!", cleanData: data };
});`,
  express: `import express from 'express';
import { z } from 'zod';
import { zbr } from 'br_standards_with_zod';
import { processRequestBody } from 'zod-express-middleware';

const app = express();

const registrationSchema = z.object({
  body: z.object({
    cnpj: zbr.cnpj("CNPJ inválido"),
    inscricaoEstadual: zbr.ie("UF")
  }),
});

app.post('/register', processRequestBody(registrationSchema.shape.body), (req, res) => {
  // req.body já está tipado e com dados sanitizados
  res.send({ status: "Empresa Validada" });
});`,
  nest: `import { zbr } from 'br_standards_with_zod';
import { z } from 'zod';

// No NestJS, você usa o ZBR dentro dos seus Zod Validation Pipes
export const CreateUserSchema = z.object({
  nome: z.string(),
  cpf: zbr.cpf("Documento obrigatório"),
  rg: zbr.rg()
});

export type CreateUserDto = z.infer<typeof CreateUserSchema>;

// No Controller:
// @UsePipes(new ZodValidationPipe(CreateUserSchema))
// async create(@Body() createUserDto: CreateUserDto) { ... }`
}
</script>

<template>
  <div class="integrations-page">
    <div class="container">
      <header class="header">
        <h1>Integrações Oficiais</h1>
        <p>Implemente a <strong>ZBR</strong> no seu ecossistema TypeScript favorito.</p>
      </header>

      <div class="tabs-container">
        <div class="tabs-header">
          <button 
            v-for="tab in tabs" 
            :key="tab.id"
            :class="['tab-btn', { active: activeTab === tab.id }]"
            @click="activeTab = tab.id"
          >
            <div class="tab-icon">
              <svg v-if="tab.id === 'react'" viewBox="-11.5 -10.23174 23 20.46348" width="20">
                <circle cx="0" cy="0" r="2.05" fill="#61dafb"/>
                <g stroke="#61dafb" stroke-width="1" fill="none">
                  <ellipse rx="11" ry="4.2"/><ellipse rx="11" ry="4.2" transform="rotate(60)"/><ellipse rx="11" ry="4.2" transform="rotate(120)"/>
                </g>
              </svg>
              
              <svg v-if="tab.id === 'vue'" viewBox="0 0 256 221" width="18">
                <path d="M204.8 0H256L128 220.8L0 0h97.92L128 51.2L157.44 0h47.36Z" fill="#41B883"/>
                <path d="m0 0l128 220.8L256 0h-51.2L128 132.48L51.2 0H0Z" fill="#35495E"/>
              </svg>

              <svg v-if="tab.id === 'fastify'" viewBox="0 0 512 512" width="18" fill="currentColor">
                <path d="M437.1 113.1L266.3 14.4c-6.4-3.7-14.2-3.7-20.6 0L74.9 113.1c-6.4 3.7-10.3 10.5-10.3 17.8v197.3c0 7.3 3.9 14.1 10.3 17.8l170.8 98.7c6.4 3.7 14.2 3.7 20.6 0l170.8-98.7c6.4-3.7 10.3-10.5 10.3-17.8V130.9c0-7.3-3.9-14.1-10.3-17.8zM315 251l-40 93.3c-2 4.6-8.5 4.8-10.8.4L221 261h-44.3c-5.5 0-9-5.9-6.3-10.7l46.7-84c2-3.6 7.2-3.6 9.2 0l35 63h47.4c5.5 0 8.9 6 6.3 10.7z"/>
              </svg>

              <svg v-if="tab.id === 'express'" viewBox="0 0 512 512" width="18" fill="currentColor">
                <path d="M256 8C119 8 8 119 8 256s111 248 248 248 248-111 248-248S393 8 256 8zm144 326.6c0 40-32.4 72.4-72.4 72.4H184.4c-40 0-72.4-32.4-72.4-72.4V185.4c0-40 32.4-72.4 72.4-72.4h143.2c40 0 72.4 32.4 72.4 72.4v149.2z"/>
                <path d="M176 216h32v80h-32zm64 0h32v80h-32zm64 0h32v80h-32z" opacity=".5"/>
              </svg>

              <svg v-if="tab.id === 'nest'" viewBox="0 0 512 512" width="18" fill="#E0234E">
                <path d="M482 152V360c0 67.38-54.62 122-122 122H152c-67.38 0-122-54.62-122-122V152c0-67.38 54.62-122 122-122H360c67.38 0 122 54.62 122 122zM339.14 103.14l-81.25 119.55-15.01-22.12 43.14-63.51h-56.12l-65.01 95.66-26.63-39.18h-58.26l66.52 97.87-83.52 123.01h56.12l53.4-78.64 15.01 22.12-43.14 63.5h56.12l65.01-95.66 26.63 39.18h58.26l-66.52-97.87 83.52-123.01h-53.77z"/>
              </svg>
            </div>
            {{ tab.name }}
          </button>
        </div>

        <div class="code-viewer">
          <div class="code-header">
            <span class="file-name">example.{{ activeTab === 'react' || activeTab === 'vue' ? (activeTab === 'vue' ? 'vue' : 'tsx') : 'ts' }}</span>
            <span class="lang-tag">TypeScript</span>
          </div>
          <pre><code>{{ codeExamples[activeTab] }}</code></pre>
        </div>
      </div>

      <div class="tip-card">
        <h3>💡 Sanitização Nativa</h3>
        <p>
          O <strong>ZBR</strong> não apenas valida. Ele utiliza o método <code>.transform()</code> do Zod para garantir que 
          se o input for <code>"123.456.789-00"</code>, o seu banco receba <code>"12345678900"</code> automaticamente.
        </p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.integrations-page {
  min-height: 100vh;
  background: #0f172a;
  color: #f8fafc;
  padding: 4rem 1rem;
}

.container {
  max-width: 1000px; /* Um pouco mais largo para acomodar mais abas */
  margin: 0 auto;
}

.header {
  text-align: center;
  margin-bottom: 3rem;
}

h1 { font-size: 2.5rem; margin-bottom: 1rem; color: #f8fafc; }
p { color: #94a3b8; font-size: 1.1rem; }

.tabs-container {
  background: #1e293b;
  border: 1px solid #334155;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 20px 40px rgba(0,0,0,0.3);
}

.tabs-header {
  display: flex;
  background: #111827;
  border-bottom: 1px solid #334155;
  padding: 0.5rem;
  gap: 0.5rem;
  overflow-x: auto; /* Scroll horizontal para mobile */
}

.tabs-header::-webkit-scrollbar {
  height: 4px;
}
.tabs-header::-webkit-scrollbar-thumb {
  background: #334155;
  border-radius: 10px;
}

.tab-btn {
  background: transparent;
  border: none;
  color: #94a3b8;
  padding: 0.8rem 1.2rem;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 0.7rem;
  font-weight: 600;
  white-space: nowrap;
}

.tab-btn:hover { background: #1e293b; color: #fff; }
.tab-btn.active { background: #334155; color: #38bdf8; }

.tab-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 20px;
}

.tab-btn.active .tab-icon svg {
  filter: drop-shadow(0 0 4px rgba(56, 189, 248, 0.5));
}

/* Cores específicas no hover/active */
.tab-btn:hover svg[fill="currentColor"], .tab-btn.active svg[fill="currentColor"] {
  color: #fff;
}

.code-viewer {
  padding: 1.5rem;
  background: #010409;
}

.code-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 1rem;
  font-family: monospace;
  font-size: 0.8rem;
  color: #475569;
}

pre {
  margin: 0;
  overflow-x: auto;
  color: #e2e8f0;
  line-height: 1.6;
  font-family: 'Fira Code', monospace;
  font-size: 0.9rem;
}

.tip-card {
  margin-top: 2rem;
  background: rgba(56, 189, 248, 0.1);
  border: 1px solid rgba(56, 189, 248, 0.2);
  padding: 1.5rem;
  border-radius: 16px;
}

.tip-card h3 { color: #38bdf8; margin-bottom: 0.5rem; }
.tip-card p { color: #cbd5e1; font-size: 0.95rem; }

@media (max-width: 768px) {
  .tabs-header { padding: 0.8rem; }
}
</style>