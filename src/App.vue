<script setup lang="ts">
import Nav from './components/nav.vue'
import SiteFooter from './components/site-footer.vue'
</script>

<template>
  <Nav />

  <main class="app-main">
    <router-view v-slot="{ Component, route }">
      <transition name="page" mode="out-in">
        <component :is="Component" :key="route.path" />
      </transition>
    </router-view>
  </main>

  <SiteFooter />
</template>

<style>
.app-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  width: 100%;
}
</style>
