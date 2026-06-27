import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/shared_widgets.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate OTP sending
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      final phone = '+229${_phoneController.text.replaceAll(' ', '')}';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(phoneNumber: phone),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.gapH48,

              // Logo
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🍳', style: TextStyle(fontSize: 40)),
                  ),
                ),
              ),

              AppSpacing.gapH32,

              // Welcome text
              Center(
                child: Text(
                  'Bienvenue sur KUIZINE',
                  style: AppTypography.headlineLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              AppSpacing.gapH8,
              Center(
                child: Text(
                  'Connectez-vous avec votre numéro de téléphone',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              AppSpacing.gapH48,

              // Phone input
              Text(
                'Numéro de téléphone',
                style: AppTypography.labelLarge,
              ),
              AppSpacing.gapH8,

              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                    _BeninPhoneFormatter(),
                  ],
                  validator: Validators.validatePhone,
                  style: AppTypography.bodyLarge.copyWith(
                    fontSize: 18,
                    letterSpacing: 1,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      width: 80,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🇧🇯', style: TextStyle(fontSize: 20)),
                          AppSpacing.gapW4,
                          Text(
                            '+229',
                            style: AppTypography.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    hintText: '97 12 34 56',
                    hintStyle: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 18,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              AppSpacing.gapH12,

              // Operator detection hint
              if (_phoneController.text.length >= 2)
                _buildOperatorHint(),

              AppSpacing.gapH32,

              // Send OTP button
              KuizineButton(
                label: 'Recevoir le code',
                icon: Icons.sms_outlined,
                isLoading: _isLoading,
                onPressed: _sendOtp,
              ),

              AppSpacing.gapH24,

              // Terms
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text.rich(
                    TextSpan(
                      text: 'En continuant, vous acceptez nos ',
                      style: AppTypography.bodySmall,
                      children: [
                        TextSpan(
                          text: 'Conditions d\'utilisation',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(text: ' et notre '),
                        TextSpan(
                          text: 'Politique de confidentialité',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              AppSpacing.gapH48,

              // Payment methods info
              Center(
                child: Column(
                  children: [
                    Text(
                      'Moyens de paiement acceptés',
                      style: AppTypography.labelSmall,
                    ),
                    AppSpacing.gapH12,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPaymentBadge('MTN MoMo', AppColors.mtnYellow, '📱'),
                        AppSpacing.gapW12,
                        _buildPaymentBadge('Moov Money', AppColors.moovBlue, '📱'),
                        AppSpacing.gapW12,
                        _buildPaymentBadge('Espèces', AppColors.cashGreen, '💵'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOperatorHint() {
    final phone = _phoneController.text.replaceAll(' ', '');
    final isMtn = Validators.isMtnBenin(phone);
    final isMoov = Validators.isMoovBenin(phone);

    if (!isMtn && !isMoov) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isMtn
            ? AppColors.mtnYellow.withValues(alpha: 0.15)
            : AppColors.moovBlue.withValues(alpha: 0.15),
        borderRadius: AppSpacing.borderRadiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sim_card,
            size: 16,
            color: isMtn ? AppColors.mtnYellow : AppColors.moovBlue,
          ),
          AppSpacing.gapW4,
          Text(
            isMtn ? 'Réseau MTN détecté' : 'Réseau Moov détecté',
            style: AppTypography.labelSmall.copyWith(
              color: isMtn
                  ? AppColors.mtnYellow.withValues(alpha: 0.9)
                  : AppColors.moovBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBadge(String label, Color color, String emoji) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusFull,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          AppSpacing.gapW4,
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom formatter for Benin phone numbers: "97 12 34 56"
class _BeninPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 2 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
