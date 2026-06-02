import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

/// Centralized theme configuration using FlexColorScheme.
///
/// Uses the [FlexScheme.blueM3] seed to give a professional, neutral
/// look appropriate for a resume-focused product.
abstract final class AppTheme {
  static const FlexScheme _scheme = FlexScheme.blueM3;
  static const double _borderRadius = 12.0;

  /// Light theme — used when [ThemeMode.light] is active.
  static ThemeData get light => FlexThemeData.light(
        scheme: _scheme,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          defaultRadius: _borderRadius,
          elevatedButtonSchemeColor: SchemeColor.primary,
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorUnfocusedBorderIsColored: false,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
      );

  /// Dark theme — used when [ThemeMode.dark] is active.
  static ThemeData get dark => FlexThemeData.dark(
        scheme: _scheme,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          defaultRadius: _borderRadius,
          elevatedButtonSchemeColor: SchemeColor.primary,
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorUnfocusedBorderIsColored: false,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
      );
}
