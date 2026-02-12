-- Seed structured lesson data that supports the new lessons screen experience.
INSERT INTO public.lessons (title, summary, goal, tip, reward_badge, reward_certificate, reward_coins, supported_languages, position)
VALUES
  ('Foundation English', 'Build confidence introducing yourself and sharing basic information.', 'Goal: Introduce yourself, respond politely, and ask basic questions.', 'Speak slowly and it’s okay to ask someone to repeat.', 'Introduction Ace', 'Friendly Intro Certificate', 10, '["Malay","Tamil","Bengali","Tagalog"]'::jsonb, 1),
  ('Understanding Instructions & Responding', 'Clarify tasks and reply with confidence.', 'Goal: Understand instructions and respond clearly.', 'Ask for repetition if the instruction is too fast.', 'Instruction Receiver', 'Listening Certificate', 12, '["Malay","Tamil","Bengali","Tagalog"]'::jsonb, 2),
  ('Past, Present, Future at Work', 'Talk about what you did, are doing, and will do.', 'Goal: Explain past, present, and future actions at work.', 'Use simple verbs to describe tasks in the stable.', 'Time Teller', 'Timekeeping Certificate', 13, '["Malay","Tamil","Bengali","Tagalog"]'::jsonb, 3),
  ('Should, Need To, Better To', 'Understand advice and expectations from trainers.', 'Goal: Understand advice, instructions, and expectations.', 'Repeat instructions to confirm before acting.', 'Advice Expert', 'Guidance Certificate', 14, '["Malay","Tamil","Bengali","Tagalog"]'::jsonb, 4),
  ('Reporting Lessons Clearly', 'Report problems early and keep everyone safe.', 'Goal: Report problems early and safely.', 'Always report hazards immediately.', 'Safety Reporter', 'Hazard Certificate', 15, '["Malay","Tamil","Bengali","Tagalog"]'::jsonb, 5),
  ('Groom-to-rider Communication', 'Talk directly to riders and trainers before lessons.', 'Goal: Communicate clearly with riders and trainers.', 'Ask clarifying questions before the rider mounts.', 'Rider Liaison', 'Communication Certificate', 16, '["Malay","Tamil","Bengali","Tagalog"]'::jsonb, 6),
  ('Health & Safety for Horseriding', 'Spot horse problems and relay them quickly.', 'Goal: Identify horse problems and communicate them.', 'Report emergencies clearly, and don’t wait.', 'Safety Spotter', 'Horse Health Certificate', 18, '["Malay","Tamil","Bengali","Tagalog"]'::jsonb, 7),
  ('Respectful Communication', 'Keep conversations polite and professional.', 'Goal: Communicate politely and respectfully.', 'Say thank you and check for permissions.', 'Respect Ambassador', 'Politeness Certificate', 17, '["Malay","Tamil","Bengali","Tagalog"]'::jsonb, 8),
  ('Daily Routine & Equipment', 'Describe daily tasks and equipment status.', 'Goal: Use task-based phrases for stable work.', 'Always describe the condition of the equipment.', 'Routine Keeper', 'Task Master Certificate', 19, '["Malay","Tamil","Bengali","Tagalog"]'::jsonb, 9);

