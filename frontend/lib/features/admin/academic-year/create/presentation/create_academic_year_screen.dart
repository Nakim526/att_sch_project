import 'package:att_school/features/admin/academic-year/academic_year_form_screen.dart';
import 'package:att_school/features/admin/academic-year/create/provider/create_academic_year_provider.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAcademicYearScreen extends StatelessWidget {
  const CreateAcademicYearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateAcademicYearProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            AcademicYearFormScreen(
              'Update Academic Year',
              onSubmit: (data) async => await provider.createAcademicYear(data),
            ),
            if (provider.isLoading) AppLoading(),
          ],
        );
      },
    );
  }
}
