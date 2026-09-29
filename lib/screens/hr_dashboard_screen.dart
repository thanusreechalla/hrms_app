import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/pathvision_logo.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PathVision HRMS Official Design Tokens
// ─────────────────────────────────────────────────────────────────────────────
class PVColors {
  static const Color primaryIndigo = Color(0xFF1A237E);
  static const Color secondaryIndigo = Color(0xFF3949AB);
  static const Color accentGold = Color(0xFFF9A825);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFE65100);
  static const Color error = Color(0xFFB71C1C);
  static const Color pageBg = Color(0xFFF5F7FA);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color border = Color(0xFFE2E8F0);
  static const Color softBlue = Color(0xFFE8EAF6);
}

// ─────────────────────────────────────────────────────────────────────────────
// HR Manager Mobile Application Shell
// ─────────────────────────────────────────────────────────────────────────────
class HRDashboardScreen extends StatefulWidget {
  const HRDashboardScreen({super.key});

  @override
  State<HRDashboardScreen> createState() => _HRDashboardScreenState();
}

class _HRDashboardScreenState extends State<HRDashboardScreen> {
  int _currentTab = 0;

  // User Profile State
  String _userName = 'Sarah Jenkins';
  String _userRoleTitle = 'Lead HR Manager';
  String _userInitials = 'SJ';
  Color _userDpColor = const Color(0xFF00695C);
  String _userDpUrl = '';

