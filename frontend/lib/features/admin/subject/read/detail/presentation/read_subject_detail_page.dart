import 'package:att_school/features/admin/subject/read/data/read_subject_service.dart';
import 'package:att_school/features/admin/subject/read/detail/presentation/read_subject_detail_screen.dart';
import 'package:att_school/features/admin/subject/read/detail/provider/read_subject_detail_provider.dart';
import 'package:att_school/features/school/provider/school_provider.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadSubjectDetailPage extends StatelessWidget {
  final String id;
  const ReadSubjectDetailPage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return ReadSubjectDetailProvider(
            context.read<ReadSubjectService>(),
            context.read<SchoolProvider>(),
          )
          ..fetchById(id).then((result) {
            if (!result.status && context.mounted) {
              return AppDialog.show(
                context,
                title: "Error",
                message: result.message,
              );
            }
          });
      },
      child: const ReadSubjectDetailScreen(),
    );
  }
}
