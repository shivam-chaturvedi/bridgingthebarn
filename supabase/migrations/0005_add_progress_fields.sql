-- Add extra tracking fields to progress_metrics for daily goals and lesson completion.
ALTER TABLE IF EXISTS public.progress_metrics
ADD COLUMN IF NOT EXISTS daily_goal_progress INT NOT NULL DEFAULT 0,
ADD COLUMN IF NOT EXISTS daily_goal_target INT NOT NULL DEFAULT 50,
ADD COLUMN IF NOT EXISTS lessons_completed INT NOT NULL DEFAULT 0;
