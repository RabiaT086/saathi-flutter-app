import 'package:flutter/material.dart';

/// App-wide settings that multiple screens need to read/react to:
/// dark/light theme and English/Urdu language. Kept as simple
/// ValueNotifiers so any widget can listen without extra packages.
class AppState {
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  static final ValueNotifier<bool> isUrdu = ValueNotifier(false);

  /// Combined notifier for both theme and language:
  /// Any screen or widget listening to AppState.listenable
  /// will automatically rebuild whenever EITHER themeMode OR isUrdu changes.
  static final Listenable listenable = Listenable.merge([themeMode, isUrdu]);
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
    'university_email': {'en': 'Email', 'ur': 'ای میل'},
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

    // Onboarding Slides
    'onboarding_title_1': {'en': 'Report harassment safely', 'ur': 'ہراسانی کی محفوظ رپورٹ درج کریں'},
    'onboarding_desc_1': {'en': 'Submit a detailed complaint with date, time, location and evidence. Only authorised university personnel can review it.', 'ur': 'تاریخ، وقت، مقام اور شواہد کے ساتھ تفصیلی شکایت جمع کروائیں۔ صرف مجاز یونیورسٹی عملہ ہی اس کا جائزہ لے سکتا ہے۔'},
    'onboarding_title_2': {'en': 'Get emergency assistance', 'ur': 'ہنگامی مدد حاصل کریں'},
    'onboarding_desc_2': {'en': 'One tap on the panic button — or a shake of your phone — shares your live location and alerts your emergency contacts.', 'ur': 'پینک بٹن پر ایک ٹیپ — یا فون ہلانے سے — آپ کا لائیو مقام شیئر ہوتا ہے اور ہنگامی رابطوں کو الرٹ جاتا ہے۔'},
    'onboarding_title_3': {'en': 'Track your complaint', 'ur': 'اپنی شکایت کا سراغ لگائیں'},
    'onboarding_desc_3': {'en': 'Follow your case from Submitted to Resolved with a clear timeline and updates from the committee.', 'ur': 'کمیٹی کی ٹائم لائن اور اپ ڈیٹس کے ساتھ اپنے کیس کو جمع کروانے سے حل ہونے تک ٹریک کریں۔'},

    // Signup Extra Fields
    'student_university_id': {'en': 'Student / University ID', 'ur': 'طالب علم / یونیورسٹی شناختی کارڈ'},
    'emergency_contact_name': {'en': 'Emergency contact name', 'ur': 'ہنگامی رابطے کا نام'},
    'emergency_contact_number': {'en': 'Emergency contact number', 'ur': 'ہنگامی رابطہ نمبر'},
    'relation_hint': {'en': 'Sister, parent or guardian', 'ur': 'بہن، والدین یا سرپرست'},
    'reenter_password': {'en': 'Re-enter password', 'ur': 'پاس ورڈ دوبارہ درج کریں'},
    'at_least_6_chars': {'en': 'At least 6 characters', 'ur': 'کم از کم 6 حروف'},

    // Forgot Password
    'reset_your_password': {'en': 'Reset your password', 'ur': 'اپنا پاس ورڈ ری سیٹ کریں'},
    'reset_instructions_text': {'en': 'Enter your registered email address and we will send you instructions to reset your password.', 'ur': 'اپنا رجسٹرڈ ای میل ایڈریس درج کریں اور ہم آپ کو پاس ورڈ ری سیٹ کرنے کی ہدایات بھیجیں گے۔'},
    'email_address': {'en': 'Email Address', 'ur': 'ای میل ایڈریس'},
    'send_reset_instructions': {'en': 'Send Reset Instructions', 'ur': 'ہدایات بھیجیں'},

    // Change Password
    'current_password': {'en': 'Current Password', 'ur': 'موجودہ پاس ورڈ'},
    'new_password': {'en': 'New Password', 'ur': 'نیا پاس ورڈ'},
    'update_password': {'en': 'Update Password', 'ur': 'پاس ورڈ اپ ڈیٹ کریں'},