-- Foundation English key language items
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Foundation English' LIMIT 1)
INSERT INTO public.lesson_key_language (lesson_id, phrase, translations, explanation, example)
SELECT id, 'Hello, my name is ___', '{"Malay":"Hai, nama saya ___","Tamil":"வணக்கம், என் பெயர் ___","Bengali":"হ্যালো, আমার নাম ___","Tagalog":"Kumusta, ang pangalan ko ay ___"}'::jsonb, 'Use this to introduce yourself with confidence.', '“Hello, my name is Priya.”' FROM lesson
UNION ALL
SELECT id, 'I am from ___', '{"Malay":"Saya dari ___","Tamil":"நான் ___ என்கிறேன்","Bengali":"আমি ___ থেকে এসেছি","Tagalog":"Nanggaling ako sa ___"}'::jsonb, 'Tell others where you are from.', '“I am from Chennai.”' FROM lesson
UNION ALL
SELECT id, 'I have ___ (family/children)', '{"Malay":"Saya ada ___","Tamil":"எனக்கு ___ இருக்கிறது","Bengali":"আমার ___ আছে","Tagalog":"Mayroon akong ___"}'::jsonb, 'Share something about your family.', '“I have three children.”' FROM lesson
UNION ALL
SELECT id, 'How about you?', '{"Malay":"Bagaimana pula dengan awak?","Tamil":"நீங்கள் எப்படி?","Bengali":"আপনার কী অবস্থা?","Tagalog":"Kumusta ka naman?"}'::jsonb, 'Ask the listener about themselves.', '“How about you?”' FROM lesson
UNION ALL
SELECT id, 'Hello, how are you today?', '{"Malay":"Hai, apa khabar hari ini?","Tamil":"வணக்கம், நீங்கள் இன்று எப்படி?","Bengali":"হ্যালো, আপনি আজ কেমন আছেন?","Tagalog":"Kamusta ka ngayong araw?"}'::jsonb, 'Start a friendly greeting.', '“Hello, how are you today?”' FROM lesson
UNION ALL
SELECT id, 'How’s it going?', '{"Malay":"Bagaimana keadaan?","Tamil":"இது எப்படி இருக்கிறது?","Bengali":"কেমন চলছে?","Tagalog":"Kumusta na?"}'::jsonb, 'A casual way to check in.', '“How’s it going?”' FROM lesson
UNION ALL
SELECT id, 'Nice to meet you.', '{"Malay":"Senang bertemu anda","Tamil":"உங்களை சந்தித்ததில் சந்தோஷம்","Bengali":"আপনার সাথে পরিচিত হয়ে ভালো লাগলো","Tagalog":"Ikinagagalak kitang makilala"}'::jsonb, 'Say this when meeting someone new.', '“Nice to meet you.”' FROM lesson
UNION ALL
SELECT id, 'I am feeling good.', '{"Malay":"Saya rasa baik","Tamil":"நான் நன்றாக உணர்கிறேன்","Bengali":"আমি ভালো অনুভব করছি","Tagalog":"Masaya ako"}'::jsonb, 'Share a positive feeling.', '“I am feeling good.”' FROM lesson
UNION ALL
SELECT id, 'I am okay.', '{"Malay":"Saya okay","Tamil":"நான் நன்றாக இருக்கிறேன்","Bengali":"আমি ঠিক আছি","Tagalog":"Ayos lang ako"}'::jsonb, 'Answer when someone asks how you are.', '“I am okay.”' FROM lesson
UNION ALL
SELECT id, 'I am not having a good day because ___', '{"Malay":"Saya tidak sihat hari ini kerana ___","Tamil":"இன்று நான் நல்ல நாள் இல்லை ஏனெனில் ___","Bengali":"আজ আমি ভালো দিন কাটাচ্ছি না কারণ ___","Tagalog":"Hindi maganda ang araw ko dahil ___"}'::jsonb, 'Explain when you are not feeling well.', '“I am not having a good day because I missed the bus.”' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Foundation English' LIMIT 1)
INSERT INTO public.lesson_practices (lesson_id, title, description, mode)
SELECT id, 'Record your introduction', 'Record your introduction and listen back to match the pronunciation.', 'record' FROM lesson
UNION ALL
SELECT id, 'Match greetings to responses', 'Match greetings with the right response using multiple-choice buttons.', 'multiple_choice' FROM lesson
UNION ALL
SELECT id, 'Tap-to-play audio', 'Tap a phrase to hear the speaker and repeat it aloud.', 'matching' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Foundation English' LIMIT 1)
INSERT INTO public.lesson_scenarios (lesson_id, title, description, question)
SELECT id, 'Meeting the team', 'You meet a coworker for the first time.', 'What would you say to start the conversation?' FROM lesson;

WITH scenario AS (SELECT id FROM public.lesson_scenarios WHERE title = 'Meeting the team' LIMIT 1)
INSERT INTO public.lesson_scenario_options (scenario_id, option_text)
SELECT id, 'Hello, how are you today?' FROM scenario
UNION ALL
SELECT id, 'Please leave me alone.' FROM scenario
UNION ALL
SELECT id, 'I have no idea.' FROM scenario;

-- Understanding Instructions & Responding
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Understanding Instructions & Responding' LIMIT 1)
INSERT INTO public.lesson_key_language (lesson_id, phrase, translations, explanation, example)
SELECT id, 'Can you repeat, please?', '{"Malay":"Bolehkah anda ulangi, sila?","Tamil":"மீண்டும் சொல்ல முடியுமா?","Bengali":"আপনি কি আবার বলতে পারেন?","Tagalog":"Puwede mo bang ulitin?"}'::jsonb, 'Politely ask someone to repeat the instruction.', '“Can you repeat, please?”' FROM lesson
UNION ALL
SELECT id, 'Can you speak slowly?', '{"Malay":"Bolehkah anda bercakap perlahan?","Tamil":"மெதுவாக பேச முடியுமா?","Bengali":"আপনি কি ধীরে কথা বলতে পারেন?","Tagalog":"Pwede ka bang magsalita nang mabagal?"}'::jsonb, 'Ask for a slower pace to understand better.', '“Can you speak slowly?”' FROM lesson
UNION ALL
SELECT id, 'I don’t understand. Can you show me?', '{"Malay":"Saya tidak faham. Boleh tunjukkan?","Tamil":"எனக்கு புரியவில்லை. காட்ட முடியுமா?","Bengali":"আমি বুঝতে পারি না। আপনি কি দেখাতে পারেন?","Tagalog":"Hindi ko naintindihan. Puwede mo bang ipakita?"}'::jsonb, 'Request a visual demonstration.', '“I don’t understand. Can you show me?”' FROM lesson
UNION ALL
SELECT id, 'Yes, I have finished.', '{"Malay":"Ya, saya sudah selesai.","Tamil":"ஆம், நான் முடித்துவிட்டேன்.","Bengali":"হ্যাঁ, আমি শেষ করেছি।","Tagalog":"Oo, tapos na ako."}'::jsonb, 'Confirm when a task is complete.', '“Yes, I have finished.”' FROM lesson
UNION ALL
SELECT id, 'No, I am not done yet.', '{"Malay":"Tidak, saya belum selesai.","Tamil":"இல்லை, நான் இன்னும் முடியவில்லை.","Bengali":"না, আমি এখনও শেষ করিনি।","Tagalog":"Hindi pa ako tapos."}'::jsonb, 'Explain that you still need time.', '“No, I am not done yet.”' FROM lesson
UNION ALL
SELECT id, 'I don’t understand. Can you help me?', '{"Malay":"Saya tidak faham. Bolehkah anda membantu?","Tamil":"எனக்கு புரியவில்லை. உதவி செய்ய முடியுமா?","Bengali":"আমি বুঝতে পারছি না। আপনি কি সাহায্য করতে পারেন?","Tagalog":"Hindi ko maintindihan. Puwede mo ba akong tulungan?"}'::jsonb, 'Ask for assistance politely.', '“I don’t understand. Can you help me?”' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Understanding Instructions & Responding' LIMIT 1)
INSERT INTO public.lesson_practices (lesson_id, title, description, mode)
SELECT id, 'Tap-to-play comprehension', 'Listen to instructions and choose the correct response.', 'matching' FROM lesson
UNION ALL
SELECT id, 'Choose the correct response', 'Select the most appropriate phrase for each scenario.', 'multiple_choice' FROM lesson
UNION ALL
SELECT id, 'Record “Yes, I have finished.”', 'Record the completion phrase and compare to the sample.', 'record' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Understanding Instructions & Responding' LIMIT 1)
INSERT INTO public.lesson_scenarios (lesson_id, title, description, question)
SELECT id, 'Clarifying a task', 'Your supervisor gives quick steps without pauses.', 'Which request would you choose?' FROM lesson;

