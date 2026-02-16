import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/has-access/read/list/provider/read_has_access_list_provider.dart';
import 'package:att_school/features/admin/teacher/read/data/read_teacher_service.dart';
import 'package:flutter/material.dart';

class ReadTeacherListProvider extends ChangeNotifier {
  final ReadTeacherService service;
  final ReadHasAccessListProvider provider;
  List<String> _emails = [];
  List<Map<String, dynamic>> _teachers = [];
  bool _isLoading = false;
  String _error = '';

  ReadTeacherListProvider(this.service, this.provider) {
    _fetch();
  }

  List<Map<String, dynamic>> get teachers => _teachers;

  List<String> get emails => _emails;

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<BackendMessageHelper> fetchAllEmails() async {
    _isLoading = true;
    notifyListeners();

    try {
      _emails = [];
      await provider.reload();

      for (final user in provider.hasAccess) {
        _emails.add(user['email'].toString());
      }

      return BackendMessageHelper(true);
    } catch (e) {
      debugPrint(e.toString());
      return BackendMessageHelper(false, message: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<BackendMessageHelper> _fetch() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Map<String, dynamic>> teachers = [];
      final response = await service.readTeacherList();

      final result = response.data['data'] as List;

      for (final item in result) {
        teachers.add({
          'id': item['id'],
          'nip': item['nip'],
          'name': item['user']['name'],
          'email': item['user']['email'],
          'isActive': item['isActive'] as bool,
        });
      }

      _teachers = teachers;

      return BackendMessageHelper(true);
    } catch (e) {
      _error = e.toString();
      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() => _error = '';

  void reload() => _fetch();

  Future<void> search(String query) async {
    await _fetch();
    _isLoading = true;
    notifyListeners();
    _teachers =
        _teachers.where((e) {
          return e['name'].toString().toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList();
    _isLoading = false;
    notifyListeners();
  }
}
