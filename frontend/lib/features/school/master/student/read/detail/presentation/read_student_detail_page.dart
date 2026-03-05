import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_active_provider.dart';
import 'package:att_school/features/school/master/student/read/data/read_student_service.dart';
import 'package:att_school/features/school/master/student/read/detail/presentation/read_student_detail_screen.dart';
import 'package:att_school/features/school/master/student/read/detail/provider/read_student_detail_provider.dart';
import 'package:att_school/features/school/public/provider/school_provider.dart';
import 'package:att_school/features/school/data/student-enrollment/provider/student_enrollment_provider.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadStudentDetailPage extends StatelessWidget {
  final String id;
  const ReadStudentDetailPage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final semester = context.read<ReadSemesterActiveProvider>();

    return ChangeNotifierProvider(
      create: (_) {
        return ReadStudentDetailProvider(
            context.read<ReadStudentService>(),
            context.read<SchoolProvider>(),
            context.read<StudentEnrollmentProvider>(),
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
      child: const ReadStudentDetailScreen(),
    );
  }
}
