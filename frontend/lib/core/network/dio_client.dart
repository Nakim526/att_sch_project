import 'package:dio/dio.dart';
import 'package:att_school/core/constant/string/app_string.dart';

class DioClient {
  DioClient._();

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppString.baseUrl,
      headers: {'Accept': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Dio get instance => _dio;
}
