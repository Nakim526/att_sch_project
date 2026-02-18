import 'package:att_school/features/admin/semester/read/detail/provider/read_semester_detail_provider.dart';
import 'package:att_school/features/admin/semester/semester_form_screen.dart';
import 'package:att_school/features/admin/semester/update/provider/update_semester_provider.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateSemesterScreen extends StatelessWidget {
  final String id;
  const UpdateSemesterScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<ReadSemesterDetailProvider>();

    return Consumer<UpdateSemesterProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            SemesterFormScreen(
              'Update Semester',
              onSubmit: (data) async => await provider.updateSemester(data),
              id: id,
              editData: detail.semester,
            ),
            if (provider.isLoading ||
                detail.semester == null ||
                detail.isLoading)
              AppLoading(),
          ],
        );
      },
    );
  }
}
