import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class CreateClassService {
  final Dio dio;

  CreateClassService(this.dio);

  Future<Response> createClass(Map<String, dynamic> data) async {
    return await dio.post(AppString.classUrl, data: data);
  }
}
