import 'package:att_school/core/constant/item/app_items.dart';
import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/admin/class/class_form_screen.dart';
import 'package:att_school/features/admin/class/create/provider/create_class_provider.dart';
import 'package:att_school/features/admin/class/models/class_model.dart';
import 'package:att_school/features/admin/class/read/detail/presentation/read_class_detail_page.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateClassScreen extends StatefulWidget {
  const CreateClassScreen({super.key});

  @override
  State<CreateClassScreen> createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends State<CreateClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _grades = AppItems.grades;
  int? _selectedGrade;
  bool _errorName = false;
  bool _errorGrade = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onChangedName(_) {
    if (_errorName) setState(() => _errorName = false);
  }

  void _onChangedGrade(int? value) {
    setState(() {
      _selectedGrade = value;
      _errorGrade = false;
    });
  }

  bool _validate() {
    setState(() {
      _errorName = _nameController.text.isEmpty;
      _errorGrade = _selectedGrade == null;
    });

    return !(_errorName || _errorGrade);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreateClassProvider>(context);

    return Stack(
      children: [
        AppScreen(
          appBar: AppBar(title: const Text('Create Class')),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSize.medium,
              children: [
                AppText("Create Class", variant: AppTextVariant.h2),
                AppButton(
                  "Save",
                  onPressed: () async {
                    if (!_validate()) return;

                    final result = await provider.createClass(
                      ClassModel(
                        name: _nameController.text,
                        grade: _selectedGrade!,
                      ),
                    );

                    if (context.mounted) {
                      await AppDialog.show(
                        context,
                        title: result.success ? 'Success' : 'Error',
                        message: result.message,
                      );

                      if (result.success && context.mounted) {
                        final id = result.data['id'];

                        await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadClassDetailPage(id),
                          ),
                        );
                      }
                    }
                  },
                  variant: AppButtonVariant.primary,
                ),
                ClassFormScreen(
                  formKey: _formKey,
                  nameController: _nameController,
                  errorName: _errorName,
                  errorGrade: _errorGrade,
                  grades: _grades,
                  selectedGrade: _selectedGrade,
                  onChangedName: _onChangedName,
                  onChangedGrade: (value) => _onChangedGrade(value),
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
