import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/student/models/student_model.dart';
import 'package:att_school/features/school/master/student/read/data/read_student_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadStudentListProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadStudentService service;
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  ReadStudentListProvider(this.service) {
    _fetch();
  }

  List<Map<String, dynamic>> get data => _students;

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

  Future<void> _fetch() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      List<Map<String, dynamic>> result = [];
      final response = await service.readStudentList(_cancelToken);

      for (final item in response.data['data']) {
        final data = StudentModel.fromJson(item);
        result.add(data.toMap());
      }

      _students = result;
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Siswa').toString();

      debugPrint(_error);
    } catch (e) {
      debugPrint(e.toString());
      _error = e.toString();
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

    _students =
        _students.where((e) {
          return e['name'].toString().toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList();
    _isLoading = false;
    notifyListeners();
  }
}
