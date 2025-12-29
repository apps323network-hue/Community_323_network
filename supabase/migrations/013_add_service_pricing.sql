-- ============================================
-- 013: Add pricing fields to services
-- ============================================

-- Add price column (in cents, e.g., 9900 = $99.00)
ALTER TABLE public.services
ADD COLUMN IF NOT EXISTS preco INTEGER;

-- Add currency column
ALTER TABLE public.services
ADD COLUMN IF NOT EXISTS moeda TEXT DEFAULT 'USD' CHECK (moeda IN ('USD', 'BRL'));

-- Add comments
COMMENT ON COLUMN public.services.preco IS 'Preço do serviço em centavos (ex: 9900 = $99.00)';
COMMENT ON COLUMN public.services.moeda IS 'Moeda do preço: USD ou BRL';
