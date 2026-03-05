import 'package:att_school/core/config/google_sign_in_service.dart';
import 'package:att_school/core/constant/string/app_string.dart';
import 'package:att_school/core/utils/auth/auth_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

class AuthService {
  final Dio dio;

  AuthService(this.dio);

  Future<Response> login(String schoolName, CancelToken? cancelToken) async {
    final credential = await GoogleSignInService.login();

    if (credential.status) {
      final response = await dio.post(
        AppString.loginUrl,
        data: {"idToken": credential.data, "schoolName": schoolName},
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200) {
        AuthManager.setCredential(response.data['token']);
        return response;
      }

      return response;
    }

    return Response(
      requestOptions: RequestOptions(),
      statusCode: 401,
      statusMessage: credential.message,
    );
  }

  Future<void> logout() async {
    await GoogleSignInService.logout();
    AuthManager.clear();
  }
}
