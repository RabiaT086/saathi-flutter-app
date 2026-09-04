import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/admin_case_card.dart';

class AdminCasesScreen extends StatelessWidget {
  const AdminCasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Manage Cases', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          AdminCaseCard(id: 'SA-2026-001', type: 'Verbal Harassment', student: 'Student 01', status: 'In Review'),
          SizedBox(height: 15),
          AdminCaseCard(id: 'SA-2026-002', type: 'Online Harassment', student: 'Student 02', status: 'Pending'),
          SizedBox(height: 15),
          AdminCaseCard(id: 'SA-2026-003', type: 'Bullying', student: 'Student 03', status: 'Resolved'),
        ],
      ),
    );
  }
}
