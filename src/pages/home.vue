<script setup lang="ts">
import { ref } from 'vue';
const copied = ref(false);

const copyToClipboard = async () => {
    const text = 'npm install br_standards_with_zod'
    try {
        await navigator.clipboard.writeText(text)
        copied.value = true

        setTimeout(() => {
            copied.value = false
        }, 2000)
    } catch (err) {
        console.error('Falha ao copiar:', err)
    }
}
</script>

<template>
    <div class="container">
        <header class="hero">
            <div class="logo-wrapper">
                <img src="../assets/imgs/logo zbr (1).png" alt="ZBR Logo" class="main-logo" />
            </div>
            <h1>ZBR Standards</h1>
            <p class="subtitle">A ponte perfeita entre o <strong>Zod</strong> e os padrões brasileiros.</p>

            <div class="npm-install" @click="copyToClipboard" title="Clique para copiar"
                style="cursor: pointer; position: relative;">
                <code>npm install br_standards_with_zod</code>

                <span class="copy-status">
                    {{ copied ? ' Copiado!' : '📋' }}
                </span>
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
                        <li>✅ <strong>CPF, CNPJ e RG</strong> (v1.1.0)</li>
                        <li>✅ <strong>CEP</strong> e <strong>Telefone</strong> (DDDs Reais)</li>
                        <li>✅ <strong>Sanitização</strong> automática (remove máscaras)</li>
                        <li>✅ Mensagens de erro customizáveis</li>
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
                <h3>1. Validação e Transformação</h3>
                <p>Valide e limpe os dados automaticamente para o seu banco de dados.</p>
                <pre>
                    <code class="code_center">
import { zbr } from 'br_standards_with_zod'

// Valida e transforma: "123.456.789-01" -> "12345678901"
zbr.cpf().parse('123.456.789-01') 

// Valida telefones com DDDs brasileiros reais
zbr.tel().parse('(47) 99888-7766')
                    </code>
                </pre>
            </div>

            <div class="how-it-works">
                <h3>2. Mensagens Customizadas</h3>
                <p>Dê um feedback personalizado para o seu usuário.</p>
                <pre>
                    <code class="code_center">
// Você pode passar a mensagem diretamente no método
const schema = zbr.cep("CEP não encontrado em nossa base")

const result = schema.safeParse('00000-000')
if (!result.success) {
  console.log(result.error.errors[0].message)
}
                    </code>
                </pre>
            </div>

            <div class="how-it-works">
                <h3>3. Integração em Schemas Complexos</h3>
                <p>Use dentro de objetos do Zod perfeitamente.</p>
                <pre>
                    <code class="code_center">
import { z } from 'zod'

const userSchema = z.object({
  name: z.string().min(3),
  documento: zbr.cpf(),
  contato: zbr.tel(),
  endereco_cep: zbr.cep()
})
                    </code>
                </pre>
            </div>
        </section>

        <footer class="footer-simple">
            <p>ZBR Standards &copy; 2026 - Desenvolvido por Braian de Liz para a comunidade.</p>
        </footer>
    </div>
</template>

<style scoped>
/* Mantive todos os seus estilos intactos, pois a estética está perfeita. */
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
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
    width: 100%;
    max-width: min(1200px, 92vw);
    margin: 0 auto;
    padding: clamp(4rem, 6vw, 6rem) clamp(1rem, 4vw, 2rem) 2rem;
    color: #f8fafc;
    box-sizing: border-box;
    animation: fadeInUp 0.8s ease-out;
}

.hero {
    text-align: center;
    padding: 0 clamp(0.5rem, 3vw, 1rem) clamp(2rem, 6vw, 3rem);
}

.main-logo {
    height: clamp(64px, 18vw, 96px);
    max-width: 100%;
    margin-bottom: 1.5rem;
    animation: float 4s ease-in-out infinite, pulse-glow 3s infinite;
    transition: transform 0.3s ease;
}

.main-logo:hover { transform: scale(1.05); }

.hero h1 {
    font-size: clamp(2rem, 10vw, 3.5rem);
    margin-bottom: 1rem;
    background: linear-gradient(to right, #22c55e, #3b82f6);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    font-weight: 800;
    line-height: 1.1;
}

.subtitle {
    font-size: clamp(1rem, 3vw, 1.1rem);
    line-height: 1.5;
    color: #94a3b8;
}

.npm-install {
    background: #1e293b;
    padding: 0.9rem 1.2rem;
    border-radius: 12px;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    margin: 2rem auto 0;
    border: 1px solid #334155;
    font-family: monospace;
    color: #38bdf8;
    font-size: clamp(0.75rem, 2.5vw, 0.85rem);
    max-width: 100%;
    word-break: break-word;
    text-align: center;
    transition: all 0.2s ease;
}

.npm-install:hover {
    border-color: #38bdf8;
    background: #243046;
    transform: translateY(-2px);
}

.npm-install:active { transform: translateY(0); }

.npm-install code {
    white-space: normal;
    overflow-wrap: anywhere;
}

.grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(min(280px, 100%), 1fr));
    gap: clamp(1rem, 3vw, 1.5rem);
    margin-top: 2rem;
}

.card {
    background: #1e293b;
    padding: clamp(1.2rem, 4vw, 1.5rem);
    border-radius: 16px;
    border: 1px solid #334155;
    display: flex;
    flex-direction: column;
    transition: all 0.3s ease;
}

.card:hover {
    border-color: #334155;
    background: #243046;
    transform: translateY(-5px);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
}

.card h3 {
    color: #38bdf8;
    margin-bottom: 1rem;
    font-size: 1.3rem;
}

.card li {
    display: flex;
    align-items: flex-start;
    gap: 8px;
    margin-bottom: 0.75rem;
    color: #cbd5e1;
    font-size: 0.95rem;
}

.code-showcase { margin-top: 3rem; }
.section-title { text-align: center; margin-bottom: 2rem; }
.section-title h2 { font-size: clamp(1.6rem, 5vw, 2.2rem); }
.section-title p { color: #94a3b8; }

.how-it-works {
    margin: 2rem 0;
    background: #111827;
    padding: clamp(1.2rem, 4vw, 1.5rem);
    border-radius: 16px;
    border: 1px solid #1e293b;
    transition: border-color 0.3s ease;
}

.how-it-works:hover { border-color: #334155; }

pre {
    background: #010409;
    padding: clamp(0.75rem, 3vw, 1rem);
    border-radius: 8px;
    overflow-x: auto;
    border: 1px solid #30363d;
    transition: border-color 0.3s ease;
}

.how-it-works:hover pre { border-color: #38bdf8; }
.code_center { font-size: clamp(0.75rem, 2.5vw, 0.85rem); line-height: 1.6; }

.footer-simple {
    text-align: center;
    margin-top: 4rem;
    color: #64748b;
    font-size: 0.9rem;
}

@media (max-width: 600px) {
    .container { padding-top: 4.5rem; }
    .hero h1 { font-size: clamp(1.9rem, 9vw, 2.3rem); }
    .card:hover { transform: translateY(-2px); }
}
</style>