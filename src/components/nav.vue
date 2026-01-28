<script setup lang="ts">
// Você não precisa importar o componente da página aqui na Nav.
// O Router cuida disso sozinho!
</script>

<template>
    <nav class="navbar">
        <div class="nav-content">
            <div class="brand-group">
                <router-link to="/" class="brand">
                    <img src="../assets/imgs/logo zbr (1).png" alt="ZBR Logo" class="nav-logo" />
                    <span class="brand-name">ZBR <span class="thin">Standards</span></span>
                </router-link>

                <div class="social-links">
                    <a href="https://github.com/Braian-de-Liz/br_standards_with_ZOD" target="_blank" class="social-icon" title="GitHub">
                        <i class="fab fa-github"></i> <span class="social-text">GitHub</span>
                    </a>
                    <a href="https://www.npmjs.com/package/br_standards_with_zod" target="_blank" class="social-icon" title="NPM">
                        <span class="social-text">NPM</span>
                    </a>
                </div>
            </div>

            <div class="nav-links">
                <router-link to="/" class="nav-item btn-playground">Início</router-link>
                <router-link to="/playground" class="nav-item btn-playground">
                    <img src="../assets/imgs/playground.png" alt="" class="icon-sm" />
                    Playground
                </router-link>
            </div>
        </div>
    </nav>
</template>

<style scoped>
.navbar {
    position: fixed;
    top: 0; left: 0;
    width: 100%;
    height: 64px;
    background: rgba(15, 23, 42, 0.8);
    backdrop-filter: blur(12px);
    border-bottom: 1px solid #1e293b;
    z-index: 1000;
    display: flex;
    justify-content: center;
}

.nav-content {
    width: 100%;
    max-width: 1200px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 2rem;
}

/* Novo grupo para alinhar logo + links sociais */
.brand-group {
    display: flex;
    align-items: center;
    gap: 24px;
}

.brand {
    display: flex;
    align-items: center;
    gap: 12px;
    text-decoration: none;
    color: white;
    font-weight: 700;
    font-size: 1.2rem;
}

.nav-logo { height: 32px; }

.thin { font-weight: 300; color: #94a3b8; }

/* Estilização dos links do GitHub/NPM */
.social-links {
    display: flex;
    gap: 16px;
    border-left: 1px solid #334155;
    padding-left: 20px;
}

.social-icon {
    color: #94a3b8;
    text-decoration: none;
    font-size: 0.85rem;
    font-weight: 500;
    transition: color 0.2s, transform 0.2s;
    display: flex;
    align-items: center;
}

.social-icon:hover {
    color: #38bdf8;
    transform: translateY(-1px);
}

.nav-links {
    display: flex;
    align-items: center;
    gap: 1.5rem;
}

.nav-item {
    text-decoration: none;
    color: #94a3b8;
    font-size: 0.95rem;
    font-weight: 500;
    transition: color 0.2s;
}

.nav-item:hover,
.router-link-active {
    color: #38bdf8;
}

.btn-playground {
    display: flex;
    align-items: center;
    gap: 8px;
    background: #1e293b;
    padding: 0.5rem 1rem;
    border-radius: 8px;
    border: 1px solid #334155;
    color: white !important;
}

.btn-playground:hover {
    border-color: #38bdf8;
    background: #263349;
}

.icon-sm { height: 18px; width: 18px; }

@media (max-width: 600px) {
    .social-text { display: none; } /* Esconde o texto em telas pequenas */
    .social-links { gap: 10px; }
}
</style>