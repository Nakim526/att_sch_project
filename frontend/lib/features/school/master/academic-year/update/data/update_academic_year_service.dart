import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class UpdateAcademicYearService {
  final Dio dio;

  UpdateAcademicYearService(this.dio);

  Future<Response> updateAcademicYear(
    String id, {
    required Map<String, dynamic> payload,
    CancelToken? cancelToken,
  }) async {
    return await dio.put(
      '${AppString.academicYearUrl}/$id',
      data: payload,
      cancelToken: cancelToken,
    );
  }
}
