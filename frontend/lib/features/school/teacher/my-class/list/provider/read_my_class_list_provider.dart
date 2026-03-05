import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/class/models/class_model.dart';
import 'package:att_school/features/school/master/class/read/data/read_class_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadMyClassListProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadClassService service;
  List<Map<String, dynamic>> _classes = [];
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  ReadMyClassListProvider(this.service) {
    _fetch();
  }

  List<Map<String, dynamic>> get data => _classes;

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
      Response<dynamic> response;
      List<Map<String, dynamic>> result = [];

      response = await service.readClassListByTeacher(_cancelToken);

      for (final data in response.data['data']['class_'] as List) {
        result.add({
          ...ClassModel.fromJson(data).toMap(),
          'teacherId': response.data['data']['teacherId'],
        });
      }

      _classes = result;
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Kelas').toString();
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

    _classes =
        _classes.where((e) {
          return e['name'].toString().toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList();
        
    _isLoading = false;
    notifyListeners();
  }
}
