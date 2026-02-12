-- Add position columns to lesson detail tables to control ordering explicitly.

ALTER TABLE IF EXISTS public.lesson_key_language
ADD COLUMN IF NOT EXISTS position int NOT NULL DEFAULT 0;

ALTER TABLE IF EXISTS public.lesson_practices
ADD COLUMN IF NOT EXISTS position int NOT NULL DEFAULT 0;

ALTER TABLE IF EXISTS public.lesson_scenarios
ADD COLUMN IF NOT EXISTS position int NOT NULL DEFAULT 0;

ALTER TABLE IF EXISTS public.lesson_scenario_options
ADD COLUMN IF NOT EXISTS position int NOT NULL DEFAULT 0;

ALTER TABLE IF EXISTS public.lesson_modules
ADD COLUMN IF NOT EXISTS position int NOT NULL DEFAULT 0;
