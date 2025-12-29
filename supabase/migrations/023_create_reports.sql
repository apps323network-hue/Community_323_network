-- Migration 023: Create Reports System
-- Cria tabela e políticas RLS para sistema de reports
-- Data: 2025-01-29

-- ============================================
-- CRIAR TABELA reports
-- ============================================
CREATE TABLE IF NOT EXISTS public.reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reported_by UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  reported_item_type TEXT NOT NULL CHECK (reported_item_type IN ('post', 'comment', 'user')),
  reported_item_id UUID NOT NULL,
  reason TEXT NOT NULL CHECK (reason IN ('spam', 'inappropriate', 'harassment', 'fake_news', 'other')),
  description TEXT,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'resolved', 'dismissed')),
  resolved_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  resolved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_reports_status ON public.reports(status);
CREATE INDEX IF NOT EXISTS idx_reports_item ON public.reports(reported_item_type, reported_item_id);
CREATE INDEX IF NOT EXISTS idx_reports_reported_by ON public.reports(reported_by);
CREATE INDEX IF NOT EXISTS idx_reports_created_at ON public.reports(created_at);
CREATE INDEX IF NOT EXISTS idx_reports_resolved_by ON public.reports(resolved_by);

-- Comentários
COMMENT ON TABLE public.reports IS 'Tabela de reports de conteúdo inapropriado';
COMMENT ON COLUMN public.reports.reported_by IS 'ID do usuário que fez o report';
COMMENT ON COLUMN public.reports.reported_item_type IS 'Tipo do item reportado: post, comment, user';
COMMENT ON COLUMN public.reports.reported_item_id IS 'ID do item reportado';
COMMENT ON COLUMN public.reports.reason IS 'Motivo do report: spam, inappropriate, harassment, fake_news, other';
COMMENT ON COLUMN public.reports.description IS 'Descrição opcional do report';
COMMENT ON COLUMN public.reports.status IS 'Status: pending, reviewed, resolved, dismissed';
COMMENT ON COLUMN public.reports.resolved_by IS 'ID do admin que resolveu o report';
COMMENT ON COLUMN public.reports.resolved_at IS 'Data/hora da resolução do report';

-- ============================================
-- FUNÇÃO PARA ATUALIZAR updated_at
-- ============================================
CREATE OR REPLACE FUNCTION public.update_reports_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_reports_updated_at
  BEFORE UPDATE ON public.reports
  FOR EACH ROW
  EXECUTE FUNCTION public.update_reports_updated_at();

-- ============================================
-- HABILITAR RLS
-- ============================================
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;

-- ============================================
-- POLÍTICAS RLS
-- ============================================

-- SELECT: Usuários podem ver apenas seus próprios reports, admins podem ver todos
CREATE POLICY "Users can view their own reports, admins can view all"
  ON public.reports FOR SELECT
  TO authenticated
  USING (
    reported_by = auth.uid() OR
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- INSERT: Usuários autenticados podem criar reports
CREATE POLICY "Authenticated users can create reports"
  ON public.reports FOR INSERT
  TO authenticated
  WITH CHECK (reported_by = auth.uid());

-- UPDATE: Apenas admins podem atualizar
CREATE POLICY "Only admins can update reports"
  ON public.reports FOR UPDATE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- DELETE: Apenas admins podem deletar
CREATE POLICY "Only admins can delete reports"
  ON public.reports FOR DELETE
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Comentários nas políticas
COMMENT ON POLICY "Users can view their own reports, admins can view all" ON public.reports IS 
'Permite que usuários vejam apenas seus próprios reports e admins vejam todos';

COMMENT ON POLICY "Authenticated users can create reports" ON public.reports IS 
'Permite que usuários autenticados criem reports';

COMMENT ON POLICY "Only admins can update reports" ON public.reports IS 
'Permite que apenas admins atualizem reports';

COMMENT ON POLICY "Only admins can delete reports" ON public.reports IS 
'Permite que apenas admins deletem reports';

