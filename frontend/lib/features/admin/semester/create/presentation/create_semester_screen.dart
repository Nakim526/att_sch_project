import 'package:att_school/features/admin/semester/create/provider/create_semester_provider.dart';
import 'package:att_school/features/admin/semester/semester_form_screen.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateSemesterScreen extends StatelessWidget {
  const CreateSemesterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateSemesterProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            SemesterFormScreen(
              'Create Semester',
              onSubmit: (data) async {
                return await provider.createSemester(data);
              },
            ),
            if (provider.isLoading) AppLoading(),
          ],
        );
      },
    );
  }
}
