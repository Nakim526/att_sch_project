import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/academic-year/models/academic_year_model.dart';
import 'package:att_school/features/school/master/academic-year/read/detail/provider/read_academic_year_detail_provider.dart';
import 'package:att_school/features/school/master/semester/models/semester_model.dart';
import 'package:att_school/features/school/master/semester/read/data/read_semester_service.dart';
import 'package:att_school/features/school/public/provider/school_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadSemesterActiveProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadSemesterService service;
  final SchoolProvider school;
  final ReadAcademicYearDetailProvider provider;
  AcademicYearModel? _academicYear;
  SemesterModel? _semester;
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';
  String? _id;

  ReadSemesterActiveProvider(this.service, this.school, this.provider);

  SemesterModel? get data => _semester;

  AcademicYearModel? get academicYear => _academicYear;

  bool get isLoading => _isLoading;

  String get error => _error;

  @override
  void dispose() {
    _disposed = true;
    _cancelToken.cancel('Page disposed');
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  Future<SemesterModel?> fetchActive() async {
    _isLoading = true;
    _semester = null;
    _error = '';
    notifyListeners();

    try {
      await provider.fetchActive();

      _id = provider.data?.id;

      if (_id == null) {
        _error = 'Tahun Ajaran aktif tidak ditemukan.';
        return null;
      }

      final response = await service.readSemesterActive(_id!, _cancelToken);

      final data = SemesterModel.fromJson(response.data['data']);

      if (data == null) {
        _error = 'Semester aktif tidak ditemukan.';
        return null;
      }

      _semester = data;
      _academicYear = provider.data;
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Semester').toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _semester;
  }

  void clearError() => _error = '';
}
