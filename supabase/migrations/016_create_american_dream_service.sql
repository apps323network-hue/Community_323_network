-- ============================================
-- 016: Create American Dream service
-- ============================================

-- Criar serviço "American Dream" se não existir
INSERT INTO public.services (id, nome, descricao, categoria, ativo, destaque)
VALUES (
  '00000000-0000-0000-0000-000000000001',
  'American Dream',
  'Programa American Dream - Consultoria e planejamento para realização do sonho americano',
  'mentoring',
  true,
  true
)
ON CONFLICT (id) DO NOTHING;

-- Se o ID acima já existir, tentar criar com nome único
DO $$
DECLARE
  service_exists BOOLEAN;
BEGIN
  SELECT EXISTS (
    SELECT 1 FROM public.services WHERE nome = 'American Dream'
  ) INTO service_exists;
  
  IF NOT service_exists THEN
    INSERT INTO public.services (nome, descricao, categoria, ativo, destaque)
    VALUES (
      'American Dream',
      'Programa American Dream - Consultoria e planejamento para realização do sonho americano',
      'mentoring',
      true,
      true
    );
  END IF;
END $$;

