import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../domain/entities/product.dart';
import '../../data/mock/mock_catalog.dart';
import '../../shared/widgets/shared_widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Function(Product) onAddToCart;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late double _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.product.minQuantity;
  }

  double get _totalPrice => widget.product.sellingPrice * _quantity;
  double get _marketTotal => widget.product.marketPrice * _quantity;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final category = MockCatalog.getCategoryById(product.categoryId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Image hero
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.surfaceVariant,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: AppColors.surface.withValues(alpha: 0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.surfaceVariant,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category?.icon ?? '🍽️',
                        style: const TextStyle(fontSize: 100),
                      ),
                      AppSpacing.gapH8,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.8),
                          borderRadius: AppSpacing.borderRadiusFull,
                        ),
                        child: Text(
                          category?.name ?? '',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Product details
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusXl),
                ),
              ),
              transform: Matrix4.translationValues(0, -20, 0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name & availability
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: AppTypography.headlineLarge,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: product.inStock
                                ? AppColors.successLight
                                : AppColors.errorLight,
                            borderRadius: AppSpacing.borderRadiusFull,
                          ),
                          child: Text(
                            product.inStock ? '✅ En stock' : '❌ Indisponible',
                            style: AppTypography.labelSmall.copyWith(
                              color: product.inStock
                                  ? AppColors.success
                                  : AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    AppSpacing.gapH16,

                    // Price section
                    Container(
                      padding: AppSpacing.cardPadding,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: AppSpacing.borderRadiusLg,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Prix KUIZINE',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  '${product.sellingPrice.toInt()} FCFA',
                                  style: AppTypography.priceLarge,
                                ),
                                Text(
                                  'par ${product.unit}',
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 50,
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                          AppSpacing.gapW16,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Prix marché',
                                  style: AppTypography.labelMedium.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                                Text(
                                  '${product.marketPrice.toInt()} FCFA',
                                  style: AppTypography.priceStrikethrough.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  '+${product.marginPercent.toStringAsFixed(1)}% marge',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    AppSpacing.gapH24,

                    // Description
                    Text('Description', style: AppTypography.headlineSmall),
                    AppSpacing.gapH8,
                    Text(
                      product.description,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),

                    AppSpacing.gapH24,

                    // Info chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildInfoChip('📏', 'Unité: ${product.unit}'),
                        _buildInfoChip('📦', 'Min: ${product.minQuantity.toStringAsFixed(product.minQuantity == product.minQuantity.toInt() ? 0 : 1)} ${product.unit}'),
                        _buildInfoChip('🏷️', 'Marge: +${product.marginPercent}%'),
                      ],
                    ),

                    AppSpacing.gapH24,

                    // Quantity selector
                    Text('Quantité', style: AppTypography.headlineSmall),
                    AppSpacing.gapH12,
                    Row(
                      children: [
                        QuantitySelector(
                          quantity: _quantity,
                          minQuantity: product.minQuantity,
                          step: product.stepQuantity,
                          unit: product.unit,
                          onChanged: (q) => setState(() => _quantity = q),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Total: ${_totalPrice.toInt()} FCFA',
                              style: AppTypography.priceMedium,
                            ),
                            Text(
                              'Marché: ${_marketTotal.toInt()} FCFA',
                              style: AppTypography.priceStrikethrough,
                            ),
                          ],
                        ),
                      ],
                    ),

                    AppSpacing.gapH32,

                    // Similar products
                    Text('Du même rayon', style: AppTypography.headlineSmall),
                    AppSpacing.gapH12,
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: MockCatalog.getProductsByCategory(product.categoryId)
                            .where((p) => p.id != product.id)
                            .length,
                        itemBuilder: (context, index) {
                          final similar = MockCatalog.getProductsByCategory(product.categoryId)
                              .where((p) => p.id != product.id)
                              .toList()[index];
                          return _buildSimilarProductCard(similar);
                        },
                      ),
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom bar — Add to cart
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total', style: AppTypography.bodySmall),
                  Text(
                    '${_totalPrice.toInt()} FCFA',
                    style: AppTypography.priceMedium,
                  ),
                ],
              ),
              AppSpacing.gapW16,
              Expanded(
                child: KuizineButton(
                  label: 'Ajouter au panier',
                  icon: Icons.shopping_bag_outlined,
                  onPressed: product.inStock
                      ? () {
                          HapticFeedback.mediumImpact();
                          widget.onAddToCart(product);
                          Navigator.pop(context);
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String emoji, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppSpacing.borderRadiusFull,
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          AppSpacing.gapW4,
          Text(text, style: AppTypography.labelSmall),
        ],
      ),
    );
  }

  Widget _buildSimilarProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
              product: product,
              onAddToCart: widget.onAddToCart,
            ),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              MockCatalog.getCategoryById(product.categoryId)?.icon ?? '🍽️',
              style: const TextStyle(fontSize: 36),
            ),
            AppSpacing.gapH8,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                product.name,
                style: AppTypography.labelSmall.copyWith(fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            AppSpacing.gapH4,
            Text(
              '${product.sellingPrice.toInt()} FCFA',
              style: AppTypography.priceSmall.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
