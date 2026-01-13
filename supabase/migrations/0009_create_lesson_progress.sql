-- Track each completed lesson/module for every profile.
CREATE TABLE IF NOT EXISTS public.lesson_progress (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE,
  lesson_id uuid REFERENCES public.lessons(id) ON DELETE CASCADE,
  module_id uuid REFERENCES public.lesson_modules(id) ON DELETE SET NULL,
  completed_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (profile_id, lesson_id, module_id)
);

ALTER TABLE IF EXISTS public.lesson_progress ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all lesson progress"
  ON public.lesson_progress
  FOR ALL
  USING (true)
  WITH CHECK (true);
