import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/admin/school/read/data/read_school_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadSchoolListProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadSchoolService service;
  List<Map<String, dynamic>> _school = [];
  bool _diposed = false;
  bool _isLoading = false;
  String _error = '';

  ReadSchoolListProvider(this.service);

  List<Map<String, dynamic>> get data => _school;

  bool get isLoading => _isLoading;

  String get error => _error;

  @override
  void dispose() {
    _diposed = true;
    _cancelToken.cancel('Page disposed');
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_diposed) super.notifyListeners();
  }

  Future<BackendMessageHelper> _fetch() async {
    _school = [];
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await service.readAllSchool(_cancelToken);

      _school = (response.data['data'] as List).cast<Map<String, dynamic>>();

      return BackendMessageHelper(true);
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Sekolah').toString();

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reload() => _fetch();

  void clearError() => _error = '';

  Future<void> search(String query) async {
    await _fetch();
    _isLoading = true;
    notifyListeners();

    _school =
        _school.where((e) {
          return e['name'].toString().toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList();

    _isLoading = false;
    notifyListeners();
  }
}
