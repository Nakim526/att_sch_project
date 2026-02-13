import 'package:att_school/core/constant/app_color.dart';
import 'package:flutter/material.dart';

extension ThemeX on BuildContext {
  Color get primary => Theme.of(this).colorScheme.primary;

  Color get secondary => Theme.of(this).colorScheme.secondary;

  Color get tertiary => Theme.of(this).colorScheme.tertiary;

  Color get primaryContainer => Theme.of(this).colorScheme.primaryContainer;

  Color get secondaryContainer => Theme.of(this).colorScheme.secondaryContainer;

  Color get tertiaryContainer => Theme.of(this).colorScheme.tertiaryContainer;
  
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

  Color get error => Theme.of(this).colorScheme.error;

  Color get surface => Theme.of(this).colorScheme.surface;

  Color get outline => Theme.of(this).colorScheme.outline;

  Color get disabled => Theme.of(this).disabledColor;

  Brightness get brightness => Theme.of(this).brightness;

  TextTheme get text => Theme.of(this).textTheme;
}
