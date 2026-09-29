import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/pathvision_logo.dart';
import '../constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Role Data Model
// ─────────────────────────────────────────────────────────────────────────────
class _RoleItem {
  final String label;
  final String emoji;
  final IconData icon;
  final Color primaryColor;
  final Color bgColor;
  final String description;

  const _RoleItem({
    required this.label,
    required this.emoji,
    required this.icon,
    required this.primaryColor,
    required this.bgColor,
    required this.description,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Role Selector Screen
// ─────────────────────────────────────────────────────────────────────────────
class RoleSelectorScreen extends StatefulWidget {
  const RoleSelectorScreen({super.key});

  @override
  State<RoleSelectorScreen> createState() => _RoleSelectorScreenState();
}

class _RoleSelectorScreenState extends State<RoleSelectorScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedRole;

  late AnimationController _entryCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const List<_RoleItem> _roles = [
    _RoleItem(
      label: 'Super Admin',
      emoji: '🛡️',
      icon: Icons.admin_panel_settings_rounded,
      primaryColor: Color(0xFF1565C0),
      bgColor: Color(0xFFE3F2FD),
      description: 'System-wide control & security',
    ),
    _RoleItem(
      label: 'HR Manager',
      emoji: '👩‍💼',
      icon: Icons.badge_rounded,
      primaryColor: Color(0xFF00897B),
      bgColor: Color(0xFFE0F2F1),
      description: 'Personnel & onboarding',
    ),
    _RoleItem(
      label: 'Team Lead',
      emoji: '👥',
      icon: Icons.groups_rounded,
      primaryColor: Color(0xFF5E35B1),
      bgColor: Color(0xFFEDE7F6),
      description: 'Projects, sprints & team metrics',
    ),
    _RoleItem(
      label: 'Engineer',
      emoji: '⚙️',
      icon: Icons.code_rounded,
      primaryColor: Color(0xFFE53935),
      bgColor: Color(0xFFFFEBEE),
      description: 'Development, tasks & PRs',
    ),
    _RoleItem(
      label: 'Intern',
      emoji: '🎓',
      icon: Icons.school_rounded,
      primaryColor: Color(0xFFFB8C00),
      bgColor: Color(0xFFFFF3E0),
      description: 'Learning paths & assignments',
    ),
    _RoleItem(
      label: 'Mentor',
      emoji: '💬',
      icon: Icons.forum_rounded,
      primaryColor: Color(0xFF43A047),
      bgColor: Color(0xFFE8F5E9),
      description: 'Guidance, reviews & feedback',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut),
    );
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic),
    );
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  // ── Continue Action & Error Handling ───────────────────────────────────────

  void _handleContinue() {
    if (_selectedRole == null) {
      HapticFeedback.heavyImpact();
      _showProfessionalErrorSnackbar('Please select a role to continue.');
      return;
    }

    HapticFeedback.mediumImpact();
    String targetRoute = '/dashboard';
    if (_selectedRole == 'HR Manager') {
      targetRoute = '/hr-dashboard';
    } else if (_selectedRole == 'Engineer' ||
        _selectedRole == 'Intern' ||
        _selectedRole == 'Mentor' ||
        _selectedRole == 'Team Lead') {
      targetRoute = '/employee-dashboard';
    } else {
      targetRoute = '/dashboard';
    }

    Navigator.pushReplacementNamed(
      context,
      targetRoute,
      arguments: {'role': _selectedRole},
    );
  }

  void _showProfessionalErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFD32F2F),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        duration: const Duration(milliseconds: 3200),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFCEE8FB), // Soft corporate sky blue
              Color(0xFFE8F4FD),
              Color(0xFFF7FAFD),
              Color(0xFFFFFFFF),
            ],
            stops: [0.0, 0.25, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    children: [
                      // ── Top Header ──────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                        child: Row(
                          children: [
                            AntigravityHover(
                              amplitude: 4,
                              period: const Duration(milliseconds: 2800),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF1565C0).withAlpha(25),
                                      blurRadius: 12,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(5),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/pathvision_logo.jpeg',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const PathVisionLogo(size: 28),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PathVision Innovations',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0D1B2A),
                                  ),
                                ),
                                Text(
                                  'Select Workspace Profile',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF78909C),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => Navigator.pushReplacementNamed(
                                  context, '/login'),
                              icon: const Icon(
                                Icons.logout_rounded,
                                color: Color(0xFF78909C),
                                size: 20,
                              ),
                              tooltip: 'Back to Login',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ── Main Titles ─────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Select Your Role',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0D1B2A),
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Choose the role that best describes you.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF607D8B),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── 2 Columns × 3 Rows Grid ─────────────────────────────
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.35,
                            ),
                            itemCount: _roles.length,
                            itemBuilder: (context, index) {
                              final role = _roles[index];
                              final isSelected = _selectedRole == role.label;
                              final phaseOffset = (index * 0.16) % 1.0;

                              return _RoleCard(
                                role: role,
                                isSelected: isSelected,
                                phaseOffset: phaseOffset,
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    _selectedRole = role.label;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),

                      // ── Bottom Action Button (Continue) ──────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _selectedRole != null
                                    ? [
                                        const Color(0xFF1246A8),
                                        const Color(0xFF1976D2),
                                        const Color(0xFF42A5F5),
                                      ]
                                    : [
                                        const Color(0xFF90CAF9),
                                        const Color(0xFFBBDEFB),
                                      ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: _selectedRole != null
                                      ? const Color(0xFF1565C0).withAlpha(70)
                                      : Colors.transparent,
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _handleContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _selectedRole != null
                                        ? 'Continue as $_selectedRole'
                                        : 'Continue',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward_rounded, size: 17),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual Role Card Component (Compact & Modern)
// ─────────────────────────────────────────────────────────────────────────────
class _RoleCard extends StatefulWidget {
  final _RoleItem role;
  final bool isSelected;
  final double phaseOffset;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.isSelected,
    required this.phaseOffset,
    required this.onTap,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapCtrl;

  @override
  void initState() {
    super.initState();
    _tapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.94,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _tapCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AntigravityHover(
      amplitude: 4,
      period: const Duration(milliseconds: 2600),
      phaseOffset: widget.phaseOffset,
      child: GestureDetector(
        onTapDown: (_) => _tapCtrl.reverse(),
        onTapUp: (_) {
          _tapCtrl.forward();
          widget.onTap();
        },
        onTapCancel: () => _tapCtrl.forward(),
        child: AnimatedBuilder(
          animation: _tapCtrl,
          builder: (_, child) =>
              Transform.scale(scale: _tapCtrl.value, child: child),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isSelected
                    ? widget.role.primaryColor
                    : const Color(0xFFE2EAF2),
                width: widget.isSelected ? 2.0 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.isSelected
                      ? widget.role.primaryColor.withAlpha(50)
                      : const Color(0xFF1565C0).withAlpha(10),
                  blurRadius: widget.isSelected ? 14 : 6,
                  spreadRadius: widget.isSelected ? 1 : 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Active check indicator badge
                if (widget.isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: widget.role.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Emoji / Icon Avatar
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: widget.isSelected
                                ? widget.role.primaryColor.withAlpha(25)
                                : widget.role.bgColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              widget.role.emoji,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Label
                        Text(
                          widget.role.label,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: widget.isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: widget.isSelected
                                ? widget.role.primaryColor
                                : const Color(0xFF1A1A2E),
                          ),
                        ),

                        // Selection Bar Indicator
                        const SizedBox(height: 3),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: widget.isSelected ? 20 : 0,
                          height: 2.5,
                          decoration: BoxDecoration(
                            color: widget.role.primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
