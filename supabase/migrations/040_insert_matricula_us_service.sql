-- Migration 040: Insert Matrícula US as external service with SSO
-- Insere o serviço Matrícula US na tabela services com configuração SSO
-- Data: 2026-01-02

-- ============================================
-- INSERIR SERVIÇO MATRÍCULA US
-- ============================================
-- Nota: Este serviço será exibido na página de serviços do 323 Network
-- Quando o usuário clicar, será redirecionado para o Matrícula US com SSO

-- Verificar se serviço já existe antes de inserir
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.services WHERE nome = 'Matrícula US' AND is_external = true) THEN
    INSERT INTO public.services (
      nome,
      descricao,
      categoria,
      beneficio_membro,
      destaque,
      ativo,
      is_external,
      external_url,
      sso_enabled,
      sso_callback_path
    ) VALUES (
      'Matrícula US',
      'Plataforma completa para busca e aplicação de bolsas de estudo em universidades dos Estados Unidos. Acesse milhares de oportunidades de bolsas e simplifique seu processo de matrícula.',
      'mentoring',
      'Acesso exclusivo à plataforma Matrícula US com SSO integrado',
      true,  -- Destaque
      true,  -- Ativo
      true,  -- Serviço externo
      'https://matriculausa.com',  -- URL do Matrícula US (ajustar se necessário)
      true,  -- SSO habilitado
      '/auth/callback'  -- Caminho de callback no Matrícula US
    );
  ELSE
    -- Atualizar serviço existente se já existir
    UPDATE public.services
    SET
      descricao = 'Plataforma completa para busca e aplicação de bolsas de estudo em universidades dos Estados Unidos. Acesse milhares de oportunidades de bolsas e simplifique seu processo de matrícula.',
      categoria = 'mentoring',
      beneficio_membro = 'Acesso exclusivo à plataforma Matrícula US com SSO integrado',
      destaque = true,
      ativo = true,
      is_external = true,
      external_url = 'https://matriculausa.com',
      sso_enabled = true,
      sso_callback_path = '/auth/callback',
      updated_at = NOW()
    WHERE nome = 'Matrícula US' AND is_external = true;
  END IF;
END $$;

-- ============================================
-- COMENTÁRIOS
-- ============================================
COMMENT ON TABLE public.services IS 'Serviços disponíveis na plataforma 323 Network. Serviços externos com SSO habilitado redirecionam usuários logados automaticamente.';

