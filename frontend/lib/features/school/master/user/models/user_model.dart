import 'package:att_school/features/auth/roles/data/roles_model.dart';

class UserModel {
  final String? id;
  final String name;
  final String email;
  final List<RolesModel>? roles;
  final bool? isActive;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.roles,
    this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      roles: RolesModel.jsonToList(json['roles']),
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'roles': roles!.map((e) => e.toJson()).toList(),
  };

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'role': roles!.first.toString(),
      'isActive': isActive,
    };
  }
}
