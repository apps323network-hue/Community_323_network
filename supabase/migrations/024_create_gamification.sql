-- Migration 024: Create Gamification System
-- Cria tabelas e políticas RLS para sistema de gamificação (desafios e pontos)
-- Data: 2025-01-29

-- ============================================
-- CRIAR TABELA challenges
-- ============================================
CREATE TABLE IF NOT EXISTS public.challenges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome TEXT NOT NULL,
  descricao TEXT,
  tipo TEXT NOT NULL CHECK (tipo IN ('post', 'comment', 'event', 'connection', 'engagement', 'other')),
  pontos INTEGER NOT NULL DEFAULT 10 CHECK (pontos > 0),
  prazo TIMESTAMPTZ,
  ativo BOOLEAN NOT NULL DEFAULT true,
  created_by UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_challenges_tipo ON public.challenges(tipo);
CREATE INDEX IF NOT EXISTS idx_challenges_ativo ON public.challenges(ativo);
CREATE INDEX IF NOT EXISTS idx_challenges_created_at ON public.challenges(created_at);

-- Comentários
COMMENT ON TABLE public.challenges IS 'Tabela de desafios para gamificação';
COMMENT ON COLUMN public.challenges.nome IS 'Nome do desafio';
COMMENT ON COLUMN public.challenges.descricao IS 'Descrição detalhada do desafio';
COMMENT ON COLUMN public.challenges.tipo IS 'Tipo: post, comment, event, connection, engagement, other';
COMMENT ON COLUMN public.challenges.pontos IS 'Pontos que o usuário ganha ao completar';
COMMENT ON COLUMN public.challenges.prazo IS 'Data limite para completar o desafio (NULL = sem prazo)';
COMMENT ON COLUMN public.challenges.ativo IS 'Se o desafio está ativo e disponível para usuários';

-- ============================================
-- CRIAR TABELA user_challenges
-- ============================================
CREATE TABLE IF NOT EXISTS public.user_challenges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  challenge_id UUID NOT NULL REFERENCES public.challenges(id) ON DELETE CASCADE,
  progresso INTEGER DEFAULT 0 CHECK (progresso >= 0),
  completado BOOLEAN NOT NULL DEFAULT false,
  completado_em TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, challenge_id)
);

-- Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_user_challenges_user_id ON public.user_challenges(user_id);
CREATE INDEX IF NOT EXISTS idx_user_challenges_challenge_id ON public.user_challenges(challenge_id);
CREATE INDEX IF NOT EXISTS idx_user_challenges_completado ON public.user_challenges(completado);

-- Comentários
COMMENT ON TABLE public.user_challenges IS 'Progresso dos usuários nos desafios';
COMMENT ON COLUMN public.user_challenges.progresso IS 'Progresso atual (ex: 3 de 5 posts)';
COMMENT ON COLUMN public.user_challenges.completado IS 'Se o desafio foi completado';

