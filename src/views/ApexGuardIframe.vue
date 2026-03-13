<template>
  <div class="apex-guard-iframe-container">
    <iframe 
      :src="iframeUrl" 
      frameborder="0" 
      class="apex-guard-iframe"
      title="Asset Protection"
    ></iframe>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

// O Iframe aponta para o build estático isolado em /public/asset-protection-app
const iframeUrl = ref('/asset-protection-app/index.html')
console.log('[ApexGuard] Loading iframe from:', iframeUrl.value)
</script>

<style scoped>
.apex-guard-iframe-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  z-index: 9999;
  background: #000;
  border: none;
  overflow: hidden;
}

.apex-guard-iframe {
  width: 100%;
  height: 100%;
  border: none;
  display: block;
}
</style>
