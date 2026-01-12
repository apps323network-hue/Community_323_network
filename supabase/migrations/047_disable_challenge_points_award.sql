-- Migration 047: Desativar ganho de pontos ao completar desafios
-- Esta migração desativa a atribuição automática de pontos quando um desafio é completado
-- Data: 2026-01-09
--
-- FUNCIONALIDADE DESATIVADA:
-- O ganho de pontos ao completar desafios foi desativado temporariamente.
-- Para reativar no futuro, remova ou comente o código abaixo que previne a inserção de pontos
-- quando origem = 'challenge' na tabela user_points.
--
-- LOCALIZAÇÃO:
-- - Arquivo: supabase/migrations/047_disable_challenge_points_award.sql
-- - Trigger: prevent_challenge_points_trigger
-- - Função: prevent_challenge_points_award()

-- ============================================
-- FUNÇÃO PARA PREVENIR ATRIBUIÇÃO DE PONTOS DE DESAFIOS
-- ============================================
-- Esta função impede que pontos sejam atribuídos quando origem = 'challenge'
-- Para reativar: DROP TRIGGER prevent_challenge_points_trigger ON public.user_points;
CREATE OR REPLACE FUNCTION public.prevent_challenge_points_award()
RETURNS TRIGGER AS $$
BEGIN
  -- DESATIVADO: Prevenir atribuição de pontos quando origem = 'challenge'
  -- Para reativar: Remova ou comente o bloco IF abaixo
  IF NEW.origem = 'challenge' THEN
    -- Retornar NULL cancela a inserção
    RETURN NULL;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- TRIGGER PARA PREVENIR PONTOS DE DESAFIOS
-- ============================================
-- Este trigger impede que pontos sejam atribuídos quando um desafio é completado
-- Para reativar: DROP TRIGGER prevent_challenge_points_trigger ON public.user_points;
DROP TRIGGER IF EXISTS prevent_challenge_points_trigger ON public.user_points;

CREATE TRIGGER prevent_challenge_points_trigger
  BEFORE INSERT ON public.user_points
  FOR EACH ROW
  EXECUTE FUNCTION public.prevent_challenge_points_award();

-- Comentário explicativo
COMMENT ON FUNCTION public.prevent_challenge_points_award() IS 
'FUNÇÃO DESATIVADA: Previne atribuição de pontos quando origem = challenge. Para reativar, remova o trigger prevent_challenge_points_trigger.';

COMMENT ON TRIGGER prevent_challenge_points_trigger ON public.user_points IS 
'TRIGGER DESATIVADO: Previne atribuição de pontos ao completar desafios. Para reativar, execute: DROP TRIGGER prevent_challenge_points_trigger ON public.user_points;';
