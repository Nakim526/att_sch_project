import 'package:att_school/features/admin/school/school_form_screen.dart';
import 'package:att_school/features/admin/school/create/provider/create_school_provider.dart';
import 'package:att_school/features/admin/school/read/detail/provider/read_school_detail_provider.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateSchoolScreen extends StatelessWidget {
  const CreateSchoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<ReadSchoolDetailProvider>();

    return Consumer<CreateSchoolProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            SchoolFormScreen(
              'Create Sekolah',
              onSubmit: (data) async => await provider.createSchool(data),
            ),
            if (provider.isLoading || !detail.isReady) AppLoading(),
          ],
        );
      },
    );
  }
}
