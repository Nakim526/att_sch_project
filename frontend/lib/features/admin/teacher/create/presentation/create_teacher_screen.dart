import 'package:att_school/features/admin/teacher/create/provider/create_teacher_provider.dart';
import 'package:att_school/features/admin/teacher/teacher_form_screen.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateTeacherScreen extends StatelessWidget {
  const CreateTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateTeacherProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            TeacherFormScreen(
              'Create Teacher',
              onSubmit: (data) async => await provider.createTeacher(data),
            ),
            if (provider.isLoading) const AppLoading(),
          ],
        );
      },
    );
  }
}
