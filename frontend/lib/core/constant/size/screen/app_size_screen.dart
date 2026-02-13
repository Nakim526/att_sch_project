import 'package:att_school/core/constant/size/app_size.dart';
import 'package:flutter/widgets.dart';

class AppSizeScreen {
  AppSizeScreen._();

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double card(BuildContext context) {
    return width(context) / 2 - AppSize.large * 3;
  }
}
