import 'package:att_school/features/admin/student/models/student_model.dart';
import 'package:att_school/features/admin/student/read/data/read_student_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadStudentListProvider extends ChangeNotifier {
  final ReadStudentService service;
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = false;
  String _error = '';

  ReadStudentListProvider(this.service) {
    _fetch();
  }

  List<Map<String, dynamic>> get students => _students;

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<void> _fetch() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      List<Map<String, dynamic>> result = [];
      final response = await service.readStudentList();

      for (final item in response.data['data']) {
        final data = StudentModel.fromJson(item);
        result.add(data.toMap());
      }

      _students = result;
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