    // Know Your Rights
    'know_your_rights_title': {'en': 'Know Your Rights', 'ur': 'اپنے حقوق جانیں'},
    'legal_framework_subtitle': {'en': 'Protection & Legal Framework in Pakistan', 'ur': 'پاکستان میں تحفظ اور قانونی فریم ورک'},
    'fundamental_rights': {'en': 'Your Fundamental Rights as a Student', 'ur': 'طالب علم کی حیثیت سے آپ کے بنیادی حقوق'},
    'complete_confidentiality': {'en': 'Complete Confidentiality', 'ur': 'مکمل رازداری'},
    'complete_confidentiality_desc': {'en': 'Your identity will not be disclosed to peers or unauthorized staff.', 'ur': 'آپ کی شناخت کلاس فیلوز یا غیر مجاز عملے پر ظاہر نہیں کی جائے گی۔'},
    'retaliation_protection': {'en': 'Protection Against Retaliation', 'ur': 'انتقامی کارروائی سے تحفظ'},
    'retaliation_protection_desc': {'en': 'Any victimization, grade threats, or bias is strictly illegal.', 'ur': 'گریڈز کی دھمکی یا کسی بھی قسم کی انتقامی کارروائی سختی سے غیر قانونی ہے۔'},
    'time_bound_inquiry': {'en': 'Mandatory Time-Bound Inquiry', 'ur': 'وقت پر مبنی تحقیقات لازمی'},
    'time_bound_inquiry_desc': {'en': 'The Inquiry Committee must complete proceedings within 30 days.', 'ur': 'تحقیقاتی کمیٹی کے لیے 30 دن کے اندر کارروائی مکمل کرنا لازمی ہے۔'},
    'right_to_appeal': {'en': 'Right to Appeal', 'ur': 'اپیل کا حق'},
    'right_to_appeal_desc': {'en': 'You have the right to appeal before the Federal/Provincial Ombudsperson.', 'ur': 'آپ کو وفاقی یا صوبائی محتسب کے سامنے اپیل کرنے کا پورا حق حاصل ہے۔'},
    'applicable_laws': {'en': 'Applicable Laws & Policies', 'ur': 'نافذ العمل قوانین اور پالیسیاں'},
    'emergency_helplines': {'en': 'Key Emergency Helplines (Pakistan)', 'ur': 'اہم ہنگامی ہیلپ لائنز (پاکستان)'},

    // Case Details & Evidence
    'case_details': {'en': 'Case details', 'ur': 'کیس کی تفصیلات'},
    'description': {'en': 'Description', 'ur': 'تفصیل'},
    'evidence': {'en': 'Evidence', 'ur': 'شواہد'},
    'files_linked': {'en': 'files linked to this case', 'ur': 'فائلیں اس کیس سے منسلک ہیں'},
    'case_timeline': {'en': 'Case timeline', 'ur': 'کیس کی ٹائم لائن'},
    'secured_files': {'en': 'secured files', 'ur': 'محفوظ فائلیں'},
    'evidence_encryption_notice': {'en': 'Files are encrypted at rest and only visible to you and the Anti-Harassment Committee handling your case.', 'ur': 'فائلیں محفوظ اور انکرپٹڈ ہیں، اور صرف آپ کو اور کمیٹی کو نظر آتی ہیں۔'},
    'no_files_category': {'en': 'No files in this category yet', 'ur': 'اس کیٹیگری میں ابھی کوئی فائل نہیں ہے'},

    // Upload options
    'upload_photo': {'en': 'Upload Photo', 'ur': 'تصویر اپ لوڈ'},
    'upload_video': {'en': 'Upload Video', 'ur': 'ویڈیو اپ لوڈ'},
    'upload_audio': {'en': 'Upload Audio', 'ur': 'آڈیو اپ لوڈ'},
    'upload_document': {'en': 'Upload Document', 'ur': 'دستاویز اپ لوڈ'},

