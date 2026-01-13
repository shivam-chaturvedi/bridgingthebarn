-- Track which profiles have liked each community post so we can toggle safely.
CREATE TABLE IF NOT EXISTS public.community_post_likes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id uuid REFERENCES public.community_posts(id) ON DELETE CASCADE,
  profile_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (post_id, profile_id)
);

ALTER TABLE IF EXISTS public.community_post_likes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all community post likes access"
  ON public.community_post_likes
  FOR ALL
  USING (true)
  WITH CHECK (true);
