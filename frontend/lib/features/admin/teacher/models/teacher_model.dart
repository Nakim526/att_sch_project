class TeacherModel {
  final String? id;
  final String nip;
  final String name;
  final String email;
  final bool? isActive;
  final String? school;

  TeacherModel({
    this.id,
    required this.nip,
    required this.name,
    required this.email,
    this.isActive,
    this.school,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'],
      nip: json['nip'],
      name: json['user']['name'],
      email: json['user']['email'],
      isActive: json['isActive'],
      school: json['school'],
    );
  }

  Map<String, dynamic> toJson() => {
    'nip': nip,
    'name': name,
    'email': email,
  };
}
