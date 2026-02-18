import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class DeleteAcademicYearService {
  final Dio dio;

  DeleteAcademicYearService(this.dio);

  Future<Response> deleteAcademicYear(String id) async {
    return await dio.delete('${AppString.academicYearUrl}/$id');
  }
}
