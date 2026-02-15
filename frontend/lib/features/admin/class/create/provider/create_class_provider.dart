import 'package:att_school/core/utils/helper/backend_helper.dart';
import 'package:att_school/features/admin/class/create/data/create_class_service.dart';
import 'package:att_school/features/admin/class/models/class_model.dart';
import 'package:flutter/material.dart';

class CreateClassProvider extends ChangeNotifier {
  final CreateClassService service;

  CreateClassProvider(this.service);

  Future<BackendHelper> createClass(ClassModel payload) async {
    try {
      final response = await service.createClass(payload.toJson());

      return BackendHelper(true, message: response.data['data']);
    } catch (e) {
      debugPrint(e.toString());
      return BackendHelper(false, message: e.toString());
    }
  }
}
