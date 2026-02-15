import 'package:att_school/features/admin/has-access/read/data/read_has_access_service.dart';
import 'package:att_school/features/admin/has-access/read/detail/presentation/read_has_access_detail_screen.dart';
import 'package:att_school/features/admin/has-access/read/detail/provider/read_has_access_detail_provider.dart';
import 'package:att_school/features/school/provider/school_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadHasAccessDetailPage extends StatelessWidget {
  final String id;
  const ReadHasAccessDetailPage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return ReadHasAccessDetailProvider(
          context.read<ReadHasAccessService>(),
          context.read<SchoolProvider>(),
        )..fetchById(id);
      },
      child: const ReadHasAccessDetailScreen(),
    );
  }
}
