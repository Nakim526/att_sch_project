import 'package:att_school/features/school/master/user/user_form_screen.dart';
import 'package:att_school/features/school/master/user/read/detail/provider/read_user_detail_provider.dart';
import 'package:att_school/features/school/master/user/update/provider/update_user_provider.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateUserScreen extends StatelessWidget {
  final String id;
  const UpdateUserScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<ReadUserDetailProvider>();

    return Consumer<UpdateUserProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            UserFormScreen(
              'Update Hak Akses',
              onSubmit: (data) async => await provider.updateUser(data),
              id: id,
              editData: detail.data,
            ),
            if (provider.isLoading || !detail.isReady) AppLoading(),
          ],
        );
      },
    );
  }
}
