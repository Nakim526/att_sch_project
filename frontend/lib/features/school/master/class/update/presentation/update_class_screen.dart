import 'package:att_school/features/school/master/class/class_form_screen.dart';
import 'package:att_school/features/school/master/class/read/detail/provider/read_class_detail_provider.dart';
import 'package:att_school/features/school/master/class/update/provider/update_class_provider.dart';
import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_active_provider.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateClassScreen extends StatelessWidget {
  final String id;
  const UpdateClassScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final semester = context.watch<ReadSemesterActiveProvider>();
    final detail = context.watch<ReadClassDetailProvider>();

    return Consumer<UpdateClassProvider>(
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
            ClassFormScreen(
              'Update Class',
              onSubmit: (payload) async => await provider.updateClass(payload),
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
