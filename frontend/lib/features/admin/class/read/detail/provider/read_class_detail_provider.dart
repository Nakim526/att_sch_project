import 'package:att_school/features/admin/class/models/class_model.dart';
import 'package:att_school/features/admin/class/read/data/read_class_service.dart';
import 'package:att_school/features/school/provider/school_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadClassDetailProvider extends ChangeNotifier {
  final ReadClassService service;
  final SchoolProvider provider;
  ClassModel? _class;
  bool _isLoading = false;
  String _error = '';
  String _id = '';

  ReadClassDetailProvider(this.service, this.provider);

  ClassModel? get class_ => _class;

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<void> fetchById(String id) async {
    _id = id;
    _error = '';
    _class = null;
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {};
      final response = await service.readClassById(id);
      final school = await provider.getSchoolName();

      if (response.data != null) {
        data = response.data['data'];
        data['school'] = school;

        _class = ClassModel.fromJson(data);
      }
    } on DioException catch (e) {
      debugPrint(e.toString());
      _error = "${e.response?.statusCode} - ${e.response?.statusMessage}";
    } catch (e) {
      debugPrint(e.toString());
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reload() => fetchById(_id);
}
