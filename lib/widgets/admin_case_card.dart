import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';
import '../data_store.dart';

class AdminCaseCard extends StatelessWidget {
  final Map<String, String> caseData;
  final VoidCallback? onStatusUpdated;

  const AdminCaseCard({
    super.key,
    required this.caseData,
    this.onStatusUpdated,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return Colors.blue;
      case 'under review':
        return Colors.amber.shade800;
      case 'investigation':
        return AppColors.primary;
      case 'resolved':
        return Colors.green.shade700;
      case 'closed':
        return Colors.grey.shade600;
      default:
        return AppColors.primary;
    }
  }

  Color _priorityColor(String priority) {
    switch (priority.toUpperCase()) {
      case 'HIGH':
        return AppColors.danger;
      case 'MEDIUM':
        return Colors.amber.shade800;
      case 'LOW':
        return Colors.teal;
      default:
        return AppColors.textSecondary;
    }
  }

  void _openStatusUpdateSheet(BuildContext context) {
    final currentStatus = caseData['status'] ?? 'Submitted';
    final caseId = caseData['id'] ?? '';
    final isUrdu = AppState.isUrdu.value;

    String selectedStatus = currentStatus;
    final remarksController = TextEditingController(text: caseData['remark'] ?? '');

    final availableStatuses = [
      'Submitted',
      'Under Review',
      'Investigation',
      'Resolved',
      'Closed',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isUrdu ? 'کیس کی کارروائی / اسٹیٹس' : 'Case Review & Status',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                            Text(
                              caseId,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Text(
                      isUrdu ? 'مرحلہ منتخب کریں:' : 'Update Case Stage:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableStatuses.map((st) {
                        final isSel = selectedStatus == st;
                        return ChoiceChip(
                          label: Text(st),
                          selected: isSel,
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.chipBackground,
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          onSelected: (_) {
                            setModalState(() {
                              selectedStatus = st;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      AppText.of(context, 'committee_remarks'),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: remarksController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: isUrdu
                            ? 'کمیٹی کے فیصلوں، پیشی کی تاریخ یا کارروائی کی تفصیل لکھیں...'
                            : 'Enter hearing dates, investigation findings or remarks...',
                        hintStyle: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        filled: true,
                        fillColor: AppColors.chipBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.cardBorder),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          DataStore.updateCaseStatus(
                            caseId,
                            selectedStatus,
                            remark: remarksController.text,
                          );
                          Navigator.pop(ctx);
                          onStatusUpdated?.call();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.primaryDark,
                              content: Text(
                                isUrdu
                                    ? '$caseId کا اسٹیٹس تبدیل ہو کر "$selectedStatus" ہو گیا ہے۔'
                                    : '$caseId status updated to "$selectedStatus".',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle_rounded, size: 18),
                        label: Text(AppText.of(context, 'update_status_btn')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
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

  @override
  Widget build(BuildContext context) {
    final id = caseData['id'] ?? '';
    final type = caseData['type'] ?? '';
    final student = caseData['student'] ?? 'Confidential Student';
    final status = caseData['status'] ?? 'Submitted';
    final priority = caseData['priority'] ?? 'MEDIUM';
    final date = caseData['date'] ?? '';
    final location = caseData['location'] ?? '';
    final description = caseData['description'] ?? '';
    final remark = caseData['remark'];

    final statColor = _statusColor(status);
    final priColor = _priorityColor(priority);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppColors.isDark ? 0.3 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: ID + Priority + Status Badges
          Row(
            children: [
              Text(
                id,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: priColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  priority,
                  style: TextStyle(
                    color: priColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: statColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Incident Type
          Text(
            type,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 4),

          // Student Complainant
          Row(
            children: [
              const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                student,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Date & Location
          Row(
            children: [
              const Icon(Icons.schedule_rounded, size: 13, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(date, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              const SizedBox(width: 12),
              const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textMuted),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Description preview
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
          ),

          // Remarks if any
          if (remark != null && remark.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.chipBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.note_alt_outlined, size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Committee: $remark',
                      style: TextStyle(fontSize: 11, color: AppColors.primaryDark, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.cardBorder),
          const SizedBox(height: 8),

          // Action button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _openStatusUpdateSheet(context),
              icon: const Icon(Icons.edit_note_rounded, size: 18),
              label: Text(
                AppText.of(context, 'review_update_status'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
