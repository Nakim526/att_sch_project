import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_active_provider.dart';
import 'package:att_school/features/school/master/teacher/create/provider/create_teacher_provider.dart';
import 'package:att_school/features/school/master/teacher/read/detail/provider/read_teacher_detail_provider.dart';
import 'package:att_school/features/school/master/teacher/teacher_form_screen.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateTeacherScreen extends StatelessWidget {
  const CreateTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final semester = context.watch<ReadSemesterActiveProvider>();
    final detail = context.watch<ReadTeacherDetailProvider>();

    return Consumer<CreateTeacherProvider>(
      builder: (context, provider, _) {
        // 🔥 SIDE-EFFECT: dialog
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (semester.error.isNotEmpty) {
            AppDialog.show(context, title: 'Error', message: semester.error);

            // penting: reset error
            semester.clearError();
          }
        });

        return Stack(
          children: [
            TeacherFormScreen(
              'Create Teacher',
              onSubmit: (data) async => await provider.createTeacher(data),
            ),
            if (provider.isLoading || !detail.isReady) AppLoading(),
          ],
        );
      },
    );
  }
}
