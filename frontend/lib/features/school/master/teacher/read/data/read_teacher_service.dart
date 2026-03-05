import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class ReadTeacherService {
  final Dio dio;

  ReadTeacherService(this.dio);

  Future<Response> readTeacherList(CancelToken? cancelToken) async {
    return await dio.get(AppString.teacherUrl, cancelToken: cancelToken);
  }

  Future<Response> readTeacherDetail(
    String id,
    CancelToken? cancelToken,
  ) async {
    return await dio.get(
      '${AppString.teacherUrl}/$id',
      cancelToken: cancelToken,
    );
  }
}
