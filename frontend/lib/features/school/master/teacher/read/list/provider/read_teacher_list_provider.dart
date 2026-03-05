import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/user/read/list/provider/read_user_list_provider.dart';
import 'package:att_school/features/school/master/teacher/models/teacher_model.dart';
import 'package:att_school/features/school/master/teacher/read/data/read_teacher_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadTeacherListProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadTeacherService service;
  final ReadUserListProvider provider;
  List<Map<String, dynamic>> _teachers = [];
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  ReadTeacherListProvider(this.service, this.provider) {
    _fetch();
  }

  List<Map<String, dynamic>> get data => _teachers;

  String get error => _error;

  bool get isLoading => _isLoading;

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

  Future<void> _fetch() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Map<String, dynamic>> result = [];
      final response = await service.readTeacherList(_cancelToken);

      for (final item in response.data['data']) {
        final data = TeacherModel.fromJson(item);
        result.add(data.toMap());
      }

      _teachers = result;
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Guru').toString();

      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() => _error = '';

  Future<void> reload() => _fetch();

  Future<void> search(String query) async {
    await _fetch();
    _isLoading = true;
    notifyListeners();
    _teachers =
        _teachers.where((e) {
          return e['name'].toString().toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList();
    _isLoading = false;
    notifyListeners();
  }
}
