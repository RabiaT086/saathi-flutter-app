import 'package:flutter/material.dart';

/// App-wide settings that multiple screens need to read/react to:
/// dark/light theme and English/Urdu language. Kept as simple
/// ValueNotifiers so any widget can listen without extra packages.
class AppState {
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  static final ValueNotifier<bool> isUrdu = ValueNotifier(false);
}

/// A small set of shared UI strings that appear in more than one place
/// (drawer, bottom nav, welcome screen). Add more keys here as more
/// screens are translated.
class AppText {
  static String of(BuildContext context, String key) {
    final ur = AppState.isUrdu.value;
    final map = _strings[key];
    if (map == null) return key;
    return ur ? map['ur']! : map['en']!;
  }

  static const Map<String, Map<String, String>> _strings = {
    'home': {'en': 'Home', 'ur': 'ہوم'},
    'ai_assistant': {'en': 'AI Assistant', 'ur': 'اے آئی اسسٹنٹ'},
    'profile': {'en': 'Profile', 'ur': 'پروفائل'},
    'get_started': {'en': 'Get Started', 'ur': 'شروع کریں'},
    'welcome_tagline': {'en': 'Smart harassment response & safety for students', 'ur': 'طالبات کے لیے ہراسانی رپورٹنگ اور حفاظتی نظام'},
    'language': {'en': 'LANGUAGE', 'ur': 'زبان'},
    'theme': {'en': 'THEME', 'ur': 'تھیم'},
    'light_mode': {'en': 'Light mode', 'ur': 'لائٹ موڈ'},
    'dark_mode': {'en': 'Dark mode', 'ur': 'ڈارک موڈ'},
    'notification_settings': {'en': 'NOTIFICATION SETTINGS', 'ur': 'نوٹیفیکیشن سیٹنگز'},
    'permissions': {'en': 'PERMISSIONS', 'ur': 'اجازتیں'},
    'more': {'en': 'MORE', 'ur': 'مزید'},
    'privacy_policy': {'en': 'Privacy Policy', 'ur': 'رازداری کی پالیسی'},
    'help_faqs': {'en': 'Help / FAQs', 'ur': 'مدد / اکثر پوچھے گئے سوالات'},
    'about_us': {'en': 'About Us', 'ur': 'ہمارے بارے میں'},
  };
}
