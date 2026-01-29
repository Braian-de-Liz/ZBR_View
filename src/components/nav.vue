<script setup lang="ts">
import { ref } from 'vue';

const isMenuOpen = ref(false);

const toggleMenu = () => {
    isMenuOpen.value = !isMenuOpen.value;
};

const closeMenu = () => {
    isMenuOpen.value = false;
};
</script>

<template>
    <nav class="navbar">
        <div class="nav-content">
            <div class="brand-group">
                <router-link to="/" class="brand" @click="closeMenu">
                    <img src="../assets/imgs/logo zbr (1).png" alt="ZBR Logo" class="nav-logo" />
                    <span class="brand-name">ZBR <span class="thin">Standards</span></span>
                </router-link>
            </div>

            <div class="nav-links desktop-only">
                <div class="social-links">
                    <a href="https://github.com/Braian-de-Liz/br_standards_with_ZOD" target="_blank" class="social-icon">
                        <i class="fab fa-github"></i> <span class="social-text">GitHub</span>
                    </a>
                    <a href="https://www.npmjs.com/package/br_standards_with_zod" target="_blank" class="social-icon">
                        <span class="social-text">NPM</span>
                    </a>
                </div>
                
                <router-link to="/" class="nav-item btn-playground">Início</router-link>
                <router-link to="/playground" class="nav-item btn-playground">
                    <img src="../assets/imgs/playground.png" alt="" class="icon-sm" />
                    <span>Playground</span>
                </router-link>
            </div>

            <button class="hamburger" @click="toggleMenu" :class="{ 'is-active': isMenuOpen }" aria-label="Menu">
                <span></span>
                <span></span>
                <span></span>
            </button>
        </div>

        <transition name="fade-slide">
            <div v-if="isMenuOpen" class="mobile-menu">
                <router-link to="/" class="mobile-item" @click="closeMenu">Início</router-link>
                <router-link to="/playground" class="mobile-item" @click="closeMenu">Playground</router-link>
                
                <div class="mobile-footer">
                    <a href="https://github.com/Braian-de-Liz/br_standards_with_ZOD" target="_blank" class="social-icon">GitHub</a>
                    <a href="https://www.npmjs.com/package/br_standards_with_zod" target="_blank" class="social-icon">NPM</a>
                </div>
            </div>
        </transition>
    </nav>
</template>

<style scoped>
/* NAVBAR BASE */
.navbar {
    position: fixed;
    top: 0; left: 0;
    width: 100%;
    height: 64px;
    background: rgba(15, 23, 42, 0.9);
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
    padding: 0 1.5rem;
}

/* BRAND / LOGO */
.brand-group {
    display: flex;
    align-items: center;
}

.brand {
    display: flex;
    align-items: center;
    gap: 10px;
    text-decoration: none;
    color: white;
    font-weight: 700;
    font-size: 1.2rem;
    flex-shrink: 0;
}

.nav-logo { height: 30px; }
.thin { font-weight: 300; color: #94a3b8; }

/* MENU DESKTOP */
.nav-links {
    display: flex;
    align-items: center;
    gap: 1.5rem;
}

.social-links {
    display: flex;
    gap: 1rem;
    padding-right: 1rem;
    border-right: 1px solid #334155;
}

.social-icon {
    color: #94a3b8;
    text-decoration: none;
    font-size: 0.85rem;
    transition: color 0.2s;
}

.social-icon:hover { color: #38bdf8; }

.nav-item {
    text-decoration: none;
    color: #94a3b8;
    font-size: 0.95rem;
    transition: color 0.2s;
}

.nav-item:hover { color: white; }

/* BOTÃO PLAYGROUND (O que estava gigante) */
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

.icon-sm {
    height: 18px !important;
    width: 18px !important;
    object-fit: contain;
    flex-shrink: 0;
}

/* HAMBURGER */
.hamburger {
    display: none;
    flex-direction: column;
    gap: 5px;
    background: none;
    border: none;
    cursor: pointer;
    z-index: 1100;
}

.hamburger span {
    display: block;
    width: 25px;
    height: 2px;
    background: white;
    transition: 0.3s;
}

/* Animação X */
.hamburger.is-active span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
.hamburger.is-active span:nth-child(2) { opacity: 0; }
.hamburger.is-active span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }

/* MENU MOBILE */
.mobile-menu {
    position: fixed;
    top: 0; left: 0;
    width: 100%;
    height: 100vh;
    background: #0f172a;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    gap: 2rem;
    z-index: 1050;
}

.mobile-item {
    font-size: 1.8rem;
    color: white;
    text-decoration: none;
    font-weight: 700;
}

.mobile-footer {
    display: flex;
    gap: 2rem;
    margin-top: 2rem;
}

/* TRANSIÇÃO */
.fade-slide-enter-active, .fade-slide-leave-active { transition: all 0.3s ease; }
.fade-slide-enter-from, .fade-slide-leave-to { opacity: 0; transform: translateY(-20px); }

/* RESPONSIVIDADE */
@media (max-width: 850px) {
    .desktop-only { display: none; }
    .hamburger { display: flex; }
}

@media (max-width: 480px) {
    .brand-name .thin { display: none; }
}
</style>