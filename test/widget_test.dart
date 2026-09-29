import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hrms_app/constants.dart';
import 'package:hrms_app/main.dart';
import 'package:hrms_app/screens/dashboard_screen.dart';
import 'package:hrms_app/widgets/responsive_shell.dart';

void main() {
  testWidgets('PathVision app launches and renders MaterialApp with ResponsiveShell',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PathVisionApp());
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(ResponsiveShell), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
  });

  for (final width in [375.0, 768.0, 1280.0, 1920.0]) {
    testWidgets('Dashboard layout width is constrained to <= kMaxContentWidth at width $width',
        (WidgetTester tester) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveShell(
            child: child ?? const SizedBox.shrink(),
          ),
          home: const DashboardScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      final scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);

      final scaffoldSize = tester.getSize(scaffoldFinder);
      final expectedWidth = width < kMaxContentWidth ? width : kMaxContentWidth;
      expect(scaffoldSize.width, equals(expectedWidth));

      // Verify FAB is positioned within the constrained Scaffold
      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);

      final fabTopRight = tester.getTopRight(fabFinder);
      final scaffoldTopRight = tester.getTopRight(scaffoldFinder);

      // FAB right edge should be inside the scaffold right edge by ~16px
      expect(fabTopRight.dx, lessThanOrEqualTo(scaffoldTopRight.dx));
      expect(fabTopRight.dx, greaterThanOrEqualTo(scaffoldTopRight.dx - 20));
    });
  }
}
