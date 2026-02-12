enum PracticeMode { matching, multipleChoice, record }

class KeyLanguageItem {
  const KeyLanguageItem({
    required this.phrase,
    required this.translations,
    required this.explanation,
    this.example,
  });

  final String phrase;
  final Map<String, String> translations;
  final String explanation;
  final String? example;
}

class MiniPracticeItem {
  const MiniPracticeItem({
    required this.title,
    required this.description,
    required this.mode,
  });

  final String title;
  final String description;
  final PracticeMode mode;
}

class ScenarioContent {
  const ScenarioContent({
    required this.title,
    required this.description,
    required this.question,
    required this.options,
  });

  final String title;
  final String description;
  final String question;
  final List<String> options;
}

class RewardContent {
  const RewardContent({
    required this.badge,
    required this.certificate,
    required this.coins,
  });

  final String badge;
  final String certificate;
  final int coins;
}

class LessonDetailContent {
  const LessonDetailContent({
    required this.goal,
    required this.keyLanguage,
    required this.practices,
    this.scenario,
    required this.tip,
    required this.reward,
    required this.supportedLanguages,
  });

  final String goal;
  final List<KeyLanguageItem> keyLanguage;
  final List<MiniPracticeItem> practices;
  final ScenarioContent? scenario;
  final String tip;
  final RewardContent reward;
  final List<String> supportedLanguages;
}

const defaultLanguageList = ['Malay', 'Tamil', 'Bengali', 'Tagalog'];

const lessonDetailsByTitle = {
  'Foundation English': LessonDetailContent(
    goal: 'Goal: Learn to report problems safely and clearly.',
    supportedLanguages: defaultLanguageList,
    keyLanguage: [
      KeyLanguageItem(
        phrase: 'I need help',
        translations: {
          'Malay': 'Saya perlukan bantuan',
          'Tamil': 'எனக்கு உதவி தேவை',
          'Bengali': 'আমাকে সাহায্য দরকার',
          'Tagalog': 'Kailangan ko ng tulong',
        },
        explanation: 'Use this to get immediate attention from supervisors.',
        example: '“I need help fixing the equipment.”',
      ),
      KeyLanguageItem(
        phrase: 'This area is unsafe',
        translations: {
          'Malay': 'Kawasan ini tidak selamat',
          'Tamil': 'இந்த பகுதி பாதுகாப்பாக இல்லை',
          'Bengali': 'এই এলাকা নিরাপদ নয়',
          'Tagalog': 'Hindi ligtas ang lugar na ito',
        },
        explanation: 'Point out hazards before anyone gets hurt.',
        example: 'During safety walk-throughs.',
      ),
    ],
    practices: [
      MiniPracticeItem(
        title: 'Match the meaning',
        description: 'Connect each phrase with the correct response or action.',
        mode: PracticeMode.matching,
      ),
      MiniPracticeItem(
        title: 'Choose the right phrase',
        description: 'Select the option that fits the safety scenario.',
        mode: PracticeMode.multipleChoice,
      ),
      MiniPracticeItem(
        title: 'Tap-play + Record',
        description:
            'Listen to the phrase, record yourself, and replay to compare pronunciation.',
        mode: PracticeMode.record,
      ),
    ],
    scenario: ScenarioContent(
      title: 'Scenario: Hazard in the barn',
      description:
          'You notice leaking hydraulic fluid near the grooming area.',
      question: 'What would you say to your supervisor?',
      options: [
        '“I need help, the floor is slippery.”',
        '“This area is unsafe, can we block it?”',
        '“I am okay, someone else can handle it.”',
      ],
    ),
    tip: 'Always report hazards immediately and describe exactly what you see.',
    reward: RewardContent(
      badge: 'Safety Scout',
      certificate: 'Hazard Reporter',
      coins: 15,
    ),
  ),
  'Horse Care English': LessonDetailContent(
    goal: 'Goal: Learn to talk about horse health, gear, and checkups.',
    supportedLanguages: defaultLanguageList,
    keyLanguage: [
      KeyLanguageItem(
        phrase: 'Let’s check the saddle',
        translations: {
          'Malay': 'Mari periksa pelana',
          'Tamil': 'சால்டில் சோதிக்கலாம்',
          'Bengali': 'চালান পরীক্ষা করি',
          'Tagalog': 'Suriin natin ang saddle',
        },
        explanation: 'Use when confirming equipment before mounting.',
        example: '“Let’s check the saddle before the lesson.”',
      ),
      KeyLanguageItem(
        phrase: 'How is the horse feeling today?',
        translations: {
          'Malay': 'Bagaimana kuda rasa hari ini?',
          'Tamil': 'இன்று குதிரை எப்படி உணர்கிறாள்?',
          'Bengali': 'আজ ঘোড়াটি কেমন অনুভব করছে?',
          'Tagalog': 'Kumusta ang damdamin ng kabayo ngayon?',
        },
        explanation: 'Ask before riding to ensure the animal is calm.',
        example: '“How are you feeling today, boy?”',
      ),
    ],
    practices: [
      MiniPracticeItem(
        title: 'Matching the tools',
        description: 'Match tack items to their purpose.',
        mode: PracticeMode.matching,
      ),
      MiniPracticeItem(
        title: 'Scenario-based multiple choice',
        description: 'Pick the phrase that helps when the horse is anxious.',
        mode: PracticeMode.multipleChoice,
      ),
      MiniPracticeItem(
        title: 'Record the check-in',
        description:
            'Listen to the prompt, record your full sentence, then listen again.',
        mode: PracticeMode.record,
      ),
    ],
    scenario: ScenarioContent(
      title: 'Scenario: Morning grooming',
      description:
          'The horse seems restless before the lesson and shakes its head.',
      question: 'What would you say to calm it?',
      options: [
        '“Take a deep breath, buddy.”',
        '“Let’s walk slowly for five minutes.”',
        '“This is how we always do it.”',
      ],
    ),
    tip: 'Always explain each check before you do it so riders feel safe.',
    reward: RewardContent(
      badge: 'Gear Guardian',
      certificate: 'Equipment Pro',
      coins: 20,
    ),
  ),
  'Safety & Your Rights': LessonDetailContent(
    goal: 'Goal: Know how to speak up about rights and the law.',
    supportedLanguages: defaultLanguageList,
    keyLanguage: [
      KeyLanguageItem(
        phrase: 'I want to make a complaint',
        translations: {
          'Malay': 'Saya mahu membuat aduan',
          'Tamil': 'நான் புகார் செய்ய விரும்புகிறேன்',
          'Bengali': 'আমি অভিযোগ করতে চাই',
          'Tagalog': 'Gusto kong magsampa ng reklamo',
        },
        explanation: 'State this when a situation feels unfair.',
        example: '“I want to make a complaint about overtime pay.”',
      ),
      KeyLanguageItem(
        phrase: 'Can you explain slowly?',
        translations: {
          'Malay': 'Bolehkah anda jelaskan perlahan-lahan?',
          'Tamil': 'நீங்கள் மெதுவாக விளக்க முடியுமா?',
          'Bengali': 'আপনি কি ধীরে ধীরে ব্যাখ্যা করতে পারেন?',
          'Tagalog': 'Pwede mo bang ipaliwanag nang mabagal?',
        },
        explanation: 'Ask for clarity when instructions are rushed.',
        example: '“Can you explain slowly, please?”',
      ),
    ],
    practices: [
      MiniPracticeItem(
        title: 'Match rights to actions',
        description: 'Connect rights statements with proper responses.',
        mode: PracticeMode.matching,
      ),
      MiniPracticeItem(
        title: 'Choose the safety phrase',
        description: 'Pick the phrase that protects your rights in each scene.',
        mode: PracticeMode.multipleChoice,
      ),
      MiniPracticeItem(
        title: 'Record your answer',
        description: 'Speak a full sentence about the issue you noticed.',
        mode: PracticeMode.record,
      ),
    ],
    scenario: ScenarioContent(
      title: 'Scenario: Unfair pay meeting',
      description:
          'Your paycheck feels incorrect and the manager avoids eye contact.',
      question: 'What would you say to report the problem?',
      options: [
        '“I think there is a mistake on my payslip.”',
        '“I do not want to cause trouble.”',
        '“Can I talk to someone who can help?”',
      ],
    ),
    tip: 'Remember: you can speak to a translator or supervisor for clarity.',
    reward: RewardContent(
      badge: 'Rights Champion',
      certificate: 'Fair Treatment Star',
      coins: 25,
    ),
  ),
};

