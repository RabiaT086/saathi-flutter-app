import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';
import '../data_store.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/admin_case_card.dart';
import '../widgets/admin_drawer.dart';
import 'login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final int initialTabIndex;
  final String? initialFilter;

  const AdminDashboardScreen({
    super.key,
    this.initialTabIndex = 0,
    this.initialFilter,
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late int _currentTabIndex;
  late String _selectedFilter;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _filters = [
    'All',
    'Open',
    'High Priority',
    'Emergency',
    'Submitted',
    'Under Review',
    'Investigation',
    'Resolved',
    'Closed',
  ];

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialTabIndex;
    _selectedFilter = widget.initialFilter ?? 'All';
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmLogout(BuildContext context) {
    final isUrdu = AppState.isUrdu.value;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          isUrdu ? 'لاگ آؤٹ کی تصدیق' : 'Confirm Logout',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
        ),
        content: Text(
          isUrdu
              ? 'کیا آپ واقعی ایڈمن / اتھارٹی پورٹل سے لاگ آؤٹ کرنا چاہتے ہیں؟'
              : 'Are you sure you want to log out of the Authority Portal?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isUrdu ? 'منسوخ' : 'Cancel', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            child: Text(isUrdu ? 'لاگ آؤٹ' : 'Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        AppState.listenable,
        DataStore.cases,
        DataStore.emergencyAlerts,
      ]),
      builder: (context, _) {
        final allCases = DataStore.cases.value;
        final allAlerts = DataStore.emergencyAlerts.value;

        return PopScope(
          canPop: _currentTabIndex == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (_currentTabIndex != 0) {
              setState(() {
                _currentTabIndex = 0;
                _selectedFilter = 'All';
                _searchController.clear();
              });
            }
          },
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppColors.background,
            drawer: AdminDrawer(
              onSwitchToCases: () {
                setState(() {
                  _currentTabIndex = 1;
                  _selectedFilter = 'All';
                  _searchController.clear();
                });
              },
            ),
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, allCases.length),
                  Expanded(
                    child: _currentTabIndex == 0
                        ? _buildDashboardTab(context, allCases, allAlerts)
                        : _buildCaseManagementTab(context, allCases, allAlerts),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomNavigation(context),
          ),
        );
      },
    );
  }

  // --- TOP CUSTOM HEADER ---
  Widget _buildHeader(BuildContext context, int totalCount) {
    final isUrdu = AppState.isUrdu.value;
    final isDashboard = _currentTabIndex == 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(bottom: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        children: [
          if (!isDashboard)
            InkWell(
              onTap: () {
                setState(() {
                  _currentTabIndex = 0;
                  _selectedFilter = 'All';
                  _searchController.clear();
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.chipBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_back_rounded,
                      size: 20,
                      color: AppColors.primaryDark,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppText.of(context, 'back'),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: const Icon(Icons.menu_rounded, size: 24),
              color: AppColors.primaryDark,
              tooltip: 'Authority Menu',
            ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDashboard ? const Color(0xFF134E4A) : AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDashboard ? Icons.grid_view_rounded : Icons.folder_open_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isDashboard
                      ? AppText.of(context, 'authority_dashboard')
                      : AppText.of(context, 'case_management'),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  isDashboard
                      ? AppText.of(context, 'anti_harassment_committee')
                      : '$totalCount ${isUrdu ? "شکایات" : "complaints"}',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _confirmLogout(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: AppColors.chipBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 20,
                color: AppColors.danger,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // --- TAB 1: DASHBOARD TAB ---
  Widget _buildDashboardTab(
    BuildContext context,
    List<Map<String, String>> cases,
    List<Map<String, String>> alerts,
  ) {
    final isUrdu = AppState.isUrdu.value;

    final totalComplaints = cases.length;
    final openCases = cases.where((c) {
      final s = (c['status'] ?? '').toLowerCase();
      return s == 'submitted' || s == 'under review' || s == 'investigation';
    }).length;

    final highPriority = cases.where((c) => (c['priority'] ?? '').toUpperCase() == 'HIGH').length;
    final activeAlerts = alerts.where((a) => a['status'] == 'Active').length;

    final countSubmitted = cases.where((c) => (c['status'] ?? '').toLowerCase() == 'submitted').length;
    final countUnderReview = cases.where((c) => (c['status'] ?? '').toLowerCase() == 'under review').length;
    final countInvestigation = cases.where((c) => (c['status'] ?? '').toLowerCase() == 'investigation').length;
    final countResolved = cases.where((c) => (c['status'] ?? '').toLowerCase() == 'resolved').length;
    final countClosed = cases.where((c) => (c['status'] ?? '').toLowerCase() == 'closed').length;

    final needsAttention = cases.where((c) {
      final isHigh = (c['priority'] ?? '').toUpperCase() == 'HIGH';
      final isSubmitted = (c['status'] ?? '').toLowerCase() == 'submitted';
      return isHigh || isSubmitted;
    }).take(3).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 2x2 Stats Grid with Colored Frames
          Row(
            children: [
              // Total Complaints: Theme Blue
              Expanded(
                child: AdminStatCard(
                  title: AppText.of(context, 'total_complaints'),
                  value: '$totalComplaints',
                  icon: Icons.article_outlined,
                  iconColor: const Color(0xFF2563EB),
                  borderColor: const Color(0xFF2563EB),
                  borderWidth: 1.8,
                  backgroundColor: AppColors.isDark
                      ? const Color(0xFF131D2E)
                      : const Color(0xFFF0F7FF),
                  valueColor: const Color(0xFF1D4ED8),
                  glowColor: const Color(0xFF2563EB).withValues(alpha: 0.12),
                  onTap: () {
                    setState(() {
                      _currentTabIndex = 1;
                      _selectedFilter = 'All';
                      _searchController.clear();
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Open Cases: Theme Green
              Expanded(
                child: AdminStatCard(
                  title: AppText.of(context, 'open_cases'),
                  value: '$openCases',
                  icon: Icons.trending_up_rounded,
                  iconColor: const Color(0xFF16A34A),
                  borderColor: const Color(0xFF16A34A),
                  borderWidth: 1.8,
                  backgroundColor: AppColors.isDark
                      ? const Color(0xFF11261B)
                      : const Color(0xFFF0FDF4),
                  valueColor: const Color(0xFF15803D),
                  glowColor: const Color(0xFF16A34A).withValues(alpha: 0.12),
                  onTap: () {
                    setState(() {
                      _currentTabIndex = 1;
                      _selectedFilter = 'Open';
                      _searchController.clear();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // High Priority: Orange/Amber border/frame (Stands Out)
              Expanded(
                child: AdminStatCard(
                  title: AppText.of(context, 'high_priority'),
                  value: '$highPriority',
                  icon: Icons.warning_amber_rounded,
                  iconColor: const Color(0xFFEA580C),
                  borderColor: const Color(0xFFF59E0B),
                  borderWidth: 2.4,
                  backgroundColor: AppColors.isDark
                      ? const Color(0xFF2C190A)
                      : const Color(0xFFFFF7ED),
                  valueColor: const Color(0xFFC2410C),
                  glowColor: const Color(0xFFF59E0B).withValues(alpha: 0.28),
                  badgeText: isUrdu ? 'اہم' : 'HIGH',
                  onTap: () {
                    setState(() {
                      _currentTabIndex = 1;
                      _selectedFilter = 'High Priority';
                      _searchController.clear();
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Emergency Alerts: Red border/frame (Stands Out)
              Expanded(
                child: AdminStatCard(
                  title: AppText.of(context, 'emergency_alerts'),
                  value: '$activeAlerts',
                  icon: Icons.crisis_alert_rounded,
                  iconColor: const Color(0xFFDC2626),
                  borderColor: const Color(0xFFDC2626),
                  borderWidth: 2.4,
                  backgroundColor: AppColors.isDark
                      ? const Color(0xFF2F1012)
                      : const Color(0xFFFEF2F2),
                  valueColor: const Color(0xFFDC2626),
                  glowColor: const Color(0xFFDC2626).withValues(alpha: 0.32),
                  badgeText: isUrdu ? 'ایمرجنسی' : 'SOS',
                  onTap: () {
                    setState(() {
                      _currentTabIndex = 1;
                      _selectedFilter = 'Emergency';
                      _searchController.clear();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildCasesByStatusSection(
            context,
            submitted: countSubmitted,
            underReview: countUnderReview,
            investigation: countInvestigation,
            resolved: countResolved,
            closed: countClosed,
          ),
          const SizedBox(height: 20),
          _buildHarassmentTypesSection(context, cases),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppText.of(context, 'needs_attention'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentTabIndex = 1;
                    _selectedFilter = 'All';
                    _searchController.clear();
                  });
                },
                child: Row(
                  children: [
                    Text(
                      AppText.of(context, 'manage_all'),
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (needsAttention.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Center(
                child: Text(
                  isUrdu ? 'کوئی فوری توجہ طلب کیس نہیں ہے۔' : 'All urgent complaints have been addressed!',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ),
            )
          else
            ...needsAttention.map((c) => AdminCaseCard(caseData: c)),
          const SizedBox(height: 20),
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
                Text(
                  AppText.of(context, 'recent_activity'),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${AppText.of(context, "resolved_to_date")}: $countResolved of $totalComplaints ${isUrdu ? "شکایات" : "complaints"}',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  // --- CASES BY STATUS ARCHED PILLS ---
  Widget _buildCasesByStatusSection(
    BuildContext context, {
    required int submitted,
    required int underReview,
    required int investigation,
    required int resolved,
    required int closed,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppColors.isDark ? 0.3 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppText.of(context, 'cases_by_status'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatusPill(context, 'Submitted', submitted),
              _buildStatusPill(context, 'Under Review', underReview),
              _buildStatusPill(context, 'Investigation', investigation),
              _buildStatusPill(context, 'Resolved', resolved),
              _buildStatusPill(context, 'Closed', closed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(BuildContext context, String statusLabel, int count) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentTabIndex = 1;
          _selectedFilter = statusLabel;
          _searchController.clear();
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 58,
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 22,
              width: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF0D9488),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(14),
                  bottom: Radius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              statusLabel,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HARASSMENT TYPES SECTION ---
  Widget _buildHarassmentTypesSection(BuildContext context, List<Map<String, String>> cases) {
    final types = [
      'Verbal Harassment',
      'Cyber Harassment',
      'Physical Harassment',
      'Sexual Harassment',
      'Bullying',
    ];

    final total = cases.isEmpty ? 1 : cases.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppColors.isDark ? 0.3 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppText.of(context, 'harassment_types'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 14),
          ...types.map((t) {
            final count = cases.where((c) => (c['type'] ?? '').toLowerCase() == t.toLowerCase()).length;
            final ratio = cases.isEmpty ? 0.0 : count / total;
            final pct = cases.isEmpty ? 0 : (ratio * 100).toInt();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColors.primaryDark)),
                      Text('$count ($pct%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 7,
                      backgroundColor: AppColors.chipBackground,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        count > 0 ? AppColors.primary : AppColors.cardBorder,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
  // --- TAB 2: CASE MANAGEMENT TAB ---
  Widget _buildCaseManagementTab(
    BuildContext context,
    List<Map<String, String>> allCases,
    List<Map<String, String>> allAlerts,
  ) {
    final isUrdu = AppState.isUrdu.value;
    final activeAlerts = allAlerts.where((a) => a['status'] == 'Active').toList();

    // Filter by category chip
    var filtered = allCases;
    if (_selectedFilter == 'Open') {
      filtered = filtered.where((c) {
        final s = (c['status'] ?? '').toLowerCase();
        return s == 'submitted' || s == 'under review' || s == 'investigation';
      }).toList();
    } else if (_selectedFilter == 'High Priority') {
      filtered = filtered.where((c) => (c['priority'] ?? '').toUpperCase() == 'HIGH').toList();
    } else if (_selectedFilter == 'Emergency') {
      filtered = filtered.where((c) {
        final desc = (c['description'] ?? '').toLowerCase();
        final type = (c['type'] ?? '').toLowerCase();
        final priority = (c['priority'] ?? '').toUpperCase();
        return priority == 'HIGH' || desc.contains('emergency') || desc.contains('urgent') || type.contains('physical');
      }).toList();
    } else if (_selectedFilter != 'All') {
      filtered = filtered.where((c) {
        return (c['status'] ?? '').toLowerCase() == _selectedFilter.toLowerCase();
      }).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((c) {
        final id = (c['id'] ?? '').toLowerCase();
        final student = (c['student'] ?? '').toLowerCase();
        final type = (c['type'] ?? '').toLowerCase();
        final desc = (c['description'] ?? '').toLowerCase();
        final loc = (c['location'] ?? '').toLowerCase();
        final priority = (c['priority'] ?? '').toLowerCase();
        final status = (c['status'] ?? '').toLowerCase();
        return id.contains(_searchQuery) ||
            student.contains(_searchQuery) ||
            type.contains(_searchQuery) ||
            desc.contains(_searchQuery) ||
            loc.contains(_searchQuery) ||
            priority.contains(_searchQuery) ||
            status.contains(_searchQuery);
      }).toList();
    }

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppText.of(context, 'search_cases_hint'),
                hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textMuted),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),

        // Horizontal Status Filter Chips
        SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final isSelected = _selectedFilter.toLowerCase() == filter.toLowerCase();

              Color chipActiveColor = const Color(0xFF0D9488);
              if (filter == 'Emergency') {
                chipActiveColor = const Color(0xFFDC2626);
              } else if (filter == 'High Priority') {
                chipActiveColor = const Color(0xFFEA580C);
              } else if (filter == 'Open') {
                chipActiveColor = const Color(0xFF16A34A);
              }

              String displayFilter = filter;
              if (isUrdu) {
                switch (filter) {
                  case 'All':
                    displayFilter = 'تمام';
                    break;
                  case 'Open':
                    displayFilter = 'کھلے کیسز';
                    break;
                  case 'High Priority':
                    displayFilter = 'ہائی پرائرٹی';
                    break;
                  case 'Emergency':
                    displayFilter = 'ایمرجنسی';
                    break;
                  case 'Submitted':
                    displayFilter = 'جمع شدہ';
                    break;
                  case 'Under Review':
                    displayFilter = 'زیر جائزہ';
                    break;
                  case 'Investigation':
                    displayFilter = 'تحقیقات';
                    break;
                  case 'Resolved':
                    displayFilter = 'حل شدہ';
                    break;
                  case 'Closed':
                    displayFilter = 'بند شدہ';
                    break;
                }
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? chipActiveColor : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isSelected ? chipActiveColor : AppColors.cardBorder,
                      width: 1.2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      displayFilter,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // Complaints & Emergency Alerts List
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
            children: [
              if (_selectedFilter == 'Emergency') ...[
                if (activeAlerts.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.crisis_alert_rounded, color: Color(0xFFDC2626), size: 18),
                        const SizedBox(width: 6),
                        Text(
                          isUrdu ? 'لائیو ایمرجنسی ایس او ایس الرٹس' : 'Live Emergency SOS Alerts',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...activeAlerts.map((a) => _buildEmergencyAlertCard(context, a, isUrdu)),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 8),
                    child: Text(
                      isUrdu ? 'دیگر فوری شکایات' : 'Other Urgent Complaints',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ] else ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16A34A).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF16A34A).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF16A34A), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isUrdu
                                ? 'کوئی فعال ایمرجنسی الرٹ نہیں ہے۔ نیچے فوری شکایات ملاحظہ کریں۔'
                                : 'No active SOS alerts. Showing urgent complaints below.',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF16A34A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],

              if (filtered.isEmpty && (_selectedFilter != 'Emergency' || activeAlerts.isEmpty))
                _buildEmptyState(context)
              else
                ...filtered.map(
                  (c) => AdminCaseCard(
                    caseData: c,
                    onStatusUpdated: () => setState(() {}),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // --- EMERGENCY ALERT CARD IN CASE MANAGEMENT ---
  Widget _buildEmergencyAlertCard(BuildContext context, Map<String, String> alert, bool isUrdu) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.isDark ? const Color(0xFF2F1012) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDC2626), width: 1.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC2626).withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.crisis_alert_rounded, color: Color(0xFFDC2626), size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert['student'] ?? 'Student',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Text(
                      'ID: ${alert['id'] ?? ''}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'LIVE SOS',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  alert['location'] ?? '',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          if (alert['phone'] != null && alert['phone']!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.phone_outlined, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text(
                  alert['phone']!,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                alert['time'] ?? '',
                style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  DataStore.resolveAlert(alert['id'] ?? '');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isUrdu ? 'الرٹ حل شدہ قرار دے دیا گیا' : 'Alert marked as resolved'),
                      backgroundColor: const Color(0xFF16A34A),
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                label: Text(isUrdu ? 'حل کریں' : 'Resolve'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- EMPTY STATE CARD ---
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_rounded, size: 36, color: AppColors.textMuted.withValues(alpha: 0.6)),
              const SizedBox(height: 12),
              Text(
                AppText.of(context, 'no_complaints_match'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- BOTTOM NAVIGATION BAR ---
  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: _buildBottomNavItem(
                index: 0,
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard_rounded,
                label: AppText.of(context, 'dashboard'),
              ),
            ),
            Expanded(
              child: _buildBottomNavItem(
                index: 1,
                icon: Icons.folder_open_outlined,
                activeIcon: Icons.folder_rounded,
                label: AppText.of(context, 'case_management'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _currentTabIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}