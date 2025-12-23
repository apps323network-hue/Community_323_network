-- Migration 005: Add image field to posts
-- Adiciona campo para armazenar URL da imagem do post
-- Data: 2025

-- ============================================
-- ADICIONAR CAMPO image_url NA TABELA posts
-- ============================================
ALTER TABLE public.posts 
ADD COLUMN IF NOT EXISTS image_url TEXT;

-- ============================================
-- COMENTÁRIOS
-- ============================================
COMMENT ON COLUMN public.posts.image_url IS 'URL da imagem anexada ao post (armazenada no Supabase Storage)';

