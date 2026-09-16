import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Material 3, as Flutter ships it, re-coloured with the azuma tokens - the
/// mapping on the design canvas's token sheet. No third-party UI package.
///
/// Shape and type follow the spec (`examples/specifications/customer-app.md`
/// section 5): pill buttons 48 (56 for a screen's one primary action), outlined
/// fields 56 with radius 8, tiles radius 12, a 64 app bar, Figtree throughout.
abstract final class AppTheme {
  static const String fontFamily = 'Figtree';

  static const double screenPadding = 24;
  static const double fieldRadius = 8;
  static const double tileRadius = 12;
  static const double buttonHeight = 48;
  static const double heroButtonHeight = 56;

  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primary100,
    onPrimaryContainer: AppColors.primary700,
    secondary: AppColors.primary500,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.primary100,
    onSecondaryContainer: AppColors.primary700,
    tertiary: AppColors.success,
    onTertiary: AppColors.white,
    tertiaryContainer: AppColors.success50,
    onTertiaryContainer: AppColors.successText,
    error: AppColors.error,
    onError: AppColors.white,
    errorContainer: AppColors.error50,
    onErrorContainer: AppColors.errorText,
    surface: AppColors.white,
    onSurface: AppColors.neutral900,
    surfaceContainerLowest: AppColors.white,
    surfaceContainerLow: AppColors.neutral50,
    surfaceContainer: AppColors.neutral50,
    surfaceContainerHigh: AppColors.neutral100,
    surfaceContainerHighest: AppColors.neutral100,
    onSurfaceVariant: AppColors.neutral500,
    outline: AppColors.neutral300,
    outlineVariant: AppColors.neutral200,
    inverseSurface: AppColors.primary700,
    onInverseSurface: AppColors.white,
    inversePrimary: AppColors.primary200,
    shadow: AppColors.neutral900,
    scrim: AppColors.neutral900,
  );

  /// Built once; `MaterialApp` reads it on every build.
  static final ThemeData light = _build();

  static ThemeData _build() {
    const pill = StadiumBorder();
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.white,
    );
    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        toolbarHeight: 64,
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.neutral700,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: AppColors.neutral900,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(buttonHeight),
          shape: pill,
          textStyle: _buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(buttonHeight),
          shape: pill,
          side: const BorderSide(color: AppColors.neutral200),
          foregroundColor: AppColors.primary700,
          textStyle: _buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 44),
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(fieldRadius)),
          borderSide: BorderSide(color: AppColors.neutral300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(fieldRadius)),
          borderSide: BorderSide(color: AppColors.neutral300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(fieldRadius)),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(fieldRadius)),
          borderSide: BorderSide(color: AppColors.neutral200),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(fieldRadius)),
          borderSide: BorderSide(color: AppColors.errorText, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(fieldRadius)),
          borderSide: BorderSide(color: AppColors.errorText, width: 2),
        ),
        errorStyle: TextStyle(color: AppColors.errorText, fontSize: 12),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        labelStyle: TextStyle(color: AppColors.neutral500),
        floatingLabelStyle: TextStyle(color: AppColors.primary),
        helperStyle: TextStyle(color: AppColors.neutral500, fontSize: 12),
        hintStyle: TextStyle(color: AppColors.neutral400),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.primary700,
        textColor: AppColors.neutral900,
        subtitleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          color: AppColors.neutral500,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.neutral100,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primary100,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(color: AppColors.neutral300, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  static const TextStyle _buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextTheme _textTheme(TextTheme base) => base.copyWith(
    // Welcome headline (one size up from the standard headline).
    headlineLarge: const TextStyle(
      fontSize: 30,
      height: 38 / 30,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.6,
      color: AppColors.neutral900,
    ),
    // Standard screen headline.
    headlineMedium: const TextStyle(
      fontSize: 28,
      height: 36 / 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.56,
      color: AppColors.neutral900,
    ),
    // Greeting on a linked phone.
    headlineSmall: const TextStyle(
      fontSize: 24,
      height: 30 / 24,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.48,
      color: AppColors.neutral900,
    ),
    titleMedium: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.neutral900,
    ),
    bodyLarge: const TextStyle(
      fontSize: 16,
      height: 26 / 16,
      color: AppColors.neutral600,
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      height: 20 / 14,
      color: AppColors.neutral600,
    ),
    bodySmall: const TextStyle(
      fontSize: 12,
      height: 16 / 12,
      color: AppColors.neutral500,
    ),
    // Section labels: 12/600, 0.08em tracking, upper-case by the caller.
    labelSmall: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.96,
      color: AppColors.neutral500,
    ),
  );
}
