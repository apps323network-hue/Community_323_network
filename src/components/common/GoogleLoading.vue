<template>
  <div class="fixed inset-0 z-[100] flex flex-col items-center justify-center bg-black/20 dark:bg-slate-900/40 backdrop-blur-md animate-fade-in">
    <div class="wrapper animate-scale-in">
      <div class="blue ball"></div>
      <div class="red ball"></div>
      <div class="yellow ball"></div>
      <div class="green ball"></div>
    </div>
  </div>
</template>

<script setup lang="ts">
// Componente simplificado para feedback visual elegante
</script>

<style scoped>
/* Base Animations */
.animate-fade-in {
  animation: fadeIn 0.4s ease-out forwards;
}

.animate-scale-in {
  animation: scaleIn 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes scaleIn {
  from { 
    opacity: 0;
    transform: scale(0.9);
  }
  to { 
    opacity: 1;
    transform: scale(1);
  }
}

/* From Uiverse.io by SteveBloX */ 
.wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 60px;
}

.ball {
  --size: 16px;
  width: var(--size);
  height: var(--size);
  border-radius: 50%;
  margin: 0 10px;
  animation: bounce 2s ease infinite;
}

.blue { background-color: #4285f5; }
.red { background-color: #ea4436; animation-delay: 0.25s; }
.yellow { background-color: #fbbd06; animation-delay: 0.5s; }
.green { background-color: #34a952; animation-delay: 0.75s; }

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(25px); }
}
</style>
