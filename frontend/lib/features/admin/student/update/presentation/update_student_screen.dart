import 'package:att_school/features/admin/student/read/detail/provider/read_student_detail_provider.dart';
import 'package:att_school/features/admin/student/student_form_screen.dart';
import 'package:att_school/features/admin/student/update/provider/update_student_provider.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateStudentScreen extends StatelessWidget {
  final String id;
  const UpdateStudentScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<ReadStudentDetailProvider>();

    return Consumer<UpdateStudentProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            StudentFormScreen(
              'Update Student',
              onSubmit: (data) async => await provider.updateStudent(data),
              id: id,
              editData: detail.student,
            ),
            if (provider.isLoading ||
                detail.student == null ||
                detail.isLoading)
              AppLoading(),
          ],
        );
      },
    );
  }
}
