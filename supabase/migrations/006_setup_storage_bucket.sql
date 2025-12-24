-- Migration 006: Setup Storage Bucket for Post Images
-- Configura o bucket de storage para imagens de posts
-- Data: 2025

-- ============================================
-- CRIAR BUCKET post-images (se não existir)
-- ============================================
-- Nota: Buckets são criados via Storage API ou Dashboard
-- Este script apenas configura as políticas RLS

-- ============================================
-- POLÍTICAS RLS PARA O BUCKET post-images
-- ============================================

-- Política 1: Permitir INSERT (upload) para usuários autenticados
CREATE POLICY IF NOT EXISTS "Usuários autenticados podem fazer upload de imagens"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'post-images' AND
  (storage.foldername(name))[1] = 'posts'
);

-- Política 2: Permitir SELECT (leitura) para todos (público)
CREATE POLICY IF NOT EXISTS "Imagens de posts são públicas para leitura"
ON storage.objects
FOR SELECT
TO public
USING (
  bucket_id = 'post-images'
);

-- Política 3: Permitir DELETE apenas para o próprio usuário que fez upload
CREATE POLICY IF NOT EXISTS "Usuários podem deletar suas próprias imagens"
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'post-images' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- ============================================
-- COMENTÁRIOS
-- ============================================
COMMENT ON POLICY "Usuários autenticados podem fazer upload de imagens" ON storage.objects IS 
'Permite que usuários autenticados façam upload de imagens no bucket post-images';

COMMENT ON POLICY "Imagens de posts são públicas para leitura" ON storage.objects IS 
'Permite que qualquer pessoa visualize as imagens dos posts';

COMMENT ON POLICY "Usuários podem deletar suas próprias imagens" ON storage.objects IS 
'Permite que usuários deletem apenas as imagens que eles próprios fizeram upload';


