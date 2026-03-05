class SchoolModel {
  final String? id;
  final String name;
  final String? address;
  final String? phone;
  final String? email;
  final String principalName;
  final String principalEmail;

  SchoolModel({
    this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    required this.principalName,
    required this.principalEmail,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: json['school']['id'],
      name: json['school']['name'],
      address: json['school']['address'],
      phone: json['school']['phone'],
      email: json['school']['email'],
      principalName: json['principal']['name'],
      principalEmail: json['principal']['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'principalName': principalName,
      'principalEmail': principalEmail,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'principalName': principalName,
      'principalEmail': principalEmail,
    };
  }
}
