import 'package:att_school/features/admin/subject/read/data/read_subject_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadSubjectListProvider extends ChangeNotifier {
  final ReadSubjectService service;
  List<Map<String, dynamic>> _subjects = [];
  bool _isLoading = false;
  String _error = '';

  ReadSubjectListProvider(this.service) {
    _fetch();
  }

  List<Map<String, dynamic>> get subjects => _subjects;

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<void> _fetch() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await service.readSubjectList();
      _subjects = (response.data['data'] as List).cast<Map<String, dynamic>>();
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
