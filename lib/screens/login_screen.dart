import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/pathvision_logo.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Entry animation
  late AnimationController _entryCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // Login button press animation
  late AnimationController _btnCtrl;
  late Animation<double> _btnScale;

  // Focus nodes for field glow
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 850));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
            CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));
    _entryCtrl.forward();

    _btnCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _btnScale = Tween<double>(begin: 1.0, end: 0.97).animate(
        CurvedAnimation(parent: _btnCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _entryCtrl.dispose();
    _btnCtrl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  // ── Auth handlers ──────────────────────────────────────────────────────────

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack(
        email.isEmpty
            ? 'Please enter your email address.'
            : 'Please enter your password.',
        isError: true,
      );
      return;
    }

    await _btnCtrl.forward();
    _btnCtrl.reverse();

    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, '/role-selector');
    }
  }

  void _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1100));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, '/role-selector');
    }
  }

  // ── Forgot Password Dialog ─────────────────────────────────────────────────

  void _showForgotPasswordDialog() {
    final emailCtrl = TextEditingController(text: _emailController.text);
    showDialog(
      context: context,
      builder: (context) {
        bool isSending = false;
        bool isSent = false;
        return StatefulBuilder(
          builder: (context, setDs) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0x1A1565C0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_reset_rounded,
                        color: Color(0xFF1565C0)),
                  ),
                  const SizedBox(width: 12),
                  Text('Reset Password',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: const Color(0xFF1A1A2E))),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isSent) ...[
                    Text(
                      "Enter your email and we'll send a reset link.",
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF757575),
                          height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: _dialogFieldDecoration(
                          'Enter your email', Icons.email_outlined),
                    ),
                  ] else ...[
                    const Center(
                        child: Icon(Icons.check_circle_rounded,
                            color: Color(0xFF4CAF50), size: 56)),
                    const SizedBox(height: 16),
                    Text('Reset link sent! Check your inbox.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF424242))),
                  ],
                ],
              ),
              actions: [
                if (!isSent) ...[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel',
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF757575),
                            fontWeight: FontWeight.w600)),
                  ),
                  ElevatedButton(
                    onPressed: isSending
                        ? null
                        : () async {
                            if (emailCtrl.text.trim().isEmpty) return;
                            setDs(() => isSending = true);
                            await Future.delayed(
                                const Duration(milliseconds: 1200));
                            setDs(() {
                              isSending = false;
                              isSent = true;
                            });
                          },
                    style: _dialogBtnStyle(),
                    child: isSending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text('Send Link',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600)),
                  ),
                ] else ...[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Close',
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF1565C0),
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  void _showCreateAccountDialog() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final fKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        bool isRegistering = false;
        return StatefulBuilder(
          builder: (context, setDs) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Color(0x1A1565C0), shape: BoxShape.circle),
                    child: const Icon(Icons.person_add_alt_1_rounded,
                        color: Color(0xFF1565C0)),
                  ),
                  const SizedBox(width: 12),
                  Text('Create Account',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: const Color(0xFF1A1A2E))),
                ],
              ),
              content: Form(
                key: fKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _dialogTextField(nameCtrl, 'Full Name',
                        Icons.person_outline_rounded,
                        validator: (v) =>
                            v!.isEmpty ? 'Please enter name' : null),
                    const SizedBox(height: 12),
                    _dialogTextField(emailCtrl, 'Email address',
                        Icons.email_outlined,
                        type: TextInputType.emailAddress,
                        validator: (v) =>
                            v!.isEmpty ? 'Please enter email' : null),
                    const SizedBox(height: 12),
                    _dialogTextField(passCtrl, 'Password',
                        Icons.lock_outline_rounded,
                        obscure: true,
                        validator: (v) =>
                            v!.isEmpty ? 'Please enter password' : null),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel',
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF757575),
                          fontWeight: FontWeight.w600)),
                ),
                ElevatedButton(
                  onPressed: isRegistering
                      ? null
                      : () async {
                          if (!fKey.currentState!.validate()) return;
                          setDs(() => isRegistering = true);
                          await Future.delayed(
                              const Duration(milliseconds: 1500));
                          if (context.mounted) {
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(
                                context, '/role-selector');
                          }
                        },
                  style: _dialogBtnStyle(),
                  child: isRegistering
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : Text('Register & Login',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ── Snackbar ───────────────────────────────────────────────────────────────

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.info_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(msg,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        backgroundColor:
            isError ? const Color(0xFFD32F2F) : const Color(0xFF1565C0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
              Color(0xFFFFFFFF), // Pure white
            ],
            stops: [0.0, 0.30, 0.65, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),

                        // ── 1. Uploaded Logo at Top Center ────────────────
                        AntigravityHover(
                          amplitude: 5,
                          period: const Duration(milliseconds: 2800),
                          child: Container(
                            width: 86,
                            height: 86,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1565C0).withAlpha(25),
                                  blurRadius: 20,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 6),
                                ),
                                BoxShadow(
                                  color: Colors.white.withAlpha(220),
                                  blurRadius: 4,
                                  offset: const Offset(0, -2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              'assets/images/pathvision_logo.jpeg',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const PathVisionLogo(size: 68),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ── 2. Brand Name in Solid Black Text ──────────────
                        Text(
                          'PathVision Innovations',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0D1B2A), // Solid black/navy
                            letterSpacing: -0.2,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // ── 3. Subtitle in Lighter Gray Tone ───────────────
                        Text(
                          'Human Resource Management System',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF78909C), // Lighter gray
                            letterSpacing: 0.2,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ── 4. Main Login Card ─────────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 26),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xFF1565C0).withAlpha(16),
                                blurRadius: 36,
                                spreadRadius: 0,
                                offset: const Offset(0, 12),
                              ),
                              BoxShadow(
                                color: Colors.white.withAlpha(220),
                                blurRadius: 6,
                                offset: const Offset(0, -2),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFFBBDEFB).withAlpha(120),
                              width: 1,
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Welcome text
                                Text(
                                  'Welcome back',
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0D1B2A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Sign in to continue to your workspace',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF9E9E9E),
                                  ),
                                ),

                                const SizedBox(height: 22),

                                // ── 5. Email Input Field ───────────────────
                                _FloatingInputField(
                                  controller: _emailController,
                                  focusNode: _emailFocus,
                                  hint: 'Email address',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                ),

                                const SizedBox(height: 12),

                                // ── 6. Password Input Field ────────────────
                                _FloatingInputField(
                                  controller: _passwordController,
                                  focusNode: _passFocus,
                                  hint: 'Password',
                                  icon: Icons.lock_outline_rounded,
                                  obscure: _obscurePassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: const Color(0xFF9E9E9E),
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                        () => _obscurePassword =
                                            !_obscurePassword),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // ── 7. Large Blue 'Sign In' Button ─────────
                                AnimatedBuilder(
                                  animation: _btnScale,
                                  builder: (context, child) =>
                                      Transform.scale(
                                    scale: _btnScale.value,
                                    child: child,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF1246A8),
                                            Color(0xFF1976D2),
                                            Color(0xFF42A5F5),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF1565C0)
                                                .withAlpha(75),
                                            blurRadius: 16,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed:
                                            _isLoading ? null : _handleLogin,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: _isLoading
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2.2,
                                                ),
                                              )
                                            : Text(
                                                'Sign In',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15.5,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // ── 8. Forgot Password Link ────────────────
                                GestureDetector(
                                  onTap: _showForgotPasswordDialog,
                                  child: Text(
                                    'Forgot Password?',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1565C0),
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          const Color(0xFF1565C0),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 18),

                                // ── Divider ─────────────────────────────────
                                Row(
                                  children: [
                                    const Expanded(
                                        child: Divider(
                                            color: Color(0xFFE8EEF4),
                                            thickness: 1)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14),
                                      child: Text('OR',
                                          style: GoogleFonts.poppins(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  const Color(0xFFB0BEC5))),
                                    ),
                                    const Expanded(
                                        child: Divider(
                                            color: Color(0xFFE8EEF4),
                                            thickness: 1)),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                // ── 9. Continue with Google Option ─────────
                                _SecondaryButton(
                                  onPressed:
                                      _isLoading ? null : _handleGoogleLogin,
                                  icon: const _GoogleIcon(size: 19),
                                  label: 'Continue with Google',
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ── 10. Footer: Create Account in Subtle Gray ──────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account? ",
                                style: GoogleFonts.poppins(
                                    fontSize: 12.5,
                                    color: const Color(0xFF78909C))),
                            GestureDetector(
                              onTap: _showCreateAccountDialog,
                              child: Text(
                                'Create one',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1565C0),
                                  decoration: TextDecoration.underline,
                                  decorationColor: const Color(0xFF1565C0),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        Text(
                          '© 2025 PathVision Innovations. All rights reserved.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 10.5,
                              color: const Color(0xFFB0BEC5)),
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Helper builders ────────────────────────────────────────────────────────

  InputDecoration _dialogFieldDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          GoogleFonts.poppins(fontSize: 13, color: const Color(0xFFBDBDBD)),
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF1565C0), width: 1.5)),
    );
  }

  Widget _dialogTextField(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    TextInputType type = TextInputType.text,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      obscureText: obscure,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: _dialogFieldDecoration(hint, icon),
    );
  }

  ButtonStyle _dialogBtnStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1565C0),
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Floating input field with animated blue glow on focus
// ─────────────────────────────────────────────────────────────────────────────
class _FloatingInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const _FloatingInputField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  State<_FloatingInputField> createState() => _FloatingInputFieldState();
}

