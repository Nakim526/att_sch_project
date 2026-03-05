import 'package:att_school/core/constant/item/app_items.dart';
import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/border-radius/app_border_radius.dart';
import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/features/auth/roles/provider/roles_provider.dart';
import 'package:att_school/features/school/data/class-schedule/data/class_schedule_model.dart';
import 'package:att_school/features/school/master/academic-year/models/academic_year_model.dart';
import 'package:att_school/features/school/master/class/read/list/provider/read_class_list_provider.dart';
import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_active_provider.dart';
import 'package:att_school/features/school/master/user/read/list/provider/read_user_list_provider.dart';
import 'package:att_school/features/school/master/semester/models/semester_model.dart';
import 'package:att_school/features/school/master/subject/read/list/provider/read_subject_list_provider.dart';
import 'package:att_school/features/school/master/teacher/models/teacher_model.dart';
import 'package:att_school/features/school/master/teacher/read/detail/presentation/read_teacher_detail_page.dart';
import 'package:att_school/features/school/master/teacher/read/detail/provider/read_teacher_detail_provider.dart';
import 'package:att_school/features/school/data/teaching-assignment/data/teaching_assignment_model.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/field/app_field.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/elements/input/time/app_time_input.dart';
import 'package:att_school/shared/widgets/elements/input/app_many_input.dart';
import 'package:att_school/shared/widgets/elements/input/select/app_select_one_input.dart';
import 'package:att_school/shared/widgets/elements/input/text/app_text_input.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef Detail = ReadTeacherDetailProvider;
typedef User = ReadUserListProvider;
typedef Class = ReadClassListProvider;
typedef Subject = ReadSubjectListProvider;

// ============================================
// Model untuk Assignment Item
// ============================================
class AssignmentItem {
  Map<String, dynamic>? classData;
  Map<String, dynamic>? subject;
  Map<String, dynamic>? day;
  final TextEditingController startTime;
  final TextEditingController endTime;
  final TextEditingController room;
  bool errorClass;
  bool errorSubject;
  bool errorDay;
  bool errorStartTime;
  bool errorEndTime;

  AssignmentItem({
    this.classData,
    this.subject,
    this.day,
    TextEditingController? startTime,
    TextEditingController? endTime,
    TextEditingController? room,
    this.errorClass = false,
    this.errorSubject = false,
    this.errorDay = false,
    this.errorStartTime = false,
    this.errorEndTime = false,
  }) : startTime = startTime ?? TextEditingController(),
       endTime = endTime ?? TextEditingController(),
       room = room ?? TextEditingController();

  void dispose() {
    startTime.dispose();
    endTime.dispose();
    room.dispose();
  }

  bool validate() {
    errorClass = classData == null;
    errorSubject = subject == null;
    errorDay = day == null;
    errorStartTime = startTime.text.isEmpty;
    errorEndTime = endTime.text.isEmpty;

    return !(errorClass ||
        errorSubject ||
        errorDay ||
        errorStartTime ||
        errorEndTime);
  }

  void clearErrors() {
    errorClass = false;
    errorSubject = false;
    errorDay = false;
    errorStartTime = false;
    errorEndTime = false;
  }
}

