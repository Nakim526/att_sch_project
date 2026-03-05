import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class ReadUserService {
  final Dio dio;

  ReadUserService(this.dio);

  Future<Response> readUserList(CancelToken? cancelToken) async {
    return await dio.get(AppString.userUrl, cancelToken: cancelToken);
  }

  Future<Response> readUserDetail(String id, CancelToken? cancelToken) async {
    return await dio.get('${AppString.userUrl}/$id', cancelToken: cancelToken);
  }
}
