import 'package:att_school/core/utils/extensions/string_extension.dart';

class RolesModel {
  final String role;
  final int? count;
  final bool? admin;
  final bool? teacher;
  final bool? principal;
  final bool? operator;

  RolesModel(
    this.role, {
    this.count,
    this.admin,
    this.teacher,
    this.principal,
    this.operator,
  });

  bool get isTeacher => (teacher ?? false) && (count ?? 0) == 1;

  bool get andTeacher => (teacher ?? false) && (count ?? 0) > 1;

  bool get isOperator => operator ?? false;

  bool get isPrincipal => principal ?? false;

  bool get isAdmin => admin ?? false;

  factory RolesModel.fromJson(Map<String, dynamic> json) {
    return RolesModel(json['name'].toString().capitalizeEachWord());
  }

  static List<RolesModel> jsonToList(List<dynamic> json) {
    return json.map((e) {
      return RolesModel.fromJson(e['role']);
    }).toList();
  }

  List<String> toList() {
    final clean = role.substring(1, role.length - 1).replaceAll(' ', '');
    return clean.split(',').toList();
  }

  List<String> toListString() {
    List<String> result = [];

    if (admin ?? false) result.add('ADMIN');
    if (principal ?? false) result.add('KEPSEK');
    if (operator ?? false) result.add('OPERATOR');
    if (teacher ?? false) result.add('GURU');

    return result;
  }

  String toStringList() {
    List<String> result = [];

    if (admin ?? false) result.add('ADMIN');
    if (principal ?? false) result.add('KEPSEK');
    if (operator ?? false) result.add('OPERATOR');
    if (teacher ?? false) result.add('GURU');

    return '[${result.map((e) => e).join(', ')}]';
  }

  @override
  String toString() => role.toString().capitalizeEachWord();

  String toJson() => role.toUpperCase();

  Map<String, String> toMap() => {'id': role.toLowerCase(), 'name': role};
}
