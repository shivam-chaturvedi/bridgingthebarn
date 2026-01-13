-- Keep progress-related tables open to simplify early testing.
ALTER TABLE IF EXISTS public.progress_metrics ENABLE ROW LEVEL SECURITY;
CREATE POLICY IF NOT EXISTS "Allow all progress access"
  ON public.progress_metrics
  FOR ALL
  USING (true)
  WITH CHECK (true);
