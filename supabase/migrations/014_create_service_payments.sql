-- ============================================
-- 014: Create service_payments table
-- ============================================

CREATE TABLE IF NOT EXISTS public.service_payments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  service_request_id UUID REFERENCES public.service_requests(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  service_id UUID REFERENCES public.services(id) ON DELETE CASCADE NOT NULL,
  amount INTEGER NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'USD',
  payment_method VARCHAR(20),
  status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
  stripe_session_id VARCHAR(255),
  stripe_payment_intent_id VARCHAR(255),
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add comments
COMMENT ON TABLE public.service_payments IS 'Pagamentos de serviços via Stripe';
COMMENT ON COLUMN public.service_payments.amount IS 'Valor em centavos';
COMMENT ON COLUMN public.service_payments.status IS 'pending, completed, failed, refunded';

-- Enable RLS
ALTER TABLE public.service_payments ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own payments"
  ON public.service_payments FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own payments"
  ON public.service_payments FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Add payment_id to service_requests
ALTER TABLE public.service_requests
ADD COLUMN IF NOT EXISTS payment_id UUID REFERENCES public.service_payments(id) ON DELETE SET NULL;

-- Add payment_required flag
ALTER TABLE public.service_requests
ADD COLUMN IF NOT EXISTS payment_required BOOLEAN DEFAULT FALSE;

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_service_payments_user_id ON public.service_payments(user_id);
CREATE INDEX IF NOT EXISTS idx_service_payments_stripe_session ON public.service_payments(stripe_session_id);
CREATE INDEX IF NOT EXISTS idx_service_payments_status ON public.service_payments(status);
