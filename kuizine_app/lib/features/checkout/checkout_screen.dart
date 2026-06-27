import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock/mock_catalog.dart';
import '../../domain/entities/order.dart';
import '../../shared/widgets/shared_widgets.dart';
import '../orders/order_tracking_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<int, double> cartItems;

  const CheckoutScreen({super.key, required this.cartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedQuarter = 'Centre Porto-Novo';
  PaymentMethod _selectedPayment = PaymentMethod.mtnMomo;
  bool _isProcessing = false;

  final List<String> _quarters = [
    'Centre Porto-Novo',
    'Ouando',
    'Tokpota',
    'Djassin',
    'Houinmé',
    'Agbokou',
    'Catchi',
    'Autre',
  ];

  double get _subtotal {
    return widget.cartItems.entries.fold(0.0, (sum, entry) {
      final product = MockCatalog.getProductById(entry.key);
      if (product == null) return sum;
      return sum + product.sellingPrice * entry.value;
    });
  }

  int get _deliveryFee {
    switch (_selectedQuarter.toLowerCase()) {
      case 'centre porto-novo':
        return 200;
      case 'ouando':
      case 'tokpota':
      case 'djassin':
        return 300;
      case 'houinmé':
      case 'agbokou':
      case 'catchi':
        return 400;
      default:
        return 500;
    }
  }

  double get _total => _subtotal + _deliveryFee;

  void _placeOrder() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    // Simulate order placement
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _isProcessing = false);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OrderTrackingScreen(
            orderNumber: Formatters.formatOrderNumber(1),
            total: _total,
            paymentMethod: _selectedPayment,
            deliveryAddress: _addressController.text,
            quarter: _selectedQuarter,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Finaliser la commande'),
        backgroundColor: AppColors.background,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Delivery Address ───
                  AppSpacing.gapH16,
                  _buildSectionHeader('📍', 'Adresse de livraison'),
                  AppSpacing.gapH12,

                  // Quarter selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: AppSpacing.borderRadiusMd,
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedQuarter,
                        isExpanded: true,
                        icon: const Icon(Icons.expand_more),
                        items: _quarters.map((q) => DropdownMenuItem(
                          value: q,
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 18, color: AppColors.primary),
                              AppSpacing.gapW8,
                              Text(q),
                              if (q != 'Autre') ...[
                                const Spacer(),
                                Text(
                                  _getDeliveryFeeForQuarter(q),
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.accent,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )).toList(),
                        onChanged: (v) => setState(() => _selectedQuarter = v!),
                      ),
                    ),
                  ),

                  AppSpacing.gapH12,

                  // Address detail
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Adresse détaillée',
                      hintText: 'Ex: Derrière le marché Ouando, maison bleue...',
                      prefixIcon: Icon(Icons.home_outlined),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Veuillez saisir votre adresse';
                      }
                      if (v.trim().length < 10) {
                        return 'Veuillez fournir plus de détails';
                      }
                      return null;
                    },
                  ),

                  AppSpacing.gapH12,

                  // Notes
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Instructions (optionnel)',
                      hintText: 'Ex: Appeler à l\'arrivée, portail vert...',
                      prefixIcon: Icon(Icons.note_outlined),
                    ),
                  ),

                  AppSpacing.gapH24,

                  // ─── Payment Method ───
                  _buildSectionHeader('💳', 'Mode de paiement'),
                  AppSpacing.gapH12,

                  _buildPaymentOption(
                    PaymentMethod.mtnMomo,
                    'MTN Mobile Money',
                    'Paiement instantané via MoMo',
                    AppColors.mtnYellow,
                    '📱',
                  ),
                  AppSpacing.gapH8,
                  _buildPaymentOption(
                    PaymentMethod.moovMoney,
                    'Moov Money',
                    'Paiement instantané via Moov',
                    AppColors.moovBlue,
                    '📱',
                  ),
                  AppSpacing.gapH8,
                  _buildPaymentOption(
                    PaymentMethod.cash,
                    'Espèces à la livraison',
                    'Payez en cash au livreur',
                    AppColors.cashGreen,
                    '💵',
                  ),

                  AppSpacing.gapH24,

                  // ─── Order Summary ───
                  _buildSectionHeader('🧾', 'Résumé de la commande'),
                  AppSpacing.gapH12,

                  Container(
                    padding: AppSpacing.cardPadding,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppSpacing.borderRadiusLg,
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      children: [
                        // Items list
                        ...widget.cartItems.entries.map((entry) {
                          final product = MockCatalog.getProductById(entry.key);
                          if (product == null) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${product.name} × ${entry.value.toStringAsFixed(entry.value == entry.value.toInt() ? 0 : 1)}',
                                    style: AppTypography.bodySmall,
                                  ),
                                ),
                                Text(
                                  Formatters.formatPrice(product.sellingPrice * entry.value),
                                  style: AppTypography.labelMedium,
                                ),
                              ],
                            ),
                          );
                        }),

                        const Divider(),
                        _buildSummaryRow('Sous-total', _subtotal),
                        AppSpacing.gapH4,
                        _buildSummaryRow('Livraison ($_selectedQuarter)',
                            _deliveryFee.toDouble()),
                        AppSpacing.gapH8,
                        const Divider(),
                        AppSpacing.gapH4,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total',
                                style: AppTypography.headlineSmall),
                            Text(
                              Formatters.formatPrice(_total),
                              style: AppTypography.priceLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.gapH16,

                  // Estimated delivery
                  Container(
                    padding: AppSpacing.cardPaddingSmall,
                    decoration: BoxDecoration(
                      color: AppColors.accentSurface,
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.schedule, color: AppColors.accent, size: 20),
                        AppSpacing.gapW8,
                        Expanded(
                          child: Text(
                            'Livraison estimée : 30-60 minutes',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom CTA
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
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
                child: KuizineButton(
                  label: 'Confirmer — ${Formatters.formatPrice(_total)}',
                  icon: Icons.check_circle_outline,
                  isLoading: _isProcessing,
                  onPressed: _placeOrder,
                ),
              ),
            ),
          ),

          // Loading overlay
          if (_isProcessing)
            const LoadingOverlay(message: 'Traitement de votre commande...'),
        ],
      ),
    );
  }

  String _getDeliveryFeeForQuarter(String quarter) {
    switch (quarter.toLowerCase()) {
      case 'centre porto-novo':
        return '200 FCFA';
      case 'ouando':
      case 'tokpota':
      case 'djassin':
        return '300 FCFA';
      case 'houinmé':
      case 'agbokou':
      case 'catchi':
        return '400 FCFA';
      default:
        return '500 FCFA';
    }
  }

  Widget _buildSectionHeader(String emoji, String title) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        AppSpacing.gapW8,
        Text(title, style: AppTypography.headlineSmall),
      ],
    );
  }

  Widget _buildPaymentOption(
    PaymentMethod method,
    String title,
    String subtitle,
    Color color,
    String emoji,
  ) {
    final isSelected = _selectedPayment == method;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedPayment = method);
      },
      child: AnimatedContainer(
        duration: AppSpacing.animFast,
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: isSelected ? color : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
            AppSpacing.gapW12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.labelLarge),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: AppSpacing.animFast,
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? color : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(Formatters.formatPrice(value), style: AppTypography.labelMedium),
      ],
    );
  }
}
