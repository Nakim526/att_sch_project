import 'package:att_school/features/school/master/class/read/data/read_class_service.dart';
import 'package:att_school/features/school/master/class/read/detail/presentation/read_class_detail_screen.dart';
import 'package:att_school/features/school/master/class/read/detail/provider/read_class_detail_provider.dart';
import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_active_provider.dart';
import 'package:att_school/features/school/data/class-teacher/provider/class_teacher_provider.dart';
import 'package:att_school/features/school/master/subject/read/data/read_subject_service.dart';
import 'package:att_school/features/school/public/provider/school_provider.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadClassDetailPage extends StatelessWidget {
  final String id;
  final String? teacherId;
  const ReadClassDetailPage(this.id, {super.key, this.teacherId});

  @override
  Widget build(BuildContext context) {
    final semester = context.read<ReadSemesterActiveProvider>();

    return ChangeNotifierProvider(
      create: (_) {
        return ReadClassDetailProvider(
            context.read<ReadClassService>(),
            context.read<ReadSubjectService>(),
            context.read<SchoolProvider>(),
            context.read<ClassTeacherProvider>(),
          )
          ..fetchById(id, teacherId: teacherId).then((result) async {
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
      child: ReadClassDetailScreen(teacherId: teacherId),
    );
  }
}
