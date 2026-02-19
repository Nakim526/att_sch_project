import 'package:att_school/features/admin/student/read/data/read_student_service.dart';
import 'package:att_school/features/admin/student/read/detail/presentation/read_student_detail_screen.dart';
import 'package:att_school/features/admin/student/read/detail/provider/read_student_detail_provider.dart';
import 'package:att_school/features/school/provider/school_provider.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadStudentDetailPage extends StatelessWidget {
  final String id;
  const ReadStudentDetailPage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return ReadStudentDetailProvider(
            context.read<ReadStudentService>(),
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
      child: const ReadStudentDetailScreen(),
    );
  }
}
