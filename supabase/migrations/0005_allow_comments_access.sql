-- Allow the community comments table to be read and written by anyone.
ALTER TABLE IF EXISTS public.community_comments ENABLE ROW LEVEL SECURITY;
CREATE POLICY IF NOT EXISTS "Allow all community comments"
  ON public.community_comments
  FOR ALL
  USING (true)
  WITH CHECK (true);