WITH scenario AS (SELECT id FROM public.lesson_scenarios WHERE title = 'Clarifying a task' LIMIT 1)
INSERT INTO public.lesson_scenario_options (scenario_id, option_text)
SELECT id, 'Can you repeat, please?' FROM scenario
UNION ALL
SELECT id, 'I already know it.' FROM scenario
UNION ALL
SELECT id, 'No, I cannot do it.' FROM scenario;

-- Past, Present, Future at Work
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Past, Present, Future at Work' LIMIT 1)
INSERT INTO public.lesson_key_language (lesson_id, phrase, translations, explanation, example)
SELECT id, 'I cleaned the stable.', '{"Malay":"Saya membersihkan kandang","Tamil":"நான் பகுதியைப் பிழைத்தேன்","Bengali":"আমি স্টেবল পরিছন্ন করেছি","Tagalog":"Nilinis ko ang istableng ito"}'::jsonb, 'Describe a past action in the stable.', '“I cleaned the stable yesterday.”' FROM lesson
UNION ALL
SELECT id, 'I fed the horses.', '{"Malay":"Saya memberi makan kuda","Tamil":"நான் குதிரைகளை ஊட்டினேன்","Bengali":"আমি ঘোড়াগুলোকে খাবার দিয়েছি","Tagalog":"Pinakain ko ang mga kabayo"}'::jsonb, 'Say what you already did.', '“I fed the horses this morning.”' FROM lesson
UNION ALL
SELECT id, 'I am cleaning now.', '{"Malay":"Saya sedang membersihkan","Tamil":"நான் இப்போது சுத்தம் செய்கிறேன்","Bengali":"আমি এখন পরিষ্কার করছি","Tagalog":"Kasalukuyan akong naglilinis"}'::jsonb, 'Share what you are doing right now.', '“I am cleaning now.”' FROM lesson
UNION ALL
SELECT id, 'I am preparing the equipment.', '{"Malay":"Saya sedang menyediakan peralatan","Tamil":"நான் உபகரணத்தை தயாரிக்கிறேன்","Bengali":"আমি সরঞ্জাম প্রস্তুত করছি","Tagalog":"Inihahanda ko ang kagamitan"}'::jsonb, 'Explain current preparations.', '“I am preparing the equipment.”' FROM lesson
UNION ALL
SELECT id, 'I will do it later.', '{"Malay":"Saya akan buat nanti","Tamil":"நான் பிறகு செய்வேன்","Bengali":"আমি পরে করব","Tagalog":"Gagawin ko ito mamaya"}'::jsonb, 'Talk about future plans.', '“I will do it later.”' FROM lesson
UNION ALL
SELECT id, 'I will finish after lunch.', '{"Malay":"Saya akan selesai selepas makan tengahari","Tamil":"நான் மதிய உணவுக்கு பின் முடிப்பேன்","Bengali":"আমি দুপুরের পরে শেষ করব","Tagalog":"Tatapusin ko pagkatapos ng tanghalian"}'::jsonb, 'Set expectations for when you will finish.', '“I will finish after lunch.”' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Past, Present, Future at Work' LIMIT 1)
INSERT INTO public.lesson_practices (lesson_id, title, description, mode)
SELECT id, 'Tense selection', 'Select the correct past, present, or future phrase for each scenario.', 'multiple_choice' FROM lesson
UNION ALL
SELECT id, 'Record daily tasks', 'Record what you did today and what you will do tomorrow.', 'record' FROM lesson
UNION ALL
SELECT id, 'Tap to listen', 'Listen to sample sentences for stable work.', 'matching' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Past, Present, Future at Work' LIMIT 1)
INSERT INTO public.lesson_scenarios (lesson_id, title, description, question)
SELECT id, 'Shift handover', 'You hand over to the next worker and describe completed tasks.', 'What would you say?' FROM lesson;

