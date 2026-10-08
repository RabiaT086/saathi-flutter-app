import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';
import '../data_store.dart';
import 'case_details_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  IconData _getIconForType(String? type) {
    switch (type) {
      case 'case_update':
        return Icons.assignment_outlined;
      case 'resolved':
        return Icons.check_circle_outline;
      case 'emergency':
        return Icons.warning_amber_rounded;
      default:
        return Icons.notifications_active_outlined;
    }
  }

  Color _getColorForType(String? type) {
    switch (type) {
      case 'case_update':
        return AppColors.primary;
      case 'resolved':
        return Colors.green;
      case 'emergency':
        return AppColors.danger;
      default:
        return AppColors.primaryDark;
    }
  }

  void _openCase(BuildContext context, String caseId) {
    final caseList = DataStore.cases.value;

    final match = caseList.firstWhere(
      (c) => c['id'] == caseId,
      orElse: () => {},
    );

    if (match.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CaseDetailsScreen(
            caseId: match['id'] ?? caseId,
            type: match['type'] ?? 'Harassment Report',
            date: match['date'] ?? '',
            location: match['location'] ?? '',
            description: match['description'] ?? '',
            priority: match['priority'] ?? 'MEDIUM',
            status: match['status'] ?? 'Submitted',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.listenable,
      builder: (context, _) {
        return ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: DataStore.notifications,
          builder: (context, notifications, _) {
            final unreadCount =
                notifications.where((n) => n['isRead'] == false).length;

            return Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: Column(
                  children: [
                    // Header Banner
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primaryDark,
                              AppColors.primary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppText.of(context, 'notifications'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  unreadCount == 0
                                      ? 'All caught up'
                                      : '$unreadCount unread notification${unreadCount > 1 ? "s" : ""}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            if (notifications.isNotEmpty)
                              IconButton(
                                onPressed: () {
                                  DataStore.clearNotifications();
                                },
                                tooltip: 'Clear All',
                                icon: const Icon(
                                  Icons.delete_sweep_outlined,
                                  color: Colors.white70,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Notifications List or Empty State
                    Expanded(
                      child: notifications.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.notifications_none_rounded,
                                    size: 60,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    AppText.of(
                                      context,
                                      'no_notifications',
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Case status changes and alerts will appear here.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              itemCount: notifications.length,
                              separatorBuilder: (context, _) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final notif = notifications[index];
                                final type = notif['type']?.toString();
                                final caseId = notif['caseId']?.toString();
                                final isRead = notif['isRead'] == true;

                                final notificationColor =
                                    _getColorForType(type);

                                return Card(
                                  elevation: 0,
                                  color: isRead
                                      ? AppColors.cardBackground
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: BorderSide(
                                      color: isRead
                                          ? AppColors.cardBorder
                                          : AppColors.primary
                                              .withValues(alpha: 0.4),
                                      width: isRead ? 1 : 1.5,
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: notificationColor
                                          .withValues(alpha: 0.12),
                                      child: Icon(
                                        _getIconForType(type),
                                        color: notificationColor,
                                        size: 20,
                                      ),
                                    ),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            notif['title'] ?? '',
                                            style: TextStyle(
                                              fontWeight: isRead
                                                  ? FontWeight.w600
                                                  : FontWeight.bold,
                                              fontSize: 14,
                                              color: AppColors.primaryDark,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          notif['time'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notif['message'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color:
                                                  AppColors.textSecondary,
                                              height: 1.3,
                                            ),
                                          ),
                                          if (caseId != null &&
                                              caseId.isNotEmpty)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                top: 8,
                                              ),
                                              child: InkWell(
                                                onTap: () => _openCase(
                                                  context,
                                                  caseId,
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'View Case ($caseId)',
                                                      style:
                                                          const TextStyle(
                                                        fontSize: 12,
                                                        color: AppColors
                                                            .primary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const Icon(
                                                      Icons
                                                          .arrow_forward_ios,
                                                      size: 10,
                                                      color: AppColors.primary,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}