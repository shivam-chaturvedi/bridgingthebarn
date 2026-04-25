-- Weekly interview video uploads (metadata in Postgres + binary in Storage).

CREATE TABLE IF NOT EXISTS public.interviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text NOT NULL DEFAULT '',
  week_start date NOT NULL,
  youtube_url text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS interviews_profile_week_idx
  ON public.interviews (week_start DESC, created_at DESC);

ALTER TABLE IF EXISTS public.interviews ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'interviews'
      AND policyname = 'Allow all interviews access'
  ) THEN
    EXECUTE 'CREATE POLICY "Allow all interviews access"
      ON public.interviews
      FOR ALL
      USING (true)
      WITH CHECK (true);';
  END IF;
END
$$;
