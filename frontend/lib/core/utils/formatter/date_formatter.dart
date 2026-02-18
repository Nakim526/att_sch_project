import 'package:intl/intl.dart';

class DateFormatter {
  const DateFormatter._();

  static DateTime normalize(DateTime d) => DateTime(d.year, d.month, d.day, 12);

  static DateTime fromJson(String date) => DateTime.parse(date);

  static String toJson(DateTime date) {
    return normalize(date).toUtc().toIso8601String();
  }

  static String toController(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static DateTime fromController(String date) {
    return DateFormat('dd/MM/yyyy').parse(date);
  }

  static String toView(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }
}
