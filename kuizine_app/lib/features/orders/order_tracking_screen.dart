import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/order.dart';
import '../../shared/widgets/shared_widgets.dart';
import '../home/home_screen.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderNumber;
  final double total;
  final PaymentMethod paymentMethod;
  final String deliveryAddress;
  final String quarter;

  const OrderTrackingScreen({
    super.key,
    required this.orderNumber,
    required this.total,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.quarter,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _confettiController;
  OrderStatus _currentStatus = OrderStatus.confirmed;

  final List<_TimelineStep> _steps = [
    _TimelineStep(
      status: OrderStatus.pending,
      title: 'Commande reçue',
      subtitle: 'Votre commande a été enregistrée',
      time: 'Maintenant',
    ),
    _TimelineStep(
      status: OrderStatus.confirmed,
      title: 'Confirmée',
      subtitle: 'Votre commande est confirmée',
      time: 'il y a 1 min',
    ),
    _TimelineStep(
      status: OrderStatus.preparing,
      title: 'En préparation',
      subtitle: 'Nous préparons vos ingrédients',
      time: '~10 min',
    ),
    _TimelineStep(
      status: OrderStatus.outForDelivery,
      title: 'En livraison',
      subtitle: 'Le livreur est en route',
      time: '~25 min',
    ),
    _TimelineStep(
      status: OrderStatus.delivered,
      title: 'Livrée',
      subtitle: 'Bonne cuisine ! 🎉',
      time: '~45 min',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();

    // Simulate order progression
    _simulateProgress();
  }

  void _simulateProgress() async {
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) setState(() => _currentStatus = OrderStatus.preparing);
    
    await Future.delayed(const Duration(seconds: 8));
    if (mounted) setState(() => _currentStatus = OrderStatus.outForDelivery);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    ),
                  ),
                  const Spacer(),
                  Text('Suivi commande', style: AppTypography.headlineSmall),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.help_outline),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Success animation
                    ScaleTransition(
                      scale: CurvedAnimation(
                        parent: _confettiController,
                        curve: Curves.elasticOut,
                      ),
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('✅', style: TextStyle(fontSize: 42)),
                        ),
                      ),
                    ),

                    AppSpacing.gapH16,

                    Text(
                      'Commande confirmée !',
                      style: AppTypography.headlineLarge.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                    AppSpacing.gapH4,
                    Text(
                      widget.orderNumber,
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textTertiary,
                        letterSpacing: 1,
                      ),
                    ),

                    AppSpacing.gapH32,

                    // Order info card
                    Container(
                      padding: AppSpacing.cardPadding,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppSpacing.borderRadiusLg,
                        border: Border.all(color: AppColors.divider),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            Icons.receipt_outlined,
                            'Total',
                            Formatters.formatPrice(widget.total),
                          ),
                          const Divider(height: 20),
                          _buildInfoRow(
                            Icons.payment_outlined,
                            'Paiement',
                            '${widget.paymentMethod.emoji} ${widget.paymentMethod.label}',
                          ),
                          const Divider(height: 20),
                          _buildInfoRow(
                            Icons.location_on_outlined,
                            'Livraison',
                            '${widget.quarter}\n${widget.deliveryAddress}',
                          ),
                          const Divider(height: 20),
                          _buildInfoRow(
                            Icons.schedule_outlined,
                            'Estimation',
                            '30-60 minutes',
                          ),
                        ],
                      ),
                    ),

                    AppSpacing.gapH24,

                    // Timeline
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Suivi en temps réel',
                        style: AppTypography.headlineSmall,
                      ),
                    ),
                    AppSpacing.gapH16,

                    ...List.generate(_steps.length, (index) {
                      final step = _steps[index];
                      final isCompleted =
                          step.status.stepIndex <= _currentStatus.stepIndex;
                      final isCurrent =
                          step.status.stepIndex == _currentStatus.stepIndex;
                      final isLast = index == _steps.length - 1;

                      return _buildTimelineStep(
                        step: step,
                        isCompleted: isCompleted,
                        isCurrent: isCurrent,
                        isLast: isLast,
                      );
                    }),

                    AppSpacing.gapH32,

                    // Back to home button
                    KuizineButton(
                      label: 'Retour à l\'accueil',
                      icon: Icons.home_outlined,
                      isOutlined: true,
                      onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      ),
                    ),

                    AppSpacing.gapH32,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        AppSpacing.gapW12,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.labelSmall),
            const SizedBox(height: 2),
            Text(value, style: AppTypography.labelLarge),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineStep({
    required _TimelineStep step,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
  }) {
    final color = isCompleted ? AppColors.accent : AppColors.divider;
    final statusColor = _getStatusColor(step.status);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line + dot
        SizedBox(
          width: 32,
          child: Column(
            children: [
              // Dot
              AnimatedContainer(
                duration: AppSpacing.animNormal,
                width: isCurrent ? 28 : 20,
                height: isCurrent ? 28 : 20,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? statusColor.withValues(alpha: 0.15)
                      : AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted ? statusColor : AppColors.divider,
                    width: isCurrent ? 3 : 2,
                  ),
                ),
                child: isCompleted
                    ? Center(
                        child: Icon(
                          isCurrent ? Icons.circle : Icons.check,
                          size: isCurrent ? 10 : 12,
                          color: statusColor,
                        ),
                      )
                    : null,
              ),
              // Line
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: isCompleted ? color : AppColors.divider,
                ),
            ],
          ),
        ),

        AppSpacing.gapW12,

        // Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${step.status.emoji} ${step.title}',
                      style: AppTypography.labelLarge.copyWith(
                        color: isCompleted
                            ? AppColors.textPrimary
                            : AppColors.textTertiary,
                        fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (isCompleted)
                      Text(
                        step.time,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  step.subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: isCompleted
                        ? AppColors.textSecondary
                        : AppColors.textTertiary,
                  ),
                ),
                if (isCurrent) ...[
                  AppSpacing.gapH4,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: AppSpacing.borderRadiusFull,
                    ),
                    child: Text(
                      'En cours...',
                      style: AppTypography.labelSmall.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.statusPending;
      case OrderStatus.confirmed:
        return AppColors.statusConfirmed;
      case OrderStatus.preparing:
        return AppColors.statusPreparing;
      case OrderStatus.outForDelivery:
        return AppColors.statusOutForDelivery;
      case OrderStatus.delivered:
        return AppColors.statusDelivered;
      case OrderStatus.cancelled:
        return AppColors.statusCancelled;
    }
  }
}

class _TimelineStep {
  final OrderStatus status;
  final String title;
  final String subtitle;
  final String time;

  const _TimelineStep({
    required this.status,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}