// ============================================
// Main Form
// ============================================
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

  // Basic Info Controllers
  final _nipController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  // Assignment Items
  final List<AssignmentItem> _assignments = [];

  // Basic Info State
  String? _selectedEmail;
  String? _selectedGender;
  bool _errorNip = false;
  bool _errorName = false;
  bool _errorEmail = false;

  // Reference Data
  late List<String> _emails;
  late List<Map<String, dynamic>> _subjects;
  late List<Map<String, dynamic>> _classes;
  SemesterModel? _semester;
  AcademicYearModel? _academicYear;

  String _id = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeForm();
    });
  }

  @override
  void dispose() {
    _nipController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();

    for (var assignment in _assignments) {
      assignment.dispose();
    }

    super.dispose();
  }

  Future<void> _initializeForm() async {
    _id = widget.id ?? '';
    if (RolesProvider.me.isTeacher) _id = 'me';

    if (!mounted) return;

    final detail = context.read<Detail>();
    final emails = context.read<User>();
    final subjects = context.read<Subject>();
    final classes = context.read<Class>();
    final semester = context.read<ReadSemesterActiveProvider>();

    detail.ready = false;

    await semester.fetchActive();
    if (semester.error.isNotEmpty) return;

    // Load reference data
    _emails = emails.userEmails;
    _subjects = subjects.data;
    _classes = classes.data;
    _semester = semester.data;
    _academicYear = semester.academicYear;

    // Add first assignment
    _assignments.add(AssignmentItem());

    // Load existing data if editing
    if (widget.id != null) {
      await detail.fetchById(_id);
      if (detail.data != null) {
        _populateFormData(detail.data!);
      }
    }

    detail.ready = true;
    if (mounted) setState(() {});
  }

  void _populateFormData(TeacherModel data) {
    _assignments.clear();

    // Populate assignments
    for (final assignment in data.assignments ?? <TeachingAssignmentModel>[]) {
      for (final schedule in assignment.schedules ?? <ClassScheduleModel>[]) {
        _assignments.add(
          AssignmentItem(
            classData: assignment.class_?.toMap(),
            subject: assignment.subject?.toMap(),
            day: schedule.dayToForm,
            startTime: schedule.startTimeToForm,
            endTime: schedule.endTimeToForm,
            room: schedule.roomToForm,
          ),
        );
      }
    }

    // Ensure at least one assignment
    if (_assignments.isEmpty) {
      _assignments.add(AssignmentItem());
    }

    // Populate basic info
    _nipController.text = data.nip;
    _nameController.text = data.name;
    _selectedEmail = data.email;
    _phoneController.text = data.phone ?? '';
    _addressController.text = data.address ?? '';
    _selectedGender = data.gender;
  }

  bool _validateForm() {
    setState(() {
      _errorNip = _nipController.text.isEmpty;
      _errorName = _nameController.text.isEmpty;
      _errorEmail = _selectedEmail == null || _selectedEmail!.isEmpty;
    });

    bool assignmentsValid = true;
    for (var assignment in _assignments) {
      if (!assignment.validate()) {
        assignmentsValid = false;
      }
    }

    setState(() {});

    return !(_errorNip || _errorName || _errorEmail) && assignmentsValid;
  }

  Future<void> _handleSubmit() async {
    if (!_validateForm()) return;

    final result = await widget.onSubmit(
      TeacherModel(
        id: _id,
        nip: _nipController.text,
        name: _nameController.text,
        email: _selectedEmail!,
        phone: _phoneController.text,
        address: _addressController.text,
        gender: _selectedGender,
        semester: _semester,
        assignments: TeachingAssignmentModel.fromForm(
          class_: _assignments.map((a) => a.classData).toList(),
          subject: _assignments.map((a) => a.subject).toList(),
          semesterId: _semester!.id!,
          schedule: ClassScheduleModel.fromForm(
            days: _assignments.map((a) => a.day).toList(),
            startTime: _assignments.map((a) => a.startTime).toList(),
            endTime: _assignments.map((a) => a.endTime).toList(),
            room: _assignments.map((a) => a.room).toList(),
          ),
        ),
      ),
    );

    if (!mounted) return;

    await AppDialog.show(
      context,
      title: result.status ? 'Success' : 'Error',
      message: result.message,
    );

    if (result.status && mounted) {
      if (widget.editData == null) {
        final id = result.data['id'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ReadTeacherDetailPage(id)),
        );
      } else {
        Navigator.pop(context);
      }
    }
  }

  void _addAssignment() {
    final lastAssignment = _assignments.last;

    // Validate last assignment before adding new
    if (lastAssignment.classData == null ||
        lastAssignment.subject == null ||
        lastAssignment.day == null ||
        lastAssignment.startTime.text.isEmpty ||
        lastAssignment.endTime.text.isEmpty) {
      return;
    }

    setState(() {
      _assignments.add(AssignmentItem());
    });
  }

  void _removeAssignment(int index) {
    if (_assignments.length <= 1) return;

    setState(() {
      _assignments[index].dispose();
      _assignments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isReady = context.select<Detail, bool>((p) => p.isReady);

    return AppScreen(
      appBar: AppBar(title: Text(widget.title)),
      children: [
        AppText(widget.title, variant: AppTextVariant.h2),
        AppButton(
          "Save",
          onPressed: _handleSubmit,
          variant: AppButtonVariant.primary,
        ),
        if (isReady && _semester != null)
          Form(
            key: _formKey,
            child: Column(
              spacing: AppSize.medium,
              children: [
                _buildDataForm(),
                if (!RolesProvider.me.isTeacher) _buildDetailForm(),
              ],
            ),
          ),
      ],
    );
  }

  // ============================================
  // Data Form (Basic Info)
  // ============================================
  Widget _buildDataForm() {
    return AppSection(
      title: 'Data Guru',
      children: [
        AppTextInput(
          controller: _nipController,
          labelText: 'NIP',
          errorText: 'NIP Wajib Diisi',
          isError: _errorNip,
          onChanged: (_) => setState(() => _errorNip = false),
        ),
        AppTextInput(
          controller: _nameController,
          labelText: 'Nama',
          errorText: 'Nama Wajib Diisi',
          isError: _errorName,
          onChanged: (_) => setState(() => _errorName = false),
        ),
        AppSelectOneInput(
          items: _emails,
          labelText: 'Email',
          errorText: 'Email Wajib Diisi',
          isError: _errorEmail,
          initialValue: _selectedEmail,
          onChanged:
              (value) => setState(() {
                _selectedEmail = value;
                _errorEmail = false;
              }),
          showSearchBox: true,
          enabled: !RolesProvider.me.isTeacher,
        ),
        AppSelectOneInput(
          items: AppItems.genders,
          labelText: 'Gender',
          initialValue: _selectedGender,
          onChanged: (value) => setState(() => _selectedGender = value),
        ),
        AppTextInput(controller: _phoneController, labelText: 'Nomor Telepon'),
        AppTextInput(controller: _addressController, labelText: 'Alamat'),
      ],
    );
  }

  // ============================================
  // Detail Form (Assignments)
  // ============================================
  Widget _buildDetailForm() {
    return Column(
      spacing: AppSize.medium,
      children: [
        AppManyInput(
          label: 'Jadwal Mengajar',
          itemsCount: _assignments.length,
          onAdd: _addAssignment,
          onRemove: _removeAssignment,
          buildChild: (index) => _buildAssignmentFields(index),
        ),
        AppSection(
          title: 'Detail',
          children: [
            AppField('Semester', value: _semester?.name),
            AppField('Tahun Ajaran', value: _academicYear?.name),
          ],
        ),
      ],
    );
  }

  // ============================================
  // Assignment Fields (Extracted Widget)
  // ============================================
  List<Widget> _buildAssignmentFields(int index) {
    final assignment = _assignments[index];

    return [
      AppSelectOneInput(
        items: _classes,
        initialValue: assignment.classData,
        labelText: 'Kelas',
        errorText: 'Kelas Wajib Diisi',
        isError: assignment.errorClass,
        onChanged:
            (value) => setState(() {
              assignment.classData = value;
              assignment.errorClass = false;
            }),
        isFormatted: false,
        showSearchBox: true,
      ),
      AppSelectOneInput(
        items: _subjects,
        initialValue: assignment.subject,
        labelText: 'Mata Pelajaran',
        errorText: 'Mata Pelajaran Wajib Diisi',
        isError: assignment.errorSubject,
        onChanged:
            (value) => setState(() {
              assignment.subject = value;
              assignment.errorSubject = false;
            }),
        showSearchBox: true,
      ),
      AppSelectOneInput(
        items: AppItems.days,
        initialValue: assignment.day,
        labelText: 'Hari',
        errorText: 'Hari Wajib Diisi',
        isError: assignment.errorDay,
        onChanged:
            (value) => setState(() {
              assignment.day = value;
              assignment.errorDay = false;
            }),
      ),
      AppTimeInput(
        controller: assignment.startTime,
        initialValue: assignment.startTime.text,
        hintText: 'hh:mm',
        labelText: 'Waktu Mulai',
        errorText: 'Waktu Mulai Wajib Diisi',
        borderRadius: AppBorderRadius.left(AppSize.xSmall),
        isError: assignment.errorStartTime,
        onChanged: (_) => setState(() => assignment.errorStartTime = false),
      ),
      AppTimeInput(
        controller: assignment.endTime,
        initialValue: assignment.endTime.text,
        hintText: 'hh:mm',
        labelText: 'Waktu Selesai',
        errorText: 'Waktu Selesai Wajib Diisi',
        borderRadius: AppBorderRadius.left(AppSize.xSmall),
        isError: assignment.errorEndTime,
        onChanged: (_) => setState(() => assignment.errorEndTime = false),
      ),
      AppTextInput(controller: assignment.room, labelText: 'Ruangan'),
    ];
  }
}
