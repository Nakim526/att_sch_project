import 'package:att_school/features/admin/teacher/read/data/read_teacher_service.dart';
import 'package:att_school/features/admin/teacher/read/detail/presentation/read_teacher_detail_screen.dart';
import 'package:att_school/features/admin/teacher/read/detail/provider/read_teacher_detail_provider.dart';
import 'package:att_school/features/school/provider/school_provider.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadTeacherDetailPage extends StatelessWidget {
  final String id;
  const ReadTeacherDetailPage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return ReadTeacherDetailProvider(
            context.read<ReadTeacherService>(),
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
      child: const ReadTeacherDetailScreen(),
    );
  }
}
