-- Migration 020: Setup Storage Buckets for Event and Service Images
-- Configura os buckets de storage para imagens de eventos e serviços
-- Data: 2025-01-29

-- ============================================
-- POLÍTICAS RLS PARA O BUCKET event-images
-- ============================================

-- Política 1: Permitir INSERT (upload) para usuários autenticados
DROP POLICY IF EXISTS "Usuários autenticados podem fazer upload de imagens de eventos" ON storage.objects;
CREATE POLICY "Usuários autenticados podem fazer upload de imagens de eventos"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'event-images'
);

-- Política 2: Permitir SELECT (leitura) para todos (público)
DROP POLICY IF EXISTS "Imagens de eventos são públicas para leitura" ON storage.objects;
CREATE POLICY "Imagens de eventos são públicas para leitura"
ON storage.objects
FOR SELECT
TO public
USING (
  bucket_id = 'event-images'
);

-- Política 3: Permitir DELETE apenas para o próprio usuário que fez upload ou admins
DROP POLICY IF EXISTS "Usuários podem deletar suas próprias imagens de eventos" ON storage.objects;
CREATE POLICY "Usuários podem deletar suas próprias imagens de eventos"
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'event-images' AND
  (
    auth.uid() = owner
    OR
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
  )
);

-- ============================================
-- POLÍTICAS RLS PARA O BUCKET service-images
-- ============================================

-- Política 1: Permitir INSERT (upload) apenas para admins
DROP POLICY IF EXISTS "Admins podem fazer upload de imagens de serviços" ON storage.objects;
CREATE POLICY "Admins podem fazer upload de imagens de serviços"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'service-images' AND
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
);

-- Política 2: Permitir SELECT (leitura) para todos (público)
DROP POLICY IF EXISTS "Imagens de serviços são públicas para leitura" ON storage.objects;
CREATE POLICY "Imagens de serviços são públicas para leitura"
ON storage.objects
FOR SELECT
TO public
USING (
  bucket_id = 'service-images'
);

-- Política 3: Permitir DELETE apenas para admins
DROP POLICY IF EXISTS "Admins podem deletar imagens de serviços" ON storage.objects;
CREATE POLICY "Admins podem deletar imagens de serviços"
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'service-images' AND
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
);

-- ============================================
-- COMENTÁRIOS
-- ============================================
COMMENT ON POLICY "Usuários autenticados podem fazer upload de imagens de eventos" ON storage.objects IS 
'Permite que usuários autenticados façam upload de imagens no bucket event-images';

COMMENT ON POLICY "Imagens de eventos são públicas para leitura" ON storage.objects IS 
'Permite que qualquer pessoa visualize as imagens dos eventos';

COMMENT ON POLICY "Usuários podem deletar suas próprias imagens de eventos" ON storage.objects IS 
'Permite que usuários deletem apenas as imagens que eles próprios fizeram upload, ou admins podem deletar qualquer imagem';

COMMENT ON POLICY "Admins podem fazer upload de imagens de serviços" ON storage.objects IS 
'Permite que apenas admins façam upload de imagens no bucket service-images';

COMMENT ON POLICY "Imagens de serviços são públicas para leitura" ON storage.objects IS 
'Permite que qualquer pessoa visualize as imagens dos serviços';

COMMENT ON POLICY "Admins podem deletar imagens de serviços" ON storage.objects IS 
'Permite que apenas admins deletem imagens de serviços';

