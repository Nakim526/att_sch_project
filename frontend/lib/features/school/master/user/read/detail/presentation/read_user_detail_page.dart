import 'package:att_school/features/school/master/user/read/data/read_user_service.dart';
import 'package:att_school/features/school/master/user/read/detail/presentation/read_user_detail_screen.dart';
import 'package:att_school/features/school/master/user/read/detail/provider/read_user_detail_provider.dart';
import 'package:att_school/features/school/public/provider/school_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadUserDetailPage extends StatelessWidget {
  final String id;
  const ReadUserDetailPage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return ReadUserDetailProvider(
          context.read<ReadUserService>(),
          context.read<SchoolProvider>(),
        )..fetchById(id);
      },
      child: const ReadUserDetailScreen(),
    );
  }
}
