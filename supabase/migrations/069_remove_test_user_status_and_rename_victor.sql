-- Migration 069: Remove test user status from specific users and rename victor admin
-- Remove status de test user de usuários específicos e renomeia "victor admin" para "Paulo Victor"

-- 1. Renomear "victor admin" para "Paulo Victor"
UPDATE public.profiles
SET nome = 'Paulo Victor'
WHERE nome = 'victor admin';

-- 2. Remover status de test user dos usuários especificados
-- Baseado nos nomes conhecidos (incluindo o renomeado "Paulo Victor")
UPDATE public.profiles
SET is_test_user = FALSE
WHERE nome IN ('Henrique Fiori', 'Guilherme Reis', 'Paulo Victor', 'Antônio Cruz Gomes')
   AND is_test_user = TRUE;

COMMENT ON COLUMN public.profiles.is_test_user IS 'Indica se o usuário é um usuário de teste. Usuários de teste não aparecem em produção.';
