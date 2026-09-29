import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/role_selector_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/hr_dashboard_screen.dart';
import 'screens/employee_dashboard_screen.dart';
import 'widgets/responsive_shell.dart';

void main() {
  runApp(const PathVisionApp());
}

class PathVisionApp extends StatelessWidget {
  const PathVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PathVision HRMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF212121)),
        ),
      ),
      initialRoute: '/',
      builder: (context, child) => ResponsiveShell(
        child: child ?? const SizedBox.shrink(),
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/role-selector': (context) => const RoleSelectorScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/hr-dashboard': (context) => const HRDashboardScreen(),
        '/employee-dashboard': (context) => const EmployeeDashboardScreen(),
      },
    );
  }
}