    // Statuses
    'status_all': {'en': 'All', 'ur': 'تمام'},
    'status_submitted': {'en': 'Submitted', 'ur': 'جمع شدہ'},
    'status_under_review': {'en': 'Under Review', 'ur': 'زیر غور'},
    'status_in_progress': {'en': 'In Progress', 'ur': 'جاری ہے'},
    'status_resolved': {'en': 'Resolved', 'ur': 'حل شدہ'},
    'status_closed': {'en': 'Closed', 'ur': 'بند'},

    // Profile extra
    'manage_account_safety': {'en': 'Manage your account & safety settings', 'ur': 'اپنے اکاؤنٹ اور حفاظتی ترتیبات کا انتظام کریں'},
    'name': {'en': 'Name', 'ur': 'نام'},
    'department': {'en': 'Department', 'ur': 'شعبہ'},
    'semester': {'en': 'Semester', 'ur': 'سمسٹر'},
    'email': {'en': 'Email', 'ur': 'ای میل'},
    'relation': {'en': 'Relation', 'ur': 'رشتہ'},
    'phone': {'en': 'Phone', 'ur': 'فون'},
    'shake_detection': {'en': 'Shake detection', 'ur': 'شیک ڈیٹیکشن (فون ہلانا)'},
    'shake_detection_desc': {'en': 'Shake the phone to trigger an alert', 'ur': 'ہنگامی الرٹ جاری کرنے کے لیے فون ہلائیں'},
    'auto_record': {'en': 'Auto-record on emergency', 'ur': 'ہنگامی صورت میں خودکار ریکارڈنگ'},
    'auto_record_desc': {'en': 'Start audio/video capture with alerts', 'ur': 'الرٹ کے ساتھ آڈیو/ویڈیو ریکارڈنگ شروع کریں'},
    'push_notifications': {'en': 'Push notifications', 'ur': 'پش نوٹیفیکیشنز'},
    'push_notifications_desc': {'en': 'Case updates and alert confirmations', 'ur': 'کیس اپ ڈیٹس اور الرٹ کی تصدیق'},
    'case_update_emails': {'en': 'Case update emails', 'ur': 'کیس اپ ڈیٹ ای میلز'},
    'case_update_emails_desc': {'en': 'Email a copy of every status change', 'ur': 'ہر اسٹیٹس کی تبدیلی کی ای میل کاپی حاصل کریں'},
    'share_location_authority': {'en': 'Share location with authority', 'ur': 'اتھارٹی کے ساتھ مقام شیئر کریں'},
    'share_location_authority_desc': {'en': 'Committee sees live location during alerts', 'ur': 'الرٹ کے دوران کمیٹی کو لائیو لوکیشن نظر آئے گی'},
    'hide_identity_peers': {'en': 'Hide identity from peers', 'ur': 'ساتھی طلباء سے شناخت چھپائیں'},
    'hide_identity_peers_desc': {'en': 'Your name is never shown to other students', 'ur': 'آپ کا نام دیگر طلباء کو کبھی نہیں دکھایا جائے گا'},

    // Report extra
    'select_date': {'en': 'Select date', 'ur': 'تاریخ منتخب کریں'},
    'select_time': {'en': 'Select time', 'ur': 'وقت منتخب کریں'},
    'select_harassment_type': {'en': 'Select type of harassment', 'ur': 'ہراسانی کی قسم منتخب کریں'},
    'location_hint': {'en': 'e.g. Cafeteria block, Main Campus', 'ur': 'مثلاً: کیفے ٹیریا بلاک، مین کیمپس'},
    'description_hint': {'en': 'Describe what happened, who was involved and whether it happened before.', 'ur': 'واقعے کی تفصیل درج کریں، کون ملوث تھا اور کیا یہ پہلے بھی ہوا تھا۔'},
    'additional_info_hint': {'en': 'Witnesses, previous complaints, anything else the committee should know.', 'ur': 'گواہان، سابقہ شکایات یا کوئی بھی اہم بات جو کمیٹی کو معلوم ہونی چاہیے۔'},

