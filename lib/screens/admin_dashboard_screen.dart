import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/admin_action_card.dart';
import 'admin_cases_screen.dart';
import 'notifications_screen.dart';
import 'login_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Admin Dashboard', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome, Admin 👋', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            const SizedBox(height: 8),
            const Text('Manage reports, cases and notifications.', style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
            const SizedBox(height: 25),
            const Row(
              children: [
                Expanded(child: AdminStatCard(title: 'Total Cases', value: '24', icon: Icons.folder_outlined)),
                SizedBox(width: 12),
                Expanded(child: AdminStatCard(title: 'Pending', value: '8', icon: Icons.pending_actions_outlined)),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(child: AdminStatCard(title: 'In Review', value: '10', icon: Icons.manage_search_outlined)),
                SizedBox(width: 12),
                Expanded(child: AdminStatCard(title: 'Resolved', value: '6', icon: Icons.check_circle_outline)),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Admin Actions', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            const SizedBox(height: 15),
            AdminActionCard(
              icon: Icons.folder_open_outlined,
              title: 'Manage Cases',
              subtitle: 'Review and update reported cases',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminCasesScreen()));
              },
            ),
            AdminActionCard(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'View system and case notifications',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
              },
            ),
            AdminActionCard(
              icon: Icons.people_outline,
              title: 'Users',
              subtitle: 'Manage registered students',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
