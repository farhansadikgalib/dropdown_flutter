import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';

/// Brand seed used across the example app.
const Color brandSeed = Color(0xFF4F46E5);

ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: brandSeed,
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: brightness == Brightness.light
        ? const Color(0xFFF6F7FB)
        : const Color(0xFF101014),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: scheme.onSurface,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

/// Card that wraps every example so each demo reads as its own labelled unit.
class DemoCard extends StatelessWidget {
  const DemoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.icon = Icons.tune_rounded,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      key: ValueKey('demo-card-$title'),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : const Color(0xFF1A1A20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: .5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isLight ? .05 : .25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Centred header: icon, then title and description beneath it.
          Center(
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: scheme.primary),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.35,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

/// Shared decoration giving the plain demos a visible field outline so they
/// read as interactive inputs inside the white [DemoCard] surface.
CustomDropdownDecoration fieldDecoration(
  BuildContext context, {
  ListItemDecoration? listItemDecoration,
}) {
  final scheme = Theme.of(context).colorScheme;
  final isLight = Theme.of(context).brightness == Brightness.light;
  final fill = isLight ? const Color(0xFFF8F9FC) : const Color(0xFF24242C);

  return CustomDropdownDecoration(
    closedFillColor: fill,
    expandedFillColor: isLight ? Colors.white : const Color(0xFF24242C),
    closedBorder: Border.all(color: scheme.outlineVariant),
    closedBorderRadius: BorderRadius.circular(14),
    expandedBorder: Border.all(color: scheme.primary.withValues(alpha: .55)),
    expandedBorderRadius: BorderRadius.circular(14),
    closedErrorBorder: Border.all(color: scheme.error),
    closedErrorBorderRadius: BorderRadius.circular(14),
    hintStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 15),
    headerStyle: TextStyle(
      color: scheme.onSurface,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
    listItemStyle: TextStyle(color: scheme.onSurface, fontSize: 15),
    errorStyle: TextStyle(color: scheme.error, fontSize: 12.5),
    listItemDecoration: listItemDecoration,
  );
}
