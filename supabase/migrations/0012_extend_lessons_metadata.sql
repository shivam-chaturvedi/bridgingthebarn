-- Extend lessons with the supporting copy and structured content that the new lessons screen expects.
ALTER TABLE IF EXISTS public.lessons
ADD COLUMN IF NOT EXISTS goal text NOT NULL DEFAULT '',
ADD COLUMN IF NOT EXISTS tip text NOT NULL DEFAULT '',
ADD COLUMN IF NOT EXISTS reward_badge text NOT NULL DEFAULT '',
ADD COLUMN IF NOT EXISTS reward_certificate text NOT NULL DEFAULT '',
ADD COLUMN IF NOT EXISTS reward_coins int NOT NULL DEFAULT 0,
ADD COLUMN IF NOT EXISTS supported_languages jsonb NOT NULL DEFAULT '[]'::jsonb;

CREATE TABLE IF NOT EXISTS public.lesson_key_language (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id uuid REFERENCES public.lessons(id) ON DELETE CASCADE,
  phrase text NOT NULL,
  translations jsonb NOT NULL DEFAULT '{}'::jsonb,
  explanation text NOT NULL DEFAULT '',
  example text
);

CREATE TABLE IF NOT EXISTS public.lesson_practices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id uuid REFERENCES public.lessons(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text NOT NULL DEFAULT '',
  mode text NOT NULL DEFAULT 'matching'
);

CREATE TABLE IF NOT EXISTS public.lesson_scenarios (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id uuid REFERENCES public.lessons(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text NOT NULL DEFAULT '',
  question text NOT NULL DEFAULT ''
);

CREATE TABLE IF NOT EXISTS public.lesson_scenario_options (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  scenario_id uuid REFERENCES public.lesson_scenarios(id) ON DELETE CASCADE,
  option_text text NOT NULL
);

ALTER TABLE IF EXISTS public.lessons ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow all lessons access" ON public.lessons;
CREATE POLICY "Allow all lessons access" ON public.lessons FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE IF EXISTS public.lesson_key_language ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow all lesson key language access" ON public.lesson_key_language;
CREATE POLICY "Allow all lesson key language access"
  ON public.lesson_key_language FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE IF EXISTS public.lesson_practices ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow all lesson practices access" ON public.lesson_practices;
CREATE POLICY "Allow all lesson practices access"
  ON public.lesson_practices FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE IF EXISTS public.lesson_scenarios ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow all lesson scenarios access" ON public.lesson_scenarios;
CREATE POLICY "Allow all lesson scenarios access"
  ON public.lesson_scenarios FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE IF EXISTS public.lesson_scenario_options ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow all lesson scenario options access" ON public.lesson_scenario_options;
CREATE POLICY "Allow all lesson scenario options access"
  ON public.lesson_scenario_options FOR ALL USING (true) WITH CHECK (true);
