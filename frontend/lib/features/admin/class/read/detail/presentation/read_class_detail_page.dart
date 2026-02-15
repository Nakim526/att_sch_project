import 'package:att_school/features/admin/class/read/data/read_class_service.dart';
import 'package:att_school/features/admin/class/read/detail/presentation/read_class_detail_screen.dart';
import 'package:att_school/features/admin/class/read/detail/provider/read_class_detail_provider.dart';
import 'package:att_school/features/school/provider/school_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadClassDetailPage extends StatelessWidget {
  final String id;
  const ReadClassDetailPage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return ReadClassDetailProvider(
          context.read<ReadClassService>(),
          context.read<SchoolProvider>(),
        )..fetchById(id);
      },
      child: const ReadClassDetailScreen(),
    );
  }
}
