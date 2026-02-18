import 'package:att_school/core/constant/item/app_items.dart';
import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/class/models/class_model.dart';
import 'package:att_school/features/admin/class/read/detail/presentation/read_class_detail_page.dart';
import 'package:att_school/features/admin/class/read/detail/provider/read_class_detail_provider.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/elements/input/app_select_one_input.dart';
import 'package:att_school/shared/widgets/elements/input/app_text_input.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassFormScreen extends StatefulWidget {
  final String title;
  final Future<BackendMessageHelper> Function(ClassModel data) onSubmit;
  final String? id;
  final ClassModel? editData;

  const ClassFormScreen(
    this.title, {
    super.key,
    required this.onSubmit,
    this.id,
    this.editData,
  });

  @override
  State<ClassFormScreen> createState() => _ClassFormScreenState();
}

class _ClassFormScreenState extends State<ClassFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _grades = AppItems.grades;
  int? _selectedGrade;
  bool _errorName = false;
  bool _errorGrade = false;

  @override
  void initState() {
    super.initState();

    if (widget.id != null) {
      Future.microtask(() async {
        if (mounted) {
          final detail = context.read<ReadClassDetailProvider>();
          await detail.fetchById(widget.id!);

          if (detail.class_ != null) {
            setState(() {
              _nameController.text = detail.class_!.name;
              _selectedGrade = detail.class_!.grade;
            });
          }
        }
      });
    }
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
    return AppScreen(
      appBar: AppBar(title: Text(widget.title)),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSize.xLarge,
          children: [
            AppText(widget.title, variant: AppTextVariant.h2),
            AppButton(
              "Save",
              onPressed: () async {
                if (!_validate()) return;

                final result = await widget.onSubmit(
                  ClassModel(
                    id: widget.id,
                    name: _nameController.text,
                    grade: _selectedGrade!,
                  ),
                );

                if (context.mounted) {
                  await AppDialog.show(
                    context,
                    title: result.status ? 'Success' : 'Error',
                    message: result.message,
                  );

                  if (result.status && context.mounted) {
                    if (widget.editData == null) {
                      final id = result.data['id'];
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadClassDetailPage(id),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  }
                }
              },
              variant: AppButtonVariant.primary,
            ),
            if (widget.id == null ||
                (widget.id != null && widget.editData != null))
              Form(
                key: _formKey,
                child: AppSection(
                  children: [
                    AppSelectOneInput(
                      items: _grades,
                      labelText: 'Grade',
                      errorText: 'Grade is required',
                      isError: _errorGrade,
                      initialValue: _selectedGrade,
                      onChanged: (value) => _onChangedGrade(value),
                    ),
                    AppTextInput(
                      controller: _nameController,
                      labelText: 'Class Name',
                      errorText: 'Class Name is required',
                      isError: _errorName,
                      onChanged: _onChangedName,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
