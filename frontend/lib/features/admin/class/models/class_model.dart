class ClassModel {
  final String? id;
  final String name;
  final int grade;
  final String? schoolId;
  final String? school;

  ClassModel({
    this.id,
    required this.name,
    required this.grade,
    this.schoolId,
    this.school,
  });

  static ClassModel? fromJson(Map<String, dynamic> json) {
    if (json['name'] == null || json['gradeLevel'] == null) return null;

    return ClassModel(
      id: json['id'],
      name: json['name'],
      grade: json['gradeLevel'],
      schoolId: json['schoolId'],
      school: json['school'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'gradeLevel': grade,
    };
  }

}
