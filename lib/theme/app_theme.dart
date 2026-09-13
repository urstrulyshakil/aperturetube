import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_palette.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final palette = AppPalette.dark();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: palette.surfaceCanvas,
      primaryColor: palette.primary,
      colorScheme: ColorScheme.dark(
        primary: palette.primary,
        onPrimary: palette.onPrimaryDark,
        primaryContainer: palette.primaryContainer,
        secondary: AppColors.secondary,
        surface: palette.surfaceCard,
        onSurface: palette.textPrimary,
        error: palette.statusError,
        outline: palette.borderSubtle,
        surfaceContainerHighest: palette.surfaceContainerHighest,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.surfaceContainerLowest.withValues(alpha: 0.95),
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: false,
        titleTextStyle: AppTypography.headlineSmall.copyWith(color: palette.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: palette.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: palette.borderSubtle, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: palette.borderSubtle,
        thickness: 1,
        space: 1,
      ),
      extensions: [palette],
    );
  }

  // Daylight Studio — warm cream white base with radiant gold accents & readable deep obsidian text
  static ThemeData get lightTheme {
    final palette = AppPalette.light();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: palette.surfaceCanvas, // 0xFFFAF7F0 cream white
      primaryColor: palette.primaryContainer,
      colorScheme: ColorScheme.light(
        primary: palette.primary,
        onPrimary: palette.onPrimaryDark,
        primaryContainer: palette.primaryContainer,
        secondary: const Color(0xFF966800),
        surface: palette.surfaceCard,
        onSurface: palette.textPrimary,
        error: palette.statusError,
        outline: palette.borderSubtle,
        surfaceContainerHighest: palette.surfaceContainerHighest,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.surfaceContainerLowest.withValues(alpha: 0.95),
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: false,
        foregroundColor: palette.textPrimary,
      ),
      cardTheme: CardThemeData(
        color: palette.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: palette.borderSubtle, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: palette.borderSubtle,
        thickness: 1,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return palette.primaryContainer;
          }
          return const Color(0xFFC0B8A7);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return palette.primary.withValues(alpha: 0.45);
          }
          return const Color(0xFFDDD5C4);
        }),
      ),
      extensions: [palette],
    );
  }
}