-- ============================================
-- CRIAR TABELA user_points
-- ============================================
CREATE TABLE IF NOT EXISTS public.user_points (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  pontos INTEGER NOT NULL CHECK (pontos != 0),
  origem TEXT NOT NULL CHECK (origem IN ('challenge', 'post', 'comment', 'event', 'connection', 'manual', 'other')),
  origem_id UUID,
  descricao TEXT,
  created_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_user_points_user_id ON public.user_points(user_id);
CREATE INDEX IF NOT EXISTS idx_user_points_origem ON public.user_points(origem);
CREATE INDEX IF NOT EXISTS idx_user_points_created_at ON public.user_points(created_at);

-- Comentários
COMMENT ON TABLE public.user_points IS 'Histórico de pontos dos usuários';
COMMENT ON COLUMN public.user_points.pontos IS 'Quantidade de pontos (pode ser negativo para penalidades)';
COMMENT ON COLUMN public.user_points.origem IS 'Origem dos pontos: challenge, post, comment, event, connection, manual, other';
COMMENT ON COLUMN public.user_points.origem_id IS 'ID da origem (challenge_id, post_id, etc.)';
COMMENT ON COLUMN public.user_points.descricao IS 'Descrição do que gerou os pontos';
COMMENT ON COLUMN public.user_points.created_by IS 'Admin que adicionou pontos manualmente (se origem = manual)';

-- ============================================
-- ADICIONAR CAMPO total_points NA TABELA profiles
-- ============================================
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS total_points INTEGER DEFAULT 0 CHECK (total_points >= 0);

CREATE INDEX IF NOT EXISTS idx_profiles_total_points ON public.profiles(total_points);

COMMENT ON COLUMN public.profiles.total_points IS 'Total de pontos acumulados pelo usuário (atualizado via trigger)';

-- ============================================
-- FUNÇÃO PARA ATUALIZAR updated_at
-- ============================================
CREATE OR REPLACE FUNCTION public.update_challenges_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_challenges_updated_at
  BEFORE UPDATE ON public.challenges
  FOR EACH ROW
  EXECUTE FUNCTION public.update_challenges_updated_at();

CREATE OR REPLACE FUNCTION public.update_user_challenges_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_challenges_updated_at
  BEFORE UPDATE ON public.user_challenges
  FOR EACH ROW
  EXECUTE FUNCTION public.update_user_challenges_updated_at();

-- ============================================
-- FUNÇÃO PARA ATUALIZAR total_points AUTOMATICAMENTE
-- ============================================
CREATE OR REPLACE FUNCTION public.update_user_total_points()
RETURNS TRIGGER AS $$
BEGIN
  -- Atualizar total_points do usuário quando pontos são adicionados/removidos
  UPDATE public.profiles
  SET total_points = GREATEST(0, total_points + NEW.pontos)
  WHERE id = NEW.user_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_total_points_trigger
  AFTER INSERT ON public.user_points
  FOR EACH ROW
  EXECUTE FUNCTION public.update_user_total_points();

-- ============================================
-- HABILITAR RLS
-- ============================================
ALTER TABLE public.challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_points ENABLE ROW LEVEL SECURITY;

-- ============================================
-- POLÍTICAS RLS - challenges
-- ============================================

-- SELECT: Usuários podem ver desafios ativos, admins podem ver todos
CREATE POLICY "Users can view active challenges, admins can view all"
  ON public.challenges FOR SELECT
  TO authenticated
  USING (
    ativo = true OR
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- INSERT: Apenas admins podem criar desafios
CREATE POLICY "Only admins can create challenges"
  ON public.challenges FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- UPDATE: Apenas admins podem atualizar desafios
CREATE POLICY "Only admins can update challenges"
  ON public.challenges FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- DELETE: Apenas admins podem deletar desafios
CREATE POLICY "Only admins can delete challenges"
  ON public.challenges FOR DELETE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- ============================================
-- POLÍTICAS RLS - user_challenges
-- ============================================

-- SELECT: Usuários podem ver seus próprios desafios, admins podem ver todos
CREATE POLICY "Users can view their own challenges, admins can view all"
  ON public.user_challenges FOR SELECT
  TO authenticated
  USING (
    user_id = auth.uid() OR
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- INSERT: Usuários podem iniciar desafios, sistema pode criar automaticamente
CREATE POLICY "Users can start challenges, system can create automatically"
  ON public.user_challenges FOR INSERT
  TO authenticated
  WITH CHECK (
    user_id = auth.uid() OR
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- UPDATE: Usuários podem atualizar seu próprio progresso, admins podem atualizar qualquer
CREATE POLICY "Users can update own progress, admins can update any"
  ON public.user_challenges FOR UPDATE
  TO authenticated
  USING (
    user_id = auth.uid() OR
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  )
  WITH CHECK (
    user_id = auth.uid() OR
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- DELETE: Apenas admins podem deletar
CREATE POLICY "Only admins can delete user challenges"
  ON public.user_challenges FOR DELETE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- ============================================
-- POLÍTICAS RLS - user_points
-- ============================================

-- SELECT: Usuários podem ver seus próprios pontos, admins podem ver todos
CREATE POLICY "Users can view their own points, admins can view all"
  ON public.user_points FOR SELECT
  TO authenticated
  USING (
    user_id = auth.uid() OR
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- INSERT: Sistema pode criar automaticamente, admins podem adicionar manualmente
CREATE POLICY "System and admins can create points"
  ON public.user_points FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
    OR origem != 'manual' -- Sistema pode criar pontos automaticamente
  );

-- UPDATE/DELETE: Apenas admins
CREATE POLICY "Only admins can update or delete points"
  ON public.user_points FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "Only admins can delete points"
  ON public.user_points FOR DELETE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Comentários nas políticas
COMMENT ON POLICY "Users can view active challenges, admins can view all" ON public.challenges IS 
'Permite que usuários vejam desafios ativos e admins vejam todos';

COMMENT ON POLICY "Only admins can create challenges" ON public.challenges IS 
'Permite que apenas admins criem desafios';

COMMENT ON POLICY "Users can view their own challenges, admins can view all" ON public.user_challenges IS 
'Permite que usuários vejam seus próprios desafios e admins vejam todos';

COMMENT ON POLICY "Users can view their own points, admins can view all" ON public.user_points IS 
'Permite que usuários vejam seus próprios pontos e admins vejam todos';

