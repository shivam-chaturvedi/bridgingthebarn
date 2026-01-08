import 'package:flutter/material.dart';

const quickPhrasesData = [
  {'label': 'Good morning', 'translation': 'காலை வணக்கம்'},
  {'label': 'The horse is ready', 'translation': 'குதிரை தயார்'},
  {'label': 'I need help', 'translation': 'எனக்கு உதவி தேவை'},
  {'label': 'Be careful', 'translation': 'கவனமாக இருங்கள்'},
  {'label': 'Salary', 'translation': 'சம்பளம்'},
  {'label': 'Safety &', 'translation': 'பாதுகாப்பு'},
  {'label': 'Accidents, Injury', 'translation': 'விபத்து'},
  {'label': 'Unfair Treatment', 'translation': 'நீதியற்ற'},
];

const winStoriesData = [
  {
    'name': 'Krishnan',
    'summary': 'Read first message to daughter in English',
    'time': '2 hours ago',
  },
  {
    'name': 'Arjun',
    'summary': 'Completed 10 daily lessons',
    'time': '5 hours ago',
  },
  {
    'name': 'Priya',
    'summary': 'Spoke first sentence with vet',
    'time': '1 day ago',
  },
];

const modulesData = [
  {
    'id': 'foundation',
    'title': 'Foundation English',
    'completed': '1/3 lessons completed',
    'progress': 0.33,
    'icon': Icons.school,
    'lessons': [
      {
        'title': 'Basic Introductions',
        'duration': '10 min',
        'status': 'complete',
      },
      {
        'title': 'Workplace Communication',
        'duration': '12 min',
        'status': 'in-progress',
        'progress': '75%',
      },
      {
        'title': 'Work Schedule & Time',
        'duration': '10 min',
        'status': 'upcoming',
      },
    ],
    'keyPhrases': [
      {
        'label': 'Hello, my name is ___',
        'translation': 'வணக்கம், என் பெயர் ___',
        'note': '→ Basic introduction',
      },
      {
        'label': 'I am from ___',
        'translation': 'நான் ___ இருந்து வந்தேன்',
        'note': '→ Telling where you’re from',
      },
    ],
  },
  {
    'id': 'horse',
    'title': 'Horse Care English',
    'completed': '0/3 lessons completed',
    'progress': 0.0,
    'icon': Icons.pets,
    'lessons': [
      {
        'title': 'Daily Grooming',
        'duration': '15 min',
        'status': 'complete',
        'progress': '50%',
      },
      {'title': 'Equipment & Tack', 'duration': '12 min', 'status': 'upcoming'},
      {
        'title': 'Horse Health & Safety',
        'duration': '15 min',
        'status': 'locked',
      },
    ],
    'keyPhrases': [
      {
        'label': 'How are you feeling today?',
        'translation': 'நீங்கள் இன்று எப்படி உணர்கிறீர்கள்?',
        'note': '→ Caring for the horse',
      },
      {
        'label': 'Let’s check the saddle',
        'translation': 'நாம் சோதிக்கலாம்',
        'note': '→ Tack care',
      },
    ],
  },
  {
    'id': 'safety',
    'title': 'Safety & Your Rights',
    'completed': '0/2 lessons completed',
    'progress': 0.0,
    'icon': Icons.shield,
    'lessons': [
      {'title': 'Know Your Rights', 'duration': '8 min', 'status': 'upcoming'},
      {
        'title': 'Emergency Response',
        'duration': '10 min',
        'status': 'upcoming',
      },
    ],
    'keyPhrases': [
      {
        'label': 'I need help',
        'translation': 'எனக்கு உதவி தேவை',
        'note': '→ Safety requests',
      },
      {
        'label': 'Please explain again',
        'translation': 'மீண்டும் விளக்கவும்',
        'note': '→ Asking for clarity',
      },
    ],
  },
];

const practiceActivities = [
  {
    'label': 'Record your introduction',
    'hint': 'Practice saying your name and where you’re from',
  },
  {
    'label': 'Match greetings to responses',
    'hint': 'Connect questions with appropriate answers',
  },
  {'label': 'Tap-to-play audio', 'hint': 'Listen and repeat pronunciation'},
];

const communityGuidelines = [
  'Be kind and supportive to every member',
  'Celebrate everyone’s progress, no matter how small',
  'Share honestly and encourage others',
  'Ask questions — we’re all learning together',
];
