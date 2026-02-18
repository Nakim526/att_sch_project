import 'package:att_school/core/utils/extensions/string_extension.dart';

class RolesModel {
  final String? role;

  RolesModel({this.role});

  factory RolesModel.fromJson(Map<String, dynamic> json) {
    return RolesModel(role: json['name'].toString().capitalizeEachWord());
  }

  static List<RolesModel> fromListJson(List<dynamic> json) {
    return json.map((e) {
      return RolesModel.fromJson(e['role']);
    }).toList();
  }

  static List<String> toList(List<RolesModel> roles) {
    return roles.map((e) => e.role as String).toList();
  }

  Map<String, String> toMap() => {'id': role!.toLowerCase(), 'name': role!};
}
