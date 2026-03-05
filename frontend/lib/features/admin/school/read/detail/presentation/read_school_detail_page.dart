import 'package:att_school/features/admin/school/read/data/read_school_service.dart';
import 'package:att_school/features/admin/school/read/detail/presentation/read_school_detail_screen.dart';
import 'package:att_school/features/admin/school/read/detail/provider/read_school_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadSchoolDetailPage extends StatelessWidget {
  final String id;
  const ReadSchoolDetailPage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return ReadSchoolDetailProvider(context.read<ReadSchoolService>())
          ..fetchById(id);
      },
      child: const ReadSchoolDetailScreen(),
    );
  }
}