class _FloatingInputFieldState extends State<_FloatingInputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _shadowCtrl;
  late Animation<double> _shadowAnim;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _shadowCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _shadowAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _shadowCtrl, curve: Curves.easeOut));

    widget.focusNode.addListener(() {
      setState(() => _isFocused = widget.focusNode.hasFocus);
      if (widget.focusNode.hasFocus) {
        _shadowCtrl.forward();
      } else {
        _shadowCtrl.reverse();
      }
    });
  }

  @override
  void dispose() {
    _shadowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shadowAnim,
      builder: (context, child) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(21, 101, 192, _shadowAnim.value * 0.14),
              blurRadius: 8 + _shadowAnim.value * 8,
              spreadRadius: _shadowAnim.value * 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: child,
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: widget.obscure,
        keyboardType: widget.keyboardType,
        style: GoogleFonts.poppins(
            fontSize: 13.5,
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFFB0BEC5),
              fontWeight: FontWeight.w400),
          prefixIcon: Icon(widget.icon,
              color: _isFocused
                  ? const Color(0xFF1565C0)
                  : const Color(0xFFB0BEC5),
              size: 19),
          suffixIcon: widget.suffixIcon,
          filled: true,
          fillColor: _isFocused
              ? const Color(0xFFEBF4FF)
              : const Color(0xFFF7FAFD),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFFDDE6EF), width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFF1565C0), width: 1.8)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Outlined secondary button (Google)
