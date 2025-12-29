import { computed } from 'vue'
import { useAdminStore } from '@/stores/admin'
import { useUserStore } from '@/stores/user'
import type { EventApprovalAction } from '@/types/admin'
import type { EventStatus } from '@/types/events'

export function useAdmin() {
  const adminStore = useAdminStore()
  const userStore = useUserStore()

  const isAdmin = computed(() => {
    return userStore.profile?.role === 'admin'
  })

  const isPartner = computed(() => {
    return userStore.profile?.role === 'partner' || isAdmin.value
  })

  async function checkIsAdmin(): Promise<boolean> {
    return await adminStore.checkIsAdmin()
  }

  async function loadPendingEvents() {
    await adminStore.fetchPendingEvents()
  }

  async function loadAllEvents(statusFilter?: EventStatus) {
    await adminStore.fetchAllEvents(statusFilter)
  }

  async function approveEvent(eventId: string) {
    return await adminStore.approveEvent(eventId)
  }

  async function rejectEvent(eventId: string, reason?: string) {
    return await adminStore.rejectEvent(eventId, reason)
  }

  async function loadEventStats() {
    await adminStore.fetchEventStats()
  }

  async function handleApproval(action: EventApprovalAction) {
    return await adminStore.handleEventApproval(action)
  }

  async function createEvent(eventData: { titulo: string; descricao?: string; data_hora: string; tipo: string; local?: string; status?: EventStatus; image_url?: string; partner_id?: string }) {
    if (!adminStore.createEvent) {
      console.error('[useAdmin] createEvent não está disponível no store')
      throw new Error('Função createEvent não está disponível. Por favor, recarregue a página.')
    }
    return await adminStore.createEvent(eventData)
  }

  return {
    // State
    pendingEvents: computed(() => adminStore.pendingEvents),
    allEvents: computed(() => adminStore.allEvents),
    stats: computed(() => adminStore.stats),
    loading: computed(() => adminStore.loading),
    error: computed(() => adminStore.error),

    // Computed
    isAdmin,
    isPartner,

    // Methods
    checkIsAdmin,
    loadPendingEvents,
    loadAllEvents,
    approveEvent,
    rejectEvent,
    loadEventStats,
    handleApproval,
    createEvent,
  }
}




