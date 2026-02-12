-- Provide an RPC to record a daily goal interaction so the daily progress counter and updated_at fields stay accurate.
CREATE OR REPLACE FUNCTION public.increment_daily_goal(
  p_profile_id uuid,
  p_amount int DEFAULT 1
)
RETURNS public.progress_metrics
LANGUAGE plpgsql
AS $$
DECLARE
  current_row public.progress_metrics%ROWTYPE;
  next_progress int;
BEGIN
  SELECT *
  INTO current_row
  FROM public.progress_metrics
  WHERE profile_id = p_profile_id
  LIMIT 1
  FOR UPDATE;

  IF NOT FOUND THEN
    INSERT INTO public.progress_metrics (profile_id, daily_goal_progress, updated_at)
    VALUES (p_profile_id, LEAST(p_amount, 50), now())
    RETURNING * INTO current_row;
    RETURN current_row;
  END IF;

  next_progress := LEAST(
    current_row.daily_goal_progress + GREATEST(p_amount, 0),
    current_row.daily_goal_target
  );

  UPDATE public.progress_metrics
  SET daily_goal_progress = next_progress,
      updated_at = now()
  WHERE id = current_row.id
  RETURNING * INTO current_row;

  RETURN current_row;
END;
$$;
