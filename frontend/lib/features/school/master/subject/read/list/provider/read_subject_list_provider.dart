import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/subject/read/data/read_subject_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadSubjectListProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadSubjectService service;
  List<Map<String, dynamic>> _subjects = [];
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  ReadSubjectListProvider(this.service) {
    _fetch();
  }

  List<Map<String, dynamic>> get data => _subjects;

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
      final response = await service.readSubjectList(_cancelToken);
      _subjects = (response.data['data'] as List).cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Mata Pelajaran').toString();

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

    _subjects =
        _subjects.where((e) {
          return e['name'].toString().toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList();
    _isLoading = false;
    notifyListeners();
  }
}
