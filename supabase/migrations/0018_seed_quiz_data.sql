-- Seed quiz questions and options for all 9 lessons

-- ============================================================
-- PART 1: Foundation English (Lesson 1 - Basic Introductions)
-- ============================================================
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Foundation English' LIMIT 1)
INSERT INTO public.lesson_quizzes (lesson_id, question, position)
SELECT id, 'Someone says: "Nice to meet you." What is the best reply?', 1 FROM lesson
UNION ALL
SELECT id, 'Someone asks: "How are you today?" You feel fine. What do you say?', 2 FROM lesson
UNION ALL
SELECT id, 'You meet your new supervisor. What do you say first?', 3 FROM lesson
UNION ALL
SELECT id, 'You want to ask about the other person. What do you say?', 4 FROM lesson
UNION ALL
SELECT id, 'You are not feeling well but want to be honest. What do you say?', 5 FROM lesson;

-- Q1 options
WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'Someone says: "Nice to meet you." What is the best reply?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'I am tired', false, 1 FROM q
UNION ALL SELECT id, 'Nice to meet you too', true, 2 FROM q
UNION ALL SELECT id, 'I finished work', false, 3 FROM q
UNION ALL SELECT id, 'Goodbye', false, 4 FROM q;

-- Q2 options
WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'Someone asks: "How are you today?" You feel fine. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'I am okay.', true, 1 FROM q
UNION ALL SELECT id, 'I am late.', false, 2 FROM q
UNION ALL SELECT id, 'I am the manager.', false, 3 FROM q
UNION ALL SELECT id, 'I go home.', false, 4 FROM q;

-- Q3 options
WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'You meet your new supervisor. What do you say first?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'I am finished.', false, 1 FROM q
UNION ALL SELECT id, 'Hello, my name is Ravi.', true, 2 FROM q
UNION ALL SELECT id, 'I want break.', false, 3 FROM q
UNION ALL SELECT id, 'I am tired.', false, 4 FROM q;

-- Q4 options
WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'You want to ask about the other person. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'I am from India.', false, 1 FROM q
UNION ALL SELECT id, 'How about you?', true, 2 FROM q
UNION ALL SELECT id, 'I am new here.', false, 3 FROM q
UNION ALL SELECT id, 'Thank you.', false, 4 FROM q;

-- Q5 options
WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'You are not feeling well but want to be honest. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'I am not having a good day because I feel sick.', true, 1 FROM q
UNION ALL SELECT id, 'I feel horrible.', false, 2 FROM q
UNION ALL SELECT id, 'I am finished.', false, 3 FROM q
UNION ALL SELECT id, 'Goodbye.', false, 4 FROM q;

-- ============================================================
-- PART 1: Understanding Instructions & Responding
-- ============================================================
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Understanding Instructions & Responding' LIMIT 1)
INSERT INTO public.lesson_quizzes (lesson_id, question, position)
SELECT id, 'Your supervisor speaks too fast. What do you say?', 1 FROM lesson
UNION ALL
SELECT id, 'You did not hear the task clearly. What do you say?', 2 FROM lesson
UNION ALL
SELECT id, 'You completed the task. What do you say?', 3 FROM lesson
UNION ALL
SELECT id, 'You are still working. What do you say?', 4 FROM lesson
UNION ALL
SELECT id, 'You don''t understand how to use a machine. What do you say?', 5 FROM lesson;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'Your supervisor speaks too fast. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'Stop', false, 1 FROM q
UNION ALL SELECT id, 'Can you speak slowly please?', true, 2 FROM q
UNION ALL SELECT id, 'Wait, you are too fast', false, 3 FROM q
UNION ALL SELECT id, 'I don''t understand you', false, 4 FROM q;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'You did not hear the task clearly. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'Can you repeat, please?', true, 1 FROM q
UNION ALL SELECT id, 'Ok can', false, 2 FROM q
UNION ALL SELECT id, 'I got it', false, 3 FROM q
UNION ALL SELECT id, 'Thank you', false, 4 FROM q;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'You completed the task. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'Now what?', false, 1 FROM q
UNION ALL SELECT id, 'Yes, I have finished.', true, 2 FROM q
UNION ALL SELECT id, 'I am new', false, 3 FROM q
UNION ALL SELECT id, 'Done', false, 4 FROM q;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'You are still working. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'No, I am not done yet.', true, 1 FROM q
UNION ALL SELECT id, 'I am finished', false, 2 FROM q
UNION ALL SELECT id, 'This is too hard', false, 3 FROM q
UNION ALL SELECT id, 'I can''t do this', false, 4 FROM q;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'You don''t understand how to use a machine. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'I don''t understand. Can you show me?', true, 1 FROM q
UNION ALL SELECT id, 'I finished', false, 2 FROM q
UNION ALL SELECT id, 'It''s okay', false, 3 FROM q
UNION ALL SELECT id, 'I go home', false, 4 FROM q;

