import 'package:flutter/material.dart';
import '../constants.dart';

/// A reusable responsive shell that wraps the application layout on wide screens.
///
/// Layout structure:
/// - Outer: [Container] filling the screen with the light scaffold background color.
/// - Alignment: [Align] with [Alignment.topCenter].
/// - Width constraint: [ConstrainedBox] with `maxWidth: [kMaxContentWidth]`.
/// - Inner: The actual [Scaffold] (header, body, bottomNavigationBar, FAB).
/// - Distinct elevation: Subtle box shadow on wide screens to visually distinguish
///   the column from the outer background.
/// - Unchanged on mobile: Below [kMaxContentWidth], it expands to full screen width.
class ResponsiveShell extends StatelessWidget {
  final Widget child;

  const ResponsiveShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > kMaxContentWidth;

        return Container(
          color: const Color(0xFFF5F7FA),
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: kMaxContentWidth),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                boxShadow: isWide
                    ? const [
                        BoxShadow(
                          color: Color(0x141A237E),
                          blurRadius: 24,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 1,
                          spreadRadius: 0,
                          offset: Offset(0, 0),
                        ),
                      ]
                    : null,
              ),
              child: ClipRect(
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
