import 'package:att_school/features/roles/data/roles_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final List<RolesModel> roles;
  final bool isActive;
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.isActive,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      roles: json['roles'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'roles': roles,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }
}
