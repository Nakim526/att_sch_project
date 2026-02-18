import 'package:att_school/core/utils/formatter/backend_formatter.dart';
import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/academic-year/read/detail/provider/read_academic_year_detail_provider.dart';
import 'package:att_school/features/admin/semester/models/semester_model.dart';
import 'package:att_school/features/admin/semester/read/data/read_semester_service.dart';
import 'package:att_school/features/school/provider/school_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadSemesterDetailProvider extends ChangeNotifier {
  final ReadSemesterService service;
  final SchoolProvider school;
  final ReadAcademicYearDetailProvider academicYear;
  SemesterModel? _semester;
  bool _isLoading = false;
  String _error = '';
  String? _id;

  ReadSemesterDetailProvider(this.service, this.school, this.academicYear);

  SemesterModel? get semester => _semester;

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<BackendMessageHelper> fetchById(String id) async {
    _id = id;
    _error = '';
    _semester = null;
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {};
      final response = await service.readSemesterDetail(id);
      final schoolName = await school.getName();

      data = response.data['data'];

      debugPrint(data.toString());

      data['school'] = schoolName;

      _semester = SemesterModel.fromJson(data);

      return BackendMessageHelper(true, data: _semester);
    } on DioException catch (e) {
      if (e.response?.statusCode != null) {
        String message = e.response?.data['message'];
        message = BackendFormatter.isNotFound(message);

        _error = "${e.response?.statusCode} - $message";
      } else {
        _error = e.message.toString();
      }

      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() => _error = '';

  Future<void> reload() => fetchById(_id!);
}
