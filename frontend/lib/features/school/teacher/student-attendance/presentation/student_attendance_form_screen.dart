import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:flutter/material.dart';

class StudentAttendanceFormScreen extends StatefulWidget {
  const StudentAttendanceFormScreen({super.key});

  @override
  State<StudentAttendanceFormScreen> createState() =>
      _StudentAttendanceFormScreenState();
}

class _StudentAttendanceFormScreenState
    extends State<StudentAttendanceFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppScreen(children: []),
      ],
    );
  }
}
