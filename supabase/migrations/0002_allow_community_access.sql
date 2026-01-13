-- Allow any session to read/write community data since the UI
-- gates access through auth placeholders.
ALTER TABLE IF EXISTS public.community_posts ENABLE ROW LEVEL SECURITY;
CREATE POLICY IF NOT EXISTS "Allow all community access"
  ON public.community_posts
  FOR ALL
  USING (true)
  WITH CHECK (true);
