import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';
import 'evidence_vault_screen.dart';

class CaseTimelineEntry {
  final String status;
  final String date;
  final String note;

  const CaseTimelineEntry({required this.status, required this.date, required this.note});
}

class CaseDetailsScreen extends StatelessWidget {
  final String caseId;
  final String type;
  final String date;
  final String location;
  final String description;
  final String priority;
  final String status;

  const CaseDetailsScreen({
    super.key,
    required this.caseId,
    required this.type,
    required this.date,
    required this.location,
    required this.description,
    required this.priority,
    required this.status,
  });

  // Placeholder timeline until this is wired up to real case-update data.
  List<CaseTimelineEntry> get timeline => [
        CaseTimelineEntry(status: 'Submitted', date: date, note: 'Complaint received and assigned a case ID.'),
        const CaseTimelineEntry(status: 'Under Review', date: '2026-08-03 09:15', note: 'Anti-Harassment Committee reviewed the initial report.'),
        CaseTimelineEntry(status: status, date: '2026-08-04 11:00', note: 'Case moved to $status by the committee.'),
      ];

  Color get _statusColor {
    switch (status) {
      case 'Resolved':
        return Colors.green;
      case 'Closed':
        return AppColors.textMuted;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.listenable,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(caseId, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(AppText.of(context, 'case_details'), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
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
                        Text(type, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(20)),
                          child: Text(status, style: TextStyle(fontSize: 11, color: _statusColor, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _infoRow(Icons.calendar_today_outlined, date),
                    _infoRow(Icons.location_on_outlined, location),
                    _infoRow(Icons.priority_high_rounded, '$priority priority'),
                    const Divider(height: 24, color: AppColors.cardBorder),
                    Text(AppText.of(context, 'description'), style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                    const SizedBox(height: 6),
                    Text(description, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppText.of(context, 'evidence'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EvidenceVaultScreen()));
                    },
                    child: Text(AppText.of(context, 'view_all'), style: const TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.folder_special_outlined, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('2 ${AppText.of(context, 'files_linked')}', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textMuted),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Text(AppText.of(context, 'case_timeline'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: List.generate(timeline.length, (index) {
                    final entry = timeline[index];
                    final isLast = index == timeline.length - 1;
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isLast ? AppColors.primary : AppColors.cardBorder,
                                  border: Border.all(color: AppColors.primary, width: isLast ? 0 : 2),
                                ),
                              ),
                              if (!isLast)
                                Expanded(
                                  child: Container(width: 2, color: AppColors.cardBorder),
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(entry.status, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                                  Text(entry.date, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                  const SizedBox(height: 4),
                                  Text(entry.note, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
      },
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
