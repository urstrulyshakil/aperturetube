import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Semantic color palette for both Dark Cinema and Daylight Studio modes.
/// Access via: `context.palette.surfaceCard`
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.surfaceCanvas,
    required this.surfaceCard,
    required this.surfaceElevated,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHighest,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textGold,
    required this.borderSubtle,
    required this.borderGoldGlow,
    required this.primary,
    required this.primaryContainer,
    required this.onPrimaryDark,
    required this.statusSuccess,
    required this.statusError,
    required this.statusWarning,
    required this.cardBorder,
    required this.inputBackground,
    required this.chipBackground,
  });

  final Color surfaceCanvas;
  final Color surfaceCard;
  final Color surfaceElevated;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHighest;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textGold;
  final Color borderSubtle;
  final Color borderGoldGlow;
  final Color primary;
  final Color primaryContainer;
  final Color onPrimaryDark;
  final Color statusSuccess;
  final Color statusError;
  final Color statusWarning;
  final Color cardBorder;
  final Color inputBackground;
  final Color chipBackground;

  // ── Dark Cinema (Obsidian & Amber Gold) ──────────────────────────────
  factory AppPalette.dark() => AppPalette(
        surfaceCanvas: AppColors.surfaceCanvas,
        surfaceCard: AppColors.surfaceCard,
        surfaceElevated: AppColors.surfaceElevated,
        surfaceContainerLowest: AppColors.surfaceContainerLowest,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        textPrimary: AppColors.textPrimary,
        textSecondary: AppColors.textSecondary,
        textTertiary: AppColors.textTertiary,
        textGold: AppColors.textGold,
        borderSubtle: AppColors.borderSubtle,
        borderGoldGlow: AppColors.borderGoldGlow,
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryDark: AppColors.onPrimaryDark,
        statusSuccess: AppColors.statusSuccess,
        statusError: AppColors.statusError,
        statusWarning: AppColors.statusWarning,
        cardBorder: AppColors.borderSubtle,
        inputBackground: AppColors.surfaceContainerLowest,
        chipBackground: AppColors.surfaceContainerLow,
      );

  // ── Daylight Studio (Cream White & Gold Texture) ──────────────────────
  factory AppPalette.light() => AppPalette(
        surfaceCanvas: const Color(0xFFFAF7F0), // Cream white base
        surfaceCard: const Color(0xFFFFFFFF),   // Crisp white card
        surfaceElevated: const Color(0xFFF5EFE4), // Soft cream tone
        surfaceContainerLowest: const Color(0xFFEDE5D6), // Deeper cream
        surfaceContainerLow: const Color(0xFFE5DCCB),
        surfaceContainer: const Color(0xFFDCD2BE),
        surfaceContainerHighest: const Color(0xFFD2C7B1),
        textPrimary: const Color(0xFF181510),    // Deep warm obsidian dark
        textSecondary: const Color(0xFF665A46),  // Warm mocha brown
        textTertiary: const Color(0xFF8F816D),   // Soft warm slate
        textGold: const Color(0xFF966800),       // Deep readable antique gold
        borderSubtle: const Color(0xFFDCD4C2),   // Cream-gold border
        borderGoldGlow: const Color(0x35D4AF37),
        primary: const Color(0xFFD4AF37),        // Rich studio gold
        primaryContainer: const Color(0xFFF2CA50),
        onPrimaryDark: const Color(0xFF1A1400),
        statusSuccess: const Color(0xFF197A3E),
        statusError: const Color(0xFFB71C1C),
        statusWarning: const Color(0xFFC45A00),
        cardBorder: const Color(0xFFDCD4C2),
        inputBackground: const Color(0xFFF5EFE4),
        chipBackground: const Color(0xFFEDE5D6),
      );

  @override
  AppPalette copyWith({
    Color? surfaceCanvas,
    Color? surfaceCard,
    Color? surfaceElevated,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHighest,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textGold,
    Color? borderSubtle,
    Color? borderGoldGlow,
    Color? primary,
    Color? primaryContainer,
    Color? onPrimaryDark,
    Color? statusSuccess,
    Color? statusError,
    Color? statusWarning,
    Color? cardBorder,
    Color? inputBackground,
    Color? chipBackground,
  }) {
    return AppPalette(
      surfaceCanvas: surfaceCanvas ?? this.surfaceCanvas,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceContainerLowest: surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHighest: surfaceContainerHighest ?? this.surfaceContainerHighest,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textGold: textGold ?? this.textGold,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderGoldGlow: borderGoldGlow ?? this.borderGoldGlow,
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryDark: onPrimaryDark ?? this.onPrimaryDark,
      statusSuccess: statusSuccess ?? this.statusSuccess,
      statusError: statusError ?? this.statusError,
      statusWarning: statusWarning ?? this.statusWarning,
      cardBorder: cardBorder ?? this.cardBorder,
      inputBackground: inputBackground ?? this.inputBackground,
      chipBackground: chipBackground ?? this.chipBackground,
    );
  }

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      surfaceCanvas: Color.lerp(surfaceCanvas, other.surfaceCanvas, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceContainerLowest: Color.lerp(surfaceContainerLowest, other.surfaceContainerLowest, t)!,
      surfaceContainerLow: Color.lerp(surfaceContainerLow, other.surfaceContainerLow, t)!,
      surfaceContainer: Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerHighest: Color.lerp(surfaceContainerHighest, other.surfaceContainerHighest, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textGold: Color.lerp(textGold, other.textGold, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderGoldGlow: Color.lerp(borderGoldGlow, other.borderGoldGlow, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      onPrimaryDark: Color.lerp(onPrimaryDark, other.onPrimaryDark, t)!,
      statusSuccess: Color.lerp(statusSuccess, other.statusSuccess, t)!,
      statusError: Color.lerp(statusError, other.statusError, t)!,
      statusWarning: Color.lerp(statusWarning, other.statusWarning, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      chipBackground: Color.lerp(chipBackground, other.chipBackground, t)!,
    );
  }
}

/// Convenience extension — use `context.palette.surfaceCard` anywhere.
extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>() ?? AppPalette.dark();
}
