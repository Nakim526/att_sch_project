import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/academic-year/read/list/provider/read_academic_year_list_provider.dart';
import 'package:att_school/features/admin/semester/models/semester_model.dart';
import 'package:att_school/features/admin/semester/read/data/read_semester_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadSemesterListProvider extends ChangeNotifier {
  final ReadSemesterService service;
  final ReadAcademicYearListProvider provider;
  List<Map<String, dynamic>> _semesters = [];
  List<Map<String, dynamic>> _academicYears = [];
  bool _isLoading = false;
  String _error = '';

  ReadSemesterListProvider(this.service, this.provider) {
    _fetch();
  }

  List<Map<String, dynamic>> get semesters => _semesters;

  bool get isLoading => _isLoading;

  String get error => _error;

  List<Map<String, dynamic>> get academicYears => _academicYears;

  Future<BackendMessageHelper> fetchAllAcademicYears() async {
    _isLoading = true;
    notifyListeners();

    try {
      _academicYears = [];
      await provider.reload();

      for (final academicYear in provider.academicYears) {
        _academicYears.add({
          'id': academicYear['id'],
          'name': academicYear['name'],
        });
      }

      return BackendMessageHelper(true);
    } on DioException catch (e) {
      if (e.response?.statusCode == null) {
        _error = e.message.toString();
      } else {
        _error = "${e.response?.statusCode} - ${e.response?.data['message']}";
      }

      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetch() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      List<Map<String, dynamic>> result = [];
      final response = await service.readSemesterList();

      await fetchAllAcademicYears();

      for (final item in response.data['data']) {
        final data = SemesterModel.fromJson(item);
        result.add(data.toMap());
      }

      _semesters = result;
    } on DioException catch (e) {
      _error = "${e.response?.statusCode} - ${e.response?.statusMessage}";

      if (e.response?.statusCode == null) {
        debugPrint(e.message);
        _error = "${e.message}";
      }
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
