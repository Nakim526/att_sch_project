import 'package:att_school/features/admin/class/class_form_screen.dart';
import 'package:att_school/features/admin/class/create/provider/create_class_provider.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateClassScreen extends StatelessWidget {
  const CreateClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateClassProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            ClassFormScreen(
              'Create Class',
              onSubmit: (payload) async => await provider.createClass(payload),
            ),
            if (provider.isLoading) AppLoading(),
          ],
        );
      },
    );
  }
}
