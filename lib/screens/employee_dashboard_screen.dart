import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/pathvision_logo.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PathVision HRMS Design System Tokens
// ─────────────────────────────────────────────────────────────────────────────
class PVColors {
  static const Color primaryIndigo = Color(0xFF1A237E);
  static const Color secondaryIndigo = Color(0xFF3949AB);
  static const Color accentGold = Color(0xFFF9A825);
  static const Color accentGoldDark = Color(0xFF3B2A00);
  static const Color success = Color(0xFF2E7D32);
  static const Color successBg = Color(0xFFE3F3E4);
  static const Color warning = Color(0xFFE65100);
  static const Color warningBg = Color(0xFFFFF1D6);
  static const Color warningText = Color(0xFF8A5A00);
  static const Color error = Color(0xFFB71C1C);
  static const Color errorBg = Color(0xFFFBE0E0);
  static const Color errorText = Color(0xFF8E1616);
  static const Color infoBg = Color(0xFFE1E6FB);
  static const Color infoText = Color(0xFF2A3596);
  static const Color pageBg = Color(0xFFF5F7FA);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color border = Color(0xFFE3E7EE);
  static const Color softBlue = Color(0xFFE8EAF6);
}

// ─────────────────────────────────────────────────────────────────────────────
// Models for Employee Portal
// ─────────────────────────────────────────────────────────────────────────────
class TaskItem {
  final String id;
  final String title;
  final String priority; // High, Medium, Low, Blocked, In Review
  final String dueDate;
  final double hours;
  bool isCompleted;
  String status; // 'todo', 'doing', 'done'

  TaskItem({
    required this.id,
    required this.title,
    required this.priority,
    required this.dueDate,
    this.hours = 2.0,
    this.isCompleted = false,
    this.status = 'todo',
  });
}

class LeaveHistoryItem {
  final String dateRange;
  final String type;
  final String duration;
  final String status; // Approved, Pending, Rejected

