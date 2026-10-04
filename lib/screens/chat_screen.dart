import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_drawer.dart';
import '../app_state.dart';
import 'report_screen.dart';
import 'emergency_screen.dart';

class ChatScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;
  const ChatScreen({super.key, this.onBackToHome});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<Map<String, dynamic>> messages = [
    {
      'sender': 'saathi',
      'message': "Hi, I'm Saathi AI. You can describe any situation or incident in your own words. I will help identify the category, explain your rights, and suggest the right steps.",
      'action': null,
    },
  ];

  final List<String> quickReplies = const [
    'Is this harassment?',
    'What should I do right now?',
    'How do I file a complaint?',
    'Cyber harassment & online threats',
    'I need emergency help!',
  ];

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _generateAiResponse(String query, bool isUrdu) {
    final lower = query.toLowerCase();

    if (lower.contains('emergency') || lower.contains('help') || lower.contains('danger') || lower.contains('bachao') || lower.contains('madad')) {
      return isUrdu
          ? "اگر آپ فوری خطرے میں ہیں، تو فوراً ہنگامی 'Emergency SOS' کا بٹن دبائیں یا 15 پولیس ہیلپ لائن پر کال کریں۔ آپ اکیلی نہیں ہیں، آپ کی حفاظت اولین ترجیح ہے۔"
          : "If you are in immediate physical danger, please press the Emergency SOS button right now or dial 15 for Police. Your safety is the highest priority.";
    }

    if (lower.contains('report') || lower.contains('complaint') || lower.contains('file') || lower.contains('shikayat')) {
      return isUrdu
          ? "آپ ساتھی ایپ میں باآسانی خفیہ شکایت درج کر سکتی ہیں۔ 'Report Harassment' پر جائیں، واقعے کی تاریخ، وقت، مقام اور کوئی دستیاب اسکرین شاٹ یا آڈیو منسلک کریں۔ آپ کا نام خفیہ رکھا جا سکتا ہے۔"
          : "You can file a confidential complaint right inside the Saathi app. Go to 'Report Harassment', select the type of incident, add the date, location, and attach any screenshots, photos, or audio recordings as evidence.";
    }

    if (lower.contains('cyber') || lower.contains('online') || lower.contains('message') || lower.contains('facebook') || lower.contains('instagram') || lower.contains('whatsapp')) {
      return isUrdu
          ? "آن لائن پیغامات، بلیک میلنگ یا ناپسندیدہ تصاویر سائبر ہراسانی (Cyber Harassment) کے زمرے میں آتی ہیں۔ یہ پاکستان کے قانون PECA 2016 کے تحت جرم ہے۔ برائے مہربانی اسکرین شاٹس محفوظ رکھیں، کال ریکارڈنگ رکھیں اور فوری طور پر رپورٹ کریں۔"
          : "Unwanted DMs, threats, stalking, or non-consensual sharing of photos online constitute Cyber Harassment under PECA 2016 (Pakistan Cyber Crime Act). Please do not delete evidence—take screenshots of timestamps and handles, and submit them with your report.";
    }

    if (lower.contains('is this') || lower.contains('harassment') || lower.contains('kya yeh') || lower.contains('touch')) {
      return isUrdu
          ? "کوئی بھی ایسا رویہ، کمنٹ، اشارہ، یا جسمانی لمس جو غیر ضروری اور غیر آرام دہ ہو اور آپ کی مرضی کے خلاف ہو، ہراسانی کہلاتا ہے۔ یونیورسٹی کوڈ آف کنڈکٹ اور ملکی قانون آپ کو مکمل تحفظ فراہم کرتے ہیں۔"
          : "Any unwelcome sexual advance, request for sexual favors, verbal or physical conduct or gesture of an unreasonable or offensive nature constitutes harassment under HEC guidelines and the Protection against Harassment at Workplace Act.";
    }

    return isUrdu
        ? "شکریہ کہ آپ نے مجھ سے شیئر کیا۔ آپ بغیر کسی جھجک کے تفصیل بتا سکتی ہیں۔ کیا یہ واقعہ آن لائن پیش آیا یا کیمپس کے اندر؟ میں آپ کو شکایت درج کرنے میں مدد کروں گی۔"
        : "Thank you for sharing this. Please remember that you have the right to a safe academic environment. Would you like me to guide you through filing a formal complaint or reviewing your legal rights?";
  }

  void sendMessage([String? quickText]) async {
    final text = quickText ?? messageController.text.trim();
    if (text.isEmpty) return;

    final isUrdu = AppState.isUrdu.value;

    setState(() {
      messages.add({'sender': 'user', 'message': text, 'action': null});
      _isTyping = true;
    });
    messageController.clear();
    _scrollToBottom();

    // Simulated AI response delay with intelligent contextual replies
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    final aiReply = _generateAiResponse(text, isUrdu);
    String? suggestedAction;
    if (text.toLowerCase().contains('report') || text.toLowerCase().contains('complaint')) {
      suggestedAction = 'report';
    } else if (text.toLowerCase().contains('emergency') || text.toLowerCase().contains('danger')) {
      suggestedAction = 'emergency';
    }

    setState(() {
      _isTyping = false;
      messages.add({
        'sender': 'saathi',
        'message': aiReply,
        'action': suggestedAction,
      });
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.listenable,
      builder: (context, _) {
        final isUrdu = AppState.isUrdu.value;

        return Scaffold(
          backgroundColor: AppColors.background,
          drawer: const AppDrawer(),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryDark, AppColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Builder(
                          builder: (scaffoldContext) => IconButton(
                            onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
                            icon: const Icon(Icons.menu, color: Colors.white),
                            tooltip: 'Menu',
                          ),
                        ),
                        const SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppText.of(context, 'ai_assistant'),
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              AppText.of(context, 'general_guidance'),
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Disclaimer banner
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDECEA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFF5C6C0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined, size: 16, color: Colors.brown),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isUrdu
                              ? 'یہ چیٹ بوٹ عمومی رہنمائی کے لیے ہے۔ ہنگامی صورت میں فورا ًSOS استعمال کریں۔'
                              : 'This AI provides guidance based on university policy. For immediate danger, use SOS.',
                          style: const TextStyle(fontSize: 11, color: Colors.brown),
                        ),
                      ),
                    ],
                  ),
                ),

                // Chat Messages List
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length && _isTyping) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  isUrdu ? 'ساتھی لکھ رہا ہے...' : 'Saathi is typing...',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final message = messages[index];
                      final isUser = message['sender'] == 'user';
                      final action = message['action'] as String?;

                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: const EdgeInsets.all(14),
                              constraints: const BoxConstraints(maxWidth: 300),
                              decoration: BoxDecoration(
                                color: isUser ? AppColors.primary : AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(18),
                                border: isUser ? null : Border.all(color: AppColors.cardBorder),
                              ),
                              child: Text(
                                message['message']!,
                                style: TextStyle(fontSize: 14, color: isUser ? Colors.white : AppColors.primaryDark, height: 1.35),
                              ),
                            ),
                            if (action == 'report')
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportScreen()));
                                  },
                                  icon: const Icon(Icons.description_outlined, size: 16),
                                  label: const Text('Open Complaint Form'),
                                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                                ),
                              )
                            else if (action == 'emergency')
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyScreen()));
                                  },
                                  icon: const Icon(Icons.emergency, size: 16, color: AppColors.danger),
                                  label: const Text('Open Emergency SOS', style: TextStyle(color: AppColors.danger)),
                                ),
                              )
                            else
                              const SizedBox(height: 8),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Quick Replies
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: quickReplies.map((text) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActionChip(
                            label: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.primaryDark)),
                            backgroundColor: AppColors.chipBackground,
                            onPressed: () => sendMessage(text),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: AppColors.cardBorder.withValues(alpha: 0.5))),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Input field
                Container(
                  padding: const EdgeInsets.all(12),
                  color: AppColors.cardBackground,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          onSubmitted: (_) => sendMessage(),
                          decoration: InputDecoration(
                            hintText: isUrdu ? 'یہاں تفصیل لکھیں...' : 'Describe what happened...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primary,
                        child: IconButton(
                          onPressed: () => sendMessage(),
                          icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
