import 'package:flutter/material.dart';

/// KUIZINE Color Palette
/// Inspired by African spices, condiments, and the warmth of Porto-Novo markets.
class AppColors {
  AppColors._();

  // ─── Primary (Terracotta — Piment rouge, terre cuite) ───
  static const Color primary = Color(0xFFD4602A);
  static const Color primaryLight = Color(0xFFE8844F);
  static const Color primaryDark = Color(0xFFA8461E);
  static const Color primarySurface = Color(0xFFFFF0E8);

  // ─── Secondary (Or épicé — Curcuma, safran) ───
  static const Color secondary = Color(0xFFF5A623);
  static const Color secondaryLight = Color(0xFFFFCC66);
  static const Color secondaryDark = Color(0xFFD4880E);
  static const Color secondarySurface = Color(0xFFFFF8E8);

  // ─── Accent (Vert herbe — Basilic, persil frais) ───
  static const Color accent = Color(0xFF2D8B4E);
  static const Color accentLight = Color(0xFF4CAF6E);
  static const Color accentDark = Color(0xFF1B6B38);
  static const Color accentSurface = Color(0xFFE8F5EC);

  // ─── Semantic ───
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFEAB308);
  static const Color warningLight = Color(0xFFFEF9C3);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF2563EB);
  static const Color infoLight = Color(0xFFDBEAFE);

  // ─── Light Mode ───
  static const Color background = Color(0xFFFEFCF9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFFFF8F0);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFD1D5DB);

  // ─── Dark Mode ───
  static const Color backgroundDark = Color(0xFF0F0F1A);
  static const Color surfaceDark = Color(0xFF1E1E2E);
  static const Color surfaceVariantDark = Color(0xFF2A2A3C);
  static const Color cardBackgroundDark = Color(0xFF252538);
  static const Color dividerDark = Color(0xFF3A3A4C);
  static const Color borderDark = Color(0xFF4A4A5C);

  // ─── Text Colors ───
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFF1A1A2E);

  static const Color textPrimaryDark = Color(0xFFF3F4F6);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textTertiaryDark = Color(0xFF6B7280);

  // ─── Gradients ───
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF8F0), Color(0xFFFEFCF9)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD4602A), Color(0xFFF5A623), Color(0xFF2D8B4E)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E1E2E), Color(0xFF2A2A3C)],
  );

  // ─── Shadows ───
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.02),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.15),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  // ─── Payment Method Colors ───
  static const Color mtnYellow = Color(0xFFFFCC00);
  static const Color moovBlue = Color(0xFF004B93);
  static const Color cashGreen = Color(0xFF16A34A);

  // ─── Order Status Colors ───
  static const Color statusPending = Color(0xFFEAB308);
  static const Color statusConfirmed = Color(0xFF2563EB);
  static const Color statusPreparing = Color(0xFFF5A623);
  static const Color statusOutForDelivery = Color(0xFF7C3AED);
  static const Color statusDelivered = Color(0xFF16A34A);
  static const Color statusCancelled = Color(0xFFDC2626);
}