-- ============================================================
-- PART 1: Past, Present, Future at Work
-- ============================================================
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Past, Present, Future at Work' LIMIT 1)
INSERT INTO public.lesson_quizzes (lesson_id, question, position)
SELECT id, 'You already finished feeding. What do you say?', 1 FROM lesson
UNION ALL
SELECT id, 'You are working right now. What do you say?', 2 FROM lesson
UNION ALL
SELECT id, 'You plan to finish after lunch. What do you say?', 3 FROM lesson
UNION ALL
SELECT id, 'Your rider asks what you are doing. You are preparing tack now. What do you say?', 4 FROM lesson;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'You already finished feeding. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'I feed the horse', false, 1 FROM q
UNION ALL SELECT id, 'I am feeding', false, 2 FROM q
UNION ALL SELECT id, 'I fed the horses.', true, 3 FROM q
UNION ALL SELECT id, 'I will feed', false, 4 FROM q;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'You are working right now. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'I cleaned', false, 1 FROM q
UNION ALL SELECT id, 'I am cleaning now.', true, 2 FROM q
UNION ALL SELECT id, 'I will clean', false, 3 FROM q
UNION ALL SELECT id, 'I finished', false, 4 FROM q;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'You plan to finish after lunch. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'I finish', false, 1 FROM q
UNION ALL SELECT id, 'I finished', false, 2 FROM q
UNION ALL SELECT id, 'I will finish after lunch.', true, 3 FROM q
UNION ALL SELECT id, 'I finishing', false, 4 FROM q;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'Your rider asks what you are doing. You are preparing tack now. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'I prepared the tack', false, 1 FROM q
UNION ALL SELECT id, 'I will prepare', false, 2 FROM q
UNION ALL SELECT id, 'I am preparing the equipment.', true, 3 FROM q
UNION ALL SELECT id, 'I prepared yesterday', false, 4 FROM q;

-- ============================================================
-- PART 1: Should, Need To, Better To
-- ============================================================
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Should, Need To, Better To' LIMIT 1)
INSERT INTO public.lesson_quizzes (lesson_id, question, position)
SELECT id, 'Your manager says: "You should wear gloves." What does it mean?', 1 FROM lesson
UNION ALL
SELECT id, 'Your supervisor says: "You need to check the equipment." What does this mean?', 2 FROM lesson
UNION ALL
SELECT id, 'The rider says: "It''s better to ask if you are unsure." How do you reply?', 3 FROM lesson;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'Your manager says: "You should wear gloves." What does it mean?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'It is advice', true, 1 FROM q
UNION ALL SELECT id, 'It is salary', false, 2 FROM q
UNION ALL SELECT id, 'It is break time', false, 3 FROM q
UNION ALL SELECT id, 'It is overtime', false, 4 FROM q;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'Your supervisor says: "You need to check the equipment." What does this mean?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'It is optional', false, 1 FROM q
UNION ALL SELECT id, 'It is required', true, 2 FROM q
UNION ALL SELECT id, 'It is holiday', false, 3 FROM q
UNION ALL SELECT id, 'It is tomorrow', false, 4 FROM q;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'The rider says: "It''s better to ask if you are unsure." How do you reply?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'Okay, I will do it.', true, 1 FROM q
UNION ALL SELECT id, 'No', false, 2 FROM q
UNION ALL SELECT id, 'Goodbye', false, 3 FROM q
UNION ALL SELECT id, 'I go home', false, 4 FROM q;

-- ============================================================
-- PART 1: Reporting Lessons Clearly
-- ============================================================
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Reporting Lessons Clearly' LIMIT 1)
INSERT INTO public.lesson_quizzes (lesson_id, question, position)
SELECT id, 'The fence is broken. What do you say?', 1 FROM lesson
UNION ALL
SELECT id, 'You hurt your hand at work. What do you say?', 2 FROM lesson
UNION ALL
SELECT id, 'A machine is dangerous. What do you say?', 3 FROM lesson;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'The fence is broken. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'It is clean', false, 1 FROM q
UNION ALL SELECT id, 'This is broken.', true, 2 FROM q
UNION ALL SELECT id, 'I finished', false, 3 FROM q
UNION ALL SELECT id, 'It is ready', false, 4 FROM q;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'You hurt your hand at work. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'I am injured.', true, 1 FROM q
UNION ALL SELECT id, 'I am late', false, 2 FROM q
UNION ALL SELECT id, 'I am manager', false, 3 FROM q
UNION ALL SELECT id, 'I am okay', false, 4 FROM q;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'A machine is dangerous. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'This is unsafe.', true, 1 FROM q
UNION ALL SELECT id, 'It is good', false, 2 FROM q
UNION ALL SELECT id, 'It is finished', false, 3 FROM q
UNION ALL SELECT id, 'It is ready', false, 4 FROM q;

