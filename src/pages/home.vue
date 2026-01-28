<script setup lang="ts">
// A Nav agora é gerenciada apenas pelo App.vue
</script>

<template>
    <div class="container">
        <header class="hero">
            <div class="logo-wrapper">
                <img src="../assets/imgs/logo zbr (1).png" alt="ZBR Logo" class="main-logo" />
            </div>
            <h1>ZBR Standards</h1>
            <p class="subtitle">A ponte perfeita entre o <strong>Zod</strong> e os padrões brasileiros.</p>

            <div class="npm-install">
                <code>npm install br_standards_with_zod</code>
            </div>
        </header>

        <section class="explicacao">
            <div class="grid">
                <div class="card">
                    <h3>O que é?</h3>
                    <p>
                        É uma biblioteca de esquemas <strong>Zod</strong> pré-configurados para validar documentos
                        brasileiros. Esqueça regex complexas; nós cuidamos da matemática dos dígitos verificadores.
                    </p>
                </div>

                <div class="card">
                    <h3>O que ela faz?</h3>
                    <ul>
                        <li>✅ Valida <strong>CPF</strong> e <strong>CNPJ</strong></li>
                        <li>✅ Suporte nativo a <strong>TypeScript</strong></li>
                        <li>✅ Mensagens de erro customizáveis</li>
                        <li>✅ Verificação de algoritmos reais</li>
                    </ul>
                </div>
            </div>
        </section>

        <section class="code-showcase">
            <div class="section-title">
                <h2>Como funciona na prática?</h2>
                <p>Simples, intuitivo e poderoso.</p>
            </div>

            <div class="how-it-works">
                <h3>1. Validação Simples</h3>
                <p>Valide strings isoladas de forma rápida.</p>
                <pre>
                    <code class="code_center">
import { zbr } from 'br_standards_with_zod'

// Valida CPF com ou sem máscara
zbr.cpf().parse('123.456.789-01') 

// Valida CNPJ
zbr.cnpj().parse('12.345.678/0001-90')
                    </code>
                </pre>
            </div>

            <div class="how-it-works">
                <h3>2. Mensagens Customizadas</h3>
                <p>Dê um feedback melhor para o seu usuário brasileiro.</p>
                <pre>
                    <code class="code_center">
const schema = zbr.cpf({
  message: "Este CPF não parece estar correto, verifique os números."
})

const result = schema.safeParse('000.000.000-00')
if (!result.success) console.log(result.error.errors[0].message)
                    </code>
                </pre>
            </div>

            <div class="how-it-works">
                <h3>3. Integrado em Schemas Complexos</h3>
                <p>Use dentro de objetos do Zod como qualquer outro tipo.</p>
                <pre>
                    <code class="code_center">
import { z } from 'zod'

const userSchema = z.object({
  name: z.string().min(3),
  documento: zbr.cpf(),
  empresa_cnpj: zbr.cnpj().optional()
})
                    </code>
                </pre>
            </div>
        </section>

        <footer class="footer-simple">
            <p>ZBR Standards &copy; 2026 - Desenvolvido para a comunidade brasileira.</p>
        </footer>
    </div>
</template>

<style scoped>
/* Keyframes e Animações */
@keyframes fadeInUp {
    from { opacity: 0; transform: translateY(30px); }
    to { opacity: 1; transform: translateY(0); }
}

@keyframes float {
    0%, 100% { transform: translateY(0px); }
    50% { transform: translateY(-10px); }
}

@keyframes pulse-glow {
    0%, 100% { filter: drop-shadow(0 0 15px rgba(56, 189, 248, 0.3)); }
    50% { filter: drop-shadow(0 0 30px rgba(56, 189, 248, 0.6)); }
}

.container {
    max-width: 900px;
    margin: 0 auto;
    padding: 8rem 2rem 4rem 2rem;
    color: #f8fafc;
    animation: fadeInUp 0.8s ease-out;
}

.hero { text-align: center; padding-bottom: 4rem; }

.main-logo {
    height: 120px;
    margin-bottom: 1.5rem;
    animation: float 4s ease-in-out infinite, pulse-glow 3s infinite;
}

.hero h1 {
    font-size: 3.5rem;
    margin-bottom: 0.5rem;
    background: linear-gradient(to right, #22c55e, #3b82f6);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    font-weight: 800;
}

.subtitle { font-size: 1.25rem; color: #94a3b8; }

.npm-install {
    background: #1e293b;
    padding: 0.8rem 1.5rem;
    border-radius: 99px;
    display: inline-block;
    margin-top: 2rem;
    border: 1px solid #334155;
    font-family: monospace;
    color: #38bdf8;
}

.section-title {
    text-align: center;
    margin-top: 6rem;
    margin-bottom: 3rem;
}

.section-title h2 {
    font-size: 2.2rem;
    color: #f8fafc;
}

.section-title p {
    color: #94a3b8;
}

.grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 2rem;
}

.card {
    background: #1e293b;
    padding: 2rem;
    border-radius: 12px;
    border: 1px solid #334155;
    transition: all 0.3s ease;
}

.card:hover {
    transform: translateY(-5px);
    border-color: #38bdf8;
    background: #243147;
}

.card h3 { color: #38bdf8; margin-bottom: 1rem; }
.card ul { list-style: none; padding: 0; }
.card li { margin-bottom: 0.5rem; color: #cbd5e1; }

.how-it-works {
    margin-bottom: 2rem;
    background: #111827;
    padding: 2rem;
    border-radius: 16px;
    border: 1px solid #1e293b;
}

.how-it-works h3 {
    color: #22c55e;
    margin-bottom: 0.5rem;
}

.how-it-works p {
    color: #94a3b8;
    margin-bottom: 1rem;
    font-size: 0.95rem;
}

pre {
    background: #010409;
    padding: 1.5rem;
    border-radius: 8px;
    overflow-x: auto;
    border: 1px solid #30363d;
}

.code_center {
    color: #e6edf3;
    font-family: 'Fira Code', monospace;
    font-size: 0.9rem;
    line-height: 1.5;
}

.footer-simple {
    text-align: center;
    margin-top: 8rem;
    padding: 2rem 0;
    border-top: 1px solid #1e293b;
    color: #64748b;
    font-size: 0.9rem;
}

@media (max-width: 768px) {
    .grid { grid-template-columns: 1fr; }
    h1 { font-size: 2.5rem; }
}
</style>