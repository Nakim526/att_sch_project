import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/academic-year/models/academic_year_model.dart';
import 'package:att_school/features/school/master/academic-year/read/data/read_academic_year_service.dart';
import 'package:att_school/features/school/public/provider/school_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadAcademicYearDetailProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadAcademicYearService service;
  final SchoolProvider school;
  AcademicYearModel? _academicYear;
  bool _isLoading = false;
  bool _disposed = false;
  bool _isReady = false;
  String _error = '';
  String? _id;

  ReadAcademicYearDetailProvider(this.service, this.school);

  AcademicYearModel? get data => _academicYear;

  bool get isLoading => _isLoading;

  String get error => _error;

  bool get isReady => _isReady;

  set ready(bool value) {
    _isReady = value;
    notifyListeners();
  }

  set error(String value) {
    _error = value;
    notifyListeners();
  }

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
      final response = await service.readAcademicYearDetail(id, _cancelToken);
      await school.getName();

      data = response.data['data'];
      data['school'] = school.name;

      _academicYear = AcademicYearModel.fromJson(data);

      return BackendMessageHelper(true, data: _academicYear);
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Tahun Ajaran').toString();

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AcademicYearModel?> fetchActive() async {
    _isLoading = true;
    _academicYear = null;
    _error = '';
    notifyListeners();

    try {
      final response = await service.readAcademicYearActive(_cancelToken);
      final data = AcademicYearModel.fromJson(response.data['data']);

      _academicYear = data;
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Tahun Ajaran').toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _academicYear;
  }

  void clearError() => _error = '';

  Future<void> reload() => fetchById(_id!);
}
