import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/pathvision_logo.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Official PathVision Design Tokens
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
// Super Admin Mobile Application
// ─────────────────────────────────────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentTab = 0;

  // User Profile State
  String _userName = 'Admin';
  String _userRoleTitle = 'Founder & CTO';
  String _userInitials = 'SA';
  Color _userDpColor = PVColors.primaryIndigo;
  String _userDpUrl = '';

  String _computeInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return 'SA';
    if (parts.length == 1) return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  // Filter States
  String _attendanceRange = '30-Day';
  String _analyticsTimeframe = 'This Month';
  String _peopleFilter = 'All';
  String _approvalFilter = 'All';

  // Permission Matrix State
  final Map<String, bool> _permissions = {
    'User Management & Profiles': true,
    'Role & Permission RBAC': true,
    'System Health & Infrastructure': true,
    'Database Snapshots & Backups': true,
    'Compensation & Payroll View': true,
    'API Keys & Cloud Integrations': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PVColors.pageBg,
      body: Column(
        children: [
          // 1. Top Executive App Bar
          _buildTopAppBar(),

          // 2. Tab Views
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                _buildHomeTab(),
                _buildPeopleTab(),
                _buildWorkTab(),
                _buildAnalyticsTab(),
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
                            'Good Morning, $_userName',
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
                            'SUPER ADMIN',
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
                      'Friday, 21 August 2026 • PathVision Enterprise',
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // Search Trigger
              IconButton(
                onPressed: _showGlobalSearchSheet,
                icon: const Icon(Icons.search_rounded, color: Colors.white, size: 21),
                tooltip: 'Global Search',
              ),

              // Notification Trigger
              Stack(
                children: [
                  IconButton(
                    onPressed: _showNotificationSheet,
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 21),
                    tooltip: 'Notifications',
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

              // Avatar Trigger
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
  // TAB 1: EXECUTIVE HOME DASHBOARD
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Executive System Health Summary
          _buildHealthSummaryBanner(),

          const SizedBox(height: 16),

          // 6 PRD Executive KPIs
          _buildSectionHeader('Executive KPI Metrics', Icons.speed_rounded),
          const SizedBox(height: 10),
          _buildKpiGrid(),

          const SizedBox(height: 18),

          // Quick Operations
          _buildSectionHeader('Quick Operations', Icons.bolt_rounded),
          const SizedBox(height: 10),
          _buildQuickActionsGrid(),

          const SizedBox(height: 18),

          // Attendance Analytics
          _buildSectionHeader('Attendance Trends & Breakdown', Icons.verified_user_rounded),
          const SizedBox(height: 10),
          _buildAttendanceTrendCard(),

          const SizedBox(height: 18),

          // Project Overview & Radial Progress Gauges
          _buildSectionHeader('Project Milestones & Deliverables', Icons.account_tree_rounded),
          const SizedBox(height: 10),
          _buildProjectsOverviewCard(),

          const SizedBox(height: 18),

          // Recruitment Pipeline Funnel
          _buildSectionHeader('Recruitment Pipeline Funnel', Icons.filter_alt_rounded),
          const SizedBox(height: 10),
          _buildRecruitmentFunnelCard(),

          const SizedBox(height: 18),

          // Top Performing Engineers
          _buildSectionHeader('Top Engineering Performers', Icons.emoji_events_rounded),
          const SizedBox(height: 10),
          _buildTopPerformersCard(),

          const SizedBox(height: 18),

          // Recent System Activity Audit Stream
          _buildSectionHeader('Recent System Audit Activity', Icons.history_rounded),
          const SizedBox(height: 10),
          _buildRecentActivityCard(),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHealthSummaryBanner() {
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
              child: const Icon(Icons.check_circle_rounded, color: PVColors.success, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Organization Health: 99.2%',
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: PVColors.textPrimary),
                  ),
                  Text(
                    'FastAPI • PostgreSQL • MinIO • Keycloak Active',
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
                'Q3 Sprint Day 18',
                style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: PVColors.primaryIndigo),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // KPI SECTION (6 PRD KPIs in a clean 2x3 Grid)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildKpiGrid() {
    final kpis = [
      {
        'title': 'Total Headcount',
        'value': '256',
        'sub': '+8.4% this quarter',
        'icon': Icons.groups_rounded,
        'color': PVColors.primaryIndigo,
        'trend': '+18',
        'isUp': true,
      },
      {
        'title': 'Active Interns',
        'value': '42',
        'sub': 'Batch 2026 Alpha',
        'icon': Icons.school_rounded,
        'color': PVColors.secondaryIndigo,
        'trend': '+4',
        'isUp': true,
      },
      {
        'title': 'Open Projects',
        'value': '14',
        'sub': '4 High Priority',
        'icon': Icons.account_tree_rounded,
        'color': const Color(0xFF00695C),
        'trend': 'On Track',
        'isUp': true,
      },
      {
        'title': 'Attendance %',
        'value': '96.4%',
        'sub': 'Target: 95.0%',
        'icon': Icons.verified_user_rounded,
        'color': PVColors.success,
        'trend': '+1.2%',
        'isUp': true,
      },
      {
        'title': 'Avg Performance',
        'value': '4.85',
        'sub': 'CPI Score 1.38',
        'icon': Icons.star_rounded,
        'color': PVColors.accentGold,
        'trend': '+0.15',
        'isUp': true,
      },
      {
        'title': 'Open Positions',
        'value': '08',
        'sub': 'Engineering & HR',
        'icon': Icons.person_search_rounded,
        'color': PVColors.warning,
        'trend': 'Active',
        'isUp': false,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.6,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final item = kpis[index];
        final color = item['color'] as Color;
        final isUp = item['isUp'] as bool;

        return Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: PVColors.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: PVColors.border),
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
                    const SizedBox(width: 4),
                    Icon(item['icon'] as IconData, size: 16, color: color),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        item['value'] as String,
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800, color: PVColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: isUp ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item['trend'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: isUp ? PVColors.success : PVColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  item['sub'] as String,
                  style: GoogleFonts.poppins(fontSize: 9.5, color: PVColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // QUICK ACTIONS GRID
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildQuickActionsGrid() {
    final actions = [
      {
        'title': '+ Add Employee',
        'icon': Icons.person_add_rounded,
        'color': PVColors.primaryIndigo,
        'action': () => _showAddEmployeeSheet(),
      },
      {
        'title': '+ Add Intern',
        'icon': Icons.school_rounded,
        'color': PVColors.secondaryIndigo,
        'action': () => _showAddInternSheet(),
      },
      {
        'title': '+ Create Project',
        'icon': Icons.add_task_rounded,
        'color': const Color(0xFF00695C),
        'action': () => _showCreateProjectSheet(),
      },
      {
        'title': 'Approvals (3)',
        'icon': Icons.fact_check_rounded,
        'color': PVColors.warning,
        'action': () => setState(() => _currentTab = 4),
      },
      {
        'title': 'RBAC Permissions',
        'icon': Icons.security_rounded,
        'color': const Color(0xFF4A148C),
        'action': () => setState(() => _currentTab = 4),
      },
      {
        'title': 'System Settings',
        'icon': Icons.settings_suggest_rounded,
        'color': const Color(0xFF37474F),
        'action': () => _showSystemSettingsSheet(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.15,
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
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: PVColors.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: PVColors.border),
                boxShadow: [
                  BoxShadow(
                    color: PVColors.primaryIndigo.withAlpha(6),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withAlpha(18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item['icon'] as IconData, size: 18, color: color),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['title'] as String,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 10.5, fontWeight: FontWeight.w600, color: PVColors.textPrimary),
                    maxLines: 1,
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
  // ATTENDANCE TREND CARD
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildAttendanceTrendCard() {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: PVColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PVColors.border),
          boxShadow: [
            BoxShadow(
              color: PVColors.primaryIndigo.withAlpha(8),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Attendance Breakdown',
                    style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w700, color: PVColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownButton<String>(
                  value: _attendanceRange,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                  style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w600, color: PVColors.secondaryIndigo),
                  items: ['7-Day', '30-Day', '60-Day', '90-Day'].map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (v) => setState(() => _attendanceRange = v!),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Attendance Metric Pills
            Row(
              children: [
                Expanded(child: _buildAttendancePill('Present', '84.2%', PVColors.success)),
                const SizedBox(width: 6),
                Expanded(child: _buildAttendancePill('WFH', '12.2%', PVColors.secondaryIndigo)),
                const SizedBox(width: 6),
                Expanded(child: _buildAttendancePill('Late', '2.4%', PVColors.warning)),
                const SizedBox(width: 6),
                Expanded(child: _buildAttendancePill('Absent', '1.2%', PVColors.error)),
              ],
            ),

            const SizedBox(height: 14),

            // Histogram
            SizedBox(
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildAttendanceBar('Mon', 0.94, '94%'),
                  _buildAttendanceBar('Tue', 0.98, '98%'),
                  _buildAttendanceBar('Wed', 0.96, '96%'),
                  _buildAttendanceBar('Thu', 0.97, '97%'),
                  _buildAttendanceBar('Fri', 0.92, '92%'),
                  _buildAttendanceBar('Sat', 0.78, '78%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendancePill(String label, String pct, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(16),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 9.0, fontWeight: FontWeight.w500, color: PVColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            pct,
            style: GoogleFonts.poppins(fontSize: 11.0, fontWeight: FontWeight.w700, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceBar(String label, double fraction, String pct) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(pct, style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w600, color: PVColors.textSecondary)),
        const SizedBox(height: 3),
        Container(
          width: 18,
          height: 55 * fraction,
          decoration: BoxDecoration(
            color: fraction >= 0.90 ? PVColors.primaryIndigo : PVColors.secondaryIndigo.withAlpha(140),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: PVColors.textPrimary)),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // PROJECTS OVERVIEW CARD
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildProjectsOverviewCard() {
    final projects = [
      {
        'name': 'AI PathVision Core v3',
        'domain': 'Vision / CUDA',
        'lead': 'Aarav Patel',
        'progress': 0.88,
        'milestone': 'Quantization Complete',
        'color': PVColors.primaryIndigo,
      },
      {
        'name': 'Cloud HRMS Platform',
        'domain': 'Flutter / FastAPI',
        'lead': 'Sophia Chen',
        'progress': 0.74,
        'milestone': 'Super Admin RBAC Engine',
        'color': PVColors.secondaryIndigo,
      },
      {
        'name': 'Autonomous Drone Stack',
        'domain': 'ROS2 & Edge AI',
        'lead': 'David Kim',
        'progress': 0.62,
        'milestone': 'Telemetry 5G Protocol',
        'color': const Color(0xFF00695C),
      },
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
          children: projects.map((p) {
            final progress = p['progress'] as double;
            final color = p['color'] as Color;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: PVColors.pageBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PVColors.border),
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 42,
                        height: 42,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 4.5,
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: AlwaysStoppedAnimation(color),
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w800, color: PVColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['name'] as String,
                          style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w700, color: PVColors.textPrimary),
                        ),
                        Text(
                          '${p['domain']} • Lead: ${p['lead']}',
                          style: GoogleFonts.poppins(fontSize: 10.5, color: PVColors.textSecondary),
                        ),
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
  // RECRUITMENT FUNNEL CARD
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildRecruitmentFunnelCard() {
    final stages = [
      {'stage': 'Applications', 'count': '142', 'pct': 1.0, 'color': PVColors.primaryIndigo},
      {'stage': 'Shortlisted', 'count': '68', 'pct': 0.70, 'color': PVColors.secondaryIndigo},
      {'stage': 'Technical Round', 'count': '28', 'pct': 0.44, 'color': const Color(0xFF0288D1)},
      {'stage': 'HR Round', 'count': '14', 'pct': 0.28, 'color': PVColors.accentGold},
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
          children: stages.map((s) {
            final pct = s['pct'] as double;
            final color = s['color'] as Color;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(
                      s['stage'] as String,
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: PVColors.textPrimary),
                    ),
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
                    width: 28,
                    child: Text(
                      s['count'] as String,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: PVColors.textPrimary),
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
  // TOP PERFORMERS CARD
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildTopPerformersCard() {
    final performers = [
      {'rank': '#1', 'name': 'Aarav Patel', 'role': 'Lead Architect', 'domain': 'AI Vision', 'score': '99.4%', 'cpi': '1.42 CPI'},
      {'rank': '#2', 'name': 'Sophia Chen', 'role': 'Senior Fullstack', 'domain': 'Flutter/FastAPI', 'score': '98.2%', 'cpi': '1.38 CPI'},
      {'rank': '#3', 'name': 'David Kim', 'role': 'Robotics Lead', 'domain': 'ROS2/C++', 'score': '97.5%', 'cpi': '1.31 CPI'},
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
          children: performers.map((p) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: PVColors.border, width: 0.8)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: p['rank'] == '#1' ? const Color(0xFFFEF3C7) : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        p['rank'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: p['rank'] == '#1' ? const Color(0xFFB45309) : PVColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['name'] as String,
                          style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w700, color: PVColors.textPrimary),
                        ),
                        Text(
                          '${p['role']} • ${p['domain']}',
                          style: GoogleFonts.poppins(fontSize: 10, color: PVColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    p['score'] as String,
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w800, color: PVColors.success),
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
  // RECENT ACTIVITIES CARD
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildRecentActivityCard() {
    final activities = [
      {'title': 'New Employee Onboarded (Aisha Khan)', 'user': 'Sarah Jenkins (HR)', 'time': '12m ago', 'icon': Icons.person_add},
      {'title': 'Super Admin Role Granted to Lead Architect', 'user': 'Michael Vance', 'time': '45m ago', 'icon': Icons.security},
      {'title': 'Sprint Q3 Milestone #4 PR Merged', 'user': 'GitHub CI/CD', 'time': '2h ago', 'icon': Icons.merge_type},
      {'title': 'MinIO Cloud Storage Daily Snapshot', 'user': 'System Daemon', 'time': '4h ago', 'icon': Icons.cloud_done},
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
          children: activities.map((a) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: PVColors.border, width: 0.8)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: PVColors.softBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(a['icon'] as IconData, size: 16, color: PVColors.primaryIndigo),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a['title'] as String,
                          style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w600, color: PVColors.textPrimary),
                        ),
                        Text(
                          '${a['user']} • ${a['time']}',
                          style: GoogleFonts.poppins(fontSize: 10, color: PVColors.textSecondary),
                        ),
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
  // TAB 2: PEOPLE MANAGEMENT HUB
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildPeopleTab() {
    final employees = [
      {'name': 'Aarav Patel', 'role': 'Lead Vision Architect', 'dept': 'Engineering', 'domain': 'C++ / AI Vision'},
      {'name': 'Sophia Chen', 'role': 'Senior Fullstack Lead', 'dept': 'Engineering', 'domain': 'Flutter / FastAPI'},
      {'name': 'Sarah Jenkins', 'role': 'Lead HR Manager', 'dept': 'Human Resources', 'domain': 'People Operations'},
      {'name': 'David Kim', 'role': 'Robotics Systems Lead', 'dept': 'Hardware/ROS', 'domain': 'Embedded C'},
      {'name': 'Aisha Khan', 'role': 'Junior AI Vision Intern', 'dept': 'Interns (2026)', 'domain': 'PyTorch / Vision'},
      {'name': 'Liam O’Connor', 'role': 'DevOps & SRE Specialist', 'dept': 'Infrastructure', 'domain': 'K8s / Terraform'},
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
              Text('People Directory (256)', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
              ElevatedButton.icon(
                onPressed: _showAddEmployeeSheet,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Employee'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PVColors.primaryIndigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  textStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search Field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by name, role, domain, or team...',
              hintStyle: GoogleFonts.poppins(fontSize: 12, color: PVColors.textSecondary),
              prefixIcon: const Icon(Icons.search_rounded, size: 20, color: PVColors.textSecondary),
              filled: true,
              fillColor: PVColors.cardBg,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: PVColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: PVColors.border)),
            ),
          ),
          const SizedBox(height: 12),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Engineering', 'Interns', 'Human Resources', 'Hardware', 'Infrastructure'].map((filter) {
                final isSelected = _peopleFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _peopleFilter = filter),
                    selectedColor: PVColors.primaryIndigo,
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : PVColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Employee Cards
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
                child: Row(
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
                          Text(
                            emp['name']!,
                            style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w700, color: PVColors.textPrimary),
                          ),
                          Text(
                            '${emp['role']} • ${emp['dept']}',
                            style: GoogleFonts.poppins(fontSize: 10.5, color: PVColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert_rounded, size: 18, color: PVColors.textSecondary),
                      onPressed: () => _showEmployeeOptionsSheet(emp),
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
  // TAB 3: WORK MANAGEMENT HUB
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildWorkTab() {
    final tasks = [
      {'title': 'Implement Keycloak OAuth2 Integration', 'project': 'Cloud HRMS', 'assignee': 'Sophia Chen', 'priority': 'HIGH'},
      {'title': 'Model Quantization for Edge Inference', 'project': 'AI Vision Core', 'assignee': 'Aarav Patel', 'priority': 'CRITICAL'},
      {'title': 'Weekly Payroll Automated Calculation', 'project': 'Payroll Engine', 'assignee': 'Sarah Jenkins', 'priority': 'MEDIUM'},
      {'title': '5G Video Stream Telemetry Latency Fix', 'project': 'Drone Pipeline', 'assignee': 'David Kim', 'priority': 'BLOCKER'},
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Work & Sprint Deliverables', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          // Sprint Metrics
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: PVColors.primaryIndigo,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSprintStat('36', 'Total Tasks'),
                _buildSprintStat('24', 'Completed'),
                _buildSprintStat('10', 'In Progress'),
                _buildSprintStat('02', 'Blocked'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _buildSectionHeader('Live Task Stream', Icons.task_alt_rounded),
          const SizedBox(height: 10),

          ...tasks.map((t) {
            final isBlocker = t['priority'] == 'BLOCKER' || t['priority'] == 'CRITICAL';

            return Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: PVColors.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isBlocker ? PVColors.error.withAlpha(80) : PVColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(t['project']!, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: PVColors.secondaryIndigo)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isBlocker ? const Color(0xFFFFEBEE) : const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            t['priority']!,
                            style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w800, color: isBlocker ? PVColors.error : PVColors.success),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(t['title']!, style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w600, color: PVColors.textPrimary)),
                    Text('Assignee: ${t['assignee']}', style: GoogleFonts.poppins(fontSize: 10.5, color: PVColors.textSecondary)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSprintStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
        Text(label, style: GoogleFonts.poppins(fontSize: 10, color: Colors.white70)),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // TAB 4: ANALYTICS & DECISION HUB
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Organization Analytics', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
              DropdownButton<String>(
                value: _analyticsTimeframe,
                underline: const SizedBox(),
                items: ['This Week', 'This Month', 'This Quarter', 'Custom Range'].map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (v) => setState(() => _analyticsTimeframe = v!),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // CPI Index
          Material(
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
                  Text('Engineering Velocity & CPI', style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('1.38 Average CPI (Productivity Index) across 4 teams.', style: GoogleFonts.poppins(fontSize: 11, color: PVColors.textSecondary)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAnalyticsPill('PR Merge Time', '4.2 hrs', PVColors.success),
                      _buildAnalyticsPill('Weekly Commits', '412', PVColors.primaryIndigo),
                      _buildAnalyticsPill('Code Review %', '98.6%', PVColors.secondaryIndigo),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Skill Coverage
          Material(
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
                  Text('Skill Coverage & Domains', style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  _buildSkillBar('AI / Deep Learning', 0.92, '48 Engineers'),
                  _buildSkillBar('Flutter & Mobile', 0.85, '32 Engineers'),
                  _buildSkillBar('Backend (FastAPI/Postgres)', 0.78, '28 Engineers'),
                  _buildSkillBar('Robotics & Embedded', 0.65, '18 Engineers'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsPill(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(16),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
          Text(title, style: GoogleFonts.poppins(fontSize: 9.5, color: PVColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSkillBar(String skill, double progress, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(skill, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: PVColors.textPrimary)),
              Text(count, style: GoogleFonts.poppins(fontSize: 10, color: PVColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 3),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFF1F5F9),
            valueColor: const AlwaysStoppedAnimation(PVColors.primaryIndigo),
            minHeight: 5,
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // TAB 5: MORE / SUPER ADMIN ADMINISTRATION & APPROVALS
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildMoreTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Centralized Approval Center', Icons.inbox_rounded),
          const SizedBox(height: 10),
          _buildApprovalInboxCard(),

          const SizedBox(height: 18),

          _buildSectionHeader('Super Admin Permission Matrix', Icons.admin_panel_settings_rounded),
          const SizedBox(height: 10),
          _buildPermissionMatrixCard(),

          const SizedBox(height: 18),

          _buildSectionHeader('System Health & Infrastructure', Icons.cloud_sync_rounded),
          const SizedBox(height: 10),
          _buildSystemHealthCard(),

          const SizedBox(height: 18),

          _buildAdminSettingsList(),
        ],
      ),
    );
  }

  Widget _buildApprovalInboxCard() {
    final approvals = [
      {'title': 'Leave Request (3 Days - Annual)', 'user': 'David Kim', 'date': 'Today', 'sla': '14 hrs left'},
      {'title': 'Hardware Asset Request (MacBook M3)', 'user': 'Aisha Khan', 'date': 'Yesterday', 'sla': '28 hrs left'},
      {'title': 'Off-Cycle Attendance Regularization', 'user': 'Sophia Chen', 'date': '2 days ago', 'sla': '04 hrs left'},
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Leave', 'Attendance', 'Assets', 'Tasks'].map((t) {
                  final isSel = _approvalFilter == t;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text(t),
                      selected: isSel,
                      onSelected: (v) => setState(() => _approvalFilter = t),
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
            const SizedBox(height: 10),

            ...approvals.map((a) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: PVColors.pageBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            a['title']!,
                            style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w700, color: PVColors.textPrimary),
                          ),
                        ),
                        Text(
                          'SLA: ${a['sla']}',
                          style: GoogleFonts.poppins(fontSize: 9.5, fontWeight: FontWeight.w700, color: PVColors.warning),
                        ),
                      ],
                    ),
                    Text('Requester: ${a['user']} • ${a['date']}', style: GoogleFonts.poppins(fontSize: 10, color: PVColors.textSecondary)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => _showSnackbar('Request Rejected.'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: PVColors.error,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          ),
                          child: const Text('Reject', style: TextStyle(fontSize: 11)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _showSnackbar('Request Approved by Super Admin.'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PVColors.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          ),
                          child: const Text('Approve', style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionMatrixCard() {
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
          children: _permissions.keys.map((perm) {
            final isEnabled = _permissions[perm]!;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(perm, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: PVColors.textPrimary)),
                        Text('Full Scope Permission', style: GoogleFonts.poppins(fontSize: 10, color: PVColors.textSecondary)),
                      ],
                    ),
                  ),
                  Switch(
                    value: isEnabled,
                    activeThumbColor: PVColors.primaryIndigo,
                    onChanged: (val) {
                      setState(() => _permissions[perm] = val);
                      _showSnackbar('Permission updated: $perm');
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSystemHealthCard() {
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
            _buildHealthRow('FastAPI Gateway', '34ms latency', PVColors.success),
            _buildHealthRow('PostgreSQL Cluster', '88/100 connections', PVColors.success),
            _buildHealthRow('MinIO Object Storage', '4.2 TB / 10 TB', PVColors.success),
            _buildHealthRow('Keycloak Identity Server', 'Active • 256 tokens', PVColors.success),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthRow(String service, String metrics, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(service, style: GoogleFonts.poppins(fontSize: 11.5, fontWeight: FontWeight.w600, color: PVColors.textPrimary)),
            ],
          ),
          Text(metrics, style: GoogleFonts.poppins(fontSize: 10.5, color: PVColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildAdminSettingsList() {
    final settings = [
      {'title': 'Organization Profile & Hierarchy', 'icon': Icons.apartment_rounded},
      {'title': 'User Management & Active Sessions', 'icon': Icons.manage_accounts_rounded},
      {'title': 'GitHub & CI/CD Integrations', 'icon': Icons.integration_instructions_rounded},
      {'title': 'Audit Logs & Security Compliance', 'icon': Icons.policy_rounded},
      {'title': 'Automated Backup & Disaster Recovery', 'icon': Icons.backup_rounded},
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
          children: settings.map((s) {
            return InkWell(
              onTap: () {
                final title = s['title'] as String;
                if (title.contains('Organization')) {
                  _showOrgProfileDialog();
                } else if (title.contains('User Management')) {
                  _showUserManagementDialog();
                } else if (title.contains('GitHub')) {
                  _showIntegrationsDialog();
                } else if (title.contains('Audit')) {
                  _showAuditLogsDialog();
                } else if (title.contains('Backup')) {
                  _showBackupDialog();
                } else {
                  _showSystemSettingsSheet();
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Icon(s['icon'] as IconData, color: PVColors.primaryIndigo, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        s['title'] as String,
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: PVColors.textPrimary),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: PVColors.textSecondary, size: 18),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
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
              _buildBottomNavItem(0, Icons.home_rounded, 'Home'),
              _buildBottomNavItem(1, Icons.groups_rounded, 'People'),
              _buildBottomNavItem(2, Icons.work_history_rounded, 'Work'),
              _buildBottomNavItem(3, Icons.insights_rounded, 'Analytics'),
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
  // MODALS & DIALOGS
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
            Text('Add New Employee', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
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
                  _showSnackbar('New Employee Successfully Created!');
                },
                style: ElevatedButton.styleFrom(backgroundColor: PVColors.primaryIndigo, foregroundColor: Colors.white),
                child: const Text('Create Employee Record'),
              ),
            ),
          ],
        ),
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
            Text('Quick Operations', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _buildActionItem(Icons.person_add, 'Add Employee', () {
              Navigator.pop(ctx);
              _showAddEmployeeSheet();
            }),
            _buildActionItem(Icons.school, 'Add Intern Record', () {
              Navigator.pop(ctx);
              _showAddInternSheet();
            }),
            _buildActionItem(Icons.add_task, 'Create Engineering Project', () {
              Navigator.pop(ctx);
              _showCreateProjectSheet();
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
                Text('Notification Center', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Mark all read')),
              ],
            ),
            const Divider(),
            _buildNotifItem(Icons.security, 'Security: Super Admin login from London', '10 mins ago', PVColors.warning),
            _buildNotifItem(Icons.approval, 'Leave Approval: 3 requests pending', '25 mins ago', PVColors.success),
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
                hintText: 'Search employees, projects, audit logs, reports...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              children: ['Aarav Patel', 'AI Vision Core', 'Sprint Q3', 'Leave Request'].map((k) {
                return ActionChip(label: Text(k), onPressed: () => Navigator.pop(ctx));
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddInternSheet() {
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
            Text('Add Intern Record', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Intern Full Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'University / Institution', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'Domain (e.g. AI Vision / CAN Bus)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'Assigned Mentor', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showSnackbar('Intern Record Successfully Enrolled!');
                },
                style: ElevatedButton.styleFrom(backgroundColor: PVColors.secondaryIndigo, foregroundColor: Colors.white),
                child: const Text('Enroll Intern Record'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateProjectSheet() {
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
            Text('Create Engineering Project', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Project Name (e.g. IMAS Telemetry)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'Engineering Lead', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'Tech Stack (e.g. Flutter, FastAPI, ROS)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'Target Release Date', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showSnackbar('Engineering Project Created Successfully!');
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00695C), foregroundColor: Colors.white),
                child: const Text('Launch Engineering Project'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSystemSettingsSheet() {
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
            Text('Super Admin System Settings', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            SwitchListTile(
              value: true,
              onChanged: (v) {},
              title: const Text('Enforce Multi-Factor Authentication (MFA)'),
              subtitle: const Text('Mandatory for Super Admin & HR accounts'),
            ),
            SwitchListTile(
              value: true,
              onChanged: (v) {},
              title: const Text('Real-Time Audit Trail Logging'),
              subtitle: const Text('Stream all RBAC changes to CloudWatch'),
            ),
            SwitchListTile(
              value: false,
              onChanged: (v) {},
              title: const Text('Maintenance Mode'),
              subtitle: const Text('Disable employee portal logins'),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showSnackbar('Super Admin System Settings Saved!');
                },
                style: ElevatedButton.styleFrom(backgroundColor: PVColors.primaryIndigo, foregroundColor: Colors.white),
                child: const Text('Save System Configurations'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmployeeOptionsSheet(Map<String, String> emp) {
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
            Text('Manage ${emp['name']}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('${emp['role']} • ${emp['dept']}', style: GoogleFonts.poppins(fontSize: 12, color: PVColors.textSecondary)),
            const Divider(height: 20),
            _buildActionItem(Icons.badge, 'View Complete Profile', () {
              Navigator.pop(ctx);
              _showSnackbar('Viewing profile for ${emp['name']}');
            }),
            _buildActionItem(Icons.manage_accounts, 'Modify Access Role & Permissions', () {
              Navigator.pop(ctx);
              _showSnackbar('Access permissions updated for ${emp['name']}');
            }),
            _buildActionItem(Icons.swap_horiz, 'Reassign Department', () {
              Navigator.pop(ctx);
              _showSnackbar('Department reassigned for ${emp['name']}');
            }),
            _buildActionItem(Icons.block, 'Deactivate User Account', () {
              Navigator.pop(ctx);
              _showSnackbar('Account deactivated for ${emp['name']}');
            }),
          ],
        ),
      ),
    );
  }

  void _showOrgProfileDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Organization Hierarchy', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PathVision Enterprise Inc.', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            Text('• 4 Primary Engineering Hubs', style: GoogleFonts.poppins(fontSize: 12)),
            Text('• 148 Active Employees & Interns', style: GoogleFonts.poppins(fontSize: 12)),
            Text('• Super Admin: Founder & CTO', style: GoogleFonts.poppins(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showUserManagementDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Active User Sessions', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              dense: true,
              leading: const Icon(Icons.laptop_mac, color: PVColors.primaryIndigo),
              title: const Text('Super Admin (Windows 11)'),
              subtitle: const Text('IP: 192.168.1.45 · Active Now'),
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.phone_iphone, color: PVColors.secondaryIndigo),
              title: const Text('HR Lead (iOS App)'),
              subtitle: const Text('IP: 192.168.1.88 · Active 4m ago'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Done')),
        ],
      ),
    );
  }

  void _showIntegrationsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('GitHub & CI/CD Pipeline', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              dense: true,
              leading: const Icon(Icons.code, color: Colors.black87),
              title: const Text('GitHub Enterprise Org'),
              trailing: const Icon(Icons.check_circle, color: PVColors.success, size: 18),
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.cloud_done, color: Colors.blue),
              title: const Text('AWS EKS Cluster Deployments'),
              trailing: const Icon(Icons.check_circle, color: PVColors.success, size: 18),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showAuditLogsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Audit Logs & Compliance', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNotifItem(Icons.security, 'Role elevated: Sarah J. to HR Admin', '12:45 PM', PVColors.primaryIndigo),
              _buildNotifItem(Icons.vpn_key, 'API Token Generated for CI Pipeline', '10:15 AM', PVColors.secondaryIndigo),
              _buildNotifItem(Icons.lock, 'Password policy updated to 16 chars', 'Yesterday', PVColors.success),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Automated Backup Status', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Daily PostgreSQL Snapshot: SUCCESS'),
            const SizedBox(height: 4),
            Text('Last Backup: Today, 04:00 AM UTC', style: GoogleFonts.poppins(fontSize: 11, color: PVColors.textSecondary)),
            const SizedBox(height: 4),
            Text('Retention Policy: 30 Days (AWS S3 Glacier)', style: GoogleFonts.poppins(fontSize: 11, color: PVColors.textSecondary)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showSnackbar('On-Demand Backup Initiated!');
            },
            style: ElevatedButton.styleFrom(backgroundColor: PVColors.primaryIndigo, foregroundColor: Colors.white),
            child: const Text('Trigger Instant Backup'),
          ),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
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
            Text('$_userRoleTitle • Super Admin', style: GoogleFonts.poppins(fontSize: 11.5, color: PVColors.textSecondary)),
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
                    PVColors.primaryIndigo,
                    const Color(0xFF00695C),
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
                  decoration: const InputDecoration(labelText: 'Job Title / Role', border: OutlineInputBorder()),
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
                      _showSnackbar('Profile details & DP updated successfully!');
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
