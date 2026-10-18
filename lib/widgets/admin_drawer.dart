import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';
import '../data_store.dart';
import '../services/auth_service.dart';
import '../screens/login_screen.dart';

/// Hamburger side drawer for the Authority / Admin Portal.
/// Fully equipped with Language (English/Urdu) toggle, Theme (Light/Dark) toggle,
/// Notification settings, Emergency SOS Live Monitor, HEC Inquiry rules, and Logout.
class AdminDrawer extends StatefulWidget {
  final VoidCallback? onSwitchToCases;

  const AdminDrawer({super.key, this.onSwitchToCases});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  bool emergencySirenSound = true;
  bool newComplaintPush = true;
  bool dailyDigestEmail = true;

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textMuted,
            letterSpacing: 1.1,
          ),
        ),
      );

  void _showHecGuidelines(BuildContext context) {
    Navigator.pop(context); // close drawer
    final isUrdu = AppState.isUrdu.value;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.gavel_rounded, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isUrdu ? 'ایچ ای سی 30 روزہ تحقیقاتی ضوابط' : 'HEC 30-Day Inquiry Policy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isUrdu
                    ? 'ہائیر ایجوکیشن کمیشن (HEC) پاکستان کی پالیسی کے تحت تمام یونیورسٹیوں کے لیے درج ذیل ضوابط لازمی ہیں:'
                    : 'According to Higher Education Commission (HEC) Pakistan policy on sexual & campus harassment:',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              _guidelineItem('1. 30-Day Resolution Mandate', isUrdu ? 'کمیٹی شکایت موصول ہونے کے 30 یوم کے اندر تحقیقات مکمل کرنے کی پابند ہے۔' : 'Inquiry Committee must complete proceedings and submit findings within 30 days of receiving the complaint.'),
              _guidelineItem('2. Strict Identity Protection', isUrdu ? 'متاثرہ طالبہ یا طالب علم کی شناخت کسی بھی غیر متعلقہ شخص پر ظاہر کرنا جرم ہے۔' : 'Complainant identity remains strictly confidential. Unauthorized disclosure is a punishable offense.'),
              _guidelineItem('3. Zero Retaliation Clause', isUrdu ? 'شکایت کنندہ کے گریڈز، امتحانات یا تعلیمی کیریئر پر اثر انداز ہونے کی کوشش سختی سے ممنوع ہے۔' : 'Any intimidation, grade tampering, or hostile academic behavior against complainant is strictly prohibited.'),
              _guidelineItem('4. Right to Evidence & Appeal', isUrdu ? 'دونوں فریقین کو شواہد پیش کرنے اور وفاقی/صوبائی محتسب کے پاس اپیل کا مکمل حق حاصل ہے۔' : 'Full right to present evidence and appeal to the Federal / Provincial Ombudsperson under Act IV of 2010.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isUrdu ? 'سمجھ آ گیا' : 'Understood', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _guidelineItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primaryDark)),
          const SizedBox(height: 2),
          Text(desc, style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.35)),
        ],
      ),
    );
  }

  void _showEmergencySosMonitor(BuildContext context) {
    Navigator.pop(context); // close drawer
    final isUrdu = AppState.isUrdu.value;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return ValueListenableBuilder<List<Map<String, String>>>(
          valueListenable: DataStore.emergencyAlerts,
          builder: (context, alerts, _) {
            final activeAlerts = alerts.where((a) => a['status'] == 'Active').toList();
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.crisis_alert_rounded, color: AppColors.danger, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isUrdu ? 'لائیو ہنگامی ایس او ایس الرٹس' : 'Live Emergency SOS Monitor',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                            ),
                            Text(
                              '${activeAlerts.length} ${isUrdu ? "فعال الرٹس" : "active alert(s)"}',
                              style: const TextStyle(fontSize: 12, color: AppColors.danger, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (activeAlerts.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.chipBackground,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 36),
                          const SizedBox(height: 8),
                          Text(
                            isUrdu ? 'تمام کیمپس پر امن ہے، کوئی ہنگامی الرٹ نہیں ہے۔' : 'All clear! No active SOS panic alerts right now.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  else
                    ...activeAlerts.map(
                      (alert) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.danger.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(alert['id'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.danger)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: AppColors.danger, borderRadius: BorderRadius.circular(6)),
                                  child: const Text('EMERGENCY SOS', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(alert['student'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryDark)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.danger),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(alert['location'] ?? '', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      DataStore.resolveAlert(alert['id']!);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${alert['id']} marked as responded & secured.')),
                                      );
                                    },
                                    icon: const Icon(Icons.verified_user_rounded, size: 16),
                                    label: Text(isUrdu ? 'جواب دیا گیا' : 'Mark Secured'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _exportComplaintsReport(BuildContext context) {
    Navigator.pop(context); // close drawer
    final totalCases = DataStore.cases.value.length;
    final isUrdu = AppState.isUrdu.value;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryDark,
        content: Row(
          children: [
            const Icon(Icons.file_download_done_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isUrdu
                    ? '$totalCases شکایات کی رپورٹ بحفاظت برآمد (Export) کر لی گئی۔'
                    : 'Audit report for $totalCases complaints generated successfully (CSV/PDF).',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.listenable,
      builder: (context, _) => _buildDrawer(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final isUrdu = AppState.isUrdu.value;
    final isDark = AppState.themeMode.value == ThemeMode.dark;

    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Authority Gradient Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppText.of(context, 'authority_portal'),
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppText.of(context, 'anti_harassment_committee'),
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Official Profile Info Card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary.withOpacity(0.15),
                    child: const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Federal Urdu University',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryDark),
                        ),
                        Text(
                          'FUUAST Anti-Harassment Cell',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        Text(
                          'inquiry@fuuast.edu.pk',
                          style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LANGUAGE TOGGLE
                  _sectionTitle(AppText.of(context, 'language')),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.chipBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => AppState.isUrdu.value = false,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !isUrdu ? AppColors.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'English',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: !isUrdu ? Colors.white : AppColors.primaryDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => AppState.isUrdu.value = true,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isUrdu ? AppColors.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'اردو (Urdu)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isUrdu ? Colors.white : AppColors.primaryDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // THEME TOGGLE
                  _sectionTitle(AppText.of(context, 'theme')),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.chipBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => AppState.themeMode.value = ThemeMode.light,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !isDark ? AppColors.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.light_mode_outlined, size: 16, color: !isDark ? Colors.white : AppColors.primaryDark),
                                  const SizedBox(width: 6),
                                  Text(
                                    AppText.of(context, 'light_mode'),
                                    style: TextStyle(
                                      color: !isDark ? Colors.white : AppColors.primaryDark,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => AppState.themeMode.value = ThemeMode.dark,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.dark_mode_outlined, size: 16, color: isDark ? Colors.white : AppColors.primaryDark),
                                  const SizedBox(width: 6),
                                  Text(
                                    AppText.of(context, 'dark_mode'),
                                    style: TextStyle(
                                      color: isDark ? Colors.white : AppColors.primaryDark,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // COMMITTEE TOOLS & SHORTCUTS
                  _sectionTitle(isUrdu ? 'کمیٹی ٹولز' : 'COMMITTEE ACTIONS'),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.crisis_alert_rounded, color: AppColors.danger),
                          title: Text(
                            AppText.of(context, 'sos_live_monitor'),
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primaryDark),
                          ),
                          subtitle: Text(
                            isUrdu ? 'طالبات کے ہنگامی الرٹس دیکھیں' : 'Live campus panic alerts',
                            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                          trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                          onTap: () => _showEmergencySosMonitor(context),
                        ),
                        const Divider(height: 1, color: AppColors.cardBorder),
                        ListTile(
                          leading: const Icon(Icons.gavel_rounded, color: AppColors.primary),
                          title: Text(
                            AppText.of(context, 'hec_inquiry_rules'),
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primaryDark),
                          ),
                          subtitle: Text(
                            isUrdu ? '30 روزہ قانونی ضوابط' : 'Standard 30-day mandate rules',
                            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                          trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                          onTap: () => _showHecGuidelines(context),
                        ),
                        const Divider(height: 1, color: AppColors.cardBorder),
                        ListTile(
                          leading: const Icon(Icons.download_for_offline_outlined, color: AppColors.primary),
                          title: Text(
                            AppText.of(context, 'export_report'),
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primaryDark),
                          ),
                          subtitle: Text(
                            isUrdu ? 'رپورٹس اور شواہد کی فائل' : 'Export case audit summaries',
                            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                          trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                          onTap: () => _exportComplaintsReport(context),
                        ),
                      ],
                    ),
                  ),

                  // NOTIFICATION SETTINGS
                  _sectionTitle(AppText.of(context, 'notification_settings')),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                          value: emergencySirenSound,
                          activeColor: AppColors.primary,
                          onChanged: (v) => setState(() => emergencySirenSound = v),
                          title: Text(
                            AppText.of(context, 'sound_alerts'),
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primaryDark),
                          ),
                          subtitle: Text(
                            AppText.of(context, 'sound_alerts_desc'),
                            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ),
                        const Divider(height: 1, color: AppColors.cardBorder),
                        SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                          value: newComplaintPush,
                          activeColor: AppColors.primary,
                          onChanged: (v) => setState(() => newComplaintPush = v),
                          title: Text(
                            isUrdu ? 'نئی شکایت کا پش نوٹیفیکیشن' : 'New Complaint Alerts',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primaryDark),
                          ),
                          subtitle: Text(
                            isUrdu ? 'ہر نئی شکایت پر فوری اطلاع' : 'Push notification on new complaints',
                            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // LOGOUT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await AuthService().signOut();
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
                      label: Text(
                        AppText.of(context, 'logout'),
                        style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.danger),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Saathi · Anti-Harassment Committee v1.0.0',
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
