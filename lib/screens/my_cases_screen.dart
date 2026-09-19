import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';
import '../data_store.dart';
import 'case_details_screen.dart';

class MyCasesScreen extends StatefulWidget {
  const MyCasesScreen({super.key});

  @override
  State<MyCasesScreen> createState() => _MyCasesScreenState();
}

class _MyCasesScreenState extends State<MyCasesScreen> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Submitted', 'Under Review', 'Investigation', 'Resolved', 'Closed'];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Map<String, String>>>(
      valueListenable: DataStore.cases,
      builder: (context, cases, _) {
        final filtered = selectedFilter == 'All' ? cases : cases.where((c) => c['status'] == selectedFilter).toList();

        return AnimatedBuilder(
          animation: AppState.listenable,
          builder: (context, _) {
        return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
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
                        Text(AppText.of(context, 'my_cases'), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('${cases.length} ${AppText.of(context, 'complaints_filed')}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  final active = filter == selectedFilter;
                  return GestureDetector(
                    onTap: () => setState(() => selectedFilter = filter),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : AppColors.chipBackground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: active ? Colors.white : AppColors.primaryDark,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text('No cases in "$selectedFilter" yet', style: const TextStyle(color: AppColors.textMuted)),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CaseDetailsScreen(
                                  caseId: item['id']!,
                                  type: item['type']!,
                                  date: item['date']!,
                                  location: item['location']!,
                                  description: item['description']!,
                                  priority: item['priority']!,
                                  status: item['status']!,
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
                                  Text(item['id']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(20)),
                                    child: Text(item['status']!, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('${item['type']} · ${item['date']}', style: const TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              Text(item['description']!, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(color: const Color(0xFFFDECEA), borderRadius: BorderRadius.circular(20)),
                                    child: Text(item['priority']!, style: const TextStyle(fontSize: 10, color: AppColors.danger, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(item['location']!, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                ],
                              ),
                            ],
                          ),
                        ));
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
