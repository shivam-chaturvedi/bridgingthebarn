-- Enable row level security for the profiles table and allow
-- all authenticated or anonymous users to access it.
ALTER TABLE IF EXISTS public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY IF NOT EXISTS "Allow all profiles access"
  ON public.profiles
  FOR ALL
  USING (true)
  WITH CHECK (true);
