import 'package:flutter/material.dart';
import '../theme/color_manager.dart';

// dart format off
extension ThemeSettings on BuildContext {

  ThemeData     get theme             => Theme.of(this);

  /// 10
  TextStyle     get labelSmall        => theme.textTheme.labelSmall ?? const TextStyle();

  /// 12
  TextStyle     get labelMedium       => theme.textTheme.labelMedium ?? const TextStyle();

  /// 14
  TextStyle     get labelLarge        => theme.textTheme.labelLarge ?? const TextStyle();

  /// 12
  TextStyle     get bodySmall         => theme.textTheme.bodySmall ?? const TextStyle();

  /// 14
  TextStyle     get bodyMedium        => theme.textTheme.bodyMedium ?? const TextStyle();

  /// 16
  TextStyle     get bodyLarge         => theme.textTheme.bodyLarge ?? const TextStyle();

  /// 14
  TextStyle     get titleSmall        => theme.textTheme.titleSmall ?? const TextStyle();

  /// 16
  TextStyle     get titleMedium       => theme.textTheme.titleMedium ?? const TextStyle();

  /// 20
  TextStyle     get titleLarge        => theme.textTheme.titleLarge ?? const TextStyle();

  /// 22
  TextStyle     get headlineSmall     => theme.textTheme.headlineSmall ?? const TextStyle();

  /// 26
  TextStyle     get headlineMedium    => theme.textTheme.headlineMedium ?? const TextStyle();

  /// 30
  TextStyle     get headlineLarge     => theme.textTheme.headlineLarge ?? const TextStyle();

  /// 34
  TextStyle     get displaySmall      => theme.textTheme.displaySmall ?? const TextStyle();

  /// 40
  TextStyle     get displayMedium     => theme.textTheme.displayMedium ?? const TextStyle();

  /// 48
  TextStyle     get displayLarge      => theme.textTheme.displayLarge ?? const TextStyle();

  ColorScheme   get colorScheme       => theme.colorScheme;

  TextTheme     get textTheme         => theme.textTheme;

  // theme mode
  bool          get isDark            => theme.brightness == Brightness.dark;
  bool          get isLight           => theme.brightness == Brightness.light;
  ThemeMode     get themeMode         => isDark ? ThemeMode.dark : ThemeMode.light;

  // semantic & brand colors
  Color         get primaryColor      => ColorM.primary;
  Color         get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;
  Color         get surfaceColor      => isDark ? ColorM.surfaceDark : ColorM.surface;
  Color         get borderColor       => ColorM.border;
  Color         get textPrimaryColor  => isDark ? ColorM.white : ColorM.textPrimary;
  Color         get textSecondaryColor => ColorM.textSecondary;
  Color         get errorColor        => ColorM.error;
}
// dart format on
