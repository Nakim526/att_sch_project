import 'package:att_school/features/admin/has-access/has_access_form_screen.dart';
import 'package:att_school/features/admin/has-access/read/detail/provider/read_has_access_detail_provider.dart';
import 'package:att_school/features/admin/has-access/update/provider/update_has_access_provider.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateHasAccessScreen extends StatelessWidget {
  final String id;
  const UpdateHasAccessScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<ReadHasAccessDetailProvider>();

    return Consumer<UpdateHasAccessProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            HasAccessFormScreen(
              'Update Has Access',
              onSubmit: (data) async => await provider.updateHasAccess(data),
              id: id,
              editData: detail.hasAccess,
            ),
            if (provider.isLoading ||
                detail.hasAccess == null ||
                detail.isLoading)
              AppLoading(),
          ],
        );
      },
    );
  }
}
