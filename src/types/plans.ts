export type PlanType = 'Free' | 'Member' | 'Premium'

export interface Plan {
  id: PlanType
  name: string
  description: string
  features: string[]
  price?: number
  badge: string
}

export const PLANS: Record<PlanType, Plan> = {
  Free: {
    id: 'Free',
    name: 'Free',
    description: 'Acesso básico à comunidade',
    features: [
      'Acesso ao feed da comunidade',
      'Visualização de membros',
      'Participação em eventos públicos',
      'Perfil básico',
    ],
    badge: 'Free',
  },
  Member: {
    id: 'Member',
    name: 'Member',
    description: 'Acesso completo à comunidade',
    features: [
      'Tudo do plano Free',
      'Acesso a eventos exclusivos',
      'Benefícios mensais',
      'Atendimento prioritário',
      'Networking VIP',
    ],
    badge: 'Member',
  },
  Premium: {
    id: 'Premium',
    name: 'Premium',
    description: 'Acesso premium com todos os benefícios',
    features: [
      'Tudo do plano Member',
      'Acesso a todos os serviços',
      'Benefícios ilimitados',
      'Mentoria personalizada',
      'Eventos exclusivos premium',
      'Suporte 24/7',
    ],
    badge: 'Premium',
  },
}

export function getPlanById(id: string): Plan | null {
  return PLANS[id as PlanType] || null
}

export function getPlanHierarchy(): PlanType[] {
  return ['Free', 'Member', 'Premium']
}

export function hasPlanAccess(userPlan: PlanType, requiredPlan: PlanType): boolean {
  const hierarchy = getPlanHierarchy()
  const userIndex = hierarchy.indexOf(userPlan)
  const requiredIndex = hierarchy.indexOf(requiredPlan)
  return userIndex >= requiredIndex
}

