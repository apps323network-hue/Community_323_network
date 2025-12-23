-- Migration 002: Row Level Security (RLS) Policies
-- Configura políticas de segurança para todas as tabelas
-- Data: 2024

-- ============================================
-- HABILITAR RLS EM TODAS AS TABELAS
-- ============================================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.event_confirmations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.partners ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.service_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.benefits ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_benefits ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 1. PROFILES POLICIES
-- ============================================

-- SELECT: Público pode ver todos os perfis
CREATE POLICY "Profiles are viewable by everyone"
  ON public.profiles FOR SELECT
  USING (true);

-- INSERT: Apenas através do trigger (handle_new_user)
-- Não precisa de policy, já que é feito via trigger SECURITY DEFINER

-- UPDATE: Usuário só pode atualizar seu próprio perfil
CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- ============================================
-- 2. POSTS POLICIES
-- ============================================

-- SELECT: Todos podem ver posts públicos
CREATE POLICY "Posts are viewable by everyone"
  ON public.posts FOR SELECT
  USING (true);

-- INSERT: Usuários autenticados podem criar posts
CREATE POLICY "Authenticated users can create posts"
  ON public.posts FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- UPDATE: Apenas o autor do post
CREATE POLICY "Users can update own posts"
  ON public.posts FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- DELETE: Apenas o autor do post
CREATE POLICY "Users can delete own posts"
  ON public.posts FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- 3. POST LIKES POLICIES
-- ============================================

-- SELECT: Público
CREATE POLICY "Post likes are viewable by everyone"
  ON public.post_likes FOR SELECT
  USING (true);

-- INSERT: Usuários autenticados podem dar like
CREATE POLICY "Authenticated users can like posts"
  ON public.post_likes FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- DELETE: Usuário só pode remover seus próprios likes
CREATE POLICY "Users can delete own likes"
  ON public.post_likes FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- 4. POST COMMENTS POLICIES
-- ============================================

-- SELECT: Público
CREATE POLICY "Post comments are viewable by everyone"
  ON public.post_comments FOR SELECT
  USING (true);

-- INSERT: Usuários autenticados podem comentar
CREATE POLICY "Authenticated users can create comments"
  ON public.post_comments FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- UPDATE: Apenas o autor do comentário
CREATE POLICY "Users can update own comments"
  ON public.post_comments FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- DELETE: Apenas o autor do comentário
CREATE POLICY "Users can delete own comments"
  ON public.post_comments FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- 5. EVENTS POLICIES
-- ============================================

-- SELECT: Público
CREATE POLICY "Events are viewable by everyone"
  ON public.events FOR SELECT
  USING (true);

-- INSERT: Apenas admins ou usuários autenticados (para MVP, permitir autenticados)
CREATE POLICY "Authenticated users can create events"
  ON public.events FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- UPDATE: Apenas criador do evento ou admin (para MVP, apenas criador)
CREATE POLICY "Users can update own events"
  ON public.events FOR UPDATE
  USING (auth.uid() = created_by)
  WITH CHECK (auth.uid() = created_by);

-- DELETE: Apenas criador do evento
CREATE POLICY "Users can delete own events"
  ON public.events FOR DELETE
  USING (auth.uid() = created_by);

-- ============================================
-- 6. EVENT CONFIRMATIONS POLICIES
-- ============================================

-- SELECT: Público pode ver confirmações
CREATE POLICY "Event confirmations are viewable by everyone"
  ON public.event_confirmations FOR SELECT
  USING (true);

-- INSERT: Usuários autenticados podem confirmar presença
CREATE POLICY "Authenticated users can confirm events"
  ON public.event_confirmations FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- DELETE: Usuário pode cancelar sua própria confirmação
CREATE POLICY "Users can delete own confirmations"
  ON public.event_confirmations FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- 7. PARTNERS POLICIES
-- ============================================

-- SELECT: Público
CREATE POLICY "Partners are viewable by everyone"
  ON public.partners FOR SELECT
  USING (true);

-- INSERT/UPDATE: Apenas admins (para MVP, desabilitar - será feito manualmente)
-- CREATE POLICY "Only admins can manage partners"
--   ON public.partners FOR ALL
--   USING (auth.jwt() ->> 'role' = 'admin');

-- ============================================
-- 8. SERVICES POLICIES
-- ============================================

-- SELECT: Público
CREATE POLICY "Services are viewable by everyone"
  ON public.services FOR SELECT
  USING (true);

-- INSERT/UPDATE: Apenas admins (para MVP, desabilitar - será feito manualmente)
-- CREATE POLICY "Only admins can manage services"
--   ON public.services FOR ALL
--   USING (auth.jwt() ->> 'role' = 'admin');

-- ============================================
-- 9. SERVICE REQUESTS POLICIES
-- ============================================

-- SELECT: Usuário pode ver suas próprias solicitações
CREATE POLICY "Users can view own service requests"
  ON public.service_requests FOR SELECT
  USING (auth.uid() = user_id);

-- INSERT: Usuários autenticados podem solicitar serviços
CREATE POLICY "Authenticated users can request services"
  ON public.service_requests FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- UPDATE: Usuário pode atualizar suas próprias solicitações
CREATE POLICY "Users can update own service requests"
  ON public.service_requests FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ============================================
-- 10. BENEFITS POLICIES
-- ============================================

-- SELECT: Público
CREATE POLICY "Benefits are viewable by everyone"
  ON public.benefits FOR SELECT
  USING (true);

-- INSERT/UPDATE: Apenas admins (para MVP, desabilitar - será feito manualmente)
-- CREATE POLICY "Only admins can manage benefits"
--   ON public.benefits FOR ALL
--   USING (auth.jwt() ->> 'role' = 'admin');

-- ============================================
-- 11. USER BENEFITS POLICIES
-- ============================================

-- SELECT: Usuário pode ver seus próprios benefícios utilizados
CREATE POLICY "Users can view own benefits"
  ON public.user_benefits FOR SELECT
  USING (auth.uid() = user_id);

-- INSERT: Usuários autenticados podem utilizar benefícios
CREATE POLICY "Authenticated users can use benefits"
  ON public.user_benefits FOR INSERT
  WITH CHECK (auth.uid() = user_id);

