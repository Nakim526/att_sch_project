import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class DeleteUserService {
  final Dio dio;

  DeleteUserService(this.dio);

  Future<Response> deleteUser(String id, CancelToken? cancelToken) async {
    return await dio.delete(
      '${AppString.userUrl}/$id',
      cancelToken: cancelToken,
    );
  }
}
