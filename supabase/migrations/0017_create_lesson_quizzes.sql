-- Create lesson_quizzes table to store MCQ questions per lesson
CREATE TABLE IF NOT EXISTS public.lesson_quizzes (
  id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
  lesson_id uuid REFERENCES public.lessons(id) ON DELETE CASCADE,
  question text NOT NULL,
  position integer DEFAULT 0 NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

-- Create lesson_quiz_options table to store answer choices per question
CREATE TABLE IF NOT EXISTS public.lesson_quiz_options (
  id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
  quiz_id uuid REFERENCES public.lesson_quizzes(id) ON DELETE CASCADE,
  option_text text NOT NULL,
  is_correct boolean DEFAULT false NOT NULL,
  position integer DEFAULT 0 NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

-- Enable Row Level Security
ALTER TABLE public.lesson_quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lesson_quiz_options ENABLE ROW LEVEL SECURITY;

-- Allow public read access (same pattern as other lesson tables)
CREATE POLICY "Allow public read on lesson_quizzes"
  ON public.lesson_quizzes FOR SELECT USING (true);

CREATE POLICY "Allow public read on lesson_quiz_options"
  ON public.lesson_quiz_options FOR SELECT USING (true);