    // Permissions
    'camera': {'en': 'Camera', 'ur': 'کیمرہ'},
    'microphone': {'en': 'Microphone', 'ur': 'مائیکروفون'},
    'location_permission': {'en': 'Location', 'ur': 'مقام / لوکیشن'},
    'allowed': {'en': 'Allowed', 'ur': 'اجازت ہے'},
    'while_using_app': {'en': 'While using app', 'ur': 'ایپ استعمال کرتے ہوئے'},

    // Admin / Authority Dashboard
    'authority_dashboard': {'en': 'Authority dashboard', 'ur': 'اتھارٹی ڈیش بورڈ'},
    'anti_harassment_committee': {'en': 'Anti-Harassment Committee', 'ur': 'انسدادِ ہراسانی کمیٹی'},
    'total_complaints': {'en': 'Total complaints', 'ur': 'کل شکایات'},
    'open_cases': {'en': 'Open cases', 'ur': 'زیر کارروائی کیسز'},
    'high_priority': {'en': 'High priority', 'ur': 'ہائی پرائرٹی (فوری)'},
    'emergency_alerts': {'en': 'Emergency alerts', 'ur': 'ہنگامی الرٹس'},
    'cases_by_status': {'en': 'Cases by status', 'ur': 'اسٹیٹس کے لحاظ سے کیسز'},
    'harassment_types': {'en': 'Harassment types', 'ur': 'ہراسانی کی اقسام'},
    'needs_attention': {'en': 'Needs attention', 'ur': 'توجہ طلب شکایات'},
    'manage_all': {'en': 'Manage all', 'ur': 'سب دیکھیں'},
    'recent_activity': {'en': 'Recent activity', 'ur': 'حالیہ سرگرمی'},
    'resolved_to_date': {'en': 'Resolved to date', 'ur': 'اب تک حل شدہ'},
    'dashboard': {'en': 'Dashboard', 'ur': 'ڈیش بورڈ'},
    'case_management': {'en': 'Case management', 'ur': 'کیس مینجمنٹ'},
    'search_cases_hint': {'en': 'Search case ID, student or type', 'ur': 'کیس آئی ڈی، طالب علم یا قسم تلاش کریں'},
    'no_complaints_match': {'en': 'No complaints match this filter.', 'ur': 'اس فلٹر کے مطابق کوئی شکایت نہیں ہے۔'},
    'review_update_status': {'en': 'Review / Update Status', 'ur': 'جائزہ لیں / اسٹیٹس تبدیل کریں'},
    'committee_remarks': {'en': 'Committee remarks / notes', 'ur': 'کمیٹی کے ریمارکس / نوٹس'},
    'update_status_btn': {'en': 'Update Status', 'ur': 'اسٹیٹس اپ ڈیٹ کریں'},
    'authority_portal': {'en': 'Authority Portal', 'ur': 'اتھارٹی پورٹل'},
    'hec_inquiry_rules': {'en': 'HEC 30-Day Inquiry Guidelines', 'ur': 'ایچ ای سی 30 روزہ تحقیقاتی قواعد'},
    'sos_live_monitor': {'en': 'Emergency SOS Monitor', 'ur': 'ہنگامی ایس او ایس مانیٹر'},
    'export_report': {'en': 'Export Complaints Report', 'ur': 'شکایات کی رپورٹ ڈاؤن لوڈ کریں'},
    'sound_alerts': {'en': 'Emergency Siren Sound', 'ur': 'ہنگامی سائرن کی آواز'},
    'sound_alerts_desc': {'en': 'Play alert sound when emergency SOS triggered', 'ur': 'ہنگامی الرٹ جاری ہونے پر سائرن کی آواز بجائیں'},
    'status_investigation': {'en': 'Investigation', 'ur': 'تحقیقات'},
  };
}
