import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/semester/models/semester_model.dart';
import 'package:att_school/features/school/master/semester/read/data/read_semester_service.dart';
import 'package:att_school/features/school/public/provider/school_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadSemesterDetailProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadSemesterService service;
  final SchoolProvider school;
  SemesterModel? _semester;
  bool _isLoading = false;
  bool _disposed = false;
  bool _isReady = false;
  String _error = '';
  String? _id;

  ReadSemesterDetailProvider(this.service, this.school);

  SemesterModel? get data => _semester;

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

  Future<BackendMessageHelper> fetchById(String id) async {
    _id = id;
    _error = '';
    _semester = null;
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {};
      final response = await service.readSemesterDetail(id, _cancelToken);
      await school.getName();

      data = response.data['data'];

      debugPrint(data.toString());

      data['school'] = school.name;

      _semester = SemesterModel.fromJson(data);

      return BackendMessageHelper(true, data: _semester);
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Semester').toString();

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() => _error = '';

  Future<void> reload() => fetchById(_id!);
}
