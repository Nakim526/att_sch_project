import 'package:att_school/core/constant/item/app_items.dart';
import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/features/school/master/academic-year/models/academic_year_model.dart';
import 'package:att_school/features/school/master/class/models/class_model.dart';
import 'package:att_school/features/school/master/class/read/list/provider/read_class_list_provider.dart';
import 'package:att_school/features/school/master/semester/models/semester_model.dart';
import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_active_provider.dart';
import 'package:att_school/features/school/master/student/models/student_model.dart';
import 'package:att_school/features/school/master/student/read/detail/presentation/read_student_detail_page.dart';
import 'package:att_school/features/school/master/student/read/detail/provider/read_student_detail_provider.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/field/app_field.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/elements/input/select/app_select_one_input.dart';
import 'package:att_school/shared/widgets/elements/input/text/app_text_input.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentFormScreen extends StatefulWidget {
  final String title;
  final Future<BackendMessageHelper> Function(StudentModel data) onSubmit;
  final String? id;
  final StudentModel? editData;

  const StudentFormScreen(
    this.title, {
    super.key,
    required this.onSubmit,
    this.id,
    this.editData,
  });

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nisController = TextEditingController();
  final _nisnController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _genders = AppItems.genders;
  String? _selectedGender;
  List<Map<String, dynamic>> _classes = [];
  SemesterModel? _semester;
  AcademicYearModel? _academicYear;
  Map<String, dynamic>? _selectedClass;
  bool _errorNis = false;
  bool _errorName = false;
  bool _errorClass = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (mounted) {
        final detail = context.read<ReadStudentDetailProvider>();
        final class_ = context.read<ReadClassListProvider>();
        final semester = context.read<ReadSemesterActiveProvider>();

        detail.ready = false;

        await class_.reload();
        await semester.fetchActive();

        if (semester.error.isNotEmpty) return;

        setState(() {
          _classes = class_.data;
          _semester = semester.data;
          _academicYear = semester.academicYear;
        });

        if (widget.id != null) {
          await detail.fetchById(widget.id!);

          if (detail.data != null) {
            setState(() {
              _nisController.text = detail.data!.nis;
              _nisnController.text = detail.data!.nisn ?? '';
              _nameController.text = detail.data!.name;
              _phoneController.text = detail.data!.phone ?? '';
              _addressController.text = detail.data!.address ?? '';
              _selectedGender = detail.data!.gender;
              _selectedClass = detail.data!.class_?.toMap();
            });
          }
        }

        detail.ready = true;
      }
    });
  }

  @override
  void dispose() {
    _nisController.dispose();
    _nisnController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onChangedNis(_) {
    if (_errorNis) setState(() => _errorNis = false);
  }

  void _onChangedName(_) {
    if (_errorName) setState(() => _errorName = false);
  }

  dynamic _onChangedGender(dynamic value) {
    setState(() => _selectedGender = value);
  }

  dynamic _onChangedClass(dynamic value) {
    setState(() {
      _selectedClass = value;
      _errorClass = false;
    });
  }

  bool _validate() {
    setState(() {
      _errorNis = _nisController.text.isEmpty;
      _errorName = _nameController.text.isEmpty;
      _errorClass = _selectedClass == null;
    });

    return !(_errorNis || _errorName || _errorClass);
  }

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<ReadStudentDetailProvider>();

    return AppScreen(
      appBar: AppBar(title: Text(widget.title)),
      children: [
        AppText(widget.title, variant: AppTextVariant.h2),
        AppButton(
          "Save",
          onPressed: () async {
            if (!_validate()) return;

            final result = await widget.onSubmit(
              StudentModel(
                id: widget.editData?.id,
                nis: _nisController.text,
                nisn: _nisnController.text,
                name: _nameController.text,
                phone: _phoneController.text,
                address: _addressController.text,
                gender: _selectedGender,
                class_: ClassModel.fromMap(_selectedClass),
                semester: _semester,
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
                      builder: (context) => ReadStudentDetailPage(id),
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
        if (detail.isReady && _semester != null)
          Form(
            key: _formKey,
            child: Column(
              spacing: AppSize.medium,
              children: [
                AppSection(
                  title: 'Data Siswa',
                  children: [
                    AppTextInput(
                      controller: _nisController,
                      labelText: 'NIS',
                      errorText: 'NIS Wajib Diisi',
                      isError: _errorNis,
                      onChanged: _onChangedNis,
                    ),
                    AppTextInput(
                      controller: _nisnController,
                      labelText: 'NISN',
                    ),
                    AppTextInput(
                      controller: _nameController,
                      labelText: 'Nama',
                      errorText: 'Nama Wajib Diisi',
                      isError: _errorName,
                      onChanged: _onChangedName,
                    ),
                    AppSelectOneInput(
                      items: _genders,
                      labelText: 'Gender',
                      initialValue: _selectedGender,
                      onChanged: _onChangedGender,
                    ),
                    AppTextInput(
                      controller: _phoneController,
                      labelText: 'Nomor Telepon',
                    ),
                    AppTextInput(
                      controller: _addressController,
                      labelText: 'Alamat',
                    ),
                  ],
                ),
                AppSection(
                  title: 'Detail',
                  children: [
                    AppSelectOneInput(
                      items: _classes,
                      initialValue: _selectedClass,
                      labelText: 'Kelas',
                      errorText: 'Kelas Wajib Diisi',
                      isError: _errorClass,
                      onChanged: _onChangedClass,
                      align: MenuAlign.topCenter,
                      isFormatted: false,
                      showSearchBox: true,
                    ),
                    AppField('Semester', value: _semester?.name),
                    AppField('Tahun Ajaran', value: _academicYear?.name),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
