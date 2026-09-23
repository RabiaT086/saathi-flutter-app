import 'package:flutter/material.dart';
import 'admin_dashboard_screen.dart';

/// Legacy screen wrapper that redirects cleanly to the unified Case Management tab
/// of the Authority Dashboard.
class AdminCasesScreen extends StatelessWidget {
  final String? initialFilter;

  const AdminCasesScreen({super.key, this.initialFilter});

  @override
  Widget build(BuildContext context) {
    return AdminDashboardScreen(
      initialTabIndex: 1,
      initialFilter: initialFilter,
    );
  }
}
