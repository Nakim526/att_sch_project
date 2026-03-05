import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class UpdateUserService {
  final Dio dio;

  UpdateUserService(this.dio);

  Future<Response> updateUser(
    String id, {
    required Map<String, dynamic> payload,
    CancelToken? cancelToken,
  }) async {
    return await dio.put(
      '${AppString.userUrl}/$id',
      data: payload,
      cancelToken: cancelToken,
    );
  }
}
