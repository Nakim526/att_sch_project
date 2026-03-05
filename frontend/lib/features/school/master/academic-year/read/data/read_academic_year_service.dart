import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class ReadAcademicYearService {
  final Dio dio;

  ReadAcademicYearService(this.dio);

  Future<Response> readAcademicYearList(CancelToken? cancelToken) async {
    return await dio.get(AppString.academicYearUrl, cancelToken: cancelToken);
  }

  Future<Response> readAcademicYearActive(CancelToken? cancelToken) async {
    return await dio.get(
      "${AppString.academicYearUrl}/active",
      cancelToken: cancelToken,
    );
  }

  Future<Response> readAcademicYearDetail(
    String id,
    CancelToken? cancelToken,
  ) async {
    return await dio.get(
      "${AppString.academicYearUrl}/$id",
      cancelToken: cancelToken,
    );
  }
}
