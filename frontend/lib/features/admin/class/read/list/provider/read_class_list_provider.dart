import 'package:att_school/features/admin/class/read/data/read_class_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadClassListProvider extends ChangeNotifier {
  final ReadClassService service;
  List<Map<String, dynamic>> _classes = [];
  bool _isLoading = false;
  String _error = '';

  ReadClassListProvider(this.service) {
    _fetch();
  }

  List<Map<String, dynamic>> get classes => _classes;

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<void> _fetch() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await service.readClassList();
      _classes = (response.data['data'] as List).cast<Map<String, dynamic>>();
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

  void reload() => _fetch();

  void clearError() => _error = '';
}
