-- Remove duplicate progress rows so a unique constraint can be added.
WITH ranked AS (
  SELECT id
  FROM (
    SELECT
      id,
      ROW_NUMBER() OVER (PARTITION BY profile_id ORDER BY created_at ASC, id) AS rn
    FROM public.progress_metrics
  ) numbered
  WHERE numbered.rn > 1
)
DELETE FROM public.progress_metrics
WHERE id IN (SELECT id FROM ranked);

-- Ensure each profile_id can only ever have one progress row.
ALTER TABLE public.progress_metrics
ADD CONSTRAINT IF NOT EXISTS progress_metrics_profile_id_key UNIQUE (profile_id);
