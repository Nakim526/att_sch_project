import 'package:att_school/core/constant/app_color.dart';
import 'package:flutter/material.dart';

extension ThemeX on BuildContext {
  /* ======================
   * COLOR SCHEME SHORTCUT
   * ====================== */

  Color get primary => theme.colorScheme.primary;
  Color get onPrimary => theme.colorScheme.onPrimary;

  Color get secondary => theme.colorScheme.secondary;
  Color get onSecondary => theme.colorScheme.onSecondary;

  Color get tertiary => theme.colorScheme.tertiary;
  Color get onTertiary => theme.colorScheme.onTertiary;

  Color get primaryContainer => theme.colorScheme.primaryContainer;
  Color get onPrimaryContainer => theme.colorScheme.onPrimaryContainer;

  Color get secondaryContainer => theme.colorScheme.secondaryContainer;
  Color get onSecondaryContainer => theme.colorScheme.onSecondaryContainer;

  Color get tertiaryContainer => theme.colorScheme.tertiaryContainer;
  Color get onTertiaryContainer => theme.colorScheme.onTertiaryContainer;

  Color get error => theme.colorScheme.error;
  Color get onError => theme.colorScheme.onError;

  Color get surface => theme.colorScheme.surface;
  Color get onSurface => theme.colorScheme.onSurface;
  Color get outline => theme.colorScheme.outline;

  /* ======================
   * SEMANTIC STATES
   * ====================== */

  Color get success =>
      brightness == Brightness.light
          ? AppColor.lightSuccess
          : AppColor.darkSuccess;

  Color get warning =>
      brightness == Brightness.light
          ? AppColor.lightWarning
          : AppColor.darkWarning;

  Color get info =>
      brightness == Brightness.light
          ? AppColor.lightInfo
          : AppColor.darkInfo;

  Color get disabled => theme.disabledColor;

  /* ======================
   * INTERACTION STATES
   * ====================== */

  Color get hoverOverlay => onSurface.withValues(alpha: 0.12);
  Color get pressedOverlay => onSurface.withValues(alpha: 0.24);

  /* ======================
   * THEME SHORTCUT
   * ====================== */

  ThemeData get theme => Theme.of(this);
  TextTheme get text => theme.textTheme;
  Brightness get brightness => theme.brightness;
}
