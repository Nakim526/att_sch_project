import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_active_provider.dart';
import 'package:att_school/features/school/master/teacher/read/data/read_teacher_service.dart';
import 'package:att_school/features/school/master/teacher/read/detail/presentation/read_teacher_detail_screen.dart';
import 'package:att_school/features/school/master/teacher/read/detail/provider/read_teacher_detail_provider.dart';
import 'package:att_school/features/school/public/provider/school_provider.dart';
import 'package:att_school/features/school/data/teaching-assignment/provider/teaching_assignment_provider.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadTeacherDetailPage extends StatelessWidget {
  final String id;
  const ReadTeacherDetailPage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final semester = context.read<ReadSemesterActiveProvider>();

    return ChangeNotifierProvider(
      create: (_) {
        return ReadTeacherDetailProvider(
            context.read<ReadTeacherService>(),
            context.read<SchoolProvider>(),
            context.read<TeachingAssignmentProvider>(),
          )
          ..fetchById(id).then((result) async {
            if (!result.status && context.mounted) {
              return AppDialog.show(
                context,
                title: "Error",
                message: result.message,
              );
            }

            await semester.fetchActive();
          });
      },
      child: ReadTeacherDetailScreen(id),
    );
  }
}
