import 'package:flutter/material.dart';

/// KUIZINE Spacing & Dimension Tokens
/// Consistent 4px grid system for layout harmony.
class AppSpacing {
  AppSpacing._();

  // ─── Base Spacing (4px grid) ───
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 40.0;
  static const double massive = 48.0;
  static const double giant = 64.0;

  // ─── Screen Padding ───
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 20.0);
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: 16.0,
  );

  // ─── Card Padding ───
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardPaddingSmall = EdgeInsets.all(12.0);
  static const EdgeInsets cardPaddingLarge = EdgeInsets.all(20.0);

  // ─── Border Radius ───
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;
  static const double radiusFull = 999.0;

  static BorderRadius get borderRadiusSm => BorderRadius.circular(radiusSm);
  static BorderRadius get borderRadiusMd => BorderRadius.circular(radiusMd);
  static BorderRadius get borderRadiusLg => BorderRadius.circular(radiusLg);
  static BorderRadius get borderRadiusXl => BorderRadius.circular(radiusXl);
  static BorderRadius get borderRadiusFull => BorderRadius.circular(radiusFull);

  // ─── Component Dimensions ───
  static const double buttonHeight = 52.0;
  static const double buttonHeightSmall = 40.0;
  static const double inputHeight = 52.0;
  static const double bottomNavHeight = 72.0;
  static const double appBarHeight = 56.0;
  static const double productCardHeight = 220.0;
  static const double productImageHeight = 140.0;
  static const double categoryChipHeight = 40.0;
  static const double avatarSizeSm = 36.0;
  static const double avatarSizeMd = 48.0;
  static const double avatarSizeLg = 64.0;

  // ─── Animation Durations ───
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);
  static const Duration animVerySlow = Duration(milliseconds: 800);

  // ─── Convenience Gaps ───
  static const SizedBox gapH4 = SizedBox(height: 4);
  static const SizedBox gapH8 = SizedBox(height: 8);
  static const SizedBox gapH12 = SizedBox(height: 12);
  static const SizedBox gapH16 = SizedBox(height: 16);
  static const SizedBox gapH20 = SizedBox(height: 20);
  static const SizedBox gapH24 = SizedBox(height: 24);
  static const SizedBox gapH32 = SizedBox(height: 32);
  static const SizedBox gapH40 = SizedBox(height: 40);
  static const SizedBox gapH48 = SizedBox(height: 48);

  static const SizedBox gapW4 = SizedBox(width: 4);
  static const SizedBox gapW8 = SizedBox(width: 8);
  static const SizedBox gapW12 = SizedBox(width: 12);
  static const SizedBox gapW16 = SizedBox(width: 16);
  static const SizedBox gapW20 = SizedBox(width: 20);
  static const SizedBox gapW24 = SizedBox(width: 24);
}
