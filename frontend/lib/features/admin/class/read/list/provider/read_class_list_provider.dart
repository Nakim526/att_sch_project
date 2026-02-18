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
      if (e.response?.statusCode == null) {
        _error = e.message.toString();
      } else {
        _error = "${e.response?.statusCode} - ${e.response?.data['message']}";
      }
      
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
