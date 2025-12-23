-- Migration 004: Update Profile Trigger to include area_atuacao
-- Atualiza o trigger para salvar a área de atuação do user_metadata
-- Data: 2025

-- ============================================
-- ATUALIZAR FUNÇÃO handle_new_user
-- ============================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, nome, area_atuacao)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'nome', split_part(NEW.email, '@', 1)),
    NEW.raw_user_meta_data->>'role'
  )
  ON CONFLICT (id) DO UPDATE SET
    area_atuacao = COALESCE(EXCLUDED.area_atuacao, NEW.raw_user_meta_data->>'role'),
    nome = COALESCE(EXCLUDED.nome, COALESCE(NEW.raw_user_meta_data->>'nome', split_part(NEW.email, '@', 1)));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- COMENTÁRIOS
-- ============================================
COMMENT ON FUNCTION public.handle_new_user() IS 'Cria ou atualiza profile automaticamente quando novo usuário é criado em auth.users, incluindo area_atuacao do user_metadata';

