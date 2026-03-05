import 'package:att_school/core/constant/item/app_items.dart';

class GradeFormatter {
  const GradeFormatter._();

  static int? toInt(String? roman) {
    return AppItems.gradesMap[roman];
  }

  static String toRoman(int? grade) {
    return AppItems.gradesMap.entries.firstWhere((e) => e.value == grade).key;
  }
}
