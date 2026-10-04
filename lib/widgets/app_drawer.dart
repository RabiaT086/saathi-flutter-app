import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';
import '../screens/info_page_screen.dart';

/// Real sliding sidebar (Flutter's Drawer already closes on outside tap
/// and supports swipe-to-close). Holds Language, Theme, Notification
/// settings, Permissions and More links -- reached via the hamburger icon.
class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool pushNotifications = true;
  bool caseUpdateEmails = false;

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 1)),
      );

  Widget _permissionRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          const CircleAvatar(radius: 5, backgroundColor: Colors.green),
        ],
      ),
    );
  }

  Widget _linkRow(IconData icon, String title, String content) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => InfoPageScreen(title: title, content: content)),
        );
      },
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primaryDark, AppColors.primary], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Saathi', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text('Your campus safety companion', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(AppText.of(context, 'language')),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              AppState.isUrdu.value = false;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(color: !isUrdu ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(10)),
                              child: Text('English', textAlign: TextAlign.center, style: TextStyle(color: !isUrdu ? Colors.white : AppColors.primaryDark, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              AppState.isUrdu.value = true;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(color: isUrdu ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(10)),
                              child: Text('اردو (Urdu)', textAlign: TextAlign.center, style: TextStyle(color: isUrdu ? Colors.white : AppColors.primaryDark, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _sectionTitle(AppText.of(context, 'theme')),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              AppState.themeMode.value = ThemeMode.light;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(color: !isDark ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.light_mode_outlined, size: 16, color: !isDark ? Colors.white : AppColors.primaryDark),
                                  const SizedBox(width: 6),
                                  Text(AppText.of(context, 'light_mode'), style: TextStyle(color: !isDark ? Colors.white : AppColors.primaryDark, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              AppState.themeMode.value = ThemeMode.dark;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(color: isDark ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.dark_mode_outlined, size: 16, color: isDark ? Colors.white : AppColors.primaryDark),
                                  const SizedBox(width: 6),
                                  Text(AppText.of(context, 'dark_mode'), style: TextStyle(color: isDark ? Colors.white : AppColors.primaryDark, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _sectionTitle(AppText.of(context, 'notification_settings')),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
                    child: Column(
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          value: pushNotifications,
                          activeThumbColor: AppColors.primary,
                          onChanged: (v) => setState(() => pushNotifications = v),
                          title: Text(AppText.of(context, 'push_notifications'), style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                          subtitle: Text(AppText.of(context, 'push_notifications_desc'), style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        ),
                        const Divider(height: 1, color: AppColors.cardBorder),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          value: caseUpdateEmails,
                          activeThumbColor: AppColors.primary,
                          onChanged: (v) => setState(() => caseUpdateEmails = v),
                          title: Text(AppText.of(context, 'case_update_emails'), style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                          subtitle: Text(AppText.of(context, 'case_update_emails_desc'), style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        ),
                      ],
                    ),
                  ),

                  _sectionTitle(AppText.of(context, 'permissions')),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
                    child: Column(
                      children: [
                        _permissionRow(Icons.camera_alt_outlined, AppText.of(context, 'camera'), AppText.of(context, 'allowed')),
                        const Divider(height: 1, color: AppColors.cardBorder),
                        _permissionRow(Icons.mic_none_outlined, AppText.of(context, 'microphone'), AppText.of(context, 'allowed')),
                        const Divider(height: 1, color: AppColors.cardBorder),
                        _permissionRow(Icons.location_on_outlined, AppText.of(context, 'location_permission'), AppText.of(context, 'while_using_app')),
                      ],
                    ),
                  ),

                  _sectionTitle(AppText.of(context, 'more')),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.cardBorder)),
                    child: Column(
                      children: [
                        _linkRow(Icons.shield_outlined, AppText.of(context, 'privacy_policy'), privacyPolicyContent),
                        const Divider(height: 1, color: AppColors.cardBorder),
                        _linkRow(Icons.help_outline, AppText.of(context, 'help_faqs'), helpFaqsContent),
                        const Divider(height: 1, color: AppColors.cardBorder),
                        _linkRow(Icons.info_outline, AppText.of(context, 'about_us'), aboutUsContent),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(child: Text('Version 1.0.0 · Prototype', style: TextStyle(fontSize: 11, color: AppColors.textMuted))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
