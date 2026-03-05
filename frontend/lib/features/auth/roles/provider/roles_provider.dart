import 'package:att_school/features/auth/roles/data/roles_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RolesProvider extends ChangeNotifier {
  RolesProvider._();

  RolesProvider() : this._();

  static RolesModel me = RolesModel('');

  bool get isTeacher => me.isTeacher;

  bool get isOperator => me.isOperator;

  bool get isPrincipal => me.isPrincipal;

  bool get isAdmin => me.isAdmin;

  static Future<bool> setRoles(List<dynamic>? roles) async {
    final prefs = await SharedPreferences.getInstance();

    if (roles == null) return false;

    me = RolesModel(
      roles.toString().toUpperCase(),
      count: roles.length,
      teacher: roles.contains('GURU'),
      operator: roles.contains('OPERATOR'),
      principal: roles.contains('KEPSEK'),
      admin: roles.contains('ADMIN'),
    );

    await prefs.setString('roles', roles.toString().toUpperCase());

    return true;
  }
}
