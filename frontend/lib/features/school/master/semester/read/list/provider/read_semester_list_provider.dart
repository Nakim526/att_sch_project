import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/academic-year/read/list/provider/read_academic_year_list_provider.dart';
import 'package:att_school/features/school/master/semester/models/semester_model.dart';
import 'package:att_school/features/school/master/semester/read/data/read_semester_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadSemesterListProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadSemesterService service;
  final ReadAcademicYearListProvider provider;
  List<Map<String, dynamic>> _semesters = [];
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  ReadSemesterListProvider(this.service, this.provider) {
    _fetch();
  }

  List<Map<String, dynamic>> get data => _semesters;

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
      final response = await service.readSemesterList(_cancelToken);

      for (final item in response.data['data']) {
        final data = SemesterModel.fromJson(item);
        if (data != null) {
          result.add(data.toMap());
        }
      }

      _semesters = result;
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Semester').toString();

      debugPrint(_error);
    } catch (e) {
      debugPrint(e.toString());
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchByAcademicYear(String id) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      List<Map<String, dynamic>> result = [];
      final response = await service.readSemesterAcademicYear(id, _cancelToken);

      for (final item in response.data['data']) {
        final data = SemesterModel.fromJson(item);
        if (data != null) {
          result.add(data.toMap());
        }
      }

      _semesters = result;
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Semester').toString();

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

    _semesters =
        _semesters.where((e) {
          return e['name'].toString().toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList();
    _isLoading = false;
    notifyListeners();
  }
}