WITH scenario AS (SELECT id FROM public.lesson_scenarios WHERE title = 'Shift handover' LIMIT 1)
INSERT INTO public.lesson_scenario_options (scenario_id, option_text)
SELECT id, 'I cleaned the stable and fed the horses.' FROM scenario
UNION ALL
SELECT id, 'I will do nothing.' FROM scenario
UNION ALL
SELECT id, 'I will leave without telling anyone.' FROM scenario;

-- Should, Need To, Better To focus on advice
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Should, Need To, Better To' LIMIT 1)
INSERT INTO public.lesson_key_language (lesson_id, phrase, translations, explanation, example)
SELECT id, 'You should clean before riding.', '{"Malay":"Anda patut membersihkan sebelum menunggang","Tamil":"நீங்கள் சவாரி முன் சுத்தம் செய்ய வேண்டும்","Bengali":"আপনি সওয়ারির আগে পরিষ্কার করা উচিত","Tagalog":"Dapat mong linisin bago sumakay"}'::jsonb, 'Advice that something is recommended.', '“You should clean before riding.”' FROM lesson
UNION ALL
SELECT id, 'You need to check the equipment.', '{"Malay":"Anda perlu semak peralatan","Tamil":"நீங்கள் உபகரணத்தை சரிபார்க்க வேண்டும்","Bengali":"আপনাকে সরঞ্জাম পরীক্ষা করতে হবে","Tagalog":"Kailangan mong suriin ang kagamitan"}'::jsonb, 'Instructions that are required.', '“You need to check the equipment.”' FROM lesson
UNION ALL
SELECT id, 'It’s better to ask if you are unsure.', '{"Malay":"Lebih baik tanya jika anda tidak pasti","Tamil":"நீங்கள் உறுதியாக இல்லாவிட்டால் கேட்குவது நல்லது","Bengali":"আপনি নিশ্চিত না হলে জিজ্ঞাসা করাই ভালো","Tagalog":"Mas mabuting magtanong kung hindi ka sigurado"}'::jsonb, 'Encourage asking for clarity.', '“It’s better to ask if you are unsure.”' FROM lesson
UNION ALL
SELECT id, 'Okay, I will do it.', '{"Malay":"Baik, saya akan lakukan","Tamil":"சரி, நான் அதை செய்ய போகிறேன்","Bengali":"ঠিক আছে, আমি এটা করব","Tagalog":"Sige, gagawin ko ito"}'::jsonb, 'Confirm understanding.', '“Okay, I will do it.”' FROM lesson
UNION ALL
SELECT id, 'I understand.', '{"Malay":"Saya faham","Tamil":"புரிந்துகொண்டேன்","Bengali":"আমি বুঝেছি","Tagalog":"Naiintindihan ko"}'::jsonb, 'Acknowledge instructions.', '“I understand.”' FROM lesson
UNION ALL
SELECT id, 'Can you show me first?', '{"Malay":"Bolehkah anda tunjukkan dahulu?","Tamil":"முதலில் நீங்கள் காட்ட முடியுமா?","Bengali":"আপনি কি আগে দেখাতে পারেন?","Tagalog":"Puwede mo bang ipakita muna?"}'::jsonb, 'Ask for demonstration when uncertain.', '“Can you show me first?”' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Should, Need To, Better To' LIMIT 1)
INSERT INTO public.lesson_practices (lesson_id, title, description, mode)
SELECT id, 'Match advice to response', 'Match each instruction with an appropriate reply.', 'matching' FROM lesson
UNION ALL
SELECT id, 'Tap-to-play scenarios', 'Hear real-life examples and repeat them.', 'matching' FROM lesson
UNION ALL
SELECT id, 'Record your reply', 'Record a response and compare to the sample.', 'record' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Should, Need To, Better To' LIMIT 1)
INSERT INTO public.lesson_scenarios (lesson_id, title, description, question)
SELECT id, 'Following trainer instructions', 'The trainer tells you a sequence of tasks.', 'What would you say?' FROM lesson;

WITH scenario AS (SELECT id FROM public.lesson_scenarios WHERE title = 'Following trainer instructions' LIMIT 1)
INSERT INTO public.lesson_scenario_options (scenario_id, option_text)
SELECT id, 'Okay, I will do it.' FROM scenario
UNION ALL
SELECT id, 'No, I will not help.' FROM scenario
UNION ALL
SELECT id, 'I am not listening.' FROM scenario;

