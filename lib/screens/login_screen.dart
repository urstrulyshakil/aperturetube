import 'package:flutter/material.dart';
import '../models/studio_settings.dart';
import '../state/app_state.dart';
import '../theme/app_palette.dart';
import '../theme/app_typography.dart';
import '../widgets/aperture_logo.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const LoginScreen({super.key, this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPhotographer = true;
  bool obscurePassword = true;
  bool rememberBiometrics = true;

  final TextEditingController _emailController =
      TextEditingController(text: 'elena@luxframe.studio');
  final TextEditingController _passwordController =
      TextEditingController(text: 'MasterKey2026!');
  final TextEditingController _tokenController =
      TextEditingController(text: 'MONACO-2024-VIP');

  bool _isDriveConnected = false;
  bool _isBiometricLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final p = context.palette;
    setState(() => _isBiometricLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isBiometricLoading = false);

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
              isPhotographer
                  ? 'Welcome, Studio Pro — Accessing Workspace…'
                  : 'Vault Token Verified — Opening Event Gallery…',
              style: AppTypography.bodyMedium.copyWith(color: p.textPrimary),
            ),
          ],
        ),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) widget.onLoginSuccess?.call();
  }

  void _handleBiometricLogin() async {
    final p = context.palette;
    setState(() => _isBiometricLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isBiometricLoading = false);

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
            Icon(Icons.fingerprint, color: p.primary, size: 28),
            const SizedBox(width: 10),
            Text(
              'Biometric Verification',
              style: AppTypography.headlineSmall.copyWith(fontSize: 18, color: p.textPrimary),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: p.surfaceElevated,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.touch_app, color: p.primary, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              'Touch ID / Face ID Authentication Successful',
              style: AppTypography.bodyMedium.copyWith(color: p.textPrimary, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Encrypted hardware token loaded for Elena Vance (Studio Pro)',
              style: AppTypography.bodySmall.copyWith(fontSize: 11, color: p.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: p.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleLogin();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: p.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Authorize & Sign In', style: TextStyle(color: p.onPrimaryDark, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _handleGoogleDriveSync() async {
    final p = context.palette;
    setState(() => _isDriveConnected = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: p.surfaceElevated,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: p.primary),
            ),
            const SizedBox(width: 12),
            Text('Connecting to Google Drive Enterprise API…',
                style: AppTypography.bodySmall.copyWith(color: p.textPrimary)),
          ],
        ),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    setState(() => _isDriveConnected = true);
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
            Icon(Icons.cloud_done, color: p.statusSuccess, size: 20),
            const SizedBox(width: 10),
            Text('Drive Synced: 128 GB RAW Masters Ready',
                style: AppTypography.bodySmall.copyWith(color: p.textPrimary)),
          ],
        ),
      ),
    );
  }

  void _showQRTokenDialog() {
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
            Icon(Icons.qr_code_scanner, color: p.primary, size: 24),
            const SizedBox(width: 10),
            Text('Event QR Scanner', style: AppTypography.headlineSmall.copyWith(fontSize: 18, color: p.textPrimary)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.primary, width: 2),
              ),
              child: const Center(
                child: Icon(Icons.qr_code_2, size: 140, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Point at your event lanyard QR or physical invite token.',
              style: AppTypography.bodySmall.copyWith(height: 1.5, color: p.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: p.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _tokenController.text = 'MONACO-2024-VIP');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: p.surfaceElevated,
                  behavior: SnackBarBehavior.floating,
                  content: Row(
                    children: [
                      Icon(Icons.check, color: p.statusSuccess, size: 20),
                      const SizedBox(width: 10),
                      Text('Token MONACO-2024-VIP loaded!',
                          style: AppTypography.bodySmall.copyWith(color: p.textPrimary)),
                    ],
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: p.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Simulate Scan', style: TextStyle(color: p.onPrimaryDark, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final isDaylight = AppState().lutMode == DisplayLutMode.daylightStudio;

    return Scaffold(
      backgroundColor: p.surfaceCanvas,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Quick Ambience Mode Toggle Pill at Top Right
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        final next = isDaylight
                            ? DisplayLutMode.darkCinema
                            : DisplayLutMode.daylightStudio;
                        AppState().setLutMode(next);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: p.surfaceElevated,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: p.borderSubtle),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isDaylight ? Icons.wb_sunny : Icons.nightlight_round,
                              size: 14,
                              color: p.textGold,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isDaylight ? 'Daylight Studio' : 'Dark Cinema',
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 10.5,
                                color: p.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Brand Header & Logo
                  const ApertureLogo(size: 84),
                  const SizedBox(height: 14),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Aperture',
                          style: AppTypography.displayLarge.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: p.textPrimary,
                          ),
                        ),
                        TextSpan(
                          text: 'Tube',
                          style: AppTypography.displayLarge.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: p.textGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 20, height: 1, color: p.primary.withValues(alpha: 0.5)),
                      const SizedBox(width: 8),
                      Text(
                        'CAPTURING MEMORIES',
                        style: AppTypography.monoSmall.copyWith(
                          color: p.textGold,
                          letterSpacing: 1.8,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(width: 20, height: 1, color: p.primary.withValues(alpha: 0.5)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Role Segmented Switch
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: p.surfaceElevated,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: p.borderSubtle, width: 0.8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isPhotographer = true),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isPhotographer ? p.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(26),
                                boxShadow: isPhotographer
                                    ? [
                                        BoxShadow(
                                          color: p.primary.withValues(alpha: 0.25),
                                          blurRadius: 10,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo_camera,
                                    size: 18,
                                    color: isPhotographer ? p.onPrimaryDark : p.textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Photographer',
                                    style: AppTypography.labelMedium.copyWith(
                                      color: isPhotographer ? p.onPrimaryDark : p.textSecondary,
                                      fontWeight: isPhotographer ? FontWeight.w700 : FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isPhotographer = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !isPhotographer ? p.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(26),
                                boxShadow: !isPhotographer
                                    ? [
                                        BoxShadow(
                                          color: p.primary.withValues(alpha: 0.25),
                                          blurRadius: 10,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.lock_open,
                                    size: 18,
                                    color: !isPhotographer ? p.onPrimaryDark : p.textSecondary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Client Portal',
                                    style: AppTypography.labelMedium.copyWith(
                                      color: !isPhotographer ? p.onPrimaryDark : p.textSecondary,
                                      fontWeight: !isPhotographer ? FontWeight.w700 : FontWeight.w500,
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
                  const SizedBox(height: 20),

                  // Form Container Card
                  Container(
                    decoration: BoxDecoration(
                      color: p.surfaceCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: p.borderSubtle, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDaylight ? 0.05 : 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Column(
                        children: [
                          // Luxury gold hairline gradient accent
                          Container(
                            height: 2.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  p.primary,
                                  p.textGold,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: isPhotographer
                                ? _buildPhotographerForm()
                                : _buildClientPortalForm(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Security Badges Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSecurityPill(Icons.verified_user, 'ENCRYPTED VAULT', p.primary),
                      Container(width: 4, height: 4, decoration: BoxDecoration(color: p.borderSubtle, shape: BoxShape.circle)),
                      _buildSecurityPill(Icons.raw_on, 'EXIF INTEGRITY', p.primary),
                      Container(width: 4, height: 4, decoration: BoxDecoration(color: p.borderSubtle, shape: BoxShape.circle)),
                      _buildSecurityPill(Icons.bolt, 'INSTANT PAYOUTS', p.statusSuccess),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Calibration Footer Stamp
                  Text(
                    'APERTURE CALIBRATION ENGINE V4.8.2 • HIGH DYNAMIC RANGE',
                    style: AppTypography.monoSmall.copyWith(
                      fontSize: 8.5,
                      color: p.textTertiary,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotographerForm() {
    final p = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1-Tap Google Drive Auth
        InkWell(
          onTap: _handleGoogleDriveSync,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: p.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: p.borderSubtle, width: 0.8),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: p.surfaceCard,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(Icons.add_to_drive, color: p.primary, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sync with Google Drive',
                        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700, color: p.textPrimary),
                      ),
                      Text(
                        _isDriveConnected ? '128 GB RAW Masters Ready ✓' : 'Instant Raw Ingestion',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          color: _isDriveConnected ? p.statusSuccess : p.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isDriveConnected ? Icons.cloud_done : Icons.arrow_forward_ios,
                  color: _isDriveConnected ? p.statusSuccess : p.textGold,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Divider
        Row(
          children: [
            Expanded(child: Divider(color: p.borderSubtle)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'OR STUDIO KEY',
                style: AppTypography.monoSmall.copyWith(fontSize: 9, color: p.textTertiary),
              ),
            ),
            Expanded(child: Divider(color: p.borderSubtle)),
          ],
        ),
        const SizedBox(height: 14),

        // Studio Email
        Text('STUDIO EMAIL / PRO HANDLE', style: AppTypography.monoSmall.copyWith(fontSize: 9.5, color: p.textSecondary)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: p.inputBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: p.borderSubtle, width: 0.8),
          ),
          child: TextField(
            controller: _emailController,
            style: AppTypography.bodyMedium.copyWith(color: p.textPrimary),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.alternate_email, color: p.textSecondary, size: 18),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Master Secret
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('MASTER ACCESS SECRET', style: AppTypography.monoSmall.copyWith(fontSize: 9.5, color: p.textSecondary)),
            Text('FORGOT?', style: AppTypography.monoSmall.copyWith(fontSize: 9.5, color: p.textGold, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: p.inputBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: p.borderSubtle, width: 0.8),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: obscurePassword,
            style: AppTypography.bodyMedium.copyWith(color: p.textPrimary, letterSpacing: 2),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.key, color: p.textSecondary, size: 18),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: p.textSecondary,
                  size: 18,
                ),
                onPressed: () => setState(() => obscurePassword = !obscurePassword),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Biometric row
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: rememberBiometrics,
                activeColor: p.primary,
                checkColor: p.onPrimaryDark,
                side: BorderSide(color: p.borderSubtle, width: 1),
                onChanged: (val) => setState(() => rememberBiometrics = val ?? true),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _handleBiometricLogin,
              child: _isBiometricLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: p.primary),
                    )
                  : Icon(Icons.fingerprint, color: p.textGold, size: 20),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: _handleBiometricLogin,
              child: Text(
                'Tap to Unlock with Biometrics',
                style: AppTypography.bodySmall.copyWith(
                  color: p.textGold,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: p.textGold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Primary Action CTA
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                p.primary,
                p.primaryContainer,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: p.primary.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_user, color: p.onPrimaryDark, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Enter Studio Workspace',
                  style: AppTypography.labelLarge.copyWith(
                    color: p.onPrimaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClientPortalForm() {
    final p = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event Session Banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: p.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: p.borderSubtle, width: 0.8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.qr_code_scanner, color: p.primary, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instant Event Session',
                      style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700, color: p.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Scan your lanyard QR code or physical invite token to unlock private event captures.',
                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: p.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Passcode Input
        Text('PASSCODE OR GALLERY TOKEN', style: AppTypography.monoSmall.copyWith(fontSize: 9.5, color: p.textSecondary)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: p.inputBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: p.borderSubtle, width: 0.8),
          ),
          child: TextField(
            controller: _tokenController,
            style: AppTypography.monoLarge.copyWith(color: p.textGold, letterSpacing: 1.5, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.tag, color: p.textSecondary, size: 18),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Launch QR Scanner button
        OutlinedButton(
          onPressed: _showQRTokenDialog,
          style: OutlinedButton.styleFrom(
            backgroundColor: p.surfaceElevated,
            side: BorderSide(color: p.borderSubtle, width: 1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            minimumSize: const Size(double.infinity, 46),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.photo_camera, color: p.textGold, size: 18),
              const SizedBox(width: 8),
              Text(
                'Launch Camera QR Reader',
                style: AppTypography.labelMedium.copyWith(color: p.textGold, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Access Private Vault CTA
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: p.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: p.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Access Private Vault',
                  style: AppTypography.labelLarge.copyWith(
                    color: p.onPrimaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: p.onPrimaryDark, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityPill(IconData icon, String text, Color color) {
    final p = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTypography.monoSmall.copyWith(
            fontSize: 9,
            color: p.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
