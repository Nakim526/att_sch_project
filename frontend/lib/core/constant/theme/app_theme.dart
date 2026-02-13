import 'package:att_school/core/constant/app_color.dart';
import 'package:att_school/core/constant/size/border-radius/app_border_radius.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.lightPrimaryBg,
    primaryColor: AppColor.lightPrimary,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.lightSecondaryBg,
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColor.lightSurface,
      dayStyle: const TextStyle(color: AppColor.lightTextPrimary),
      weekdayStyle: const TextStyle(color: AppColor.lightTextPrimary),
      yearStyle: const TextStyle(color: AppColor.lightTextPrimary),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColor.lightSecondaryBg,
    ),

    dialogTheme: const DialogTheme(
      backgroundColor: AppColor.lightSecondaryBg,
    ),

    cardTheme: const CardTheme(color: AppColor.lightSurface),

    colorScheme: const ColorScheme.light(
      primary: AppColor.lightPrimary,
      secondary: AppColor.lightSecondary,
      tertiary: AppColor.lightTertiary,
      error: AppColor.lightError,
      surface: AppColor.lightSurface,
      outline: AppColor.lightOutline,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColor.lightTextPrimary),
      displayMedium: TextStyle(color: AppColor.lightTextSecondary),
      displaySmall: TextStyle(color: AppColor.lightTextMuted),
      titleLarge: TextStyle(color: AppColor.lightTextPrimary),
      titleMedium: TextStyle(color: AppColor.lightTextSecondary),
      titleSmall: TextStyle(color: AppColor.lightTextMuted),
      bodyLarge: TextStyle(color: AppColor.lightTextPrimary),
      bodyMedium: TextStyle(color: AppColor.lightTextSecondary),
      bodySmall: TextStyle(color: AppColor.lightTextMuted),
      labelLarge: TextStyle(color: AppColor.lightTextPrimary),
      labelMedium: TextStyle(color: AppColor.lightTextSecondary),
      labelSmall: TextStyle(color: AppColor.lightTextMuted),
    ),

    dividerColor: AppColor.lightDivider,

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.lightInputBg,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.lightInputBorder),
        borderRadius: AppBorderRadius.small,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.lightInputFocus),
        borderRadius: AppBorderRadius.small,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.lightError),
        borderRadius: AppBorderRadius.small,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.darkPrimaryBg,
    primaryColor: AppColor.darkPrimary,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.darkSecondaryBg,
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColor.darkSurface,
      dayStyle: const TextStyle(color: AppColor.darkTextPrimary),
      weekdayStyle: const TextStyle(color: AppColor.darkTextPrimary),
      yearStyle: const TextStyle(color: AppColor.darkTextPrimary),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColor.darkSecondaryBg,
    ),

    dialogTheme: const DialogTheme(
      backgroundColor: AppColor.darkSecondaryBg,
    ),

    cardTheme: const CardTheme(color: AppColor.darkSurface),

    colorScheme: const ColorScheme.dark(
      primary: AppColor.darkPrimary,
      secondary: AppColor.darkSecondary,
      tertiary: AppColor.darkTertiary,
      error: AppColor.darkError,
      surface: AppColor.darkSurface,
      outline: AppColor.darkOutline,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColor.darkTextPrimary),
      displayMedium: TextStyle(color: AppColor.darkTextSecondary),
      displaySmall: TextStyle(color: AppColor.darkTextMuted),
      titleLarge: TextStyle(color: AppColor.darkTextPrimary),
      titleMedium: TextStyle(color: AppColor.darkTextSecondary),
      titleSmall: TextStyle(color: AppColor.darkTextMuted),
      bodyLarge: TextStyle(color: AppColor.darkTextPrimary),
      bodyMedium: TextStyle(color: AppColor.darkTextSecondary),
      bodySmall: TextStyle(color: AppColor.darkTextMuted),
      labelLarge: TextStyle(color: AppColor.darkTextPrimary),
      labelMedium: TextStyle(color: AppColor.darkTextSecondary),
      labelSmall: TextStyle(color: AppColor.darkTextMuted),
    ),

    dividerColor: AppColor.darkDivider,

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.darkInputBg,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.darkInputBorder),
        borderRadius: AppBorderRadius.small,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.darkInputFocus),
        borderRadius: AppBorderRadius.small,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.darkError),
        borderRadius: AppBorderRadius.small,
      ),
    ),
  );
}
