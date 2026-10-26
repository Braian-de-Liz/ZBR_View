<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { Menu, X } from 'lucide-vue-next'

const route = useRoute()
const isMenuOpen = ref(false)

const toggleMenu = () => {
  isMenuOpen.value = !isMenuOpen.value
}

const closeMenu = () => {
  isMenuOpen.value = false
}

watch(() => route.fullPath, closeMenu)

watch(isMenuOpen, (open) => {
  document.body.style.overflow = open ? 'hidden' : ''
})

const onKeydown = (event: KeyboardEvent) => {
  if (event.key === 'Escape') closeMenu()
}

onMounted(() => window.addEventListener('keydown', onKeydown))

onBeforeUnmount(() => {
  window.removeEventListener('keydown', onKeydown)
  document.body.style.overflow = ''
})

const year = computed(() => new Date().getFullYear())
</script>

<template>
  <header class="navbar">
    <div class="nav-inner container">
      <router-link to="/" class="brand" @click="closeMenu" aria-label="ZBR Standards — início">
        <img src="../assets/imgs/logo-zbr.png" alt="" class="nav-logo" width="32" height="24" />
        <span class="brand-name">zbr<span class="brand-thin">/standards</span></span>
      </router-link>

      <nav class="nav-links" aria-label="Navegação principal">
        <router-link to="/" class="nav-link">Início</router-link>
        <router-link to="/playground" class="nav-link">Playground</router-link>
        <router-link to="/integracoes" class="nav-link">Integrações</router-link>

        <span class="nav-divider" aria-hidden="true"></span>

        <a
          class="nav-link"
          href="https://github.com/Braian-de-Liz/br_standards_with_ZOD"
          target="_blank"
          rel="noopener noreferrer"
        >
          GitHub
        </a>
        <a
          class="nav-link"
          href="https://www.npmjs.com/package/br_standards_with_zod"
          target="_blank"
          rel="noopener noreferrer"
        >
          npm
        </a>
      </nav>

      <button
        class="hamburger"
        type="button"
        :aria-expanded="isMenuOpen"
        aria-controls="mobile-menu"
        :aria-label="isMenuOpen ? 'Fechar menu' : 'Abrir menu'"
        @click="toggleMenu"
      >
        <X v-if="isMenuOpen" :size="22" aria-hidden="true" />
        <Menu v-else :size="22" aria-hidden="true" />
      </button>
    </div>

    <Teleport to="body">
      <transition name="menu">
        <div v-if="isMenuOpen" id="mobile-menu" class="mobile-menu">
        <nav class="mobile-nav" aria-label="Navegação principal">
          <router-link to="/" class="mobile-link" @click="closeMenu">Início</router-link>
          <router-link to="/integracoes" class="mobile-link" @click="closeMenu">Integrações</router-link>
          <router-link to="/playground" class="mobile-link" @click="closeMenu">Playground</router-link>
        </nav>

        <div class="mobile-footer">
          <a
            href="https://github.com/Braian-de-Liz/br_standards_with_ZOD"
            target="_blank"
            rel="noopener noreferrer"
            class="mobile-social"
          >
            GitHub
          </a>
          <a
            href="https://www.npmjs.com/package/br_standards_with_zod"
            target="_blank"
            rel="noopener noreferrer"
            class="mobile-social"
          >
            npm
          </a>
        </div>

        <p class="mobile-copy">ZBR Standards © {{ year }} · MIT</p>
        </div>
      </transition>
    </Teleport>
  </header>
</template>

<style scoped>
.navbar {
  position: fixed;
  inset: 0 0 auto;
  width: 100%;
  height: var(--nav-height);
  background: var(--bg);
  border-bottom: 1px solid var(--border);
  z-index: 1000;
}

.nav-inner {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--space-6);
}

.brand {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  flex-shrink: 0;
}

.nav-logo {
  width: auto;
  height: 22px;
  object-fit: contain;
  display: block;
}

.brand-name {
  font-family: var(--font-mono);
  font-size: var(--text-sm);
  font-weight: 600;
  color: var(--text);
  white-space: nowrap;
}

.brand-thin {
  font-weight: 400;
  color: var(--text-faint);
}

.nav-links {
  display: flex;
  align-items: center;
  gap: var(--space-6);
}

.nav-link {
  position: relative;
  color: var(--text-muted);
  font-size: var(--text-sm);
  padding: 4px 0;
  transition: color var(--fast) var(--ease);
}

.nav-link:hover,
.nav-link.router-link-exact-active {
  color: var(--text);
}

.nav-link.router-link-exact-active::after {
  content: '';
  position: absolute;
  left: 0;
  right: 0;
  bottom: -1px;
  height: 1px;
  background: var(--accent);
}

.nav-divider {
  width: 1px;
  height: 16px;
  background: var(--border-strong);
}

.hamburger {
  display: none;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  padding: 0;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  background: transparent;
  color: var(--text);
  cursor: pointer;
}

.hamburger:hover {
  border-color: var(--border-strong);
}

.mobile-menu {
  position: fixed;
  inset: var(--nav-height) 0 0;
  height: calc(100dvh - var(--nav-height));
  background: var(--bg);
  display: flex;
  flex-direction: column;
  padding: var(--space-6) clamp(1rem, 4vw, 2rem) var(--space-8);
  z-index: 990;
  overflow-y: auto;
}

.mobile-nav {
  display: flex;
  flex-direction: column;
}

.mobile-link {
  padding: var(--space-4) 0;
  font-size: var(--text-xl);
  font-weight: 500;
  letter-spacing: -0.02em;
  color: var(--text-muted);
  border-bottom: 1px solid var(--border);
}

.mobile-link.router-link-exact-active {
  color: var(--accent);
}

.mobile-footer {
  margin-top: auto;
  padding-top: var(--space-8);
  display: flex;
  gap: var(--space-6);
}

.mobile-social {
  color: var(--text-muted);
  font-size: var(--text-sm);
}

.mobile-social:hover {
  color: var(--text);
}

.mobile-copy {
  margin-top: var(--space-6);
  color: var(--text-faint);
  font-family: var(--font-mono);
  font-size: var(--text-xs);
}

.menu-enter-active,
.menu-leave-active {
  transition: opacity var(--base) var(--ease);
}

.menu-enter-from,
.menu-leave-to {
  opacity: 0;
}

@media (max-width: 900px) {
  .nav-links {
    display: none;
  }

  .hamburger {
    display: inline-flex;
  }
}

@media (min-width: 901px) {
  .mobile-menu {
    display: none;
  }
}
</style>
