import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/admin/subject/models/subject_model.dart';
import 'package:att_school/features/admin/subject/read/detail/provider/read_subject_detail_provider.dart';
import 'package:att_school/features/admin/subject/subject_form_screen.dart';
import 'package:att_school/features/admin/subject/update/provider/update_subject_provider.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateSubjectScreen extends StatefulWidget {
  final String id;
  const UpdateSubjectScreen(this.id, {super.key});

  @override
  State<UpdateSubjectScreen> createState() => _UpdateSubjectScreenState();
}

class _UpdateSubjectScreenState extends State<UpdateSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _errorName = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (mounted) {
        final detail = context.read<ReadSubjectDetailProvider>();
        await detail.fetchById(widget.id);

        if (detail.subject != null) {
          setState(() {
            _nameController.text = detail.subject!.name;
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

  bool _validate() {
    setState(() {
      _errorName = _nameController.text.isEmpty;
    });

    return !(_errorName);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UpdateSubjectProvider>();
    final detail = context.watch<ReadSubjectDetailProvider>();

    return Stack(
      children: [
        AppScreen(
          appBar: AppBar(title: const Text('Update Subject')),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSize.xLarge,
              children: [
                AppText("Update Subject", variant: AppTextVariant.h2),
                AppButton(
                  "Save",
                  onPressed: () async {
                    if (!_validate()) return;

                    final result = await provider.updateSubject(
                      SubjectModel(
                        id: detail.subject!.id,
                        name: _nameController.text,
                        schoolId: detail.subject!.schoolId,
                      ),
                    );

                    if (context.mounted) {
                      await AppDialog.show(
                        context,
                        title: result.status ? 'Success' : 'Error',
                        message: result.message,
                      );

                      if (result.status && context.mounted) {
                        return Navigator.pop(context);
                      }
                    }
                  },
                  variant: AppButtonVariant.primary,
                ),
                if (detail.subject != null)
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
        if (provider.isLoading || detail.subject == null || detail.isLoading)
          Container(
            color: Colors.black45,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
