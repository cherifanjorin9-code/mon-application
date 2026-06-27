import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../data/mock/mock_catalog.dart';
import '../../domain/entities/product.dart';
import '../../shared/widgets/shared_widgets.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final Map<int, double> cartItems;
  final Function(int productId, double qty) onUpdateQuantity;
  final VoidCallback onClearCart;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onUpdateQuantity,
    required this.onClearCart,
  });

  double get _subtotal {
    return cartItems.entries.fold(0.0, (sum, entry) {
      final product = MockCatalog.getProductById(entry.key);
      if (product == null) return sum;
      return sum + product.sellingPrice * entry.value;
    });
  }

  double get _deliveryFee => _subtotal > 0 ? 300 : 0;
  double get _total => _subtotal + _deliveryFee;

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return const SafeArea(
        child: EmptyState(
          emoji: '🛒',
          title: 'Votre panier est vide',
          subtitle: 'Parcourez notre catalogue et ajoutez des ingrédients',
        ),
      );
    }

    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mon panier', style: AppTypography.headlineLarge),
                TextButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onClearCart();
                  },
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Vider'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                ),
              ],
            ),
          ),

          // Cart items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final entry = cartItems.entries.toList()[index];
                final product = MockCatalog.getProductById(entry.key);
                if (product == null) return const SizedBox.shrink();
                return _buildCartItem(context, product, entry.value);
              },
            ),
          ),

          // Summary & Checkout
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusXl),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: AppSpacing.borderRadiusFull,
                  ),
                ),

                _buildSummaryRow('Sous-total', _subtotal),
                AppSpacing.gapH8,
                _buildSummaryRow('Livraison', _deliveryFee,
                    note: 'Porto-Novo Centre'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                _buildSummaryRow('Total', _total, isTotal: true),
                AppSpacing.gapH16,

                KuizineButton(
                  label: 'Commander — ${_total.toInt()} FCFA',
                  icon: Icons.shopping_bag_outlined,
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckoutScreen(
                          cartItems: cartItems,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, Product product, double quantity) {
    final category = MockCatalog.getCategoryById(product.categoryId);
    final itemTotal = product.sellingPrice * quantity;

    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        onUpdateQuantity(product.id, 0);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: AppSpacing.cardPaddingSmall,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(color: AppColors.divider),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            // Product image
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Center(
                child: Text(
                  category?.icon ?? '🍽️',
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            AppSpacing.gapW12,

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTypography.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.gapH4,
                  Text(
                    '${product.sellingPrice.toInt()} FCFA / ${product.unit}',
                    style: AppTypography.bodySmall,
                  ),
                  AppSpacing.gapH8,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QuantitySelector(
                        quantity: quantity,
                        minQuantity: product.minQuantity,
                        step: product.stepQuantity,
                        onChanged: (q) => onUpdateQuantity(product.id, q),
                      ),
                      Text(
                        '${itemTotal.toInt()} FCFA',
                        style: AppTypography.priceSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value,
      {bool isTotal = false, String? note}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: isTotal
                  ? AppTypography.headlineSmall
                  : AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
            ),
            if (note != null)
              Text(
                note,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 10,
                ),
              ),
          ],
        ),
        Text(
          '${value.toInt()} FCFA',
          style: isTotal ? AppTypography.priceMedium : AppTypography.labelLarge,
        ),
      ],
    );
  }
}
