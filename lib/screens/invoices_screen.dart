import 'package:flutter/material.dart';
import '../models/invoice_detail.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_palette.dart';
import '../theme/app_typography.dart';
import '../widgets/app_header.dart';
import '../widgets/payment_modal.dart';
import '../widgets/status_pills.dart';

class InvoicesScreen extends StatefulWidget {
  final VoidCallback? onAvatarTap;
  final VoidCallback? onLogoTap;

  const InvoicesScreen({
    super.key,
    this.onAvatarTap,
    this.onLogoTap,
  });

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  PaymentGateway selectedGateway = PaymentGateway.bKash;
  bool isProcessing = false;

  final InvoiceDetail invoice = const InvoiceDetail(
    invoiceNumber: '#AT-2025-0891',
    tokenCode: 'AT-891-XK94',
    targetDriveEmail: 'farhan.archive@gmail.com',
    rawStorageSize: '128 GB RAW',
    masterCapturesCount: '1,420 High-Res Masters',
    dueDate: 'DUE NOV 12, 2025',
    lineItems: [
      InvoiceLineItem(
        title: 'Full-Day Wedding Cinematography',
        subtitle: '4K DCI + Uncompressed RAW Footage (Dual Cams)',
        amount: 1150.00,
      ),
      InvoiceLineItem(
        title: 'RAW Drone Aerial Reels',
        subtitle: '8K CineDNG Sequences • Certified Pilot Delivery',
        amount: 350.00,
      ),
      InvoiceLineItem(
        title: 'Master Retouching Package',
        subtitle: '150 Curated Hero Selections with High-Dynamic Grading',
        amount: 200.00,
      ),
      InvoiceLineItem(
        title: 'Encrypted Cloud Vault & Fast CDN',
        subtitle: '1 Year Redundant Archival & Instant Google Drive API',
        amount: 100.00,
      ),
    ],
    taxAmount: 90.00,
    totalUsd: 1890.00,
    totalBdt: '৳225,750 BDT',
  );

