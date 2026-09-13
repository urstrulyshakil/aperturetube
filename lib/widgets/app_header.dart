import 'package:flutter/material.dart';
import '../models/studio_settings.dart';
import '../state/app_state.dart';
import '../theme/app_palette.dart';
import '../theme/app_typography.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? titleTag;
  final Widget? trailingAction;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onLogoTap;

  const AppHeader({
    super.key,
    this.titleTag,
    this.trailingAction,
    this.onAvatarTap,
    this.onLogoTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final isDaylight = AppState().lutMode == DisplayLutMode.daylightStudio;

    return Container(
      height: 66 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 4,
        bottom: 8,
        left: 14,
        right: 14,
      ),
      decoration: BoxDecoration(
        color: p.surfaceCanvas.withValues(alpha: 0.96),
        border: Border(
          bottom: BorderSide(color: p.borderSubtle, width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDaylight ? 0.04 : 0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Upper Left: Profile Button & Brand Logo (Both fully clickable) ──
          Row(
            children: [
              // Profile Button in Upper Left (Tapping navigates to Profile tab)
              Tooltip(
                message: 'Photographer Profile',
                child: InkWell(
                  onTap: onAvatarTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 36,
                    height: 36,
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: p.primary,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: p.primary.withValues(alpha: isDaylight ? 0.2 : 0.35),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida/AEtjO1W2d40aK4i2E3OdQabT3q2MX50QbYaBikw3sAiiNICxgg5kC9Q_9BFpBK5phvLLC2Ds0r2o0yI0_gYhzO9H2dQTP807oFA_V6cAhVfPk6AR1nOlU_dHgWuog7jbVj45B3DrmJ1LVtFB9_ujFQ_2Qs1tggkQ5gDCtFA-vN-LwjLqob6tt3QJFr2HHS8viGp25fiSeXQNonm8-mhL5iR73VrkyDsgFq0-eja2qRX2lTbatHOT58mTs1AaMfltDpZDVZqAlMjI6lyBgg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: p.surfaceElevated,
                          child: Icon(Icons.person, color: p.primary, size: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Brand & Projects Logo (Tapping navigates to Projects tab)
              Tooltip(
                message: 'Projects & Master Vault',
                child: InkWell(
                  onTap: onLogoTap,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Aperture',
                                style: AppTypography.headlineSmall.copyWith(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                  color: p.textPrimary,
                                ),
                              ),
                              TextSpan(
                                text: 'Tube',
                                style: AppTypography.headlineSmall.copyWith(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: p.textGold,
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 1),
                        Row(
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: p.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'CAPTURING MEMORIES',
                              style: AppTypography.monoSmall.copyWith(
                                fontSize: 8.5,
                                color: p.textGold,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Upper Right: Theme Switcher, Tag Pill & Actions ──
          Row(
            children: [
              // Quick Day/Night Studio Mode Switcher
              Tooltip(
                message: isDaylight ? 'Switch to Dark Cinema' : 'Switch to Daylight Studio',
                child: InkWell(
                  onTap: () {
                    final nextMode = isDaylight
                        ? DisplayLutMode.darkCinema
                        : DisplayLutMode.daylightStudio;
                    AppState().setLutMode(nextMode);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 1),
                        backgroundColor: p.surfaceCard,
                        content: Text(
                          isDaylight ? 'Switched to Dark Cinema' : 'Switched to Daylight Studio',
                          style: TextStyle(color: p.textPrimary),
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: p.surfaceElevated,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDaylight
                            ? p.primary.withValues(alpha: 0.6)
                            : p.borderSubtle,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isDaylight ? Icons.wb_sunny : Icons.nightlight_round,
                          color: p.textGold,
                          size: 15,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isDaylight ? 'Daylight' : 'Cinema',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: p.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              if (titleTag != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: p.surfaceCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: p.borderSubtle, width: 0.8),
                  ),
                  child: Text(
                    titleTag!,
                    style: AppTypography.labelSmall.copyWith(
                      color: p.textGold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],

              ?trailingAction,
            ],
          ),
        ],
      ),
    );
  }
}
