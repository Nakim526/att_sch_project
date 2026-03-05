import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class CreateUserService {
  final Dio dio;

  CreateUserService(this.dio);

  Future<Response> createUser(
    Map<String, dynamic> data,
    CancelToken? cancelToken,
  ) async {
    return await dio.post(
      AppString.userUrl,
      data: data,
      cancelToken: cancelToken,
    );
  }
}
