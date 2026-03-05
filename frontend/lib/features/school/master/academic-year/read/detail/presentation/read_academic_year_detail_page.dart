import 'package:att_school/features/school/master/academic-year/read/data/read_academic_year_service.dart';
import 'package:att_school/features/school/master/academic-year/read/detail/presentation/read_academic_year_detail_screen.dart';
import 'package:att_school/features/school/master/academic-year/read/detail/provider/read_academic_year_detail_provider.dart';
import 'package:att_school/features/school/public/provider/school_provider.dart';
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
        )..fetchById(id);
      },
      child: const ReadAcademicYearDetailScreen(),
    );
  }
}
