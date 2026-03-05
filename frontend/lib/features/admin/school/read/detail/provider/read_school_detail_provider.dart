import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/admin/school/models/school_model.dart';
import 'package:att_school/features/admin/school/read/data/read_school_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadSchoolDetailProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadSchoolService service;
  SchoolModel? _school;
  bool _isLoading = false;
  bool _isReady = false;
  bool _disposed = false;
  String _error = '';
  String? _id;

  ReadSchoolDetailProvider(this.service);

  SchoolModel? get data => _school;

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
    return _school?.name ?? '';
  }

  Future<BackendMessageHelper> fetchById(String id) async {
    _id = id;
    _error = '';
    _school = null;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.readSchoolById(id, _cancelToken);

      _school = SchoolModel.fromJson(response.data['data']);

      return BackendMessageHelper(true, data: _school);
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Sekolah').toString();

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() => _error = '';

  Future<void> reload() => fetchById(_id!);
}
