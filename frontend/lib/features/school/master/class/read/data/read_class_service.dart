import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class ReadClassService {
  final Dio dio;

  ReadClassService(this.dio);

  Future<Response> readClassList(CancelToken? cancelToken) async {
    return await dio.get(AppString.classUrl, cancelToken: cancelToken);
  }

  Future<Response> readClassListByTeacher(CancelToken? cancelToken) async {
    return await dio.get(
      '${AppString.classUrl}/teacher',
      cancelToken: cancelToken,
    );
  }

  Future<Response> readClassDetail(String id, CancelToken? cancelToken) async {
    return await dio.get("${AppString.classUrl}/$id", cancelToken: cancelToken);
  }
}
