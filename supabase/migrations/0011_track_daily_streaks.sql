-- Track daily app opens so we can increment streaks inside the database.
ALTER TABLE IF EXISTS public.progress_metrics
ADD COLUMN IF NOT EXISTS last_open_date DATE;

CREATE OR REPLACE FUNCTION public.track_daily_open(
  p_profile_id uuid,
  p_today date
)
RETURNS SETOF public.progress_metrics
LANGUAGE plpgsql
AS $$
DECLARE
  current_row public.progress_metrics%ROWTYPE;
BEGIN
  SELECT *
  INTO current_row
  FROM public.progress_metrics
  WHERE profile_id = p_profile_id
  LIMIT 1
  FOR UPDATE;

  IF NOT FOUND THEN
    INSERT INTO public.progress_metrics (profile_id, streak, last_open_date, updated_at)
    VALUES (p_profile_id, 1, p_today, now())
    RETURNING * INTO current_row;
    RETURN NEXT current_row;
    RETURN;
  END IF;

  IF current_row.last_open_date = p_today THEN
    RETURN NEXT current_row;
    RETURN;
  ELSIF current_row.last_open_date = p_today - INTERVAL '1 day' THEN
    UPDATE public.progress_metrics
    SET streak = current_row.streak + 1,
        last_open_date = p_today,
        updated_at = now()
    WHERE id = current_row.id
    RETURNING * INTO current_row;
  ELSE
    UPDATE public.progress_metrics
    SET streak = 1,
        last_open_date = p_today,
        updated_at = now()
    WHERE id = current_row.id
    RETURNING * INTO current_row;
  END IF;

  RETURN NEXT current_row;
  RETURN;
END;
$$;
