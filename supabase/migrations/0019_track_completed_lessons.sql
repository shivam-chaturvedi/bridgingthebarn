-- Create a table to track fully completed lessons
CREATE TABLE IF NOT EXISTS public.completed_lessons (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id uuid NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  lesson_id uuid NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  completed_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (profile_id, lesson_id)
);

ALTER TABLE public.completed_lessons ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own completed lessons"
  ON public.completed_lessons FOR SELECT
  USING (auth.uid() = profile_id);

CREATE POLICY "Users can insert own completed lessons"
  ON public.completed_lessons FOR INSERT
  WITH CHECK (auth.uid() = profile_id);

-- Function to check if a lesson is fully completed
CREATE OR REPLACE FUNCTION public.check_lesson_completion()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_total_modules int;
  v_completed_modules int;
BEGIN
  -- 1. Get total number of modules for this lesson
  SELECT count(*)
    INTO v_total_modules
    FROM public.lesson_modules
    WHERE lesson_id = NEW.lesson_id;

  -- 2. Get number of modules completed by this user for this lesson
  --    (We count the rows in lesson_progress for this profile & lesson)
  SELECT count(*)
    INTO v_completed_modules
    FROM public.lesson_progress
    WHERE profile_id = NEW.profile_id
      AND lesson_id = NEW.lesson_id;

  -- 3. If they match (and total > 0), insert into completed_lessons
  IF v_total_modules > 0 AND v_completed_modules >= v_total_modules THEN
    INSERT INTO public.completed_lessons (profile_id, lesson_id)
    VALUES (NEW.profile_id, NEW.lesson_id)
    ON CONFLICT (profile_id, lesson_id) DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$;

-- Trigger to run check_lesson_completion after every module progress update
DROP TRIGGER IF EXISTS tr_check_lesson_completion ON public.lesson_progress;
CREATE TRIGGER tr_check_lesson_completion
  AFTER INSERT OR UPDATE
  ON public.lesson_progress
  FOR EACH ROW
  EXECUTE FUNCTION public.check_lesson_completion();


-- Function to increment metrics.lessons_completed
CREATE OR REPLACE FUNCTION public.increment_progress_lessons()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Increment the counter in progress_metrics
  UPDATE public.progress_metrics
  SET lessons_completed = lessons_completed + 1,
      updated_at = now()
  WHERE profile_id = NEW.profile_id;

  -- If no row exists, we could insert one, but usually it exists by now.
  -- Alternatively, we can do an INSERT ... ON CONFLICT ...

  RETURN NEW;
END;
$$;

-- Trigger to run increment_progress_lessons when a new lesson is completed
DROP TRIGGER IF EXISTS tr_increment_progress_lessons ON public.completed_lessons;
CREATE TRIGGER tr_increment_progress_lessons
  AFTER INSERT
  ON public.completed_lessons
  FOR EACH ROW
  EXECUTE FUNCTION public.increment_progress_lessons();
