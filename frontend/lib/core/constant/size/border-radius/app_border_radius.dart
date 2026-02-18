import 'package:att_school/core/constant/size/app_size.dart';
import 'package:flutter/material.dart';

class AppBorderRadius {
  const AppBorderRadius._();

  static BorderRadius none = BorderRadius.zero;
  static BorderRadius xSmall = BorderRadius.circular(AppSize.xSmall);
  static BorderRadius small = BorderRadius.circular(AppSize.small);
  static BorderRadius medium = BorderRadius.circular(AppSize.medium);
  static BorderRadius large = BorderRadius.circular(AppSize.large);
  static BorderRadius xLarge = BorderRadius.circular(AppSize.xLarge);
  static BorderRadius xxLarge = BorderRadius.circular(AppSize.xxLarge);
  static BorderRadius xxxLarge = BorderRadius.circular(AppSize.xxxLarge);

  static BorderRadius circular(double radius) => BorderRadius.circular(radius);

  static BorderRadius only({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) => BorderRadius.only(
    topLeft: Radius.circular(topLeft),
    topRight: Radius.circular(topRight),
    bottomLeft: Radius.circular(bottomLeft),
    bottomRight: Radius.circular(bottomRight),
  );

  static BorderRadius all(double radius) {
    return BorderRadius.all(Radius.circular(radius));
  }

  static BorderRadius vertical(double radius) {
    return BorderRadius.vertical(top: Radius.circular(radius));
  }

  static BorderRadius horizontal(double radius) {
    return BorderRadius.horizontal(left: Radius.circular(radius));
  }

  static BorderRadius top(double radius) {
    return BorderRadius.vertical(top: Radius.circular(radius));
  }

  static BorderRadius bottom(double radius) {
    return BorderRadius.vertical(bottom: Radius.circular(radius));
  }

  static BorderRadius left(double radius) {
    return BorderRadius.horizontal(left: Radius.circular(radius));
  }

  static BorderRadius right(double radius) {
    return BorderRadius.horizontal(right: Radius.circular(radius));
  }
}
