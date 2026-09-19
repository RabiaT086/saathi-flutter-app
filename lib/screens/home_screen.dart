import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_drawer.dart';
import '../app_state.dart';
import '../data_store.dart';
import 'notifications_screen.dart';
import 'emergency_screen.dart';
import 'report_screen.dart';
import 'my_cases_screen.dart';
import 'evidence_vault_screen.dart';
import 'case_details_screen.dart';
import 'know_your_rights_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onOpenAIAssistant;
  const HomeScreen({super.key, this.onOpenAIAssistant});

  // Placeholder user info until this is wired up to real auth/profile data.
  static const String userName = 'Areesha Naz';
  static const String userDegree = 'BS Computer Science (8th Semester)';

  Widget _topCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required Color bg, required Color fg, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 16, backgroundColor: fg.withValues(alpha: 0.15), child: Icon(icon, color: fg, size: 18)),
              const SizedBox(height: 10),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: fg)),
              const SizedBox(height: 3),
              Text(subtitle, style: TextStyle(fontSize: 11, color: fg.withValues(alpha: 0.8))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gridCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 26),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _statusRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(radius: 16, backgroundColor: AppColors.chipBackground, child: Icon(icon, size: 16, color: AppColors.primary)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.listenable,
      builder: (context, _) {
        return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Saathi', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
            },
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.primaryDark),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting card: name + department
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppText.of(context, 'how_can_i_help'), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  const Text(userName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  const Text(userDegree, style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Emergency SOS / Know Your Rights
            Row(
              children: [
                _topCard(
                  context,
                  icon: Icons.crisis_alert,
                  title: AppText.of(context, 'emergency_sos'),
                  subtitle: AppText.of(context, 'call_15'),
                  bg: AppColors.danger,
                  fg: Colors.white,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyScreen()));
                  },
                ),
                const SizedBox(width: 12),
                _topCard(
                  context,
                  icon: Icons.balance_outlined,
                  title: AppText.of(context, 'know_your_rights'),
                  subtitle: 'Protection Against Harassment Act 2010',
                  bg: AppColors.cardBackground,
                  fg: AppColors.primaryDark,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const KnowYourRightsScreen()));
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
            Text(AppText.of(context, 'quick_actions'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _gridCard(context, icon: Icons.report_problem_outlined, title: AppText.of(context, 'report_harassment'), onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportScreen()));
                }),
                _gridCard(context, icon: Icons.folder_outlined, title: AppText.of(context, 'my_cases'), onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCasesScreen()));
                }),
                _gridCard(context, icon: Icons.folder_special_outlined, title: AppText.of(context, 'evidence_vault'), onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EvidenceVaultScreen()));
                }),
                _gridCard(context, icon: Icons.smart_toy_outlined, title: AppText.of(context, 'ai_assistant'), onTap: () {
                  onOpenAIAssistant?.call();
                }),
                _gridCard(context, icon: Icons.contacts_outlined, title: AppText.of(context, 'emergency_contact'), onTap: () => _showContactsSheet(context)),
                _gridCard(context, icon: Icons.share_location_outlined, title: AppText.of(context, 'share_live_location'), onTap: () => _shareLocation(context)),
              ],
            ),

            const SizedBox(height: 24),
            Text(AppText.of(context, 'safety_status'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  _statusRow(Icons.contacts_outlined, 'Emergency Contact Added', '2 saved'),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _statusRow(Icons.vibration, 'Shake Detection', 'Enabled'),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _statusRow(Icons.location_on_outlined, 'Location Permission', 'Granted while using app'),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppText.of(context, 'latest_case'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCasesScreen()));
                  },
                  child: Text(AppText.of(context, 'view_all'), style: const TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder<List<Map<String, String>>>(
              valueListenable: DataStore.cases,
              builder: (context, cases, _) {
                if (cases.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: const Text('No cases yet.', style: TextStyle(color: AppColors.textMuted)),
                  );
                }
                final latest = cases.first;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CaseDetailsScreen(
                          caseId: latest['id']!,
                          type: latest['type']!,
                          date: latest['date']!,
                          location: latest['location']!,
                          description: latest['description']!,
                          priority: latest['priority']!,
                          status: latest['status']!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(latest['id']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(20)),
                              child: Text(latest['status']!, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('${latest['type']} · ${latest['location']}', style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(
                          latest['description']!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
        );
      },
    );
  }

  void _showContactsSheet(BuildContext context) {
    // Placeholder contacts until Profile's contact list is wired to shared/real data.
    final contacts = [
      {'name': 'Rabia Tabassum', 'relation': 'Sister', 'phone': '+92 301 7654321'},
      {'name': 'Campus Security Office', 'relation': 'University', 'phone': '+92 21 99261300'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Emergency Contacts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
              const SizedBox(height: 14),
              ...contacts.map((c) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(backgroundColor: AppColors.chipBackground, child: Icon(Icons.call, color: AppColors.primary, size: 18)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                              Text('${c['relation']} · ${c['phone']}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 6),
              const Text(
                'Manage contacts from Profile > Emergency contacts.',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareLocation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Live Location'),
        content: const Text(
          'Your live location will be shared with your emergency contacts and Campus Security for the next hour.\n\n'
          'Native module: real GPS sharing uses the geolocator package in the Flutter build.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Live location sharing started.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }
}
