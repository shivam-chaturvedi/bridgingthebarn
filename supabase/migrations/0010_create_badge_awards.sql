-- Persist awarded badges so progress metrics can rebuild badge history later.
CREATE TABLE IF NOT EXISTS public.badge_awards (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE,
  badge_key text NOT NULL,
  awarded_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (profile_id, badge_key)
);

ALTER TABLE IF EXISTS public.badge_awards ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all badge awards access"
  ON public.badge_awards
  FOR ALL
  USING (true)
  WITH CHECK (true);
