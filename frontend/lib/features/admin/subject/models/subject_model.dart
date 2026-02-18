class SubjectModel {
  final String? id;
  final String name;
  final String? code;
  final String? schoolId;
  final String? school;

  SubjectModel({
    this.id,
    required this.name,
    this.code,
    this.schoolId,
    this.school,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      schoolId: json['schoolId'],
      school: json['school'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name, 'code': code};
  }
}
