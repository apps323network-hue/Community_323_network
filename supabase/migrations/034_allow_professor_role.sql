-- Migration: Allow 'professor' role in profiles table
-- Fixes the check constraint that limits roles to 'user', 'partner', and 'admin'

ALTER TABLE public.profiles DROP CONSTRAINT IF EXISTS profiles_role_check;

ALTER TABLE public.profiles ADD CONSTRAINT profiles_role_check 
  CHECK (role IN ('user', 'partner', 'admin', 'professor'));

-- Update column comment
COMMENT ON COLUMN public.profiles.role IS 'Role do usuário: user, partner, admin, professor';
