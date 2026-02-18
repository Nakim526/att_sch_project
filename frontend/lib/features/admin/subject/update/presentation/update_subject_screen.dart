import 'package:att_school/features/admin/subject/read/detail/provider/read_subject_detail_provider.dart';
import 'package:att_school/features/admin/subject/subject_form_screen.dart';
import 'package:att_school/features/admin/subject/update/provider/update_subject_provider.dart';
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
    final detail = context.watch<ReadSubjectDetailProvider>();

    return Consumer<UpdateSubjectProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            SubjectFormScreen(
              'Update Subject',
              onSubmit: (payload) async {
                return await provider.updateSubject(payload);
              },
              id: widget.id,
              editData: detail.subject,
            ),
            if (provider.isLoading ||
                detail.subject == null ||
                detail.isLoading)
              AppLoading(),
          ],
        );
      },
    );
  }
}
