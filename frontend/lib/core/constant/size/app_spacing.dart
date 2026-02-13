import 'package:flutter/material.dart';
import 'package:att_school/core/constant/size/app_size.dart';

abstract class AppSpacing {
  static const EdgeInsets none = EdgeInsets.zero;

  static const EdgeInsets xSmall = EdgeInsets.all(AppSize.xSmall);
  static const EdgeInsets small = EdgeInsets.all(AppSize.small);
  static const EdgeInsets medium = EdgeInsets.all(AppSize.medium);
  static const EdgeInsets large = EdgeInsets.all(AppSize.large);
  static const EdgeInsets xLarge = EdgeInsets.all(AppSize.xLarge);
  static const EdgeInsets xxLarge = EdgeInsets.all(AppSize.xxLarge);
  static const EdgeInsets xxxLarge = EdgeInsets.all(AppSize.xxxLarge);

  static const EdgeInsets button = EdgeInsets.symmetric(
    horizontal: AppSize.large,
    vertical: AppSize.medium,
  );

  static EdgeInsets horizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value);

  static EdgeInsets vertical(double value) =>
      EdgeInsets.symmetric(vertical: value);

  static EdgeInsets all(double value) => EdgeInsets.all(value);

  static EdgeInsets only({
    double top = 0,
    double right = 0,
    double bottom = 0,
    double left = 0,
  }) =>
      EdgeInsets.only(top: top, right: right, bottom: bottom, left: left);
}
