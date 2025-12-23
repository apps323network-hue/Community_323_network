-- Migration 003: Create Profile Trigger
-- Cria função e trigger para criar profile automaticamente quando novo usuário é criado
-- Data: 2024
-- NOTA: Esta migration precisa ser aplicada manualmente no Supabase Dashboard
-- ou através de SQL Editor com permissões de superuser
-- Alternativamente, pode ser configurada via Database > Functions no Dashboard

-- ============================================
-- FUNÇÃO PARA CRIAR PROFILE AUTOMATICAMENTE
-- ============================================
-- Esta função será criada no schema public e chamada via trigger
-- ou pode ser chamada manualmente no código após signup como fallback

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER 
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, nome, plano, badge)
  VALUES (
    NEW.id,
    COALESCE(
      NEW.raw_user_meta_data->>'nome',
      CASE 
        WHEN NEW.raw_user_meta_data->>'firstName' IS NOT NULL 
        THEN NEW.raw_user_meta_data->>'firstName' || ' ' || COALESCE(NEW.raw_user_meta_data->>'lastName', '')
        ELSE split_part(NEW.email, '@', 1)
      END
    ),
    'Free',
    'Free'
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- COMENTÁRIOS E INSTRUÇÕES
-- ============================================
-- Para aplicar o trigger, execute no SQL Editor do Supabase Dashboard:
-- 
-- CREATE TRIGGER on_auth_user_created
--   AFTER INSERT ON auth.users
--   FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
--
-- OU configure via Dashboard: Database > Database > Triggers

-- ============================================
-- COMENTÁRIOS
-- ============================================
COMMENT ON FUNCTION public.handle_new_user() IS 'Cria profile automaticamente quando novo usuário é criado em auth.users';
COMMENT ON TRIGGER on_auth_user_created ON auth.users IS 'Trigger que executa handle_new_user() após inserção de novo usuário';

