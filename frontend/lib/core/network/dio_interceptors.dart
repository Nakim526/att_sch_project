import 'package:att_school/core/utils/auth/auth_manager.dart';
import 'package:dio/dio.dart';

void setupDioInterceptor(Dio dio) {
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = AuthManager.idToken;
        if (token != null) {
          options.headers['Authorization'] = "Bearer $token";
        }
        return handler.next(options);
      },
    ),
  );
}
