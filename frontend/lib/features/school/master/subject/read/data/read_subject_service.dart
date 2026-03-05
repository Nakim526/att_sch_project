import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class ReadSubjectService {
  final Dio dio;

  ReadSubjectService(this.dio);

  Future<Response> readSubjectList(CancelToken? cancelToken) async {
    return await dio.get(AppString.subjectUrl, cancelToken: cancelToken);
  }

  Future<Response> readSubjectDetail(
    String id,
    CancelToken? cancelToken,
  ) async {
    return await dio.get(
      "${AppString.subjectUrl}/$id",
      cancelToken: cancelToken,
    );
  }
}
