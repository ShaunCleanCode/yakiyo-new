import 'package:flutter/material.dart';
import 'package:yakiyo/core/constants/color_constants.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: ColorConstants.primary,
      secondary: ColorConstants.secondary,
      background: ColorConstants.background,
      surface: ColorConstants.surface,
      error: ColorConstants.error,
      onPrimary: ColorConstants.onPrimary,
      onSecondary: ColorConstants.onSecondary,
      onBackground: ColorConstants.onBackground,
      onSurface: ColorConstants.onSurface,
      onError: ColorConstants.onError,
    ),
    dialogBackgroundColor: Colors.white,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: ColorConstants.primary,
      secondary: ColorConstants.secondary,
      background: ColorConstants.background,
      surface: ColorConstants.surface,
      error: ColorConstants.error,
      onPrimary: ColorConstants.onPrimary,
      onSecondary: ColorConstants.onSecondary,
      onBackground: ColorConstants.onBackground,
      onSurface: ColorConstants.onSurface,
      onError: ColorConstants.onError,
    ),
    dialogBackgroundColor: Colors.white,
  );
}
