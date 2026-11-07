import 'package:flutter/material.dart';
import 'color_manager.dart';
import 'fonts_manager.dart';
import 'sizes_manager.dart';

class ThemeManager {
  static ThemeData lightTheme([BuildContext? context]) => ThemeData(
    fontFamily: FontsM.inter.name,
    useMaterial3: true,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    scaffoldBackgroundColor: ColorM.background,
    textTheme: TextStyles.customTextTheme(ColorM.textPrimary),
    visualDensity: VisualDensity.comfortable,
    colorScheme: const ColorScheme.light(
      primary: ColorM.primary,
      onPrimary: ColorM.white,
      secondary: ColorM.primary700,
      surface: ColorM.surface,
      error: ColorM.error,
      onError: ColorM.white,
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size.zero),
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        iconColor: WidgetStatePropertyAll(ColorM.textSecondary),
        iconSize: WidgetStatePropertyAll(20),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(
          Size(double.infinity, SizeM.buttonHeight),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return ColorM.primary.withValues(alpha: .5);
          }
          return ColorM.primary;
        }),
        foregroundColor: const WidgetStatePropertyAll(ColorM.white),
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeM.buttonBorderRadius),
          ),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeightM.bold,
            fontFamily: 'Inter',
            color: ColorM.white,
          ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorM.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeightM.regular,
        color: ColorM.textHint,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeM.inputBorderRadius),
        borderSide: const BorderSide(color: ColorM.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeM.inputBorderRadius),
        borderSide: const BorderSide(color: ColorM.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeM.inputBorderRadius),
        borderSide: const BorderSide(color: ColorM.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeM.inputBorderRadius),
        borderSide: const BorderSide(color: ColorM.error, width: 1.5),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorM.primary,
      selectionColor: ColorM.primary.withValues(alpha: .2),
      selectionHandleColor: ColorM.primary,
    ),
  );
}

class TextStyles {
  static TextTheme customTextTheme(
    Color color, [
    double additionalFontSize = 0.0,
  ]) => TextTheme(
    labelSmall: TextStyle(
      fontSize: 10 + additionalFontSize,
      color: color,
      fontWeight: FontWeightM.regular,
      fontFamily: FontsM.inter.name,
    ),
    labelMedium: TextStyle(
      fontSize: 12 + additionalFontSize,
      color: color,
      fontWeight: FontWeightM.regular,
      fontFamily: FontsM.inter.name,
    ),
    labelLarge: TextStyle(
      fontSize: 14 + additionalFontSize,
      color: color,
      fontWeight: FontWeightM.regular,
      fontFamily: FontsM.inter.name,
    ),
    bodySmall: TextStyle(
      fontSize: 12 + additionalFontSize,
      color: color,
      fontWeight: FontWeightM.regular,
      fontFamily: FontsM.inter.name,
    ),
    bodyMedium: TextStyle(
      fontSize: 14 + additionalFontSize,
      color: color,
      fontWeight: FontWeightM.regular,
      fontFamily: FontsM.inter.name,
    ),
    bodyLarge: TextStyle(
      fontSize: 16 + additionalFontSize,
      color: color,
      fontWeight: FontWeightM.regular,
      fontFamily: FontsM.inter.name,
    ),
    titleSmall: TextStyle(
      fontSize: 14 + additionalFontSize,
      color: color,
      fontWeight: FontWeightM.regular,
      fontFamily: FontsM.inter.name,
    ),
    titleMedium: TextStyle(
      fontSize: 16 + additionalFontSize,
      color: color,
      fontWeight: FontWeightM.regular,
      fontFamily: FontsM.inter.name,
    ),
    titleLarge: TextStyle(
      fontSize: 20 + additionalFontSize,
      color: color,
      fontWeight: FontWeightM.regular,
      fontFamily: FontsM.inter.name,
    ),
    headlineSmall: TextStyle(
      fontSize: 22 + additionalFontSize,
      color: color,
      fontWeight: FontWeightM.regular,
      fontFamily: FontsM.inter.name,
    ),
    headlineMedium: TextStyle(
      fontSize: 26 + additionalFontSize,
      color: color,
      fontWeight: FontWeightM.regular,
      fontFamily: FontsM.inter.name,
    ),
    headlineLarge: TextStyle(
      fontSize: 30 + additionalFontSize,
      color: color,
      fontWeight: FontWeightM.regular,
      fontFamily: FontsM.inter.name,
    ),
    displaySmall: TextStyle(
      fontSize: 34 + additionalFontSize,
      color: color,
      fontWeight: FontWeightM.regular,
      fontFamily: FontsM.inter.name,
    ),
    displayMedium: TextStyle(
      fontSize: 40 + additionalFontSize,
      color: color,
      fontWeight: FontWeightM.regular,
      fontFamily: FontsM.inter.name,
    ),
    displayLarge: TextStyle(
      fontSize: 48 + additionalFontSize,
      color: color,
      fontWeight: FontWeightM.regular,
      fontFamily: FontsM.inter.name,
    ),
  );
}
