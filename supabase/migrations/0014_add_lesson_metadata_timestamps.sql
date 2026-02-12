-- Add timestamps to lesson detail tables so we can order records without relying on generated columns.
ALTER TABLE IF EXISTS public.lesson_key_language
ADD COLUMN IF NOT EXISTS created_at timestamptz NOT NULL DEFAULT now();

ALTER TABLE IF EXISTS public.lesson_practices
ADD COLUMN IF NOT EXISTS created_at timestamptz NOT NULL DEFAULT now();

ALTER TABLE IF EXISTS public.lesson_scenarios
ADD COLUMN IF NOT EXISTS created_at timestamptz NOT NULL DEFAULT now();

ALTER TABLE IF EXISTS public.lesson_scenario_options
ADD COLUMN IF NOT EXISTS created_at timestamptz NOT NULL DEFAULT now();

ALTER TABLE IF EXISTS public.lesson_modules
ADD COLUMN IF NOT EXISTS created_at timestamptz NOT NULL DEFAULT now();
