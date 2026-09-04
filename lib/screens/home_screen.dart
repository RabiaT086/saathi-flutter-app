import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_drawer.dart';
import 'notifications_screen.dart';
import 'emergency_screen.dart';
import 'report_screen.dart';
import 'my_cases_screen.dart';
import 'evidence_vault_screen.dart';
import 'case_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              CircleAvatar(radius: 16, backgroundColor: fg.withOpacity(0.15), child: Icon(icon, color: fg, size: 18)),
              const SizedBox(height: 10),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: fg)),
              const SizedBox(height: 3),
              Text(subtitle, style: TextStyle(fontSize: 11, color: fg.withOpacity(0.8))),
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
          color: Colors.white,
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
                children: const [
                  Text('How can I help you?', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 14),
                  Text(userName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  Text(userDegree, style: TextStyle(color: Colors.white70, fontSize: 12)),
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
                  title: 'Emergency SOS',
                  subtitle: 'Call 15',
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
                  title: 'Know Your Rights',
                  subtitle: 'Protection Against Harassment Act 2010',
                  bg: Colors.white,
                  fg: AppColors.primaryDark,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _gridCard(context, icon: Icons.report_problem_outlined, title: 'Report Harassment', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportScreen()));
                }),
                _gridCard(context, icon: Icons.folder_outlined, title: 'My Cases', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCasesScreen()));
                }),
                _gridCard(context, icon: Icons.folder_special_outlined, title: 'Evidence Vault', onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EvidenceVaultScreen()));
                }),
                _gridCard(context, icon: Icons.smart_toy_outlined, title: 'AI Assistant', onTap: () {
                  // Switches to the AI Assistant tab once wired to MainShell's tab controller.
                }),
                _gridCard(context, icon: Icons.contacts_outlined, title: 'Emergency Contact', onTap: () {}),
                _gridCard(context, icon: Icons.share_location_outlined, title: 'Share Live Location', onTap: () {}),
              ],
            ),

            const SizedBox(height: 24),
            const Text('Safety Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
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
                const Text('Latest case', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCasesScreen()));
                  },
                  child: const Text('View all', style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CaseDetailsScreen(
                      caseId: '#HA-2026-001',
                      type: 'Cyber Harassment',
                      date: '2026-08-02 21:40',
                      location: 'Online · Instagram DMs',
                      description: 'An unknown account has been repeatedly sending unwanted messages and comments after I asked them to stop.',
                      priority: 'HIGH',
                      status: 'Investigation',
                    ),
                  ),
                );
              },
              child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('#HA-2026-001', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(20)),
                        child: const Text('Investigation', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('Cyber Harassment · Instagram DMs', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  const Text(
                    'An unknown account has been repeatedly sending unwanted messages...',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
