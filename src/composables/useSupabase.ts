import { supabase } from '@/lib/supabase'
import type { SupabaseClient } from '@supabase/supabase-js'

export function useSupabase(): { supabase: SupabaseClient } {
  return { supabase }
}

