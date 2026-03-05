import 'package:att_school/core/utils/formatter/backend_formatter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ErrorExceptionHelper {
  final DioException error;
  final String? type;

  ErrorExceptionHelper(this.error, this.type);

  @override
  String toString() {
    final errorMessage = switch (error.type) {
      DioExceptionType.badResponse => _message,
      DioExceptionType.cancel => '525 - Request Canceled',
      DioExceptionType.connectionError => '500 - Internal Server Error',
      DioExceptionType.connectionTimeout => '522 - Connection Timeout',
      DioExceptionType.receiveTimeout => '504 - Gateway Timeout',
      DioExceptionType.sendTimeout => '521 - Send Timeout',
      _ => _message,
    };

    debugPrint(errorMessage);

    return errorMessage;
  }

  String get _message {
    String message = error.response?.data['message'] ?? 'Unknown Error';
    message = BackendFormatter.isNotFound(message, type);

    return message;
  }
}
