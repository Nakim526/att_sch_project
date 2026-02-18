import 'package:att_school/features/admin/has-access/create/provider/create_has_acces_provider.dart';
import 'package:att_school/features/admin/has-access/has_access_form_screen.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateHasAccessScreen extends StatelessWidget {
  const CreateHasAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateHasAccessProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            HasAccessFormScreen(
              'Create Has Access',
              onSubmit: (payload) async => await provider.createHasAccess(payload),
            ),
            if (provider.isLoading) const AppLoading(),
          ],
        );
      },
    );
  }
}
