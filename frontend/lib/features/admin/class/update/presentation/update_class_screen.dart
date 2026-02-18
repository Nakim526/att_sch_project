import 'package:att_school/core/constant/item/app_items.dart';
import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/admin/class/class_form_screen.dart';
import 'package:att_school/features/admin/class/models/class_model.dart';
import 'package:att_school/features/admin/class/read/detail/provider/read_class_detail_provider.dart';
import 'package:att_school/features/admin/class/update/provider/update_class_provider.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateClassScreen extends StatefulWidget {
  final String id;
  const UpdateClassScreen(this.id, {super.key});

  @override
  State<UpdateClassScreen> createState() => _UpdateClassScreenState();
}

class _UpdateClassScreenState extends State<UpdateClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _grades = AppItems.grades;
  int? _selectedGrade;
  bool _errorName = false;
  bool _errorGrade = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (mounted) {
        final detail = context.read<ReadClassDetailProvider>();
        await detail.fetchById(widget.id);

        if (detail.class_ != null) {
          setState(() {
            _nameController.text = detail.class_!.name;
            _selectedGrade = detail.class_!.grade;
          });
        }
      }
    });
  }

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
    final provider = context.watch<UpdateClassProvider>();
    final detail = context.watch<ReadClassDetailProvider>();

    return Stack(
      children: [
        AppScreen(
          appBar: AppBar(title: const Text('Update Class')),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSize.xLarge,
              children: [
                AppText("Update Class", variant: AppTextVariant.h2),
                AppButton(
                  "Save",
                  onPressed: () async {
                    if (!_validate()) return;

                    final result = await provider.updateClass(
                      ClassModel(
                        id: detail.class_!.id,
                        name: _nameController.text,
                        grade: _selectedGrade!,
                        schoolId: detail.class_!.schoolId,
                      ),
                    );

                    if (context.mounted) {
                      await AppDialog.show(
                        context,
                        title: result.status ? 'Success' : 'Error',
                        message: result.message,
                      );

                      if (result.status && context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  variant: AppButtonVariant.primary,
                ),
                if (detail.class_ != null)
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
        if (provider.isLoading || detail.class_ == null || detail.isLoading)
          Container(
            color: Colors.black45,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
