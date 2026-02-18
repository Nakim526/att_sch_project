import 'package:att_school/features/admin/teacher/read/detail/provider/read_teacher_detail_provider.dart';
import 'package:att_school/features/admin/teacher/teacher_form_screen.dart';
import 'package:att_school/features/admin/teacher/update/provider/update_teacher_provider.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateTeacherScreen extends StatelessWidget {
  final String id;
  const UpdateTeacherScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<ReadTeacherDetailProvider>();

    return Consumer<UpdateTeacherProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            TeacherFormScreen(
              'Update Teacher',
              onSubmit: (data) async => await provider.updateTeacher(data),
              id: id,
              editData: detail.teacher,
            ),
            if (provider.isLoading ||
                detail.teacher == null ||
                detail.isLoading)
              AppLoading(),
          ],
        );
      },
    );
  }
}
