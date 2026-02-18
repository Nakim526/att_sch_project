import 'package:att_school/features/admin/academic-year/academic_year_form_screen.dart';
import 'package:att_school/features/admin/academic-year/read/detail/provider/read_academic_year_detail_provider.dart';
import 'package:att_school/features/admin/academic-year/update/provider/update_academic_year_provider.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateAcademicYearScreen extends StatelessWidget {
  final String id;
  const UpdateAcademicYearScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<ReadAcademicYearDetailProvider>();

    return Consumer<UpdateAcademicYearProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            AcademicYearFormScreen(
              'Update Academic Year',
              onSubmit: (data) async => await provider.updateAcademicYear(data),
              id: id,
              editData: detail.academicYear,
            ),
            if (provider.isLoading ||
                detail.academicYear == null ||
                detail.isLoading)
              AppLoading(),
          ],
        );
      },
    );
  }
}
