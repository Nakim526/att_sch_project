enum AttendanceStatus {
  present, // Hadir
  sick, // Sakit
  permission, // Izin
  absent, // Alpa
  late, // Terlambat
}

class AttendanceModel {
  final String id;
  final String name;
  AttendanceStatus? status;

  AttendanceModel({required this.id, required this.name, this.status});
}
