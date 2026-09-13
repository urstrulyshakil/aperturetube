import 'package:flutter/material.dart';
import '../models/studio_settings.dart';
import '../state/app_state.dart';
import '../theme/app_palette.dart';
import '../theme/app_typography.dart';
import '../widgets/app_header.dart';
import '../widgets/status_pills.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onLogout;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onLogoTap;

  const ProfileScreen({
    super.key,
    this.onLogout,
    this.onAvatarTap,
    this.onLogoTap,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StudioSettings settings = StudioSettings();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    AppState().addListener(_onAppStateChanged);
  }

  @override
  void dispose() {
    AppState().removeListener(_onAppStateChanged);
    super.dispose();
  }

  void _onAppStateChanged() {
    if (mounted) setState(() {});
  }

  void _handleSavePreferences() {
    final p = context.palette;
    setState(() => isSaving = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => isSaving = false);
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
              Icon(Icons.check_circle, color: p.statusSuccess, size: 20),
              const SizedBox(width: 10),
              Text(
                'Studio Preferences Synced to Cloud Vault!',
                style: AppTypography.bodyMedium.copyWith(color: p.textPrimary),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showPayoutGatewayPicker() {
    final p = context.palette;
    final gateways = [
      {'name': 'bKash Merchant Direct', 'icon': Icons.phone_android, 'detail': 'Instant BDT payout via SSLCommerz', 'color': const Color(0xFFD12053)},
      {'name': 'Stripe Connect', 'icon': Icons.credit_card, 'detail': 'Global USD/EUR payouts', 'color': const Color(0xFF635BFF)},
      {'name': 'Google Pay Business', 'icon': Icons.g_mobiledata, 'detail': '30+ currencies', 'color': const Color(0xFF4285F4)},
      {'name': 'Wise (TransferWise)', 'icon': Icons.currency_exchange, 'detail': 'Low-fee international', 'color': const Color(0xFF00B9FF)},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: p.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: p.borderSubtle, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Select Payout Gateway',
              style: AppTypography.headlineSmall.copyWith(fontSize: 17, color: p.textPrimary, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            ...gateways.map((g) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => settings.payoutGateway = g['name'] as String);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: p.surfaceElevated,
                      behavior: SnackBarBehavior.floating,
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: p.statusSuccess, size: 18),
                          const SizedBox(width: 10),
                          Text('Payout gateway set to ${g['name']}', style: TextStyle(color: p.textPrimary)),
                        ],
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: settings.payoutGateway == g['name'] ? p.surfaceElevated : p.surfaceCanvas,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: settings.payoutGateway == g['name'] ? p.primary : p.borderSubtle,
                      width: settings.payoutGateway == g['name'] ? 1.2 : 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (g['color'] as Color).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(g['icon'] as IconData, color: g['color'] as Color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(g['name'] as String, style: AppTypography.labelMedium.copyWith(color: p.textPrimary)),
                          Text(g['detail'] as String, style: AppTypography.bodySmall.copyWith(fontSize: 11, color: p.textSecondary)),
                        ],
                      ),
                      const Spacer(),
                      if (settings.payoutGateway == g['name'])
                        Icon(Icons.check_circle, color: p.statusSuccess, size: 20),
                    ],
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final currentLutMode = AppState().lutMode;

    return Scaffold(
      backgroundColor: p.surfaceCanvas,
      appBar: AppHeader(
        titleTag: 'Profile',
        onAvatarTap: widget.onAvatarTap,
        onLogoTap: widget.onLogoTap,
        trailingAction: IconButton(
          icon: Icon(Icons.logout, color: p.textSecondary, size: 20),
          onPressed: widget.onLogout,
          tooltip: 'Exit Studio Workspace',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Photographer Identity & Hero Badge
            const SizedBox(height: 8),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          p.primary.withValues(alpha: 0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 88,
                    height: 88,
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          p.primary,
                          p.textGold,
                          p.primaryContainer,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: p.primary.withValues(alpha: 0.3),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        settings.avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: p.surfaceElevated,
                          child: Icon(Icons.person, color: p.primary, size: 36),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: p.surfaceElevated,
                        shape: BoxShape.circle,
                        border: Border.all(color: p.primary, width: 1),
                      ),
                      child: Icon(
                        Icons.verified,
                        color: p.primary,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  settings.photographerName,
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: p.textPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.workspace_premium, color: p.primary, size: 20),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              settings.roleTitle,
              style: AppTypography.bodySmall.copyWith(color: p.textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: p.surfaceElevated,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: p.borderSubtle, width: 0.8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: p.primary, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        settings.rating.toString(),
                        style: AppTypography.monoSmall.copyWith(
                          color: p.textGold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${settings.reviewsCount} reviews)',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 10,
                          color: p.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                StatusPill.activePro(label: 'ACTIVE PRO'),
              ],
            ),
            const SizedBox(height: 20),

            // Ambient Color Calibration Mode (Display LUT)
            Container(
              padding: const EdgeInsets.all(16),
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
                          Icon(Icons.palette, color: p.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Studio Ambience',
                            style: AppTypography.labelLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: p.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'DISPLAY LUT',
                        style: AppTypography.monoSmall.copyWith(
                          color: p.textGold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Ambient calibration for museum-accurate color proofing',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11,
                      color: p.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: p.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: p.borderSubtle, width: 0.8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => settings.lutMode = DisplayLutMode.darkCinema);
                              AppState().setLutMode(DisplayLutMode.darkCinema);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: currentLutMode == DisplayLutMode.darkCinema
                                    ? p.surfaceCard
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: currentLutMode == DisplayLutMode.darkCinema
                                    ? Border.all(color: p.primary, width: 1)
                                    : null,
                                boxShadow: currentLutMode == DisplayLutMode.darkCinema
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 6,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.dark_mode,
                                    size: 16,
                                    color: currentLutMode == DisplayLutMode.darkCinema ? p.primary : p.textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Dark Cinema',
                                    style: AppTypography.labelMedium.copyWith(
                                      color: currentLutMode == DisplayLutMode.darkCinema ? p.textPrimary : p.textSecondary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => settings.lutMode = DisplayLutMode.daylightStudio);
                              AppState().setLutMode(DisplayLutMode.daylightStudio);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: currentLutMode == DisplayLutMode.daylightStudio
                                    ? p.surfaceCard
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: currentLutMode == DisplayLutMode.daylightStudio
                                    ? Border.all(color: p.primary, width: 1)
                                    : null,
                                boxShadow: currentLutMode == DisplayLutMode.daylightStudio
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 6,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.light_mode,
                                    size: 16,
                                    color: currentLutMode == DisplayLutMode.daylightStudio ? p.textGold : p.textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Daylight Studio',
                                    style: AppTypography.labelMedium.copyWith(
                                      color: currentLutMode == DisplayLutMode.daylightStudio ? p.textPrimary : p.textSecondary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
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

            // Google Drive Cloud Engine Vault
            Container(
              padding: const EdgeInsets.all(16),
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
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: p.surfaceElevated,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.cloud_sync, color: p.primary, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Google Drive Cloud',
                                style: AppTypography.labelLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: p.textPrimary,
                                ),
                              ),
                              Text(
                                'Enterprise Synced',
                                style: AppTypography.monoSmall.copyWith(
                                  fontSize: 9.5,
                                  color: p.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      StatusPill(
                        label: 'CONNECTED',
                        backgroundColor: p.statusSuccess.withValues(alpha: 0.12),
                        textColor: p.statusSuccess,
                        hasPulseDot: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Sync path pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: p.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.folder_open, color: p.textSecondary, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            settings.driveSyncPath,
                            style: AppTypography.monoSmall.copyWith(color: p.textGold, fontSize: 10.5),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Storage Gauge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${settings.storageUsedTb} TB / ${settings.storageTotalTb} TB used',
                        style: AppTypography.monoSmall.copyWith(color: p.textPrimary, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${(settings.storagePercentage * 100).toInt()}%',
                        style: AppTypography.monoSmall.copyWith(color: p.textGold, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: settings.storagePercentage,
                      backgroundColor: p.surfaceElevated,
                      valueColor: AlwaysStoppedAnimation<Color>(p.primary),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Auto-sync switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Auto-Sync RAW on Tether',
                            style: AppTypography.labelMedium.copyWith(color: p.textPrimary, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Direct cloud upload via Sony/Canon USB-C link',
                            style: AppTypography.bodySmall.copyWith(fontSize: 10.5, color: p.textSecondary),
                          ),
                        ],
                      ),
                      Switch(
                        value: settings.autoSyncRawOnTether,
                        activeThumbColor: p.primary,
                        activeTrackColor: p.primary.withValues(alpha: 0.35),
                        inactiveThumbColor: p.textSecondary,
                        inactiveTrackColor: p.surfaceElevated,
                        onChanged: (val) {
                          setState(() => settings.autoSyncRawOnTether = val);
                          AppState().setAutoSyncRaw(val);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Payouts & Currency Preferences
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: p.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: p.borderSubtle, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.payments, color: p.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Financial & Payout Gateway',
                        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700, color: p.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Default Currency', style: AppTypography.bodySmall.copyWith(fontSize: 12, color: p.textSecondary)),
                      DropdownButton<String>(
                        value: settings.defaultCurrency,
                        dropdownColor: p.surfaceElevated,
                        style: AppTypography.monoSmall.copyWith(color: p.textGold, fontSize: 11, fontWeight: FontWeight.w700),
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 'USD (\$)', child: Text('USD (\$)')),
                          DropdownMenuItem(value: 'BDT (৳)', child: Text('BDT (৳)')),
                          DropdownMenuItem(value: 'EUR (€)', child: Text('EUR (€)')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => settings.defaultCurrency = val);
                        },
                      ),
                    ],
                  ),
                  Divider(color: p.borderSubtle),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Direct Payout Gateway', style: AppTypography.bodySmall.copyWith(fontSize: 12, color: p.textSecondary)),
                          Text(
                            settings.payoutGateway,
                            style: AppTypography.monoSmall.copyWith(color: p.textPrimary, fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _showPayoutGatewayPicker,
                        child: Text('Edit', style: AppTypography.labelSmall.copyWith(color: p.textGold, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Save Preferences CTA
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : _handleSavePreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: p.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  shadowColor: p.primary.withValues(alpha: 0.3),
                ),
                child: isSaving
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: p.onPrimaryDark, strokeWidth: 2.5),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save, color: p.onPrimaryDark, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Save Studio Preferences',
                            style: AppTypography.labelLarge.copyWith(
                              color: p.onPrimaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
