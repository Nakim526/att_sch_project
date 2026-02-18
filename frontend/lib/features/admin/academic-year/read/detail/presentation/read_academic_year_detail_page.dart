import 'package:att_school/features/admin/academic-year/read/data/read_academic_year_service.dart';
import 'package:att_school/features/admin/academic-year/read/detail/presentation/read_academic_year_detail_screen.dart';
import 'package:att_school/features/admin/academic-year/read/detail/provider/read_academic_year_detail_provider.dart';
import 'package:att_school/features/school/provider/school_provider.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadAcademicYearDetailPage extends StatelessWidget {
  final String id;
  const ReadAcademicYearDetailPage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return ReadAcademicYearDetailProvider(
            context.read<ReadAcademicYearService>(),
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
      child: const ReadAcademicYearDetailScreen(),
    );
  }
}