-- Reporting lessons clearly (hazard communication)
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Reporting Lessons Clearly' LIMIT 1)
INSERT INTO public.lesson_key_language (lesson_id, phrase, translations, explanation, example)
SELECT id, 'There is a problem with ___', '{"Malay":"Terdapat masalah dengan ___","Tamil":"___ பற்றி ஒரு பிரச்சனை இருக்கிறது","Bengali":"___ সম্পর্কে একটি সমস্যা আছে","Tagalog":"May problema sa ___"}'::jsonb, 'Report a generic problem.', '“There is a problem with the saddle.”' FROM lesson
UNION ALL
SELECT id, 'This is broken.', '{"Malay":"Ini rosak","Tamil":"இது உடைந்தது","Bengali":"এটি ভাঙা","Tagalog":"Sira ito"}'::jsonb, 'Point out damaged equipment.', '“This is broken.”' FROM lesson
UNION ALL
SELECT id, 'Something is not working.', '{"Malay":"Ada sesuatu yang tidak berfungsi","Tamil":"ஏதோ வேலை செய்யவில்லை","Bengali":"কোনও কিছু কাজ করছে না","Tagalog":"May hindi gumagana"}'::jsonb, 'Describe malfunctioning items.', '“Something is not working.”' FROM lesson
UNION ALL
SELECT id, 'I am injured.', '{"Malay":"Saya cedera","Tamil":"நான் காயமடைந்தேன்","Bengali":"আমি আহত","Tagalog":"Nasaktan ako"}'::jsonb, 'Report when you are hurt.', '“I am injured.”' FROM lesson
UNION ALL
SELECT id, 'I feel pain.', '{"Malay":"Saya rasa sakit","Tamil":"எனக்கு வலிக்கிறது","Bengali":"আমার ব্যথা হচ্ছে","Tagalog":"Masakit ako"}'::jsonb, 'Explain discomfort.', '“I feel pain.”' FROM lesson
UNION ALL
SELECT id, 'This is unsafe.', '{"Malay":"Ini tidak selamat","Tamil":"இது பாதுகாப்பற்றது","Bengali":"এটি নিরাপদ নয়","Tagalog":"Hindi ito ligtas"}'::jsonb, 'Warn about danger.', '“This is unsafe.”' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Reporting Lessons Clearly' LIMIT 1)
INSERT INTO public.lesson_practices (lesson_id, title, description, mode)
SELECT id, 'Scenario multiple choice', 'Choose the phrase that reports the correct hazard.', 'multiple_choice' FROM lesson
UNION ALL
SELECT id, 'Record reporting phrases', 'Practice recording the emergency sentence.', 'record' FROM lesson
UNION ALL
SELECT id, 'Tap-to-play warning', 'Hear how to say safety warnings clearly.', 'matching' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Reporting Lessons Clearly' LIMIT 1)
INSERT INTO public.lesson_scenarios (lesson_id, title, description, question)
SELECT id, 'Reporting a hazard', 'You see a broken gate and fluid on the floor.', 'What would you say to your supervisor?' FROM lesson;

WITH scenario AS (SELECT id FROM public.lesson_scenarios WHERE title = 'Reporting a hazard' LIMIT 1)
INSERT INTO public.lesson_scenario_options (scenario_id, option_text)
SELECT id, 'This is broken; it is unsafe to use.' FROM scenario
UNION ALL
SELECT id, 'Let it stay there.' FROM scenario
UNION ALL
SELECT id, 'I hope someone else sees this.' FROM scenario;

-- Job-specific: groom-to-rider communication
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Groom-to-rider Communication' LIMIT 1)
INSERT INTO public.lesson_key_language (lesson_id, phrase, translations, explanation, example)
SELECT id, 'Please prepare the horse.', '{"Malay":"Sila sediakan kuda","Tamil":"குதிரையை தயார் செய்க","Bengali":"অনুগ্রহ করে ঘোড়াটি প্রস্তুত করুন","Tagalog":"Pakihanda ang kabayo"}'::jsonb, 'Ask riders to ready the horse.', '“Please prepare the horse for riding.”' FROM lesson
UNION ALL
SELECT id, 'Is the horse ready?', '{"Malay":"Adakah kuda bersedia?","Tamil":"குதிரை தயாரா?","Bengali":"ঘোড়াটি প্রস্তুত?","Tagalog":"Handa na ba ang kabayo?"}'::jsonb, 'Check if the horse is ready.', '“Is the horse ready?”' FROM lesson
UNION ALL
SELECT id, 'Which horse?', '{"Malay":"Kuda yang mana?","Tamil":"யார் குதிரை?","Bengali":"কোন ঘোড়া?","Tagalog":"Aling kabayo?"}'::jsonb, 'Confirm the correct horse.', '“Which horse are we using?”' FROM lesson
UNION ALL
SELECT id, 'Now or later?', '{"Malay":"Sekarang atau kemudian?","Tamil":"இப்போது அல்லது பிறகு?","Bengali":"এখন না পরে?","Tagalog":"Ngayon o mamaya?"}'::jsonb, 'Choose timing for tasks.', '“Now or later?”' FROM lesson
UNION ALL
SELECT id, 'Before or after riding?', '{"Malay":"Sebelum atau selepas menunggang?","Tamil":"சவாரிக்குமுன் அல்லது பிறகு?","Bengali":"সওয়ারির আগে না পরে?","Tagalog":"Bago o pagkatapos sumakay?"}'::jsonb, 'Clarify sequence around riding.', '“Before or after riding?”' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Groom-to-rider Communication' LIMIT 1)
INSERT INTO public.lesson_practices (lesson_id, title, description, mode)
SELECT id, 'Tap to request', 'Tap-to-play request phrases and repeat them.', 'matching' FROM lesson
UNION ALL
SELECT id, 'Multiple choice responses', 'Choose the correct reply for rider questions.', 'multiple_choice' FROM lesson
UNION ALL
SELECT id, 'Record your request', 'Record yourself giving a request and listen back.', 'record' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Groom-to-rider Communication' LIMIT 1)
INSERT INTO public.lesson_scenarios (lesson_id, title, description, question)
SELECT id, 'Preparing the horse', 'Trainer asks if the horse is ready.', 'What would you say to confirm?' FROM lesson;

