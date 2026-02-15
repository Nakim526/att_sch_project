import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class DeleteClassService {
  final Dio dio;

  DeleteClassService(this.dio);

  Future<Response> deleteClass(String id) async {
    return await dio.delete('${AppString.classUrl}/$id');
  }
}