const fallbackKeyLanguage = [
  KeyLanguageItem(
    phrase: 'Hello, my name is ___',
    translations: {
      'Malay': 'Hai, nama saya ___',
      'Tamil': 'வணக்கம், என் பெயர் ___',
      'Bengali': 'হ্যালো, আমার নাম ___',
      'Tagalog': 'Kumusta, ang pangalan ko ay ___',
    },
    explanation: 'Introduce yourself to teammates and supervisors.',
    example: '“Hello, my name is Priya.”',
  ),
  KeyLanguageItem(
    phrase: 'Can you repeat that, please?',
    translations: {
      'Malay': 'Bolehkah anda ulangi itu?',
      'Tamil': 'அதை மீண்டும் கூற முடியுமா?',
      'Bengali': 'এটি কি আবার বলবেন?',
      'Tagalog': 'Puwede mo bang ulitin iyon?',
    },
    explanation: 'Ask for repetition when the instruction was too fast.',
    example: '“Can you repeat that, please?”',
  ),
];

const fallbackPractices = [
  MiniPracticeItem(
    title: 'Matching phrases',
    description: 'Pair the correct meaning with each phrase.',
    mode: PracticeMode.matching,
  ),
  MiniPracticeItem(
    title: 'Multiple choice',
    description: 'Choose the phrase that matches the workplace scenario.',
    mode: PracticeMode.multipleChoice,
  ),
  MiniPracticeItem(
    title: 'Record & review',
    description:
        'Listen to the phrase and record your voice to compare pronunciation.',
    mode: PracticeMode.record,
  ),
];

const fallbackReward = RewardContent(
  badge: 'Lesson Explorer',
  certificate: 'Checkpoint Achiever',
  coins: 10,
);
