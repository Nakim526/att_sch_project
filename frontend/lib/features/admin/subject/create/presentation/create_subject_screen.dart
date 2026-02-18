import 'package:att_school/features/admin/subject/create/provider/create_subject_provider.dart';
import 'package:att_school/features/admin/subject/subject_form_screen.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateSubjectScreen extends StatelessWidget {
  const CreateSubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateSubjectProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            SubjectFormScreen(
              'Create Subject',
              onSubmit: (payload) async {
                return await provider.createSubject(payload);
              },
            ),
            if (provider.isLoading) AppLoading(),
          ],
        );
      },
    );
  }
}
