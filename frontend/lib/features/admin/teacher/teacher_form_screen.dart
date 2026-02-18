import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/teacher/models/teacher_model.dart';
import 'package:att_school/features/admin/teacher/read/detail/presentation/read_teacher_detail_page.dart';
import 'package:att_school/features/admin/teacher/read/detail/provider/read_teacher_detail_provider.dart';
import 'package:att_school/features/admin/teacher/read/list/provider/read_teacher_list_provider.dart';
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

class TeacherFormScreen extends StatefulWidget {
  final String title;
  final Future<BackendMessageHelper> Function(TeacherModel data) onSubmit;
  final String? id;
  final TeacherModel? editData;

  const TeacherFormScreen(
    this.title, {
    super.key,
    required this.onSubmit,
    this.id,
    this.editData,
  });

  @override
  State<TeacherFormScreen> createState() => _TeacherFormScreenState();
}

class _TeacherFormScreenState extends State<TeacherFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nipController = TextEditingController();
  final _nameController = TextEditingController();
  List<String> _emails = [];
  String? _selectedEmail;
  bool _errorNip = false;
  bool _errorName = false;
  bool _errorEmail = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (mounted) {
        final list = context.read<ReadTeacherListProvider>();
        final detail = context.read<ReadTeacherDetailProvider>();

        await list.fetchAllEmails();

        setState(() => _emails = list.emails);

        if (widget.id != null) {
          await detail.fetchById(widget.id!);

          if (detail.teacher != null) {
            final data = detail.teacher!;
            setState(() {
              _nipController.text = data.nip;
              _nameController.text = data.name;
              _selectedEmail = data.email;
              _emails = list.emails;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _nipController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onChangedNip(_) {
    if (_errorNip) setState(() => _errorNip = false);
  }

  void _onChangedName(_) {
    if (_errorName) setState(() => _errorName = false);
  }

  void _onChangedEmail(String? value) {
    setState(() {
      _selectedEmail = value;
      _errorEmail = false;
    });
  }

  bool _validate() {
    setState(() {
      _errorNip = _nipController.text.isEmpty;
      _errorName = _nameController.text.isEmpty;
      _errorEmail = _selectedEmail == null || _selectedEmail!.isEmpty;
    });

    return !(_errorNip || _errorName || _errorEmail);
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
                  TeacherModel(
                    id: widget.id,
                    nip: _nipController.text,
                    name: _nameController.text,
                    email: _selectedEmail!,
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
                          builder: (context) => ReadTeacherDetailPage(id),
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
                      items: _emails,
                      labelText: 'Email',
                      errorText: 'Email is required',
                      isError: _errorEmail,
                      initialValue: _selectedEmail,
                      onChanged: (value) => _onChangedEmail(value),
                      showSearchBox: true,
                    ),
                    AppTextInput(
                      controller: _nameController,
                      labelText: 'Name',
                      errorText: 'Name is required',
                      isError: _errorName,
                      onChanged: _onChangedName,
                    ),
                    AppTextInput(
                      controller: _nipController,
                      labelText: 'Nip',
                      errorText: 'Nip is required',
                      isError: _errorNip,
                      onChanged: _onChangedNip,
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