  void _handlePayment() async {
    final p = context.palette;
    final result = await PaymentModal.show(
      context,
      initialGateway: selectedGateway,
      amount: invoice.totalUsd,
      invoiceId: invoice.invoiceNumber,
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: p.surfaceElevated,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: p.statusSuccess, width: 1.2),
          ),
          content: Row(
            children: [
              Icon(Icons.verified, color: p.statusSuccess, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '128 GB unwatermarked 4K RAW masters unlocked for ${invoice.targetDriveEmail}!',
                  style: AppTypography.bodySmall.copyWith(color: p.textPrimary),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showTokenShare() {
    final p = context.palette;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: p.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: p.primary, width: 1.5),
        ),
        title: Row(
          children: [
            Icon(Icons.vpn_key, color: p.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              'Drive Vault Token',
              style: AppTypography.headlineSmall.copyWith(color: p.textPrimary, fontSize: 17),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share this cryptographic token with your client or production team for authenticated direct download.',
              style: AppTypography.bodySmall.copyWith(color: p.textSecondary),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: p.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: p.borderSubtle),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    invoice.tokenCode,
                    style: AppTypography.monoLarge.copyWith(color: p.textGold, fontWeight: FontWeight.w800),
                  ),
                  Icon(Icons.copy, color: p.primary, size: 18),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: TextStyle(color: p.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: p.surfaceCard,
                  content: Text('Token ${invoice.tokenCode} copied to clipboard!', style: TextStyle(color: p.textPrimary)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: p.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Copy Token', style: TextStyle(color: p.onPrimaryDark, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return AnimatedBuilder(
      animation: AppState(),
      builder: (context, _) {
        final isSettled = AppState().isVaultSettled;
        return Scaffold(
          backgroundColor: p.surfaceCanvas,
          appBar: AppHeader(
            titleTag: 'Invoices',
            onAvatarTap: widget.onAvatarTap,
            onLogoTap: widget.onLogoTap,
            trailingAction: IconButton(
              icon: Icon(Icons.share, color: p.textGold, size: 19),
              onPressed: _showTokenShare,
              tooltip: 'Share Access Token',
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Micro Status Ribbon
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: p.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: p.borderSubtle, width: 0.8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSettled ? p.statusSuccess : p.statusWarning,
                              boxShadow: [
                                BoxShadow(
                                  color: (isSettled ? p.statusSuccess : p.statusWarning).withValues(alpha: 0.5),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isSettled ? 'ESCROW SETTLED' : 'ESCROW SECURED',
                            style: AppTypography.monoSmall.copyWith(
                              color: isSettled ? p.statusSuccess : p.textGold,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            invoice.invoiceNumber,
                            style: AppTypography.monoSmall.copyWith(
                              fontSize: 10,
                              color: p.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.schedule, color: p.textSecondary, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            invoice.dueDate,
                            style: AppTypography.monoSmall.copyWith(
                              fontSize: 10,
                              color: p.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Deliverables Vault Escrow Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: p.surfaceCard,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSettled ? p.statusSuccess : p.primary.withValues(alpha: 0.35),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: p.primary.withValues(alpha: 0.08),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: p.surfaceElevated,
                                  border: Border.all(color: p.primary, width: 1),
                                ),
                                child: Center(
                                  child: Icon(
                                    isSettled ? Icons.lock_open : Icons.lock,
                                    color: p.textGold,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Vault Escrow',
                                        style: AppTypography.headlineSmall.copyWith(
                                          fontSize: 18,
                                          color: p.textPrimary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: p.surfaceElevated,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          isSettled ? 'UNLOCKED' : 'LOCKED',
                                          style: AppTypography.monoSmall.copyWith(
                                            fontSize: 9,
                                            color: isSettled ? p.statusSuccess : p.textGold,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Google Drive Vault Protection',
                                    style: AppTypography.bodySmall.copyWith(
                                      fontSize: 11,
                                      color: p.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: p.surfaceElevated,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: p.borderSubtle, width: 0.8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.cloud_sync, color: p.primary, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  invoice.rawStorageSize,
                                  style: AppTypography.monoSmall.copyWith(
                                    color: p.textGold,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Target Google Drive Container
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: p.surfaceElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: p.borderSubtle, width: 0.8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.add_to_drive, color: p.primary, size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      invoice.targetDriveEmail,
                                      style: AppTypography.labelMedium.copyWith(
                                        color: p.textPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: (isSettled ? p.statusSuccess : p.statusWarning).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isSettled ? 'VERIFIED' : 'PENDING ESCROW',
                                    style: AppTypography.monoSmall.copyWith(
                                      fontSize: 8.5,
                                      color: isSettled ? p.statusSuccess : p.statusWarning,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Unwatermarked 4K RAW photos and deliverables will be instantly unshielded to your Google Account upon payment verification.',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 11,
                                color: p.textSecondary,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Preview Image Scrim
                      Container(
                        height: 68,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: p.surfaceElevated,
                          border: Border.all(color: p.borderSubtle, width: 0.8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.security, color: p.textGold, size: 20),
                                const SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      invoice.masterCapturesCount,
                                      style: AppTypography.labelMedium.copyWith(
                                        color: p.textPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      'DCI 4K & 8K CineDNG',
                                      style: AppTypography.monoSmall.copyWith(
                                        fontSize: 10,
                                        color: p.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: p.surfaceCard,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: p.borderSubtle, width: 0.6),
                              ),
                              child: Text(
                                '256-BIT AES',
                                style: AppTypography.monoSmall.copyWith(
                                  color: p.textGold,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Scannable Direct Mobile Pay Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: p.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: p.borderSubtle, width: 1),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.qr_code_scanner, color: p.textGold, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  'DIRECT MOBILE PAY',
                                  style: AppTypography.monoSmall.copyWith(
                                    color: p.textGold,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Scan via camera or digital wallet app for immediate Drive release.',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 11,
                                color: p.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  'TOKEN: ',
                                  style: AppTypography.monoSmall.copyWith(
                                    fontSize: 10,
                                    color: p.textSecondary,
                                  ),
                                ),
                                Text(
                                  invoice.tokenCode,
                                  style: AppTypography.monoSmall.copyWith(
                                    color: p.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Stylized Geometric QR
                      Container(
                        width: 76,
                        height: 76,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: p.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: p.primary.withValues(alpha: 0.3), width: 1),
                        ),
                        child: Center(
                          child: Icon(Icons.qr_code_2, color: p.textGold, size: 54),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Deliverables Breakdown Line Items
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: p.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: p.borderSubtle, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.receipt, color: p.primary, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Deliverables Breakdown',
                                style: AppTypography.labelLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: p.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '5 ITEMS',
                            style: AppTypography.monoSmall.copyWith(
                              fontSize: 9.5,
                              color: p.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...invoice.lineItems.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: p.surfaceElevated,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: p.borderSubtle, width: 0.6),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: AppTypography.labelMedium.copyWith(
                                            fontSize: 12.5,
                                            color: p.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          item.subtitle,
                                          style: AppTypography.bodySmall.copyWith(
                                            fontSize: 10.5,
                                            color: p.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '\$${item.amount.toStringAsFixed(2)}',
                                    style: AppTypography.monoSmall.copyWith(
                                      color: p.textPrimary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      // Tax row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Standard Production Tax (5%)',
                              style: AppTypography.bodySmall.copyWith(fontSize: 11, color: p.textSecondary),
                            ),
                            Text(
                              '\$${invoice.taxAmount.toStringAsFixed(2)}',
                              style: AppTypography.monoSmall.copyWith(fontSize: 11, color: p.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Total Box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: p.surfaceElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: p.primary.withValues(alpha: 0.4), width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TOTAL DUE',
                                  style: AppTypography.monoSmall.copyWith(fontSize: 9.5, color: p.textSecondary),
                                ),
                                Text(
                                  invoice.totalBdt,
                                  style: AppTypography.monoSmall.copyWith(
                                    color: p.textGold,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '\$${invoice.totalUsd.toStringAsFixed(2)}',
                              style: AppTypography.headlineMedium.copyWith(
                                fontWeight: FontWeight.w800,
                                color: p.textGold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Select Payment Method
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_balance_wallet, color: p.primary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Select Payment Method',
                          style: AppTypography.labelLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: p.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    StatusPill.verified(label: 'SECURE 256-BIT'),
                  ],
                ),
                const SizedBox(height: 10),

                // Payment Options List
                _buildPaymentOption(
                  gateway: PaymentGateway.bKash,
                  title: 'bKash Merchant',
                  subtitle: '${invoice.totalBdt} • Instant SSLCommerz',
                  icon: Icons.send_to_mobile,
                  iconColor: AppColors.bKash,
                  tag: 'BD LOCAL',
                  tagColor: AppColors.bKash,
                ),
                const SizedBox(height: 8),
                _buildPaymentOption(
                  gateway: PaymentGateway.googlePay,
                  title: 'Google Pay',
                  subtitle: 'Instant 1-Tap Checkout',
                  icon: Icons.phone_android,
                  iconColor: p.primary,
                ),
                const SizedBox(height: 8),
                _buildPaymentOption(
                  gateway: PaymentGateway.applePay,
                  title: 'Apple Pay',
                  subtitle: 'Biometric Touch ID / Face ID',
                  icon: Icons.credit_card,
                  iconColor: p.textSecondary,
                ),
                const SizedBox(height: 8),
                _buildPaymentOption(
                  gateway: PaymentGateway.stripeCard,
                  title: 'Credit / Debit Card',
                  subtitle: 'Visa, Mastercard, Amex via Stripe',
                  icon: Icons.payment,
                  iconColor: p.textSecondary,
                ),
                const SizedBox(height: 8),
                _buildPaymentOption(
                  gateway: PaymentGateway.payPal,
                  title: 'PayPal Express',
                  subtitle: 'Global Escrow Protection',
                  icon: Icons.account_balance,
                  iconColor: p.textSecondary,
                ),
                const SizedBox(height: 8),
                _buildPaymentOption(
                  gateway: PaymentGateway.upi,
                  title: 'UPI Instant Transfer',
                  subtitle: 'GPay, PhonePe, Paytm QR',
                  icon: Icons.qr_code_2,
                  iconColor: p.textSecondary,
                ),
                const SizedBox(height: 24),

                // Floating Sticky Action Button
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSettled
                          ? [p.statusSuccess, p.statusSuccess.withValues(alpha: 0.85)]
                          : [p.primary, p.primaryContainer],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: (isSettled ? p.statusSuccess : p.primary).withValues(alpha: 0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: isProcessing ? null : _handlePayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: isProcessing
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: p.onPrimaryDark, strokeWidth: 2.5),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isSettled ? Icons.check_circle : Icons.lock_open,
                                color: isSettled ? Colors.white : p.onPrimaryDark,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isSettled ? 'Vault Unlocked & Settled' : 'Release Vault & Settle Invoice (\$1,890.00)',
                                style: AppTypography.labelLarge.copyWith(
                                  color: isSettled ? Colors.white : p.onPrimaryDark,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption({
    required PaymentGateway gateway,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    String? tag,
    Color? tagColor,
  }) {
    final p = context.palette;
    final isSelected = selectedGateway == gateway;

    return GestureDetector(
      onTap: () => setState(() => selectedGateway = gateway),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? p.surfaceElevated : p.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? p.primary : p.borderSubtle,
            width: isSelected ? 1.2 : 0.8,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: p.primary.withValues(alpha: 0.15),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: p.surfaceElevated,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: AppTypography.labelMedium.copyWith(
                            color: p.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                        if (tag != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: (tagColor ?? p.primary).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tag,
                              style: AppTypography.monoSmall.copyWith(
                                fontSize: 8.5,
                                color: tagColor ?? p.textGold,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 11,
                        color: p.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? p.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? p.primary : p.borderSubtle,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Icon(Icons.circle, color: p.onPrimaryDark, size: 8),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
