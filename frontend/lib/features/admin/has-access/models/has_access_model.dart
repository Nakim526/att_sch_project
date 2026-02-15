import 'package:att_school/features/roles/data/roles_model.dart';

class HasAccessModel {
  final String? id;
  final String name;
  final String email;
  final List<RolesModel>? roles;
  final bool? isActive;

  HasAccessModel({
    this.id,
    required this.name,
    required this.email,
    this.roles,
    this.isActive,
  });

  factory HasAccessModel.fromJson(Map<String, dynamic> json) {
    return HasAccessModel(
      id: json['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      roles: RolesModel.fromListJson(json['user']['roles']),
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'roles': roles!.map((e) => e.role!.toUpperCase()).toList(),
  };
}
