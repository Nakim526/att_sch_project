import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class ReadSemesterService {
  final Dio dio;

  ReadSemesterService(this.dio);

  Future<Response> readSemesterList(CancelToken? cancelToken) async {
    return await dio.get(AppString.semesterUrl, cancelToken: cancelToken);
  }

  Future<Response> readSemesterAcademicYear(
    String id,
    CancelToken? cancelToken,
  ) async {
    return await dio.get(
      "${AppString.semesterUrl}/academic-year/$id",
      cancelToken: cancelToken,
    );
  }

  Future<Response> readSemesterActive(
    String id,
    CancelToken? cancelToken,
  ) async {
    return await dio.get(
      "${AppString.semesterUrl}/active/$id",
      cancelToken: cancelToken,
    );
  }

  Future<Response> readSemesterDetail(
    String id,
    CancelToken? cancelToken,
  ) async {
    return await dio.get(
      "${AppString.semesterUrl}/$id",
      cancelToken: cancelToken,
    );
  }
}
