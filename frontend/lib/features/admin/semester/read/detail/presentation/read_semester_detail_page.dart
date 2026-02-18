import 'package:att_school/features/admin/academic-year/read/detail/provider/read_academic_year_detail_provider.dart';
import 'package:att_school/features/admin/semester/read/data/read_semester_service.dart';
import 'package:att_school/features/admin/semester/read/detail/presentation/read_semester_year_detail_screen.dart';
import 'package:att_school/features/admin/semester/read/detail/provider/read_semester_detail_provider.dart';
import 'package:att_school/features/school/provider/school_provider.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadSemesterDetailPage extends StatelessWidget {
  final String id;
  const ReadSemesterDetailPage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return ReadSemesterDetailProvider(
            context.read<ReadSemesterService>(),
            context.read<SchoolProvider>(),
            context.read<ReadAcademicYearDetailProvider>()
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
      child: const ReadSemesterDetailScreen(),
    );
  }
}
