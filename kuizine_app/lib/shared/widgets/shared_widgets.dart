import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

/// Primary CTA button with gradient background
class KuizineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isSmall;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;

  const KuizineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isSmall = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final height = isSmall ? AppSpacing.buttonHeightSmall : AppSpacing.buttonHeight;
    final bgColor = backgroundColor ?? AppColors.primary;
    final fgColor = foregroundColor ?? AppColors.textOnPrimary;

    if (isOutlined) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: bgColor, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusMd,
            ),
          ),
          child: _buildChild(bgColor),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed != null && !isLoading
              ? AppColors.primaryGradient
              : null,
          color: onPressed == null || isLoading
              ? AppColors.textTertiary.withValues(alpha: 0.3)
              : null,
          borderRadius: AppSpacing.borderRadiusMd,
          boxShadow: onPressed != null && !isLoading
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: fgColor,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.borderRadiusMd,
            ),
          ),
          child: _buildChild(fgColor),
        ),
      ),
    );
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isSmall ? 18 : 20),
          AppSpacing.gapW8,
          Text(
            label,
            style: isSmall ? AppTypography.buttonSmall : AppTypography.buttonLarge,
          ),
        ],
      );
    }

    return Text(
      label,
      style: isSmall ? AppTypography.buttonSmall : AppTypography.buttonLarge,
    );
  }
}

/// Quantity selector widget (+/-)
class QuantitySelector extends StatelessWidget {
  final double quantity;
  final double minQuantity;
  final double step;
  final String unit;
  final ValueChanged<double> onChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    this.minQuantity = 1,
    this.step = 1,
    this.unit = '',
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppSpacing.borderRadiusFull,
        border: Border.all(color: AppColors.divider),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Icons.remove,
            onTap: quantity > minQuantity
                ? () => onChanged(quantity - step)
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _formatQuantity(),
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _buildButton(
            icon: Icons.add,
            onTap: () => onChanged(quantity + step),
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  String _formatQuantity() {
    if (quantity == quantity.toInt()) {
      return '${quantity.toInt()}${unit.isNotEmpty ? ' $unit' : ''}';
    }
    return '${quantity.toStringAsFixed(1)}${unit.isNotEmpty ? ' $unit' : ''}';
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback? onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppSpacing.animFast,
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onTap == null
              ? AppColors.divider
              : isPrimary
                  ? AppColors.primary
                  : AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: onTap != null
              ? [
                  BoxShadow(
                    color: (isPrimary ? AppColors.primary : Colors.black)
                        .withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 16,
          color: onTap == null
              ? AppColors.textTertiary
              : isPrimary
                  ? Colors.white
                  : AppColors.textPrimary,
        ),
      ),
    );
  }
}

/// Price tag widget showing market price + KUIZINE price
class PriceTag extends StatelessWidget {
  final double marketPrice;
  final double sellingPrice;
  final bool showMarketPrice;
  final bool isLarge;

  const PriceTag({
    super.key,
    required this.marketPrice,
    required this.sellingPrice,
    this.showMarketPrice = true,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${sellingPrice.toInt()} FCFA',
          style: isLarge ? AppTypography.priceLarge : AppTypography.priceSmall,
        ),
        if (showMarketPrice && marketPrice != sellingPrice) ...[
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${marketPrice.toInt()} FCFA',
                style: AppTypography.priceStrikethrough.copyWith(
                  fontSize: isLarge ? 14 : 11,
                ),
              ),
              AppSpacing.gapW4,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accentSurface,
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
                child: Text(
                  'Prix marché',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.accent,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Loading overlay with KUIZINE branding
class LoadingOverlay extends StatelessWidget {
  final String? message;

  const LoadingOverlay({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          padding: AppSpacing.cardPaddingLarge,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppSpacing.borderRadiusXl,
            boxShadow: AppColors.elevatedShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              if (message != null) ...[
                AppSpacing.gapH16,
                Text(
                  message!,
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Empty state widget
class EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 64),
            ),
            AppSpacing.gapH16,
            Text(
              title,
              style: AppTypography.headlineMedium,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapH8,
            Text(
              subtitle,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              AppSpacing.gapH24,
              KuizineButton(
                label: actionLabel!,
                onPressed: onAction,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