-- ============================================================
-- PART 2: Groom-to-rider Communication
-- ============================================================
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Groom-to-rider Communication' LIMIT 1)
INSERT INTO public.lesson_quizzes (lesson_id, question, position)
SELECT id, 'The rider asks you to prepare a horse but you are unsure which one. What do you ask?', 1 FROM lesson
UNION ALL
SELECT id, 'The rider asks if the horse is ready. You finished preparing. What do you say?', 2 FROM lesson;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'The rider asks you to prepare a horse but you are unsure which one. What do you ask?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'Which horse?', true, 1 FROM q
UNION ALL SELECT id, 'It is late', false, 2 FROM q
UNION ALL SELECT id, 'I am tired', false, 3 FROM q
UNION ALL SELECT id, 'I finished', false, 4 FROM q;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'The rider asks if the horse is ready. You finished preparing. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'The horse is ready.', true, 1 FROM q
UNION ALL SELECT id, 'No', false, 2 FROM q
UNION ALL SELECT id, 'I go home', false, 3 FROM q
UNION ALL SELECT id, 'I don''t know', false, 4 FROM q;

-- ============================================================
-- PART 2: Health & Safety for Horseriding
-- ============================================================
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Health & Safety for Horseriding' LIMIT 1)
INSERT INTO public.lesson_quizzes (lesson_id, question, position)
SELECT id, 'The horse is not eating. What do you say?', 1 FROM lesson
UNION ALL
SELECT id, 'The hoof looks injured. What do you say?', 2 FROM lesson
UNION ALL
SELECT id, 'The horse is bleeding. What do you say?', 3 FROM lesson;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'The horse is not eating. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'The horse is not eating.', true, 1 FROM q
UNION ALL SELECT id, 'The horse is running', false, 2 FROM q
UNION ALL SELECT id, 'The horse is clean', false, 3 FROM q
UNION ALL SELECT id, 'It is ready', false, 4 FROM q;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'The hoof looks injured. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'The hoof looks injured.', true, 1 FROM q
UNION ALL SELECT id, 'The saddle is ready', false, 2 FROM q
UNION ALL SELECT id, 'It is finished', false, 3 FROM q
UNION ALL SELECT id, 'It is safe', false, 4 FROM q;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'The horse is bleeding. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'The horse is sleeping', false, 1 FROM q
UNION ALL SELECT id, 'The horse is bleeding.', true, 2 FROM q
UNION ALL SELECT id, 'The horse is ready', false, 3 FROM q
UNION ALL SELECT id, 'It is fine', false, 4 FROM q;

-- ============================================================
-- PART 2: Respectful Communication
-- ============================================================
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Respectful Communication' LIMIT 1)
INSERT INTO public.lesson_quizzes (lesson_id, question, position)
SELECT id, 'You want to ask something politely. What do you say first?', 1 FROM lesson
UNION ALL
SELECT id, 'You feel something is unsafe. What do you say?', 2 FROM lesson;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'You want to ask something politely. What do you say first?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'Excuse me.', true, 1 FROM q
UNION ALL SELECT id, 'Hey', false, 2 FROM q
UNION ALL SELECT id, 'Listen', false, 3 FROM q
UNION ALL SELECT id, 'Hurry', false, 4 FROM q;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'You feel something is unsafe. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'I am not sure this is safe.', true, 1 FROM q
UNION ALL SELECT id, 'It is okay', false, 2 FROM q
UNION ALL SELECT id, 'It is fine', false, 3 FROM q
UNION ALL SELECT id, 'Goodbye', false, 4 FROM q;

-- ============================================================
-- PART 2: Daily Routine & Equipment
-- ============================================================
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Daily Routine & Equipment' LIMIT 1)
INSERT INTO public.lesson_quizzes (lesson_id, question, position)
SELECT id, 'You finished cleaning the stall. What do you say?', 1 FROM lesson
UNION ALL
SELECT id, 'The bridle is too tight. What do you say?', 2 FROM lesson;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'You finished cleaning the stall. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'The stall is clean.', true, 1 FROM q
UNION ALL SELECT id, 'The stall is late', false, 2 FROM q
UNION ALL SELECT id, 'The stall is broken', false, 3 FROM q
UNION ALL SELECT id, 'The stall is tired', false, 4 FROM q;

WITH q AS (SELECT id FROM public.lesson_quizzes WHERE question = 'The bridle is too tight. What do you say?' LIMIT 1)
INSERT INTO public.lesson_quiz_options (quiz_id, option_text, is_correct, position)
SELECT id, 'This bridle is too tight.', true, 1 FROM q
UNION ALL SELECT id, 'It is clean', false, 2 FROM q
UNION ALL SELECT id, 'It is ready', false, 3 FROM q
UNION ALL SELECT id, 'It is safe', false, 4 FROM q;
