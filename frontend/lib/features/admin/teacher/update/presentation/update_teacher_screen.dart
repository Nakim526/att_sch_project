import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/admin/teacher/models/teacher_model.dart';
import 'package:att_school/features/admin/teacher/read/detail/provider/read_teacher_detail_provider.dart';
import 'package:att_school/features/admin/teacher/read/list/provider/read_teacher_list_provider.dart';
import 'package:att_school/features/admin/teacher/teacher_form_screen.dart';
import 'package:att_school/features/admin/teacher/update/provider/update_teacher_provider.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateTeacherScreen extends StatefulWidget {
  final String id;
  const UpdateTeacherScreen(this.id, {super.key});

  @override
  State<UpdateTeacherScreen> createState() => _UpdateTeacherScreenState();
}

class _UpdateTeacherScreenState extends State<UpdateTeacherScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dropdownKey = GlobalKey<DropdownSearchState<Map<String, String>>>();
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
        await detail.fetchById(widget.id);

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
    final provider = context.watch<UpdateTeacherProvider>();
    final detail = context.watch<ReadTeacherDetailProvider>();

    return Stack(
      children: [
        AppScreen(
          appBar: AppBar(title: const Text('Update Teacher')),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSize.xLarge,
              children: [
                AppText("Update Teacher", variant: AppTextVariant.h2),
                AppButton(
                  "Save",
                  onPressed: () async {
                    if (!_validate()) return;

                    final result = await provider.updateTeacher(
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
                        title: result.success ? 'Success' : 'Error',
                        message: result.message,
                      );

                      if (result.success && context.mounted) {
                        return Navigator.pop(context);
                      }
                    }
                  },
                  variant: AppButtonVariant.primary,
                ),
                if (detail.teacher != null)
                  TeacherFormScreen(
                    formKey: _formKey,
                    dropdownKey: _dropdownKey,
                    nipController: _nipController,
                    nameController: _nameController,
                    errorNip: _errorNip,
                    errorName: _errorName,
                    errorEmail: _errorEmail,
                    emails: _emails,
                    selectedEmail: _selectedEmail,
                    onChangedNip: _onChangedNip,
                    onChangedName: _onChangedName,
                    onChangedEmail: (value) => _onChangedEmail(value),
                  ),
              ],
            ),
          ],
        ),
        if (provider.isLoading || detail.teacher == null || detail.isLoading)
          AppLoading(),
      ],
    );
  }
}
