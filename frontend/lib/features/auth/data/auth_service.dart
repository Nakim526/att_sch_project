import 'package:att_school/core/config/google_sign_in_service.dart';
import 'package:att_school/core/constant/string/app_string.dart';
import 'package:att_school/core/utils/auth/auth_manager.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio dio;

  AuthService(this.dio);

  Future<Response> login() async {
    try {
      final credential = await GoogleSignInService.login();
      if (credential != null) {
        final response = await dio.post(
          AppString.loginUrl,
          data: {"idToken": credential},
        );

        if (response.statusCode == 200) {
          AuthManager.setCredential(response.data['token']);
          return response;
        }
      }

      throw Exception('Login failed');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw 'Network error, please check your internet connection';
      } else if (e.type == DioExceptionType.connectionError) {
        throw 'Server error, please check your hostname and port';
      } else if (e.type == DioExceptionType.badResponse) {
        throw '${e.response?.statusCode} - ${e.response?.statusMessage}';
      }

      throw e.message.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    await GoogleSignInService.logout();
    AuthManager.clear();
  }
}
