import 'package:flutter/material.dart';

class ValidatorHelper {
  static void text({required bool hasError, required VoidCallback clearError}) {
    if (hasError) clearError();
  }

  static void dropdown<T>({
    required T? value,
    required void Function(T?) assignValue,
    required VoidCallback clearError,
  }) {
    assignValue(value);
    clearError();
  }

  static bool validate(
    List<dynamic> fields, {
    required VoidCallback clearError,
  }) {
    clearError();

    for (final field in fields) {
      if (field is String || field is List || field is Map) {
        return field.isNotEmpty;
      }
      return field != null;
    }

    return true;
  }
}