  LeaveHistoryItem({
    required this.dateRange,
    required this.type,
    required this.duration,
    required this.status,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Employee & Engineer Portal Screen
// ─────────────────────────────────────────────────────────────────────────────
class EmployeeDashboardScreen extends StatefulWidget {
  final String roleName;
  final String userName;
  final String employeeId;
  final String projectName;

  const EmployeeDashboardScreen({
    super.key,
    this.roleName = 'Engineer',
    this.userName = 'Ananya R.',
    this.employeeId = 'PV-1002',
    this.projectName = 'IMAS driver monitoring',
  });

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  int _currentTab = 0;

  // Attendance State
  bool _isCheckedIn = false;
  final String _checkInTime = '9:04 AM';
  int _presentDays = 17;
  final int _lateDays = 2;
  final int _wfhDays = 1;

  // Daily Report State
  int _starRating = 4;
  final TextEditingController _tomorrowPlanCtrl = TextEditingController(
    text: 'Write test plan for CAN gateway integration & run test suite.',
  );
  final List<Map<String, dynamic>> _reportTasks = [
    {'title': 'Fix drowsiness threshold', 'hours': 3.0},
    {'title': 'Review PR #214', 'hours': 1.5},
  ];

  // Tasks State
  String _taskFilter = 'All';
  late List<TaskItem> _tasks;

  // Leave State
  final double _casualLeaveBalance = 7.5;
  final double _sickLeaveBalance = 10.0;
  final List<LeaveHistoryItem> _leaveHistory = [
    LeaveHistoryItem(
      dateRange: '14 Oct',
      type: 'Casual',
      duration: '1 day',
      status: 'Approved',
    ),
    LeaveHistoryItem(
      dateRange: '28 Sep',
      type: 'Casual',
      duration: '1 day',
      status: 'Pending',
    ),
    LeaveHistoryItem(
      dateRange: '18 Aug',
      type: 'Casual',
      duration: '1 day',
      status: 'Rejected',
    ),
  ];

  late String _userName;
  late String _roleName;
  late String _userInitials;
  Color _userDpColor = PVColors.accentGold;
  String _userDpUrl = '';

  String _computeInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return 'AR';
    if (parts.length == 1) return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    _userName = widget.userName;
    _roleName = widget.roleName;
    _userInitials = _computeInitials(_userName);
    _tasks = [
      TaskItem(
        id: '1',
        title: 'Fix drowsiness threshold',
        priority: 'High',
        dueDate: 'Due today',
        status: 'doing',
        hours: 3.0,
      ),
      TaskItem(
        id: '2',
        title: 'CAN gateway test',
        priority: 'Blocked',
        dueDate: 'Due 25 Sep',
        status: 'doing',
        hours: 2.0,
      ),
      TaskItem(
        id: '3',
        title: 'Review PR #214',
        priority: 'In Review',
        dueDate: 'Due 24 Sep',
        status: 'todo',
        hours: 1.5,
      ),
      TaskItem(
        id: '4',
        title: 'Write test plan for IMAS',
        priority: 'Low',
        dueDate: 'Due 30 Sep',
        status: 'todo',
        hours: 4.0,
      ),
      TaskItem(
        id: '5',
        title: 'Update camera driver patch',
        priority: 'Low',
        dueDate: '20 Sep',
        status: 'done',
        isCompleted: true,
        hours: 2.5,
      ),
    ];
  }

  @override
  void dispose() {
    _tomorrowPlanCtrl.dispose();
    super.dispose();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // UI Helpers & Badges
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildPillBadge({
    required String text,
    required Color bg,
    required Color textColor,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return _buildPillBadge(
          text: 'High',
          bg: PVColors.warningBg,
          textColor: PVColors.warningText,
        );
      case 'blocked':
        return _buildPillBadge(
          text: 'Blocked',
          bg: PVColors.errorBg,
          textColor: PVColors.errorText,
          icon: Icons.error_outline_rounded,
        );
      case 'in review':
        return _buildPillBadge(
          text: 'In Review',
          bg: PVColors.infoBg,
          textColor: PVColors.infoText,
        );
      case 'done':
        return _buildPillBadge(
          text: 'Completed',
          bg: PVColors.successBg,
          textColor: PVColors.success,
        );
      default:
        return _buildPillBadge(
          text: priority,
          bg: PVColors.successBg,
          textColor: PVColors.success,
        );
    }
  }

  Widget _buildStatusBadge(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return _buildPillBadge(
          text: 'Approved',
          bg: PVColors.successBg,
          textColor: PVColors.success,
        );
      case 'pending':
        return _buildPillBadge(
          text: 'Pending',
          bg: PVColors.warningBg,
          textColor: PVColors.warningText,
        );
      case 'rejected':
        return _buildPillBadge(
          text: 'Rejected',
          bg: PVColors.errorBg,
          textColor: PVColors.errorText,
        );
      default:
        return _buildPillBadge(
          text: status,
          bg: const Color(0xFFEEEEEE),
          textColor: PVColors.textSecondary,
        );
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Main Scaffold & Structure
  // ───────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PVColors.pageBg,
      body: Column(
        children: [
          // System Bar / Status Row
          _buildStatusBar(),

          // Active Tab Content
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                _buildHomeTab(),
                _buildDailyReportTab(),
                _buildAttendanceTab(),
                _buildTasksTab(),
                _buildLeaveTab(),
                _buildProfileTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomTabBar(),
    );
  }

  Widget _buildStatusBar() {
    final isDarkHeader = _currentTab == 0 || _currentTab == 5;
    return Container(
      color: isDarkHeader ? PVColors.primaryIndigo : PVColors.pageBg,
      padding: const EdgeInsets.only(top: 36, left: 16, right: 16, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDarkHeader ? Colors.white : PVColors.textPrimary,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.wifi,
                size: 14,
                color: isDarkHeader ? Colors.white : PVColors.textPrimary,
              ),
              const SizedBox(width: 6),
              Text(
                '5G',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDarkHeader ? Colors.white : PVColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // 1. HOME SCREEN (Overview)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Indigo Header with Profile & Date
          Container(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
            decoration: const BoxDecoration(
              color: PVColors.primaryIndigo,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // Round Logo Badge
                Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(right: 10),
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
                          const PathVisionLogo(size: 30),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi ${_userName.split(' ').first}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Wed, 23 Sep · ${widget.projectName}',
                        style: GoogleFonts.poppins(
                          fontSize: 11.5,
                          color: const Color(0xD9FFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showNotificationsSheet();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0x26FFFFFF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Quick Metric Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Present',
                        value: '$_presentDays/20',
                        subtext: 'This month',
                        icon: Icons.check_circle_outline_rounded,
                        accentColor: PVColors.success,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Leave left',
                        value: '$_casualLeaveBalance',
                        subtext: 'Days remaining',
                        icon: Icons.beach_access_rounded,
                        accentColor: PVColors.secondaryIndigo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Today's Tasks Summary Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: PVColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: PVColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Today's tasks",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: PVColors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: PVColors.pageBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${_tasks.where((t) => !t.isCompleted).length} pending',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: PVColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ..._tasks.take(3).map((task) {
                        final isBlocked = task.priority == 'Blocked';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(
                                isBlocked
                                    ? Icons.error_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                size: 16,
                                color: isBlocked
                                    ? PVColors.error
                                    : PVColors.secondaryIndigo,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: isBlocked
                                        ? PVColors.errorText
                                        : PVColors.textPrimary,
                                    fontWeight: isBlocked
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Performance & CPI Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: PVColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: PVColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Performance (CPI)',
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              color: PVColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '84',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: PVColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '/100',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: PVColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      _buildPillBadge(
                        text: '+3 vs last sprint',
                        bg: PVColors.successBg,
                        textColor: PVColors.success,
                        icon: Icons.trending_up_rounded,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Primary Action Button (Submit Report)
                _buildActionButton(
                  label: "Submit today's report",
                  bgColor: PVColors.accentGold,
                  textColor: PVColors.accentGoldDark,
                  icon: Icons.edit_calendar_rounded,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() => _currentTab = 1);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtext,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PVColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PVColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: PVColors.textSecondary,
                ),
              ),
              Icon(icon, size: 16, color: accentColor),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: PVColors.textPrimary,
            ),
          ),
          Text(
            subtext,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: PVColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // 2. DAILY REPORT SCREEN (05-A)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildDailyReportTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildScreenHeader('Daily report', 'Log your progress & plan'),
          const SizedBox(height: 10),

          // Project Identifier Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: PVColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: PVColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: PVColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.projectName,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: PVColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Tasks Breakdown & Time Log Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: PVColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: PVColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tasks & Time Allocation',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: PVColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Total: 4.5 h',
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: PVColors.secondaryIndigo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ..._reportTasks.map((task) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            task['title'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: PVColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: PVColors.pageBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${task['hours']} h',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: PVColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(color: PVColors.border, height: 16),
                InkWell(
                  onTap: () => _showAddTaskDialog(),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add_circle_outline_rounded,
                          size: 16,
                          color: PVColors.secondaryIndigo,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '+ Add task to log',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: PVColors.secondaryIndigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Tomorrow's Plan Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: PVColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: PVColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tomorrow's plan & blockers",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: PVColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _tomorrowPlanCtrl,
                  maxLines: 3,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: PVColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'What are you working on next?',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black26,
                    ),
                    filled: true,
                    fillColor: PVColors.pageBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Star Rating Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: PVColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: PVColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rate your output',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: PVColors.textSecondary,
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    final starIndex = index + 1;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() => _starRating = starIndex);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          starIndex <= _starRating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 22,
                          color: starIndex <= _starRating
                              ? PVColors.accentGold
                              : PVColors.border,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Submit Button
          _buildActionButton(
            label: 'Submit report',
            bgColor: PVColors.accentGold,
            textColor: PVColors.accentGoldDark,
            icon: Icons.check_circle_rounded,
            onTap: () {
              HapticFeedback.mediumImpact();
              _showSuccessDialog(
                title: 'Report Submitted',
                message:
                    'Your daily progress report has been submitted for review.',
              );
            },
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // 3. ATTENDANCE & CHECK-IN SCREEN (04-A)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildAttendanceTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildScreenHeader('Attendance', 'Time tracking & verification'),
          const SizedBox(height: 10),

          // Main Check In Box
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: PVColors.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: PVColors.border),
            ),
            child: Column(
              children: [
                Text(
                  _isCheckedIn ? 'Checked in at $_checkInTime' : 'Not checked in',
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: _isCheckedIn ? PVColors.success : PVColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _checkInTime,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: PVColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: PVColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Chennai office · GPS verified',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: PVColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  label: _isCheckedIn ? 'Check out' : 'Check in',
                  bgColor: _isCheckedIn
                      ? PVColors.error
                      : PVColors.secondaryIndigo,
                  textColor: Colors.white,
                  icon: _isCheckedIn
                      ? Icons.logout_rounded
                      : Icons.touch_app_rounded,
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    setState(() {
                      _isCheckedIn = !_isCheckedIn;
                      if (_isCheckedIn) _presentDays += 1;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isCheckedIn
                              ? 'Checked in successfully at Chennai office'
                              : 'Checked out successfully',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Monthly Attendance Grid
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: PVColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: PVColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'September 2026',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: PVColors.textPrimary,
                      ),
                    ),
                    Text(
                      '20 Working Days',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: PVColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Days of week header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                      .map(
                        (d) => Expanded(
                          child: Center(
                            child: Text(
                              d,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: PVColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 6),

                // 2-Row / 14-day sample calendar dot matrix as in design
                _buildAttendanceCalendarMatrix(),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Attendance Legend Counters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: PVColors.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: PVColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('Present', '$_presentDays', PVColors.success),
                _buildLegendItem('Late', '$_lateDays', PVColors.accentGold),
                _buildLegendItem('WFH', '$_wfhDays', PVColors.secondaryIndigo),
                _buildLegendItem('Leave', '1', PVColors.error),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCalendarMatrix() {
    final List<Color> dayColors = [
      PVColors.success,
      PVColors.success,
      PVColors.accentGold, // Late
      PVColors.success,
      PVColors.secondaryIndigo, // WFH
      const Color(0xFFC7CCD9), // Weekend
      const Color(0xFFC7CCD9), // Weekend
      PVColors.success,
      PVColors.error, // Absent
      PVColors.success,
      PVColors.success,
      PVColors.success,
      const Color(0xFFC7CCD9), // Weekend
      const Color(0xFFC7CCD9), // Weekend
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1.0,
      ),
      itemCount: dayColors.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: dayColors[index],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(String label, String count, Color dotColor) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label $count',
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: PVColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // 4. MY TASKS SCREEN (06-A)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildTasksTab() {
    final filtered = _tasks.where((t) {
      if (_taskFilter == 'All') return true;
      if (_taskFilter == 'To do') return t.status == 'todo';
      if (_taskFilter == 'Doing') return t.status == 'doing';
      if (_taskFilter == 'Done') return t.status == 'done';
      return true;
    }).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildScreenHeader('My tasks', 'Active sprint commitments'),
          const SizedBox(height: 10),

          // Filter Badges Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', _tasks.length, _taskFilter == 'All'),
                const SizedBox(width: 6),
                _buildFilterChip(
                  'To do',
                  _tasks.where((t) => t.status == 'todo').length,
                  _taskFilter == 'To do',
                  color: PVColors.infoBg,
                  textColor: PVColors.infoText,
                ),
                const SizedBox(width: 6),
                _buildFilterChip(
                  'Doing',
                  _tasks.where((t) => t.status == 'doing').length,
                  _taskFilter == 'Doing',
                  color: PVColors.warningBg,
                  textColor: PVColors.warningText,
                ),
                const SizedBox(width: 6),
                _buildFilterChip(
                  'Done',
                  _tasks.where((t) => t.status == 'done').length,
                  _taskFilter == 'Done',
                  color: PVColors.successBg,
                  textColor: PVColors.success,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Tasks List Cards
          ...filtered.map((task) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: PVColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: PVColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            task.isCompleted = !task.isCompleted;
                            task.status = task.isCompleted ? 'done' : 'doing';
                          });
                        },
                        child: Icon(
                          task.isCompleted
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          size: 18,
                          color: task.isCompleted
                              ? PVColors.success
                              : PVColors.secondaryIndigo,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          task.title,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: task.isCompleted
                                ? PVColors.textSecondary
                                : PVColors.textPrimary,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 26),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPriorityBadge(task.priority),
                        Text(
                          task.dueDate,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: PVColors.textSecondary,
                          ),
                        ),
                      ],
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

  Widget _buildFilterChip(
    String label,
    int count,
    bool isSelected, {
    Color? color,
    Color? textColor,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _taskFilter = label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? PVColors.secondaryIndigo)
              : PVColors.cardBg,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : PVColors.border,
          ),
        ),
        child: Text(
          '$label $count',
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? (textColor ?? Colors.white)
                : PVColors.textSecondary,
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // 5. LEAVE SCREEN (07-A)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildLeaveTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildScreenHeader('Leave', 'Balances & requests'),
          const SizedBox(height: 10),

          // Balances Row
          Row(
            children: [
              Expanded(
                child: _buildLeaveBalanceCard(
                  title: 'Casual',
                  remaining: '$_casualLeaveBalance',
                  total: '12',
                  percent: _casualLeaveBalance / 12,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildLeaveBalanceCard(
                  title: 'Sick',
                  remaining: '$_sickLeaveBalance',
                  total: '12',
                  percent: _sickLeaveBalance / 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Apply Button
          _buildActionButton(
            label: 'Apply for leave',
            bgColor: PVColors.secondaryIndigo,
            textColor: Colors.white,
            icon: Icons.add_circle_outline_rounded,
            onTap: () => _showApplyLeaveSheet(),
          ),
          const SizedBox(height: 14),

          // History Section
          Text(
            'History',
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: PVColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          ..._leaveHistory.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: PVColors.cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: PVColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.dateRange,
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: PVColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${item.type}, ${item.duration}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: PVColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  _buildStatusBadge(item.status),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLeaveBalanceCard({
    required String title,
    required String remaining,
    required String total,
    required double percent,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PVColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PVColors.border),
      ),
      child: Column(
        children: [
          Text(
            remaining,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: PVColors.textPrimary,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: PVColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: percent.clamp(0.0, 1.0),
              backgroundColor: PVColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(
                PVColors.secondaryIndigo,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // 6. ME / PROFILE SCREEN (02-B)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile Header Card
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            decoration: const BoxDecoration(
              color: PVColors.primaryIndigo,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                // Avatar with gold circle or custom photo
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: _userDpColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: ClipOval(
                    child: _userDpUrl.isNotEmpty
                        ? Image.network(_userDpUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Center(
                            child: Text(
                              _userInitials,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: PVColors.accentGoldDark,
                              ),
                            ),
                          ))
                        : Center(
                            child: Text(
                              _userInitials,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: PVColors.accentGoldDark,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _userName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$_roleName · ${widget.employeeId}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: const Color(0xD9FFFFFF),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Performance CPI Bar Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: PVColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: PVColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Performance (CPI)',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: PVColors.textSecondary,
                            ),
                          ),
                          Text(
                            '84%',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: PVColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: const LinearProgressIndicator(
                          value: 0.84,
                          backgroundColor: PVColors.border,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            PVColors.secondaryIndigo,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Tech Stack Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: PVColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: PVColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tech stack',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: PVColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _buildPillBadge(
                            text: 'Flutter',
                            bg: PVColors.infoBg,
                            textColor: PVColors.infoText,
                          ),
                          _buildPillBadge(
                            text: 'Dart',
                            bg: PVColors.infoBg,
                            textColor: PVColors.infoText,
                          ),
                          _buildPillBadge(
                            text: 'FastAPI',
                            bg: PVColors.infoBg,
                            textColor: PVColors.infoText,
                          ),
                          _buildPillBadge(
                            text: 'MinIO',
                            bg: PVColors.infoBg,
                            textColor: PVColors.infoText,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Quick Navigation Tiles
                _buildProfileNavTile(
                  title: 'Edit Profile (Name & Display Picture)',
                  icon: Icons.edit_rounded,
                  onTap: () => _showEditProfileDialog(),
                ),
                _buildProfileNavTile(
                  title: 'Notifications',
                  icon: Icons.notifications_none_rounded,
                  onTap: () => _showNotificationsSheet(),
                ),
                _buildProfileNavTile(
                  title: 'Documents Vault',
                  icon: Icons.folder_open_rounded,
                  onTap: () => _showDocumentsVaultSheet(),
                ),
                _buildProfileNavTile(
                  title: 'Learning paths',
                  icon: Icons.school_outlined,
                  onTap: () => _showLearningPathsSheet(),
                ),
                _buildProfileNavTile(
                  title: 'Switch Role / Logout',
                  icon: Icons.swap_horiz_rounded,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/role-selector');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileNavTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: PVColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: PVColors.border),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, size: 18, color: PVColors.secondaryIndigo),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: PVColors.textPrimary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          size: 18,
          color: PVColors.textSecondary,
        ),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Common UI Elements & Headers
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildScreenHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: PVColors.textPrimary,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: PVColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color bgColor,
    required Color textColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: textColor),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: PVColors.border, width: 0.8)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabItem(0, Icons.home_rounded, 'Home'),
          _buildTabItem(1, Icons.assignment_outlined, 'Report'),
          _buildTabItem(2, Icons.access_time_rounded, 'Check in'),
          _buildTabItem(3, Icons.checklist_rounded, 'Tasks'),
          _buildTabItem(4, Icons.beach_access_rounded, 'Leave'),
          _buildTabItem(5, Icons.person_rounded, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final isSelected = _currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _currentTab = index);
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 19,
              color: isSelected
                  ? PVColors.primaryIndigo
                  : PVColors.textSecondary,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? PVColors.primaryIndigo
                    : PVColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Modals & Bottom Sheets
  // ───────────────────────────────────────────────────────────────────────────
  void _showAddTaskDialog() {
    final titleCtrl = TextEditingController();
    final hoursCtrl = TextEditingController(text: '2.0');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Task Log',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: hoursCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Hours Spent',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (titleCtrl.text.isNotEmpty) {
                    setState(() {
                      _reportTasks.add({
                        'title': titleCtrl.text,
                        'hours': double.tryParse(hoursCtrl.text) ?? 1.0,
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PVColors.primaryIndigo,
                  minimumSize: const Size.fromHeight(42),
                ),
                child: const Text('Add Task', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showApplyLeaveSheet() {
    String selectedType = 'Casual';
    final reasonCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Apply for Leave',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedType,
                    items: ['Casual', 'Sick', 'Earned', 'Compensatory']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setSheetState(() => selectedType = val);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Leave Type',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: reasonCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Reason for leave',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _leaveHistory.insert(
                          0,
                          LeaveHistoryItem(
                            dateRange: 'Tomorrow',
                            type: selectedType,
                            duration: '1 day',
                            status: 'Pending',
                          ),
                        );
                      });
                      Navigator.pop(context);
                      _showSuccessDialog(
                        title: 'Leave Requested',
                        message: 'Your leave application has been submitted to your Team Lead.',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PVColors.secondaryIndigo,
                      minimumSize: const Size.fromHeight(42),
                    ),
                    child: const Text('Submit Application', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showNotificationsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              _buildNotificationItem(
                'Sprint Planning Reminder',
                'Sprint #14 kick-off meeting at 11:30 AM today.',
                '10m ago',
              ),
              _buildNotificationItem(
                'Leave Request Approved',
                'Your casual leave request for Oct 14 has been approved.',
                '2h ago',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(String title, String subtitle, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: PVColors.infoBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_outlined,
              size: 14,
              color: PVColors.infoText,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: PVColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: PVColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showDocumentsVaultSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Document Vault',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              _buildVaultItem('Offer_Letter_Signed.pdf', 'MinIO · 1.4 MB'),
              _buildVaultItem('Payslip_Aug_2026.pdf', 'Encrypted · 420 KB'),
              _buildVaultItem('Form_16_Tax.pdf', 'Verified · 890 KB'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVaultItem(String name, String meta) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.picture_as_pdf_rounded, color: PVColors.error),
      title: Text(name, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
      subtitle: Text(meta, style: GoogleFonts.poppins(fontSize: 10, color: PVColors.textSecondary)),
      trailing: const Icon(Icons.download_rounded, size: 18, color: PVColors.secondaryIndigo),
    );
  }

  void _showLearningPathsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Learning Paths',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              _buildLearningItem('Advanced Flutter & State Architecture', '80% completed'),
              _buildLearningItem('CAN Bus Protocol & Driver Monitoring', '45% completed'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLearningItem(String title, String progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(progress, style: GoogleFonts.poppins(fontSize: 10, color: PVColors.secondaryIndigo)),
        ],
      ),
    );
  }

  void _showSuccessDialog({required String title, required String message}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: PVColors.success, size: 22),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
          content: Text(message, style: GoogleFonts.poppins(fontSize: 12.5)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _userName);
    final roleCtrl = TextEditingController(text: _roleName);
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
                      color: selectedColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: PVColors.accentGold, width: 2),
                    ),
                    child: ClipOval(
                      child: dpUrlCtrl.text.isNotEmpty
                          ? Image.network(dpUrlCtrl.text, fit: BoxFit.cover, errorBuilder: (c, e, s) => Center(
                              child: Text(_computeInitials(nameCtrl.text), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: PVColors.accentGoldDark)),
                            ))
                          : Center(
                              child: Text(_computeInitials(nameCtrl.text), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: PVColors.accentGoldDark)),
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
                    PVColors.accentGold,
                    PVColors.primaryIndigo,
                    const Color(0xFF00695C),
                    const Color(0xFFB71C1C),
                    const Color(0xFF5E35B1),
                    const Color(0xFFE65100),
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
                  controller: roleCtrl,
                  decoration: const InputDecoration(labelText: 'Role / Title', border: OutlineInputBorder()),
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
                        _roleName = roleCtrl.text.trim().isEmpty ? _roleName : roleCtrl.text.trim();
                        _userDpUrl = dpUrlCtrl.text.trim();
                        _userDpColor = selectedColor;
                        _userInitials = _computeInitials(_userName);
                      });
                      Navigator.pop(ctx);
                      _showSuccessDialog(
                        title: 'Profile Updated',
                        message: 'Your name and display picture (DP) have been updated successfully!',
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: PVColors.secondaryIndigo, foregroundColor: Colors.white),
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
