import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/admin/subject/create/provider/create_subject_provider.dart';
import 'package:att_school/features/admin/subject/models/subject_model.dart';
import 'package:att_school/features/admin/subject/read/detail/presentation/read_subject_detail_page.dart';
import 'package:att_school/features/admin/subject/subject_form_screen.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateSubjectScreen extends StatefulWidget {
  const CreateSubjectScreen({super.key});

  @override
  State<CreateSubjectScreen> createState() => _CreateSubjectScreenState();
}

class _CreateSubjectScreenState extends State<CreateSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _errorName = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onChangedName(_) {
    if (_errorName) setState(() => _errorName = false);
  }

  bool _validate() {
    setState(() {
      _errorName = _nameController.text.isEmpty;
    });

    return !(_errorName);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreateSubjectProvider>(context);

    return Stack(
      children: [
        AppScreen(
          appBar: AppBar(title: const Text('Create Subject')),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSize.medium,
              children: [
                AppText("Create Subject", variant: AppTextVariant.h2),
                AppButton(
                  "Save",
                  onPressed: () async {
                    if (!_validate()) return;

                    final result = await provider.createSubject(
                      SubjectModel(name: _nameController.text),
                    );

                    if (context.mounted) {
                      await AppDialog.show(
                        context,
                        title: result.success ? 'Success' : 'Error',
                        message: result.message,
                      );

                      if (result.success && context.mounted) {
                        final id = result.data['id'];
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadSubjectDetailPage(id),
                          ),
                        );
                      }
                    }
                  },
                  variant: AppButtonVariant.primary,
                ),
                SubjectFormScreen(
                  formKey: _formKey,
                  nameController: _nameController,
                  errorName: _errorName,
                  onChangedName: _onChangedName,
                ),
              ],
            ),
          ],
        ),
        if (provider.isLoading) AppLoading(),
      ],
    );
  }
}
