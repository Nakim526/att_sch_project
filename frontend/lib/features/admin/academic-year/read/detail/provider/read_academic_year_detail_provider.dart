import 'package:att_school/core/utils/formatter/backend_formatter.dart';
import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/academic-year/models/academic_year_model.dart';
import 'package:att_school/features/admin/academic-year/read/data/read_academic_year_service.dart';
import 'package:att_school/features/school/provider/school_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadAcademicYearDetailProvider extends ChangeNotifier {
  final ReadAcademicYearService service;
  final SchoolProvider provider;
  AcademicYearModel? _academicYear;
  bool _isLoading = false;
  String _error = '';
  String? _id;

  ReadAcademicYearDetailProvider(this.service, this.provider);

  AcademicYearModel? get academicYear => _academicYear;

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<String> getName(String id) async {
    debugPrint(id);
    await fetchById(id);
    return _academicYear?.name ?? '';
  }

  Future<BackendMessageHelper> fetchById(String id) async {
    _id = id;
    _error = '';
    _academicYear = null;
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {};
      final response = await service.readAcademicYearDetail(id);
      final school = await provider.getName();

      data = response.data['data'];
      data['school'] = school;

      _academicYear = AcademicYearModel.fromJson(data);

      return BackendMessageHelper(true, data: _academicYear);
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