WITH scenario AS (SELECT id FROM public.lesson_scenarios WHERE title = 'Preparing the horse' LIMIT 1)
INSERT INTO public.lesson_scenario_options (scenario_id, option_text)
SELECT id, 'Is the horse ready?' FROM scenario
UNION ALL
SELECT id, 'I do not care.' FROM scenario
UNION ALL
SELECT id, 'Maybe later.' FROM scenario;

-- Job-specific: health & safety
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Health & Safety for Horseriding' LIMIT 1)
INSERT INTO public.lesson_key_language (lesson_id, phrase, translations, explanation, example)
SELECT id, 'The horse is not eating.', '{"Malay":"Kuda itu tidak makan","Tamil":"குதிரை சாப்பிடாமல் இருக்கிறது","Bengali":"ঘোড়াটি খান না","Tagalog":"Hindi kumakain ang kabayo"}'::jsonb, 'Report a horse that refuses food.', '“The horse is not eating.”' FROM lesson
UNION ALL
SELECT id, 'The hoof looks injured.', '{"Malay":"Buku lali kelihatan cedera","Tamil":"கால் காயமாக உள்ளது","Bengali":"খুরে আঘাত দেখাচ্ছে","Tagalog":"Mukhang sugatan ang kuko"}'::jsonb, 'Point out hoof injuries.', '“The hoof looks injured.”' FROM lesson
UNION ALL
SELECT id, 'The saddle does not fit.', '{"Malay":"Pelana tidak muat","Tamil":"அதிரை பொருந்தவில்லை","Bengali":"সাঁট ফিট হয় না","Tagalog":"Hindi bagay ang saddle"}'::jsonb, 'Explain equipment issues.', '“The saddle does not fit.”' FROM lesson
UNION ALL
SELECT id, 'The horse is bleeding.', '{"Malay":"Kuda sedang berdarah","Tamil":"குதிரை இரத்தம் விட்டது","Bengali":"ঘোড়াটি রক্তপাত করছে","Tagalog":"Dumudugo ang kabayo"}'::jsonb, 'Report serious injuries.', '“The horse is bleeding.”' FROM lesson
UNION ALL
SELECT id, 'We need help now.', '{"Malay":"Kami perlukan bantuan sekarang","Tamil":"நமக்கு உடனே உதவி வேண்டும்","Bengali":"আমাদের এখন সাহায্য চাই","Tagalog":"Kailangan namin ng tulong agad"}'::jsonb, 'Call for immediate assistance.', '“We need help now.”' FROM lesson
UNION ALL
SELECT id, 'Please call the vet.', '{"Malay":"Sila panggil doktor haiwan","Tamil":"தயவு செய்து கால்நடை மருத்துவரை அழைக்கவும்","Bengali":"দয়া করে পশু চিকিৎসককে ডাকুন","Tagalog":"Paki-tawagan ang beterinaryo"}'::jsonb, 'Ask someone to summon veterinary support.', '“Please call the vet.”' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Health & Safety for Horseriding' LIMIT 1)
INSERT INTO public.lesson_practices (lesson_id, title, description, mode)
SELECT id, 'Tap-to-play emergency phrases', 'Tap and repeat emergency calls.', 'matching' FROM lesson
UNION ALL
SELECT id, 'Match problems to phrases', 'Match the right phrase to each horse issue.', 'matching' FROM lesson
UNION ALL
SELECT id, 'Scenario selection', 'Choose the correct phrase for a given emergency.', 'multiple_choice' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Health & Safety for Horseriding' LIMIT 1)
INSERT INTO public.lesson_scenarios (lesson_id, title, description, question)
SELECT id, 'Alerting for injury', 'The horse is bleeding near the barn entrance.', 'What would you say?' FROM lesson;

WITH scenario AS (SELECT id FROM public.lesson_scenarios WHERE title = 'Alerting for injury' LIMIT 1)
INSERT INTO public.lesson_scenario_options (scenario_id, option_text)
SELECT id, 'We need help now. Please call the vet.' FROM scenario
UNION ALL
SELECT id, 'Let it stay there.' FROM scenario
UNION ALL
SELECT id, 'I am fine with it.' FROM scenario;

