import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_active_provider.dart';
import 'package:att_school/features/school/master/subject/read/detail/provider/read_subject_detail_provider.dart';
import 'package:att_school/features/school/master/subject/subject_form_screen.dart';
import 'package:att_school/features/school/master/subject/update/provider/update_subject_provider.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateSubjectScreen extends StatefulWidget {
  final String id;
  const UpdateSubjectScreen(this.id, {super.key});

  @override
  State<UpdateSubjectScreen> createState() => _UpdateSubjectScreenState();
}

class _UpdateSubjectScreenState extends State<UpdateSubjectScreen> {
  @override
  Widget build(BuildContext context) {
    final semester = context.watch<ReadSemesterActiveProvider>();
    final detail = context.watch<ReadSubjectDetailProvider>();

    return Consumer<UpdateSubjectProvider>(
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
            SubjectFormScreen(
              'Update Subject',
              onSubmit: (payload) async {
                return await provider.updateSubject(payload);
              },
              id: widget.id,
              editData: detail.data,
            ),
            if (provider.isLoading || !detail.isReady) AppLoading(),
          ],
        );
      },
    );
  }
}
