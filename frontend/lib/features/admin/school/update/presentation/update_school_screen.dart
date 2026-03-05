import 'package:att_school/features/admin/school/school_form_screen.dart';
import 'package:att_school/features/admin/school/read/detail/provider/read_school_detail_provider.dart';
import 'package:att_school/features/admin/school/update/provider/update_school_provider.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateSchoolScreen extends StatelessWidget {
  final String id;
  const UpdateSchoolScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<ReadSchoolDetailProvider>();

    return Consumer<UpdateSchoolProvider>(
      builder: (context, provider, _) {
        // 🔥 SIDE-EFFECT: dialog
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (detail.error.isNotEmpty) {
            AppDialog.show(context, title: 'Error', message: detail.error);

            // penting: reset error
            detail.clearError();
          }
        });

        return Stack(
          children: [
            SchoolFormScreen(
              'Update Sekolah',
              onSubmit: (data) async => await provider.updateSchool(data),
              id: id,
              editData: detail.data,
            ),
            if (provider.isLoading || !detail.isReady) AppLoading(),
          ],
        );
      },
    );
  }
}
