import 'package:att_school/features/admin/student/create/provider/create_student_provider.dart';
import 'package:att_school/features/admin/student/student_form_screen.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateStudentScreen extends StatelessWidget {
  const CreateStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateStudentProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            StudentFormScreen(
              'Create Student',
              onSubmit: (data) async {
                return await provider.createStudent(data);
              },
            ),
            if (provider.isLoading) AppLoading(),
          ],
        );
      },
    );
  }
}
