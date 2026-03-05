import 'package:att_school/features/school/master/user/create/provider/create_user_provider.dart';
import 'package:att_school/features/school/master/user/user_form_screen.dart';
import 'package:att_school/features/school/master/user/read/detail/provider/read_user_detail_provider.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateUserScreen extends StatelessWidget {
  const CreateUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<ReadUserDetailProvider>();

    return Consumer<CreateUserProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            UserFormScreen(
              'Create Has Access',
              onSubmit: (payload) async => await provider.createUser(payload),
            ),
            if (provider.isLoading || !detail.isReady) const AppLoading(),
          ],
        );
      },
    );
  }
}
