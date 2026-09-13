import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/invoice_detail.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_typography.dart';
import 'aperture_logo.dart';

class PaymentModal extends StatefulWidget {
  final PaymentGateway initialGateway;
  final double amount;
  final String invoiceId;

  const PaymentModal({
    super.key,
    required this.initialGateway,
    required this.amount,
    required this.invoiceId,
  });

  static Future<bool?> show(
    BuildContext context, {
    required PaymentGateway initialGateway,
    required double amount,
    required String invoiceId,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PaymentModal(
        initialGateway: initialGateway,
        amount: amount,
        invoiceId: invoiceId,
      ),
    );
  }

  @override
  State<PaymentModal> createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal>
    with SingleTickerProviderStateMixin {
  late PaymentGateway _selectedGateway;
  int _step = 0; // 0: Input, 1: OTP, 2: PIN, 3: Success Animation
  bool _isProcessing = false;

  final TextEditingController _phoneController =
      TextEditingController(text: '01712345678');
  final TextEditingController _otpController =
      TextEditingController(text: '654321');
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _cardNumberController =
      TextEditingController(text: '4242 •••• •••• 4242');

  late AnimationController _apertureAnim;

  @override
  void initState() {
    super.initState();
    _selectedGateway = widget.initialGateway;
    _apertureAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _pinController.dispose();
    _cardNumberController.dispose();
    _apertureAnim.dispose();
    super.dispose();
  }

  void _nextStep() async {
    HapticFeedback.lightImpact();
    if (_step == 0) {
      if (_selectedGateway == PaymentGateway.bKash) {
        setState(() => _step = 1);
      } else {
        _executePayment();
      }
    } else if (_step == 1) {
      setState(() => _step = 2);
    } else if (_step == 2) {
      _executePayment();
    }
  }

  void _executePayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    AppState().settleVault(method: _selectedGateway.name);
    _apertureAnim.forward();
    setState(() {
      _isProcessing = false;
      _step = 3;
    });
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: bottomInset > 0 ? bottomInset + 12 : 24,
        top: 60,
      ),
      constraints: const BoxConstraints(maxWidth: 520),
      decoration: BoxDecoration(
        color: p.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: p.borderSubtle, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 36,
            spreadRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _step == 3 ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    final p = context.palette;

    return SingleChildScrollView(
      key: ValueKey<int>(_step),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: p.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Modal Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _selectedGateway == PaymentGateway.bKash
                      ? AppColors.bKash.withValues(alpha: 0.15)
                      : p.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _selectedGateway == PaymentGateway.bKash
                      ? Icons.phone_android_rounded
                      : Icons.credit_card_rounded,
                  color: _selectedGateway == PaymentGateway.bKash
                      ? AppColors.bKash
                      : p.textGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _step == 0
                          ? 'Settle Vault Invoice'
                          : _step == 1
                              ? 'bKash Verification'
                              : 'Enter bKash PIN',
                      style: AppTypography.headlineSmall.copyWith(fontSize: 18, color: p.textPrimary),
                    ),
                    Text(
                      '${widget.invoiceId} • \$${widget.amount.toStringAsFixed(2)} USD',
                      style: AppTypography.monoSmall.copyWith(
                        color: p.textGold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(false),
                icon: Icon(Icons.close, color: p.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Method Selector (if on Step 0)
          if (_step == 0) ...[
            Text(
              'SELECT PAYMENT GATEWAY',
              style: AppTypography.monoSmall.copyWith(
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
                color: p.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildGatewayTab(
                    gateway: PaymentGateway.bKash,
                    label: 'bKash Direct',
                    icon: Icons.flash_on_rounded,
                    accentColor: AppColors.bKash,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildGatewayTab(
                    gateway: PaymentGateway.stripeCard,
                    label: 'Stripe Card',
                    icon: Icons.credit_card_rounded,
                    accentColor: AppColors.stripe,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildGatewayTab(
                    gateway: PaymentGateway.googlePay,
                    label: 'Google Pay',
                    icon: Icons.account_balance_wallet,
                    accentColor: AppColors.googlePay,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],

          // Step 0 Fields
          if (_step == 0 && _selectedGateway == PaymentGateway.bKash) ...[
            _buildInputField(
              label: 'BKASH WALLET ACCOUNT NUMBER',
              controller: _phoneController,
              hint: 'e.g. 017XXXXXXXX',
              prefixText: '+880 ',
              keyboardType: TextInputType.phone,
              icon: Icons.phone_iphone_rounded,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bKash.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.bKash.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined,
                      color: AppColors.bKash, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Secured with bKash Direct API. OTP validation required next.',
                      style: AppTypography.bodySmall.copyWith(
                        color: p.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (_step == 0 &&
              (_selectedGateway == PaymentGateway.stripeCard ||
                  _selectedGateway == PaymentGateway.googlePay ||
                  _selectedGateway == PaymentGateway.applePay ||
                  _selectedGateway == PaymentGateway.payPal ||
                  _selectedGateway == PaymentGateway.upi)) ...[
            _buildInputField(
              label: 'CARD NUMBER',
              controller: _cardNumberController,
              hint: '4242 •••• •••• 4242',
              keyboardType: TextInputType.number,
              icon: Icons.credit_card_rounded,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'EXPIRY',
                    controller: TextEditingController(text: '12/28'),
                    hint: 'MM/YY',
                    keyboardType: TextInputType.datetime,
                    icon: Icons.calendar_today_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputField(
                    label: 'CVC / CVV',
                    controller: TextEditingController(text: '888'),
                    hint: '123',
                    keyboardType: TextInputType.number,
                    icon: Icons.lock_outline_rounded,
                  ),
                ),
              ],
            ),
          ] else if (_step == 1) ...[
            // bKash OTP step
            _buildInputField(
              label: '6-DIGIT VERIFICATION CODE (OTP)',
              controller: _otpController,
              hint: '654321',
              keyboardType: TextInputType.number,
              icon: Icons.sms_outlined,
            ),
            const SizedBox(height: 8),
            Text(
              'A verification SMS was sent to ${_phoneController.text}',
              style: AppTypography.bodySmall.copyWith(fontSize: 11, color: p.textSecondary),
            ),
          ] else if (_step == 2) ...[
            // bKash PIN step
            _buildInputField(
              label: 'ENTER 5-DIGIT bKash PIN',
              controller: _pinController,
              hint: '•••••',
              obscureText: true,
              keyboardType: TextInputType.number,
              icon: Icons.pin_rounded,
            ),
            const SizedBox(height: 8),
            Text(
              'Never share your secret bKash PIN with anyone.',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 11,
                color: p.statusWarning,
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Primary CTA Button
          ElevatedButton(
            onPressed: _isProcessing ? null : _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedGateway == PaymentGateway.bKash
                  ? AppColors.bKash
                  : p.primary,
              foregroundColor: _selectedGateway == PaymentGateway.bKash
                  ? Colors.white
                  : p.onPrimaryDark,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    _step == 0
                        ? (_selectedGateway == PaymentGateway.bKash
                            ? 'Proceed to bKash Verification'
                            : 'Pay \$${widget.amount.toStringAsFixed(2)} Now')
                        : _step == 1
                            ? 'Verify OTP'
                            : 'Confirm & Release Google Drive Vault',
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGatewayTab({
    required PaymentGateway gateway,
    required String label,
    required IconData icon,
    required Color accentColor,
  }) {
    final p = context.palette;
    final isSelected = _selectedGateway == gateway;
    return GestureDetector(
      onTap: () => setState(() => _selectedGateway = gateway),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.12)
              : p.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? accentColor : p.borderSubtle,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: isSelected ? accentColor : p.textSecondary),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? p.textPrimary : p.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? prefixText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final p = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.monoSmall.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: p.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: p.inputBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: p.borderSubtle),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: AppTypography.monoLarge.copyWith(fontSize: 14, color: p.textPrimary),
            decoration: InputDecoration(
              prefixText: prefixText,
              prefixStyle: AppTypography.monoSmall.copyWith(
                fontSize: 14,
                color: p.textSecondary,
              ),
              prefixIcon: Icon(icon, color: p.textSecondary, size: 18),
              hintText: hint,
              hintStyle: AppTypography.monoSmall.copyWith(
                fontSize: 13,
                color: p.textTertiary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    final p = context.palette;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated Aperture Unlock
          RotationTransition(
            turns: _apertureAnim,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: p.statusSuccess.withValues(alpha: 0.12),
                border: Border.all(
                  color: p.statusSuccess,
                  width: 2,
                ),
              ),
              child: const ApertureLogo(size: 64),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'VAULT UNLOCKED & SETTLED',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: p.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Google Drive RAW master license key dispatched. 100% full-resolution assets are now decrypted and available for high-speed sync.',
            style: AppTypography.bodySmall.copyWith(
              height: 1.5,
              color: p.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: p.statusSuccess.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: p.statusSuccess.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded,
                    color: p.statusSuccess, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Escrow Released: \$${widget.amount.toStringAsFixed(2)} Paid',
                  style: AppTypography.monoSmall.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: p.statusSuccess,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: p.statusSuccess,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Open Google Drive Synced Vault',
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
