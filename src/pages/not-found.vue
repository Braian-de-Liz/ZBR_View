<script setup lang="ts">
</script>

<template>
  <div class="page">
    <div class="container content">
      <p class="code" aria-hidden="true">404</p>
      <h1>Página não encontrada</h1>
      <p class="lead">
        O endereço que você tentou abrir não existe ou foi movido.
      </p>
      <router-link to="/" class="btn">
        Voltar ao início →
      </router-link>
    </div>
  </div>
</template>

<style scoped>
.page {
  width: 100%;
  padding: calc(var(--nav-height) + clamp(4rem, 12vw, 8rem)) 0 var(--space-16);
}

.code {
  font-family: var(--font-mono);
  font-size: var(--text-sm);
  color: var(--accent);
}

h1 {
  margin-top: var(--space-4);
  font-size: clamp(2rem, 6vw, 3rem);
  font-weight: 500;
  letter-spacing: -0.04em;
}

.lead {
  max-width: 420px;
  margin-top: var(--space-4);
  color: var(--text-muted);
}

.btn {
  display: inline-block;
  margin-top: var(--space-8);
  color: var(--accent);
  font-size: var(--text-sm);
  text-decoration: underline;
  text-decoration-color: var(--accent-line);
  text-underline-offset: 4px;
}

.btn:hover {
  text-decoration-color: var(--accent);
}
</style>
