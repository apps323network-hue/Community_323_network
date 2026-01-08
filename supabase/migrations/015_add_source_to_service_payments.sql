-- ============================================
-- 015: Add source field to service_payments for American Dream integration
-- ============================================

-- Adicionar campo source para identificar origem do pagamento
ALTER TABLE public.service_payments
ADD COLUMN IF NOT EXISTS source VARCHAR(50) DEFAULT '323_network' CHECK (source IN ('323_network', 'american_dream'));

-- Adicionar campo para referência externa (payment_id do American Dream)
ALTER TABLE public.service_payments
ADD COLUMN IF NOT EXISTS external_payment_id VARCHAR(255);

-- Adicionar campo para lead_id do American Dream (opcional)
ALTER TABLE public.service_payments
ADD COLUMN IF NOT EXISTS external_lead_id UUID;

-- Comentários
COMMENT ON COLUMN public.service_payments.source IS 'Origem do pagamento: 323_network ou american_dream';
COMMENT ON COLUMN public.service_payments.external_payment_id IS 'ID do pagamento no sistema externo (American Dream)';
COMMENT ON COLUMN public.service_payments.external_lead_id IS 'ID do lead no American Dream (se aplicável)';

-- Índice para busca por source
CREATE INDEX IF NOT EXISTS idx_service_payments_source ON public.service_payments(source);
CREATE INDEX IF NOT EXISTS idx_service_payments_external_payment_id ON public.service_payments(external_payment_id);

