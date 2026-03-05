import 'package:flutter/material.dart';

class TimeFormatter {
  /// Normalize string menjadi TimeOfDay yang valid
  static TimeOfDay normalize(String input) {
    if (input.trim().isEmpty) {
      return const TimeOfDay(hour: 0, minute: 0);
    }

    // Ambil hanya angka
    final digits = input.replaceAll(RegExp(r'[^0-9]'), '');

    int hour = 0;
    int minute = 0;

    if (digits.length <= 2) {
      // "8" → 08:00
      hour = int.parse(digits);
    } else if (digits.length == 3) {
      // "830" → 08:30
      hour = int.parse(digits.substring(0, 1));
      minute = int.parse(digits.substring(1));
    } else {
      // "1234", "9999", dll
      hour = int.parse(digits.substring(0, 2));
      minute = int.parse(digits.substring(2, 4));
    }

    // Normalisasi overflow
    hour = hour % 24;
    minute = minute % 60;

    return TimeOfDay(hour: hour, minute: minute);
  }

  /// Format TimeOfDay menjadi 'hh:mm'
  static String format(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Shortcut: input string → 'hh:mm'
  static String normalizeToString(String input) {
    return format(normalize(input));
  }
}