-- Job-specific: respectful communication
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Respectful Communication' LIMIT 1)
INSERT INTO public.lesson_key_language (lesson_id, phrase, translations, explanation, example)
SELECT id, 'Excuse me', '{"Malay":"Maafkan saya","Tamil":"மன்னிக்கவும்","Bengali":"ক্ষমা করবেন","Tagalog":"Paumanhin"}'::jsonb, 'Politely gain attention.', '“Excuse me, may I ask a question?”' FROM lesson
UNION ALL
SELECT id, 'May I ask a question?', '{"Malay":"Bolehkah saya tanya soalan?","Tamil":"நான் ஒரு கேள்வி கேட்டுக்கலாமா?","Bengali":"আমি কি একটি প্রশ্ন করতে পারি?","Tagalog":"Puwede ba kitang tanungin?"}'::jsonb, 'Request permission to speak.', '“May I ask a question?”' FROM lesson
UNION ALL
SELECT id, 'Thank you for explaining', '{"Malay":"Terima kasih kerana menerangkan","Tamil":"விளக்கத்திற்கு நன்றி","Bengali":"বুঝিয়ে দেওয়ার জন্য ধন্যবাদ","Tagalog":"Salamat sa pagpapaliwanag"}'::jsonb, 'Show appreciation.', '“Thank you for explaining.”' FROM lesson
UNION ALL
SELECT id, 'I am not sure this is safe.', '{"Malay":"Saya tidak pasti ini selamat","Tamil":"இது பாதுகாப்பானதா எனக்கு தெரியவில்லை","Bengali":"আমি নিশ্চিত না এটা নিরাপদ কিনা","Tagalog":"Hindi ako sigurado kung ligtas ito"}'::jsonb, 'Raise safety concerns politely.', '“I am not sure this is safe.”' FROM lesson
UNION ALL
SELECT id, 'Can we check first?', '{"Malay":"Bolehkah kita semak dulu?","Tamil":"முதலில் பரிசோதிக்கலாமா?","Bengali":"আমরা কি আগে পরীক্ষা করতে পারি?","Tagalog":"Puwede ba nating suriin muna?"}'::jsonb, 'Suggest verifying before acting.', '“Can we check first?”' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Respectful Communication' LIMIT 1)
INSERT INTO public.lesson_practices (lesson_id, title, description, mode)
SELECT id, 'Polite phrase playback', 'Tap-to-play polite phrases.', 'matching' FROM lesson
UNION ALL
SELECT id, 'Choose respectful reply', 'Select the best response to unsafe instructions.', 'multiple_choice' FROM lesson
UNION ALL
SELECT id, 'Record tone practice', 'Record your voice practicing respectful tone.', 'record' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Respectful Communication' LIMIT 1)
INSERT INTO public.lesson_scenarios (lesson_id, title, description, question)
SELECT id, 'Responding to unsafe instructions', 'Someone tells you to skip a safety check.', 'Which phrase keeps you respectful yet clear?' FROM lesson;

WITH scenario AS (SELECT id FROM public.lesson_scenarios WHERE title = 'Responding to unsafe instructions' LIMIT 1)
INSERT INTO public.lesson_scenario_options (scenario_id, option_text)
SELECT id, 'Thank you for explaining, may I check it first?' FROM scenario
UNION ALL
SELECT id, 'I do not care about safety.' FROM scenario
UNION ALL
SELECT id, 'No, I refuse to help.' FROM scenario;

-- Job-specific: daily routine & equipment
WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Daily Routine & Equipment' LIMIT 1)
INSERT INTO public.lesson_key_language (lesson_id, phrase, translations, explanation, example)
SELECT id, 'I will groom the horse now.', '{"Malay":"Saya akan menyikat kuda sekarang","Tamil":"நான் இப்போது குதிரையை மென்மையாக செய்வேன்","Bengali":"আমি এখন ঘোড়াটিকে গোছাব","Tagalog":"Lalabhan ko ang kabayo ngayon"}'::jsonb, 'Share immediate action.', '“I will groom the horse now.”' FROM lesson
UNION ALL
SELECT id, 'The stall is clean.', '{"Malay":"Kandang ini bersih","Tamil":"கட்டாரம் சுத்தம்","Bengali":"স্টলটি পরিষ্কার","Tagalog":"Malinis ang stall"}'::jsonb, 'Report the stall condition.', '“The stall is clean.”' FROM lesson
UNION ALL
SELECT id, 'Do you want me to tack up?', '{"Malay":"Adakah anda mahu saya pasang kelengkapan?","Tamil":"நீங்கள் என்னை உபகரணத்தை பொருத்த வேண்டும் என்று நினைக்கிறீர்களா?","Bengali":"আপনি কি চান আমি উপকরণ গুছিয়ে দিই?","Tagalog":"Gusto mo bang i-prepare ko ang tack?"}'::jsonb, 'Offer help with equipment.', '“Do you want me to tack up?”' FROM lesson
UNION ALL
SELECT id, 'The saddle is ready.', '{"Malay":"Pelana sudah siap","Tamil":"குதிரை தயார்","Bengali":"সেডল প্রস্তুত","Tagalog":"Handa na ang saddle"}'::jsonb, 'Confirm equipment readiness.', '“The saddle is ready.”' FROM lesson
UNION ALL
SELECT id, 'This bridle is too tight.', '{"Malay":"Tali kekang ini terlalu ketat","Tamil":"இந்த கட்டை மிக கருங்கி","Bengali":"এই ব্রাইডাল খুব টানাটানি","Tagalog":"Masikip ang bridle na ito"}'::jsonb, 'Point out discomfort.', '“This bridle is too tight.”' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Daily Routine & Equipment' LIMIT 1)
INSERT INTO public.lesson_practices (lesson_id, title, description, mode)
SELECT id, 'Scenario matching', 'Choose the correct phrase for each task action.', 'matching' FROM lesson
UNION ALL
SELECT id, 'Tap-to-play pronunciation', 'Tap the phrase to hear precise pronunciation.', 'matching' FROM lesson
UNION ALL
SELECT id, 'Record your task', 'Record a sentence describing your action.', 'record' FROM lesson;

WITH lesson AS (SELECT id FROM public.lessons WHERE title = 'Daily Routine & Equipment' LIMIT 1)
INSERT INTO public.lesson_scenarios (lesson_id, title, description, question)
SELECT id, 'Describing a daily task', 'You finish cleaning and must report to the trainer.', 'What would you say?' FROM lesson;

