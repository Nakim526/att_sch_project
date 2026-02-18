import 'package:att_school/features/admin/academic-year/models/academic_year_model.dart';
import 'package:att_school/features/admin/academic-year/read/data/read_academic_year_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadAcademicYearListProvider extends ChangeNotifier {
  final ReadAcademicYearService service;
  List<Map<String, dynamic>> _academicYears = [];
  bool _isLoading = false;
  String _error = '';

  ReadAcademicYearListProvider(this.service) {
    _fetch();
  }

  List<Map<String, dynamic>> get academicYears => _academicYears;

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<void> _fetch() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      List<Map<String, dynamic>> result = [];
      final response = await service.readAcademicYearList();

      for (final item in response.data['data']) {
        final data = AcademicYearModel.fromJson(item);
        result.add(data!.toMap());
      }

      _academicYears = result;
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

    _academicYears =
        _academicYears.where((e) {
          return e['name'].toString().toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList();
    _isLoading = false;
    notifyListeners();
  }
}