  String _computeInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return 'SJ';
    if (parts.length == 1) return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  // Filter States
  String _leaveTimeframe = 'This Month';
  String _peopleFilter = 'All';
  String _approvalFilter = 'All';
  String _recruitmentTab = 'Jobs';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PVColors.pageBg,
      body: Column(
        children: [
          // Top Executive Header
          _buildTopAppBar(),

          // Active Tab Content
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                _buildHomeTab(),
                _buildPeopleTab(),
                _buildRecruitmentTab(),
                _buildApprovalsTab(),
                _buildMoreTab(),
              ],
            ),
          ),
        ],
      ),

      // Floating Quick Action Button
      floatingActionButton: _buildFloatingQuickActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // Persistent 5-Tab Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // TOP APP BAR
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildTopAppBar() {
    return Container(
      decoration: const BoxDecoration(
        color: PVColors.primaryIndigo,
        boxShadow: [
          BoxShadow(
            color: Color(0x281A237E),
            blurRadius: 14,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Row(
            children: [
              // Round Logo Badge
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(3),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/pathvision_logo.jpeg',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const PathVisionLogo(size: 32),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title & Date & Role Badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Good Morning, ${_userName.split(' ').first}',
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: PVColors.accentGold,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'HR MANAGER',
                            style: GoogleFonts.poppins(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF3E2723),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Friday, 21 August 2026 • People Operations',
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // Global Search
              IconButton(
                onPressed: _showGlobalSearchSheet,
                icon: const Icon(Icons.search_rounded, color: Colors.white, size: 21),
                tooltip: 'Global Search',
              ),

              // Notification Center with Badge
              Stack(
                children: [
                  IconButton(
                    onPressed: _showNotificationSheet,
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 21),
                    tooltip: 'HR Alerts',
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: PVColors.accentGold,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),

              // Profile Avatar
              GestureDetector(
                onTap: _showProfileSheet,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _userDpColor.withAlpha(50),
                    shape: BoxShape.circle,
                    border: Border.all(color: PVColors.accentGold, width: 1.5),
                  ),
                  child: ClipOval(
                    child: _userDpUrl.isNotEmpty
                        ? Image.network(_userDpUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Center(
                            child: Text(
                              _userInitials,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _userDpColor),
                            ),
                          ))
                        : Center(
                            child: Text(
                              _userInitials,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _userDpColor),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // TAB 1: HR DASHBOARD (HOME)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HR Operations Status Banner
          _buildHRStatusBanner(),

          const SizedBox(height: 16),

          // 4 PRD Defined HR KPI Cards
          _buildSectionHeader('HR Key Performance Indicators', Icons.speed_rounded),
          const SizedBox(height: 10),
          _buildHRKpiCarousel(),

          const SizedBox(height: 18),

          // Quick HR Actions (8 Actions Grid)
          _buildSectionHeader('Quick HR Actions', Icons.bolt_rounded),
          const SizedBox(height: 10),
          _buildQuickActionsGrid(),

          const SizedBox(height: 18),

          // Leave Utilization Analytics
          _buildSectionHeader('Leave Utilization Analytics', Icons.pie_chart_rounded),
          const SizedBox(height: 10),
          _buildLeaveUtilizationCard(),

          const SizedBox(height: 18),

          // Recruitment Pipeline
          _buildSectionHeader('Recruitment Pipeline Funnel', Icons.filter_alt_rounded),
          const SizedBox(height: 10),
          _buildRecruitmentPipelineCard(),

          const SizedBox(height: 18),

          // Upcoming HR Actions & Deadlines
          _buildSectionHeader('Upcoming Actions & Deadlines', Icons.event_available_rounded),
          const SizedBox(height: 10),
          _buildUpcomingActionsCard(),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHRStatusBanner() {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: PVColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: PVColors.border),
          boxShadow: [
            BoxShadow(
              color: PVColors.primaryIndigo.withAlpha(8),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.people_alt_rounded, color: PVColors.success, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Workforce Overview: 256 Active',
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: PVColors.textPrimary),
                  ),
                  Text(
                    '42 Interns • 12 New Joinees • 96.4% Attendance',
                    style: GoogleFonts.poppins(fontSize: 11, color: PVColors.textSecondary),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: PVColors.softBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '7 Pending',
                style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: PVColors.primaryIndigo),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // 4 HR KPI CARDS (PRD DEFINED)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildHRKpiCarousel() {
    final hrKpis = [
      {
        'title': 'New Joiners This Month',
        'value': '12',
        'sub': '+25% vs last month',
        'icon': Icons.person_add_alt_1_rounded,
        'color': PVColors.primaryIndigo,
        'actionText': 'View Details →',
        'onTap': () => setState(() => _currentTab = 1),
      },
      {
        'title': 'Offboarding & Exits',
        'value': '02',
        'sub': '1 upcoming exit this week',
        'icon': Icons.exit_to_app_rounded,
        'color': PVColors.warning,
        'actionText': 'View Pipeline →',
        'onTap': () => _showOffboardingSheet(),
      },
      {
        'title': 'Pending Leave Approvals',
        'value': '07',
        'sub': '3 urgent SLA < 12h',
        'icon': Icons.assignment_late_rounded,
        'color': PVColors.secondaryIndigo,
        'actionText': 'Approve Now →',
        'onTap': () => setState(() => _currentTab = 3),
      },
      {
        'title': 'Document Expiry Alerts',
        'value': '04',
        'sub': '2 critical within 7 days',
        'icon': Icons.warning_amber_rounded,
        'color': PVColors.error,
        'actionText': 'View Alerts →',
        'onTap': () => _showDocumentVaultSheet(),
      },
    ];

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: hrKpis.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = hrKpis[index];
          final color = item['color'] as Color;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: item['onTap'] as VoidCallback,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 175,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: PVColors.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withAlpha(35)),
                  boxShadow: [
                    BoxShadow(
                      color: PVColors.primaryIndigo.withAlpha(6),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['title'] as String,
                            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: PVColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(item['icon'] as IconData, size: 16, color: color),
                      ],
                    ),
                    Text(
                      item['value'] as String,
                      style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w800, color: PVColors.textPrimary),
                    ),
                    Text(
                      item['sub'] as String,
                      style: GoogleFonts.poppins(fontSize: 9.5, color: PVColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item['actionText'] as String,
                      style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: color),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // QUICK ACTIONS GRID (8 TOUCH-FRIENDLY BUTTONS)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildQuickActionsGrid() {
    final actions = [
      {
        'title': 'Add Employee',
        'icon': Icons.person_add_rounded,
        'color': PVColors.primaryIndigo,
        'action': () => _showAddEmployeeSheet(),
      },
      {
        'title': 'Add Intern',
        'icon': Icons.school_rounded,
        'color': PVColors.secondaryIndigo,
        'action': () => _showAddInternSheet(),
      },
      {
        'title': 'Create Job',
        'icon': Icons.work_outline_rounded,
        'color': const Color(0xFF00695C),
        'action': () => _showCreateJobSheet(),
      },
      {
        'title': 'Schedule Interview',
        'icon': Icons.calendar_month_rounded,
        'color': const Color(0xFF6A1B9A),
        'action': () => setState(() => _currentTab = 2),
      },
      {
        'title': 'Approve Leave',
        'icon': Icons.approval_rounded,
        'color': PVColors.success,
        'action': () => setState(() => _currentTab = 3),
      },
      {
        'title': 'Attendance Reg.',
        'icon': Icons.access_time_rounded,
        'color': PVColors.warning,
        'action': () => _showAttendanceRegSheet(),
      },
      {
        'title': 'Upload Document',
        'icon': Icons.upload_file_rounded,
        'color': const Color(0xFF0277BD),
        'action': () => _showUploadDocumentSheet(),
      },
      {
        'title': 'Generate Report',
        'icon': Icons.analytics_outlined,
        'color': const Color(0xFF37474F),
        'action': () => setState(() => _currentTab = 4),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.95,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final item = actions[index];
        final color = item['color'] as Color;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              (item['action'] as VoidCallback)();
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: PVColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PVColors.border),
                boxShadow: [
                  BoxShadow(
                    color: PVColors.primaryIndigo.withAlpha(4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: color.withAlpha(16),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item['icon'] as IconData, size: 17, color: color),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item['title'] as String,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 9.5, fontWeight: FontWeight.w600, color: PVColors.textPrimary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // LEAVE UTILIZATION ANALYTICS CARD
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildLeaveUtilizationCard() {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: PVColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PVColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Leave Utilization Breakdown',
                  style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w700, color: PVColors.textPrimary),
                ),
                DropdownButton<String>(
                  value: _leaveTimeframe,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                  style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w600, color: PVColors.secondaryIndigo),
                  items: ['This Month', 'This Quarter', 'This Year'].map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (v) => setState(() => _leaveTimeframe = v!),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Segmented Bar Visualization
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: const [
                    Expanded(flex: 42, child: ColoredBox(color: PVColors.primaryIndigo)),
                    Expanded(flex: 34, child: ColoredBox(color: PVColors.secondaryIndigo)),
                    Expanded(flex: 18, child: ColoredBox(color: PVColors.accentGold)),
                    Expanded(flex: 6, child: ColoredBox(color: PVColors.warning)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Legend Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLeaveLegend('Earned/Annual', '42%', PVColors.primaryIndigo),
                _buildLeaveLegend('Casual Leave', '34%', PVColors.secondaryIndigo),
                _buildLeaveLegend('Sick Leave', '18%', PVColors.accentGold),
                _buildLeaveLegend('Other', '6%', PVColors.warning),
              ],
            ),

            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => _currentTab = 3),
                child: Text('View Full Leave Analytics →', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: PVColors.secondaryIndigo)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveLegend(String label, String pct, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 9, color: PVColors.textSecondary)),
            Text(pct, style: GoogleFonts.poppins(fontSize: 10.5, fontWeight: FontWeight.w700, color: PVColors.textPrimary)),
          ],
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // RECRUITMENT PIPELINE CARD
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildRecruitmentPipelineCard() {
    final stages = [
      {'stage': 'Applied', 'count': '142', 'pct': 1.0, 'color': PVColors.primaryIndigo},
      {'stage': 'Shortlisted', 'count': '68', 'pct': 0.70, 'color': PVColors.secondaryIndigo},
      {'stage': 'Interview', 'count': '24', 'pct': 0.45, 'color': const Color(0xFF0288D1)},
      {'stage': 'Selected', 'count': '14', 'pct': 0.28, 'color': PVColors.accentGold},
      {'stage': 'Offer Extended', 'count': '08', 'pct': 0.16, 'color': const Color(0xFFFB8C00)},
      {'stage': 'Joined', 'count': '06', 'pct': 0.10, 'color': PVColors.success},
    ];

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: PVColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PVColors.border),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Hiring Pipeline', style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w700, color: PVColors.textPrimary)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(6)),
                  child: Text('8 Open Roles', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: PVColors.success)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...stages.map((s) {
              final pct = s['pct'] as double;
              final color = s['color'] as Color;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(s['stage'] as String, style: GoogleFonts.poppins(fontSize: 10.5, fontWeight: FontWeight.w600, color: PVColors.textPrimary)),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFF1F5F9),
                          valueColor: AlwaysStoppedAnimation(color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 26,
                      child: Text(s['count'] as String, textAlign: TextAlign.end, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: PVColors.textPrimary)),
                    ),
                  ],
                ),
              );
            }),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => _currentTab = 2),
                child: Text('Manage Recruitment →', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: PVColors.secondaryIndigo)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // UPCOMING ACTIONS & DEADLINES CARD
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildUpcomingActionsCard() {
    final actions = [
      {
        'type': 'Probation Ending Soon',
        'subject': 'Rahul Kumar — AI Vision Engineer',
        'time': '5 days remaining',
        'priority': 'HIGH',
        'color': PVColors.warning,
      },
      {
        'type': 'Document Expiring',
        'subject': 'Employee ID Proof (David Kim)',
        'time': '12 days remaining',
        'priority': 'MEDIUM',
        'color': PVColors.error,
      },
      {
        'type': 'Technical Interview',
        'subject': 'Priya Sharma — Senior Frontend Role',
        'time': 'Today • 3:30 PM (Google Meet)',
        'priority': 'TODAY',
        'color': PVColors.primaryIndigo,
      },
    ];

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: PVColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PVColors.border),
        ),
        child: Column(
          children: actions.map((a) {
            final color = a['color'] as Color;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: PVColors.border, width: 0.8)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 36,
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(a['type'] as String, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
                            Text(a['priority'] as String, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w800, color: color)),
                          ],
                        ),
                        Text(a['subject'] as String, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: PVColors.textPrimary)),
                        Text(a['time'] as String, style: GoogleFonts.poppins(fontSize: 10, color: PVColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // TAB 2: PEOPLE MANAGEMENT (EMPLOYEES, INTERNS, ORG)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildPeopleTab() {
    final employees = [
      {'name': 'Aarav Patel', 'id': 'PV-1002', 'role': 'Lead Vision Architect', 'dept': 'AI Vision', 'status': 'Active', 'domain': 'C++ / CUDA'},
      {'name': 'Sophia Chen', 'id': 'PV-1008', 'role': 'Senior Fullstack Lead', 'dept': 'Cloud Platform', 'status': 'Active', 'domain': 'Flutter / FastAPI'},
      {'name': 'David Kim', 'id': 'PV-1014', 'role': 'Robotics Systems Lead', 'dept': 'Hardware/ROS', 'status': 'Active', 'domain': 'Embedded C'},
      {'name': 'Aisha Khan', 'id': 'PV-INT-04', 'role': 'Junior AI Vision Intern', 'dept': 'Interns (2026)', 'status': 'Onboarding', 'domain': 'PyTorch'},
      {'name': 'Liam O’Connor', 'id': 'PV-1022', 'role': 'DevOps & SRE Specialist', 'dept': 'Infrastructure', 'status': 'Active', 'domain': 'K8s / Terraform'},
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Employee Directory (256)', style: GoogleFonts.poppins(fontSize: 15.5, fontWeight: FontWeight.w700)),
              ElevatedButton.icon(
                onPressed: _showAddEmployeeSheet,
                icon: const Icon(Icons.add, size: 15),
                label: const Text('Add Employee'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PVColors.primaryIndigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  textStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Search Field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by name, ID, domain, department...',
              hintStyle: GoogleFonts.poppins(fontSize: 11.5, color: PVColors.textSecondary),
              prefixIcon: const Icon(Icons.search_rounded, size: 19, color: PVColors.textSecondary),
              filled: true,
              fillColor: PVColors.cardBg,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: PVColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: PVColors.border)),
            ),
          ),
          const SizedBox(height: 10),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'AI Vision', 'Cloud Platform', 'Interns', 'Hardware', 'Infrastructure'].map((filter) {
                final isSelected = _peopleFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _peopleFilter = filter),
                    selectedColor: PVColors.primaryIndigo,
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 10.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : PVColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Employee Directory Cards
          ...employees.map((emp) {
            return Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: PVColors.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: PVColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: PVColors.softBlue,
                          child: Text(
                            emp['name']!.split(' ').map((e) => e[0]).take(2).join(),
                            style: const TextStyle(fontWeight: FontWeight.w700, color: PVColors.primaryIndigo, fontSize: 11),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(emp['name']!, style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w700, color: PVColors.textPrimary)),
                                  Text(emp['id']!, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: PVColors.secondaryIndigo)),
                                ],
                              ),
                              Text('${emp['role']} • ${emp['dept']}', style: GoogleFonts.poppins(fontSize: 10.5, color: PVColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
                          child: Text(emp['domain']!, style: GoogleFonts.poppins(fontSize: 9.5, fontWeight: FontWeight.w600, color: PVColors.secondaryIndigo)),
                        ),
                        Row(
                          children: [
                            _buildEmployeeQuickAction('Profile', () => _showEmployeeProfileSheet(emp['name']!)),
                            const SizedBox(width: 6),
                            _buildEmployeeQuickAction('Leave', () => _showLeaveBalanceDialog(emp['name']!)),
                            const SizedBox(width: 6),
                            _buildEmployeeQuickAction('Docs', () => _showEmployeeDocumentsDialog(emp['name']!)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmployeeQuickAction(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: PVColors.softBlue,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label, style: GoogleFonts.poppins(fontSize: 9.5, fontWeight: FontWeight.w600, color: PVColors.primaryIndigo)),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // TAB 3: RECRUITMENT HUB (JOBS, CANDIDATES, INTERVIEWS)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildRecruitmentTab() {
    final jobs = [
      {'title': 'Senior AI Vision Architect', 'dept': 'AI Vision', 'openings': '2 Open', 'applicants': '38 Applicants', 'status': 'ACTIVE'},
      {'title': 'Flutter Fullstack Engineer', 'dept': 'Cloud Platform', 'openings': '3 Open', 'applicants': '64 Applicants', 'status': 'ACTIVE'},
      {'title': 'Robotics Embedded C++ Engineer', 'dept': 'Hardware/ROS', 'openings': '1 Open', 'applicants': '19 Applicants', 'status': 'ACTIVE'},
      {'title': 'ML & Vision Research Intern', 'dept': 'Interns (2026)', 'openings': '4 Open', 'applicants': '82 Applicants', 'status': 'ACTIVE'},
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recruitment & Talent Hub', style: GoogleFonts.poppins(fontSize: 15.5, fontWeight: FontWeight.w700)),
              ElevatedButton.icon(
                onPressed: _showCreateJobSheet,
                icon: const Icon(Icons.add, size: 15),
                label: const Text('Create Job'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PVColors.primaryIndigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  textStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Sub-navigation Pills
          Row(
            children: ['Jobs', 'Candidates', 'Interviews'].map((tab) {
              final isSel = _recruitmentTab == tab;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(tab),
                  selected: isSel,
                  onSelected: (v) => setState(() => _recruitmentTab = tab),
                  selectedColor: PVColors.primaryIndigo,
                  labelStyle: TextStyle(
                    fontSize: 11,
                    color: isSel ? Colors.white : PVColors.textPrimary,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Job Listings
          ...jobs.map((j) {
            return Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: PVColors.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: PVColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(j['title']!, style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w700, color: PVColors.textPrimary)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(4)),
                          child: Text(j['status']!, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w800, color: PVColors.success)),
                        ),
                      ],
                    ),
                    Text('${j['dept']} • ${j['openings']}', style: GoogleFonts.poppins(fontSize: 10.5, color: PVColors.textSecondary)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(j['applicants']!, style: GoogleFonts.poppins(fontSize: 10.5, fontWeight: FontWeight.w600, color: PVColors.secondaryIndigo)),
                        OutlinedButton(
                          onPressed: () => _showApplicantsSheet(j['title']!),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2)),
                          child: const Text('View Applicants →', style: TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // TAB 4: APPROVALS INBOX (LEAVE, ATTENDANCE, DOCS)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildApprovalsTab() {
    final approvals = [
      {'title': 'Casual Leave (2 Days)', 'emp': 'Rahul Kumar (AI Eng)', 'sla': '06h remaining', 'priority': 'HIGH', 'reason': 'Family Medical Emergency'},
      {'title': 'Attendance Regularization (Missed Punch)', 'emp': 'Sophia Chen (Fullstack)', 'sla': '14h remaining', 'priority': 'MEDIUM', 'reason': 'Client Onsite Meeting'},
      {'title': 'Sick Leave (3 Days)', 'emp': 'David Kim (Robotics)', 'sla': '22h remaining', 'priority': 'NORMAL', 'reason': 'Doctor Advised Rest'},
      {'title': 'Offer Letter Release Approval', 'emp': 'Candidate: Priya Sharma', 'sla': '08h remaining', 'priority': 'HIGH', 'reason': 'Cleared Technical Round 2'},
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Unified HR Approval Queue', style: GoogleFonts.poppins(fontSize: 15.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),

          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Leave', 'Attendance', 'Recruitment', 'Documents'].map((f) {
                final isSel = _approvalFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(f),
                    selected: isSel,
                    onSelected: (v) => setState(() => _approvalFilter = f),
                    selectedColor: PVColors.primaryIndigo,
                    labelStyle: TextStyle(
                      fontSize: 10.5,
                      color: isSel ? Colors.white : PVColors.textPrimary,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Approval Cards
          ...approvals.map((a) {
            final isHigh = a['priority'] == 'HIGH';

            return Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: PVColors.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isHigh ? PVColors.warning.withAlpha(90) : PVColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(a['title']!, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: PVColors.textPrimary)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: isHigh ? const Color(0xFFFFF3E0) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(a['sla']!, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w700, color: isHigh ? PVColors.warning : PVColors.textSecondary)),
                        ),
                      ],
                    ),
                    Text('Requester: ${a['emp']}', style: GoogleFonts.poppins(fontSize: 10.5, fontWeight: FontWeight.w600, color: PVColors.secondaryIndigo)),
                    Text('Reason: ${a['reason']}', style: GoogleFonts.poppins(fontSize: 10, color: PVColors.textSecondary)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => _showSnackbar('Request Rejected.'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: PVColors.error,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          ),
                          child: const Text('Reject', style: TextStyle(fontSize: 10.5)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _showSnackbar('Leave Request Approved by HR.'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PVColors.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          ),
                          child: const Text('Approve', style: TextStyle(fontSize: 10.5)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // TAB 5: MORE / HR ANALYTICS, DOCUMENTS, LEARNING & REPORTS
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildMoreTab() {
    final modules = [
      {'title': 'Secure HR Document Vault', 'icon': Icons.folder_shared_rounded, 'action': () => _showDocumentVaultSheet()},
      {'title': 'Performance Review Cycles', 'icon': Icons.star_rate_rounded, 'action': () => _showPerformanceDialog()},
      {'title': 'Internship Program & Batches', 'icon': Icons.school_rounded, 'action': () => _showAddInternSheet()},
      {'title': 'Learning & Mandatory Training', 'icon': Icons.menu_book_rounded, 'action': () => _showTrainingDialog()},
      {'title': 'HR Reports & Analytics Center', 'icon': Icons.summarize_rounded, 'action': () => _showReportsExporterDialog()},
      {'title': 'HR Profile & Preferences', 'icon': Icons.account_circle_rounded, 'action': () => _showProfileSheet()},
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('HR Operations & Modules', style: GoogleFonts.poppins(fontSize: 15.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),

          ...modules.map((m) {
            return Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: PVColors.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: PVColors.border),
                ),
                child: InkWell(
                  onTap: m['action'] as VoidCallback,
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Icon(m['icon'] as IconData, color: PVColors.primaryIndigo, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            m['title'] as String,
                            style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w600, color: PVColors.textPrimary),
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: PVColors.textSecondary, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // BOTTOM NAVIGATION BAR (5 Tabs)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x181A237E),
            blurRadius: 16,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomNavItem(0, Icons.dashboard_rounded, 'Home'),
              _buildBottomNavItem(1, Icons.groups_rounded, 'People'),
              _buildBottomNavItem(2, Icons.work_outline_rounded, 'Recruitment'),
              _buildBottomNavItem(3, Icons.fact_check_rounded, 'Approvals'),
              _buildBottomNavItem(4, Icons.more_horiz_rounded, 'More'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    final isSelected = _currentTab == index;
    final color = isSelected ? PVColors.primaryIndigo : PVColors.textSecondary;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _currentTab = index),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 21),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // FLOATING QUICK ACTION BUTTON
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildFloatingQuickActionButton() {
    return FloatingActionButton(
      onPressed: _showQuickActionSheet,
      backgroundColor: PVColors.primaryIndigo,
      elevation: 6,
      child: const Icon(Icons.add_rounded, color: PVColors.accentGold, size: 28),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // MODALS, SHEETS & DIALOGS
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: PVColors.primaryIndigo),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: PVColors.textPrimary),
          ),
        ),
      ],
    );
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w500)),
        backgroundColor: PVColors.primaryIndigo,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(14),
      ),
    );
  }

  void _showAddEmployeeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Text('Add Employee — Step 1: Personal & Role', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'Corporate Email', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'Department (e.g. AI Vision)', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showSnackbar('Employee Profile Draft Saved & Created!');
                },
                style: ElevatedButton.styleFrom(backgroundColor: PVColors.primaryIndigo, foregroundColor: Colors.white),
                child: const Text('Save & Create Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddInternSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enroll Intern — Batch 2026 Alpha', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Intern Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'Assigned Mentor (e.g. Aarav Patel)', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showSnackbar('Intern Enrolled Successfully!');
                },
                style: ElevatedButton.styleFrom(backgroundColor: PVColors.primaryIndigo, foregroundColor: Colors.white),
                child: const Text('Complete Intern Enrollment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateJobSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create Job Requisition', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Job Role Title', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'Target Openings Count', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showSnackbar('Job Requisition Published to Portal!');
                },
                style: ElevatedButton.styleFrom(backgroundColor: PVColors.primaryIndigo, foregroundColor: Colors.white),
                child: const Text('Publish Job Opening'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUploadDocumentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upload to Document Vault', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Document Name / Title', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'Category (Offer Letter, Contract, ID)', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showSnackbar('Document Uploaded & Verified.');
                },
                style: ElevatedButton.styleFrom(backgroundColor: PVColors.primaryIndigo, foregroundColor: Colors.white),
                child: const Text('Upload Document'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDocumentVaultSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Secure Document Vault', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.description, color: PVColors.primaryIndigo),
              title: const Text('Employee Contracts & NDAs'),
              subtitle: const Text('256 Active Files'),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.badge, color: PVColors.warning),
              title: const Text('Expiring Documents (4 Alerts)'),
              subtitle: const Text('Critical Action Required'),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmployeeProfileSheet(String name) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 24, backgroundColor: PVColors.softBlue, child: Text(name[0], style: const TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            Text(name, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
            Text('96.8% Attendance • 4.9 Performance CPI', style: GoogleFonts.poppins(fontSize: 11, color: PVColors.textSecondary)),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildProfileBadge('Present', '96%'),
                _buildProfileBadge('Leave Bal.', '18d'),
                _buildProfileBadge('Docs', '100% OK'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileBadge(String label, String val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: PVColors.pageBg, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(val, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: PVColors.primaryIndigo)),
          Text(label, style: GoogleFonts.poppins(fontSize: 9.5, color: PVColors.textSecondary)),
        ],
      ),
    );
  }

  void _showQuickActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('HR Quick Actions', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _buildActionItem(Icons.person_add, 'Add Employee', () {
              Navigator.pop(ctx);
              _showAddEmployeeSheet();
            }),
            _buildActionItem(Icons.school, 'Add Intern Record', () {
              Navigator.pop(ctx);
              _showAddInternSheet();
            }),
            _buildActionItem(Icons.work, 'Create Job Opening', () {
              Navigator.pop(ctx);
              _showCreateJobSheet();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: PVColors.primaryIndigo, size: 20),
            const SizedBox(width: 14),
            Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _showNotificationSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('HR Notification Center', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Mark all read')),
              ],
            ),
            const Divider(),
            _buildNotifItem(Icons.approval, 'Leave: 3 urgent requests pending review', '10 mins ago', PVColors.warning),
            _buildNotifItem(Icons.badge, 'Document Expiring: Rahul Kumar ID proof', '25 mins ago', PVColors.error),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifItem(IconData icon, String title, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                Text(time, style: GoogleFonts.poppins(fontSize: 10, color: PVColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showGlobalSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search employees, candidate applications, leave, documents...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              children: ['Rahul Kumar', 'Priya Sharma (Applicant)', 'Casual Leave Request', 'ID Expiry'].map((k) {
                return ActionChip(label: Text(k), onPressed: () => Navigator.pop(ctx));
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showOffboardingSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Text('Offboarding & Exit Clearance', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ListTile(
              dense: true,
              leading: const Icon(Icons.person, color: PVColors.warning),
              title: const Text('Vikram Sethi (Senior Systems Eng)'),
              subtitle: const Text('Last Day: 30 Sep 2026 · IT & Finance Clearance Pending'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showSnackbar('Exit Clearance Approved for Vikram Sethi');
                },
                style: ElevatedButton.styleFrom(backgroundColor: PVColors.success, foregroundColor: Colors.white),
                child: const Text('Approve Clearance', style: TextStyle(fontSize: 10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttendanceRegSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Text('Attendance Regularization Queue', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ListTile(
              dense: true,
              leading: const Icon(Icons.schedule, color: PVColors.primaryIndigo),
              title: const Text('Ananya R. · Missed Check-out (22 Sep)'),
              subtitle: const Text('Reason: Client Meeting Extended till 8 PM'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showSnackbar('Regularization Rejected');
                    },
                    style: OutlinedButton.styleFrom(foregroundColor: PVColors.error),
                    child: const Text('Reject', style: TextStyle(fontSize: 10)),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showSnackbar('Regularization Approved for Ananya R.');
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: PVColors.success, foregroundColor: Colors.white),
                    child: const Text('Approve', style: TextStyle(fontSize: 10)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLeaveBalanceDialog(String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Leave Balance: $name', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              dense: true,
              title: const Text('Casual Leave (CL)'),
              trailing: const Text('7.5 / 12 Days Remaining', style: TextStyle(fontWeight: FontWeight.bold, color: PVColors.primaryIndigo)),
            ),
            ListTile(
              dense: true,
              title: const Text('Sick Leave (SL)'),
              trailing: const Text('10.0 / 10 Days Remaining', style: TextStyle(fontWeight: FontWeight.bold, color: PVColors.success)),
            ),
            ListTile(
              dense: true,
              title: const Text('Privilege Leave (PL)'),
              trailing: const Text('14.0 / 15 Days Remaining', style: TextStyle(fontWeight: FontWeight.bold, color: PVColors.secondaryIndigo)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showEmployeeDocumentsDialog(String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Documents: $name', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              dense: true,
              leading: const Icon(Icons.picture_as_pdf, color: PVColors.error),
              title: const Text('Signed Offer Letter.pdf'),
              subtitle: const Text('Verified by HR · 1.4 MB'),
              trailing: IconButton(
                icon: const Icon(Icons.download_rounded, color: PVColors.primaryIndigo),
                onPressed: () => _showSnackbar('Downloading Offer Letter...'),
              ),
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.picture_as_pdf, color: PVColors.error),
              title: const Text('Government ID Proof.pdf'),
              subtitle: const Text('Encrypted Vault · 820 KB'),
              trailing: IconButton(
                icon: const Icon(Icons.download_rounded, color: PVColors.primaryIndigo),
                onPressed: () => _showSnackbar('Downloading ID Proof...'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showApplicantsSheet(String jobTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Text('Applicants for $jobTitle', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ListTile(
              dense: true,
              leading: const CircleAvatar(backgroundColor: PVColors.softBlue, child: Text('PS', style: TextStyle(color: PVColors.primaryIndigo, fontWeight: FontWeight.bold))),
              title: const Text('Priya Sharma · 5.5 Yrs Exp'),
              subtitle: const Text('Tech: PyTorch, CUDA, OpenCV, C++'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showSnackbar('Priya Sharma Shortlisted & Interview Scheduled!');
                },
                style: ElevatedButton.styleFrom(backgroundColor: PVColors.primaryIndigo, foregroundColor: Colors.white),
                child: const Text('Shortlist', style: TextStyle(fontSize: 10)),
              ),
            ),
            ListTile(
              dense: true,
              leading: const CircleAvatar(backgroundColor: PVColors.softBlue, child: Text('RK', style: TextStyle(color: PVColors.primaryIndigo, fontWeight: FontWeight.bold))),
              title: const Text('Rohan Kulkarni · 3.2 Yrs Exp'),
              subtitle: const Text('Tech: TensorFlow, ROS2, Python'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showSnackbar('Rohan Kulkarni Shortlisted!');
                },
                style: ElevatedButton.styleFrom(backgroundColor: PVColors.primaryIndigo, foregroundColor: Colors.white),
                child: const Text('Shortlist', style: TextStyle(fontSize: 10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPerformanceDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Performance Review Cycles', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Q3 2026 Annual Evaluation: ACTIVE', style: TextStyle(fontWeight: FontWeight.bold, color: PVColors.success)),
            const SizedBox(height: 6),
            Text('• Self-Assessments Completed: 88%', style: GoogleFonts.poppins(fontSize: 12)),
            Text('• Manager Appraisals Completed: 74%', style: GoogleFonts.poppins(fontSize: 12)),
            Text('• HR Normalization Status: In Progress', style: GoogleFonts.poppins(fontSize: 12)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showSnackbar('Review Reminders Sent to 14 Team Leads!');
            },
            style: ElevatedButton.styleFrom(backgroundColor: PVColors.primaryIndigo, foregroundColor: Colors.white),
            child: const Text('Send Manager Reminders'),
          ),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showTrainingDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Learning & Mandatory Training', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              dense: true,
              leading: const Icon(Icons.security, color: PVColors.warning),
              title: const Text('ISO 27001 Information Security 2026'),
              subtitle: const Text('Mandatory · 94% Organization Completion'),
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.code, color: PVColors.primaryIndigo),
              title: const Text('CAN Bus Safety & Automotive Standards'),
              subtitle: const Text('Engineering Teams · 82% Completion'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showReportsExporterDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('HR Reports Exporter', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              dense: true,
              leading: const Icon(Icons.description, color: PVColors.primaryIndigo),
              title: const Text('Monthly Headcount & Attrition Report (PDF)'),
              onTap: () {
                Navigator.pop(ctx);
                _showSnackbar('Exporting Headcount Report (PDF)...');
              },
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.table_chart, color: PVColors.success),
              title: const Text('Attendance & Leave Utilization Register (CSV)'),
              onTap: () {
                Navigator.pop(ctx);
                _showSnackbar('Exporting Attendance Register (CSV)...');
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ],
      ),
    );
  }

  void _showProfileSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: _userDpColor.withAlpha(50),
                shape: BoxShape.circle,
                border: Border.all(color: PVColors.accentGold, width: 2),
              ),
              child: ClipOval(
                child: _userDpUrl.isNotEmpty
                    ? Image.network(_userDpUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Center(
                        child: Text(_userInitials, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _userDpColor)),
                      ))
                    : Center(
                        child: Text(_userInitials, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _userDpColor)),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Text(_userName, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('$_userRoleTitle • People Operations', style: GoogleFonts.poppins(fontSize: 11.5, color: PVColors.textSecondary)),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                Navigator.pop(ctx);
                _showEditProfileDialog();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.edit_rounded, color: PVColors.primaryIndigo, size: 20),
                    const SizedBox(width: 12),
                    Text('Edit Profile (Name & Display Picture)', style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushReplacementNamed(context, '/role-selector');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.switch_account_rounded, color: PVColors.primaryIndigo, size: 20),
                    const SizedBox(width: 12),
                    Text('Switch Active Role', style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.logout_rounded, color: PVColors.error, size: 20),
                    const SizedBox(width: 12),
                    Text('Sign Out', style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w600, color: PVColors.error)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _userName);
    final titleCtrl = TextEditingController(text: _userRoleTitle);
    final dpUrlCtrl = TextEditingController(text: _userDpUrl);
    Color selectedColor = _userDpColor;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 14),
                Text('Edit Profile & Display Picture', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 14),
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: selectedColor.withAlpha(50),
                      shape: BoxShape.circle,
                      border: Border.all(color: PVColors.accentGold, width: 2),
                    ),
                    child: ClipOval(
                      child: dpUrlCtrl.text.isNotEmpty
                          ? Image.network(dpUrlCtrl.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => Center(
                              child: Text(_computeInitials(nameCtrl.text), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: selectedColor)),
                            ))
                          : Center(
                              child: Text(_computeInitials(nameCtrl.text), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: selectedColor)),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Select Avatar Theme Color:', style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Color(0xFF00695C),
                    PVColors.primaryIndigo,
                    const Color(0xFFB71C1C),
                    const Color(0xFF5E35B1),
                    const Color(0xFFE65100),
                    const Color(0xFF0277BD),
                  ].map((color) {
                    final isSel = selectedColor == color;
                    return GestureDetector(
                      onTap: () => setSheetState(() => selectedColor = color),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSel ? Border.all(color: Colors.black, width: 2.5) : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                  onChanged: (v) => setSheetState(() {}),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Job Title / Designation', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: dpUrlCtrl,
                  decoration: const InputDecoration(labelText: 'Display Picture Image URL (Optional)', border: OutlineInputBorder()),
                  onChanged: (v) => setSheetState(() {}),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      final newName = nameCtrl.text.trim().isEmpty ? _userName : nameCtrl.text.trim();
                      setState(() {
                        _userName = newName;
                        _userRoleTitle = titleCtrl.text.trim().isEmpty ? _userRoleTitle : titleCtrl.text.trim();
                        _userDpUrl = dpUrlCtrl.text.trim();
                        _userDpColor = selectedColor;
                        _userInitials = _computeInitials(_userName);
                      });
                      Navigator.pop(ctx);
                      _showSnackbar('HR Profile & DP updated successfully!');
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: PVColors.primaryIndigo, foregroundColor: Colors.white),
                    child: const Text('Save Profile Changes'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