// ─────────────────────────────────────────────────────────────────────────────
class _SecondaryButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final String label;

  const _SecondaryButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: widget.onPressed,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFDDE6EF), width: 1.4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              backgroundColor: const Color(0xFFF7FAFD),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.icon,
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF37474F),
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

// ─────────────────────────────────────────────────────────────────────────────
// Google colour icon (painted, no asset needed)
// ─────────────────────────────────────────────────────────────────────────────
class _GoogleIcon extends StatelessWidget {
  final double size;
  const _GoogleIcon({this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleIconPainter()),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Blue arc (right half)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -0.3,
      3.0,
      false,
      Paint()
        ..color = const Color(0xFF4285F4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.22
        ..strokeCap = StrokeCap.butt,
    );
    // Red arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      2.7,
      1.5,
      false,
      Paint()
        ..color = const Color(0xFFEA4335)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.22,
    );
    // Yellow arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      4.2,
      0.9,
      false,
      Paint()
        ..color = const Color(0xFFFBBC05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.22,
    );
    // Green arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      5.1,
      0.75,
      false,
      Paint()
        ..color = const Color(0xFF34A853)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.22,
    );
    // White horizontal bar for the "G" cutout
    final barPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.height * 0.25
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + r + size.width * 0.05, cy),
      barPaint,
    );
    // White vertical cutout
    final vPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.25;
    canvas.drawLine(
      Offset(cx + r * 0.45, cy - r * 0.35),
      Offset(cx + r * 0.45, cy + r * 0.35),
      vPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
