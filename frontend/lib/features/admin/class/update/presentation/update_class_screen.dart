import 'package:att_school/features/admin/class/class_form_screen.dart';
import 'package:att_school/features/admin/class/read/detail/provider/read_class_detail_provider.dart';
import 'package:att_school/features/admin/class/update/provider/update_class_provider.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateClassScreen extends StatelessWidget {
  final String id;
  const UpdateClassScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<ReadClassDetailProvider>();

    return Consumer<UpdateClassProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            ClassFormScreen(
              'Update Class',
              onSubmit: (payload) async => await provider.updateClass(payload),
              id: id,
              editData: detail.class_,
            ),
            if (provider.isLoading || detail.class_ == null || detail.isLoading)
              AppLoading(),
          ],
        );
      },
    );
  }
}
