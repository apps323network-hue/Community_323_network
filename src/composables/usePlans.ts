import { computed } from 'vue'
import { useUserStore } from '@/stores/user'
import { useAuthStore } from '@/stores/auth'
import type { PlanType, Plan } from '@/types/plans'
import { PLANS, hasPlanAccess, getPlanById } from '@/types/plans'

export function usePlans() {
  const userStore = useUserStore()
  const authStore = useAuthStore()

  const currentPlan = computed<PlanType>(() => {
    if (!userStore.profile?.plano) return 'Free'
    const plan = userStore.profile.plano as string
    return (plan.charAt(0).toUpperCase() + plan.slice(1)) as PlanType
  })

  const planDetails = computed<Plan | null>(() => {
    return getPlanById(currentPlan.value)
  })

  const isFree = computed(() => currentPlan.value === 'Free')
  const isMember = computed(() => currentPlan.value === 'Member' || currentPlan.value === 'Premium')
  const isPremium = computed(() => currentPlan.value === 'Premium')

  function hasPlanAccessTo(requiredPlan: PlanType): boolean {
    if (!authStore.user) return false
    return hasPlanAccess(currentPlan.value, requiredPlan)
  }

  function canAccessFeature(feature: string): boolean {
    // Lógica para verificar acesso a features específicas
    // Por enquanto, retorna baseado no plano
    if (feature === 'premium_benefits') {
      return isPremium.value
    }
    if (feature === 'member_benefits') {
      return isMember.value
    }
    return true // Free tem acesso básico
  }

  function upgradeTo(plan: PlanType) {
    // Esta função será implementada quando integrar com sistema de pagamento
    console.log(`Upgrade to ${plan} - Payment integration pending`)
  }

  return {
    currentPlan,
    planDetails,
    isFree,
    isMember,
    isPremium,
    hasPlanAccessTo,
    canAccessFeature,
    upgradeTo,
    PLANS,
  }
}

