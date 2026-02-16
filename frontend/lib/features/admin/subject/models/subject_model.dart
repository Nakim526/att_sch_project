class SubjectModel {
  final String? id;
  final String name;
  final String? schoolId;
  final String? school;

  SubjectModel({
    this.id,
    required this.name,
    this.schoolId,
    this.school,
  });

  static SubjectModel? fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      name: json['name'],
      schoolId: json['schoolId'],
      school: json['school'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
    };
  }

}
