import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class ReadStudentService {
  final Dio dio;

  ReadStudentService(this.dio);

  Future<Response> readStudentList(CancelToken? cancelToken) async {
    return await dio.get(AppString.studentUrl, cancelToken: cancelToken);
  }

  Future<Response> readStudentDetail(
    String id,
    CancelToken? cancelToken,
  ) async {
    return await dio.get(
      "${AppString.studentUrl}/$id",
      cancelToken: cancelToken,
    );
  }
}