WITH scenario AS (SELECT id FROM public.lesson_scenarios WHERE title = 'Describing a daily task' LIMIT 1)
INSERT INTO public.lesson_scenario_options (scenario_id, option_text)
SELECT id, 'The stall is clean, and the horse has been fed.' FROM scenario
UNION ALL
SELECT id, 'I ignored it.' FROM scenario
UNION ALL
SELECT id, 'I will not tell the trainer.' FROM scenario;

-- Lesson modules so the lesson plans screen can show real content per lesson.
WITH foundation AS (SELECT id FROM public.lessons WHERE title = 'Foundation English' LIMIT 1)
INSERT INTO public.lesson_modules (lesson_id, title, content, position)
SELECT id, 'Lesson 1 - Basic Introductions', 'Introduce yourself, share where you are from, and ask friendly follow-up questions.', 1 FROM foundation
UNION ALL
SELECT id, 'Lesson 2 - Greetings & Responses', 'Practice greetings, how is it going, and honest responses about how you feel.', 2 FROM foundation;

WITH instructions AS (SELECT id FROM public.lessons WHERE title = 'Understanding Instructions & Responding' LIMIT 1)
INSERT INTO public.lesson_modules (lesson_id, title, content, position)
SELECT id, 'Lesson 1 - Listening for Instructions', 'Tap-to-play prompts and match them to instructions so you can follow directions confidently.', 1 FROM instructions
UNION ALL
SELECT id, 'Lesson 2 - Responding Clearly', 'Ask people to repeat, speak slowly, and confirm when you have finished.', 2 FROM instructions;

WITH tense AS (SELECT id FROM public.lessons WHERE title = 'Past, Present, Future at Work' LIMIT 1)
INSERT INTO public.lesson_modules (lesson_id, title, content, position)
SELECT id, 'Lesson 1 - Talking About the Past', 'Describe what you already did, such as cleaning the stable or feeding horses.', 1 FROM tense
UNION ALL
SELECT id, 'Lesson 2 - Planning the Future', 'Explain what you are doing now and what you will finish after lunch.', 2 FROM tense;

WITH advice AS (SELECT id FROM public.lessons WHERE title = 'Should, Need To, Better To' LIMIT 1)
INSERT INTO public.lesson_modules (lesson_id, title, content, position)
SELECT id, 'Lesson 1 - Advice & Expectations', 'Practice instructions that start with you should/need to/better to.', 1 FROM advice
UNION ALL
SELECT id, 'Lesson 2 - Confirming You Understand', 'Reply with “Okay, I will do it” and ask for demos when unsure.', 2 FROM advice;

WITH reporting AS (SELECT id FROM public.lessons WHERE title = 'Reporting Lessons Clearly' LIMIT 1)
INSERT INTO public.lesson_modules (lesson_id, title, content, position)
SELECT id, 'Lesson 1 - Hazard Reporting', 'Report broken equipment, missing tools, and unsafe areas clearly.', 1 FROM reporting
UNION ALL
SELECT id, 'Lesson 2 - Sharing Discomfort', 'Tell someone when you feel pain, are injured, or see something unsafe.', 2 FROM reporting;

WITH rider AS (SELECT id FROM public.lessons WHERE title = 'Groom-to-rider Communication' LIMIT 1)
INSERT INTO public.lesson_modules (lesson_id, title, content, position)
SELECT id, 'Lesson 1 - Rider Requests', 'Ask politely to prepare the horse and check which horse you are handling.', 1 FROM rider
UNION ALL
SELECT id, 'Lesson 2 - Timing & Clarification', 'Ask “now or later” and “before or after riding” to avoid confusion.', 2 FROM rider;

WITH horse_health AS (SELECT id FROM public.lessons WHERE title = 'Health & Safety for Horseriding' LIMIT 1)
INSERT INTO public.lesson_modules (lesson_id, title, content, position)
SELECT id, 'Lesson 1 - Spotting Problems', 'Use tap-to-play emergency phrases to describe injuries, bleeding, or discomfort.', 1 FROM horse_health
UNION ALL
SELECT id, 'Lesson 2 - Calling for Help', 'Match horse problems with the right phrase and ask others to contact the vet.', 2 FROM horse_health;

WITH respect AS (SELECT id FROM public.lessons WHERE title = 'Respectful Communication' LIMIT 1)
INSERT INTO public.lesson_modules (lesson_id, title, content, position)
SELECT id, 'Lesson 1 - Polite Openers', 'Say “Excuse me,” “May I ask?”, and “Thank you for explaining” smoothly.', 1 FROM respect
UNION ALL
SELECT id, 'Lesson 2 - Raising Concerns', 'Use polite but firm phrases when you are unsure something is safe.', 2 FROM respect;

WITH routine AS (SELECT id FROM public.lessons WHERE title = 'Daily Routine & Equipment' LIMIT 1)
INSERT INTO public.lesson_modules (lesson_id, title, content, position)
SELECT id, 'Lesson 1 - Task Updates', 'Tell your trainer the stall is clean, the horse has been fed, and what you finished.', 1 FROM routine
UNION ALL
SELECT id, 'Lesson 2 - Equipment Status', 'Report whether the saddle is ready, bridles are too tight, and gear needs adjustment.', 2 FROM routine;
