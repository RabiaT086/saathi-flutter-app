import 'package:flutter/material.dart';

/// App-wide settings that multiple screens need to read/react to:
/// dark/light theme and English/Urdu language. Kept as simple
/// ValueNotifiers so any widget can listen without extra packages.
class AppState {
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  static final ValueNotifier<bool> isUrdu = ValueNotifier(false);
}

/// Shared UI strings used across screens. "Saathi" itself is never
/// translated, per the app's branding.
class AppText {
  static String of(BuildContext context, String key) {
    final ur = AppState.isUrdu.value;
    final map = _strings[key];
    if (map == null) return key;
    return ur ? map['ur']! : map['en']!;
  }

  static const Map<String, Map<String, String>> _strings = {
    // Bottom nav / drawer
    'home': {'en': 'Home', 'ur': 'ہوم'},
    'ai_assistant': {'en': 'AI Assistant', 'ur': 'اے آئی اسسٹنٹ'},
    'profile': {'en': 'Profile', 'ur': 'پروفائل'},
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

    // Welcome / Onboarding
    'welcome_tagline': {'en': 'Smart harassment response & safety for students', 'ur': 'طالبات کے لیے ہراسانی رپورٹنگ اور حفاظتی نظام'},
    'get_started': {'en': 'Get Started', 'ur': 'شروع کریں'},
    'skip': {'en': 'Skip', 'ur': 'نظر انداز کریں'},
    'next': {'en': 'Next', 'ur': 'اگلا'},
    'back': {'en': 'Back', 'ur': 'واپس'},

    // Login / Signup
    'welcome_back': {'en': 'Welcome back', 'ur': 'خوش آمدید'},
    'sign_in_subtitle': {'en': 'Sign in to continue to your safety dashboard', 'ur': 'اپنے حفاظتی ڈیش بورڈ تک رسائی کے لیے سائن ان کریں'},
    'university_email': {'en': 'University email', 'ur': 'یونیورسٹی ای میل'},
    'password': {'en': 'Password', 'ur': 'پاس ورڈ'},
    'forgot_password': {'en': 'Forgot password?', 'ur': 'پاس ورڈ بھول گئے؟'},
    'login': {'en': 'Login', 'ur': 'لاگ ان'},
    'no_account': {'en': "Don't have an account? ", 'ur': 'اکاؤنٹ نہیں ہے؟ '},
    'create_account': {'en': 'Create Account', 'ur': 'اکاؤنٹ بنائیں'},
    'authorised_authority': {'en': 'Authorised authority', 'ur': 'مجاز اتھارٹی'},
    'admin_login': {'en': 'Admin / Authority login', 'ur': 'ایڈمن / اتھارٹی لاگ ان'},
    'join_saathi': {'en': 'Create account', 'ur': 'اکاؤنٹ بنائیں'},
    'signup_subtitle': {'en': 'Your details stay private and are visible only to authorised university personnel.', 'ur': 'آپ کی تفصیلات صرف مجاز یونیورسٹی عملے کو نظر آتی ہیں۔'},
    'full_name': {'en': 'Full name', 'ur': 'پورا نام'},
    'confirm_password': {'en': 'Confirm password', 'ur': 'پاس ورڈ کی تصدیق کریں'},
    'already_registered': {'en': 'Already registered? ', 'ur': 'پہلے سے رجسٹرڈ ہیں؟ '},

    // Home
    'how_can_i_help': {'en': 'How can I help you?', 'ur': 'میں آپ کی کیسے مدد کر سکتی ہوں؟'},
    'emergency_sos': {'en': 'Emergency SOS', 'ur': 'ہنگامی مدد'},
    'call_15': {'en': 'Call 15', 'ur': 'کال 15'},
    'know_your_rights': {'en': 'Know Your Rights', 'ur': 'اپنے حقوق جانیں'},
    'quick_actions': {'en': 'Quick Actions', 'ur': 'فوری اقدامات'},
    'report_harassment': {'en': 'Report Harassment', 'ur': 'ہراسانی کی رپورٹ کریں'},
    'my_cases': {'en': 'My Cases', 'ur': 'میرے کیسز'},
    'evidence_vault': {'en': 'Evidence Vault', 'ur': 'شواہد کا ذخیرہ'},
    'emergency_contact': {'en': 'Emergency Contact', 'ur': 'ہنگامی رابطہ'},
    'share_live_location': {'en': 'Share Live Location', 'ur': 'لائیو مقام شیئر کریں'},
    'safety_status': {'en': 'Safety Status', 'ur': 'حفاظتی صورتحال'},
    'latest_case': {'en': 'Latest case', 'ur': 'تازہ ترین کیس'},
    'view_all': {'en': 'View all', 'ur': 'سب دیکھیں'},

    // Emergency
    'emergency': {'en': 'Emergency', 'ur': 'ہنگامی صورتحال'},
    'immediate_help': {'en': 'Immediate help & evidence', 'ur': 'فوری مدد اور شواہد'},
    'press_hold_sos': {'en': 'Press and hold to send an emergency alert', 'ur': 'ہنگامی الرٹ بھیجنے کے لیے دبائے رکھیں'},
    'will_be_notified': {'en': 'Will be notified', 'ur': 'ان کو اطلاع دی جائے گی'},

    // Report
    'confidential_form': {'en': 'Confidential complaint form', 'ur': 'خفیہ شکایتی فارم'},
    'harassment_type': {'en': 'Harassment type', 'ur': 'ہراسانی کی قسم'},
    'date': {'en': 'Date', 'ur': 'تاریخ'},
    'time': {'en': 'Time', 'ur': 'وقت'},
    'location': {'en': 'Location', 'ur': 'مقام'},
    'description_incident': {'en': 'Description of incident', 'ur': 'واقعے کی تفصیل'},
    'additional_info': {'en': 'Additional information (optional)', 'ur': 'اضافی معلومات (اختیاری)'},
    'evidence_attachment': {'en': 'Evidence attachment', 'ur': 'شواہد منسلک کریں'},
    'submit_complaint': {'en': 'Submit complaint', 'ur': 'شکایت جمع کروائیں'},

    // My Cases
    'complaints_filed': {'en': 'complaints filed', 'ur': 'شکایات درج کی گئیں'},

    // Notifications
    'notifications': {'en': 'Notifications', 'ur': 'اطلاعات'},
    'all_caught_up': {'en': 'All caught up', 'ur': 'سب اپ ڈیٹ ہے'},
    'no_notifications': {'en': 'No notifications yet', 'ur': 'ابھی کوئی اطلاع نہیں'},

    // Profile
    'change_password': {'en': 'Change password', 'ur': 'پاس ورڈ تبدیل کریں'},
    'edit_profile': {'en': 'Edit Profile', 'ur': 'پروفائل میں ترمیم کریں'},
    'save': {'en': 'Save', 'ur': 'محفوظ کریں'},
    'emergency_contacts': {'en': 'Emergency contacts', 'ur': 'ہنگامی رابطے'},
    'add_contact': {'en': 'Add contact', 'ur': 'رابطہ شامل کریں'},
    'safety_settings': {'en': 'Safety settings', 'ur': 'حفاظتی سیٹنگز'},
    'logout': {'en': 'Logout', 'ur': 'لاگ آؤٹ'},

    // AI Assistant
    'general_guidance': {'en': 'General guidance, not legal advice', 'ur': 'عمومی رہنمائی، قانونی مشورہ نہیں'},
    'saathi_assistant': {'en': 'Saathi Assistant', 'ur': 'ساتھی اسسٹنٹ'},
    'assistant_subtitle': {'en': "Here to listen and guide you — you're not alone.", 'ur': 'سننے اور رہنمائی کے لیے حاضر ہوں — آپ اکیلی نہیں ہیں۔'},
  };
}
