import 'package:att_school/core/constant/item/app_items.dart';
import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/border-radius/app_border_radius.dart';
import 'package:att_school/core/utils/formatter/date_formatter.dart';
import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/semester/models/semester_model.dart';
import 'package:att_school/features/admin/semester/read/detail/presentation/read_semester_detail_page.dart';
import 'package:att_school/features/admin/semester/read/detail/provider/read_semester_detail_provider.dart';
import 'package:att_school/features/admin/semester/read/list/provider/read_semester_list_provider.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/elements/input/app_date_input.dart';
import 'package:att_school/shared/widgets/elements/input/app_select_one_input.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SemesterFormScreen extends StatefulWidget {
  final String title;
  final Future<BackendMessageHelper> Function(SemesterModel data) onSubmit;
  final String? id;
  final SemesterModel? editData;

  const SemesterFormScreen(
    this.title, {
    super.key,
    required this.onSubmit,
    this.id,
    this.editData,
  });

  @override
  State<SemesterFormScreen> createState() => _SemesterFormScreenState();
}

class _SemesterFormScreenState extends State<SemesterFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _types = AppItems.semesterType;
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  List<Map<String, dynamic>> _academicYears = [];
  Map<String, dynamic>? _selectedAcademicYear;
  String? _selectedType;
  DateTime? _selectedStartDate, _selectedEndDate;
  bool _errorType = false;
  bool _errorAcademicYear = false;
  bool _errorStartDate = false;
  bool _errorEndDate = false;
  bool _errorStartAcademicYearDate = false;
  bool _errorEndAcademicYearDate = false;
  bool _errorDate = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (mounted) {
        final list = context.read<ReadSemesterListProvider>();
        final detail = context.read<ReadSemesterDetailProvider>();

        await list.fetchAllAcademicYears();

        setState(() => _academicYears = list.academicYears);

        if (widget.id != null) {
          await detail.fetchById(widget.id!);

          if (detail.semester != null) {
            final academicYear = {
              'id': detail.semester!.academicYearId,
              'name': detail.semester!.academicYear!,
            };

            final startDate = DateFormatter.toController(
              detail.semester!.startDate,
            );

            final endDate = DateFormatter.toController(
              detail.semester!.endDate,
            );

            setState(() {
              _selectedAcademicYear = academicYear;
              _selectedType = detail.semester!.type;
              _startDateController.text = startDate;
              _endDateController.text = endDate;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _onChangedType(String? value) {
    setState(() {
      _selectedType = value;
      _errorType = false;
    });
  }

  void _onChangedAcademicYear(Map<String, dynamic>? value) {
    setState(() {
      _selectedAcademicYear = value;
      _errorAcademicYear = false;
    });
  }

  void _onChangedStartDate(_) {
    if (_errorStartDate) setState(() => _errorStartDate = false);
  }

  void _onChangedEndDate(_) {
    if (_errorEndDate) setState(() => _errorEndDate = false);
  }

  bool _validate() {
    setState(() {
      _errorAcademicYear =
          _selectedAcademicYear == null || _selectedAcademicYear!.isEmpty;
      _errorType = _selectedType == null;
      _errorStartDate = _startDateController.text.isEmpty;
      _errorEndDate = _endDateController.text.isEmpty;
    });

    if (_errorAcademicYear || _errorType || _errorStartDate || _errorEndDate) {
      return false;
    }

    _selectedStartDate = DateFormatter.fromController(
      _startDateController.text,
    );
    _selectedEndDate = DateFormatter.fromController(_endDateController.text);

    setState(() {
      _errorDate = _selectedStartDate!.isAfter(_selectedEndDate!);
      _errorEndDate = _errorDate;
    });

    if (_errorEndDate) return false;

    final academicYear = _selectedAcademicYear!['name'].split('/');

    setState(() {
      _errorStartAcademicYearDate = _selectedStartDate!.isBefore(
        DateTime(int.parse(academicYear[0])),
      );

      _errorEndAcademicYearDate = _selectedEndDate!.isAfter(
        DateTime(int.parse(academicYear[1])),
      );
      
      _errorStartDate = _errorStartAcademicYearDate;
      _errorEndDate = _errorEndAcademicYearDate;
    });

    if (_errorStartDate || _errorEndDate) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      appBar: AppBar(title: Text(widget.title)),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSize.medium,
          children: [
            AppText(widget.title, variant: AppTextVariant.h2),
            AppButton(
              "Save",
              onPressed: () async {
                if (!_validate()) return;

                final result = await widget.onSubmit(
                  SemesterModel(
                    id: widget.editData?.id,
                    academicYearId: _selectedAcademicYear!['id'],
                    type: _selectedType!,
                    startDate: _selectedStartDate!,
                    endDate: _selectedEndDate!,
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
                          builder: (context) => ReadSemesterDetailPage(id),
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
                      items: _academicYears,
                      labelText: 'Tahun Akademik',
                      errorText: 'Tahun Akademik is required',
                      isError: _errorAcademicYear,
                      initialValue: _selectedAcademicYear,
                      onChanged: (value) => _onChangedAcademicYear(value),
                    ),
                    AppSelectOneInput(
                      items: _types,
                      labelText: 'Type',
                      errorText: 'Type is required',
                      isError: _errorType,
                      initialValue: _selectedType,
                      onChanged: (value) => _onChangedType(value),
                    ),
                    AppDateInput(
                      controller: _startDateController,
                      initialValue: _startDateController.text,
                      labelText: 'Tanggal Mulai',
                      hintText: 'dd/mm/yyyy',
                      errorText:
                          _errorStartAcademicYearDate
                              ? 'Tanggal Mulai tidak boleh sebelum Tahun Akademik'
                              : 'Tanggal Mulai Wajib Diisi',
                      borderRadius: AppBorderRadius.left(AppSize.xSmall),
                      isError: _errorStartDate,
                      onChanged: _onChangedStartDate,
                    ),
                    AppDateInput(
                      controller: _endDateController,
                      initialValue: _endDateController.text,
                      labelText: 'Tanggal Berakhir',
                      hintText: 'dd/mm/yyyy',
                      errorText:
                          _errorDate
                              ? 'Tanggal Berakhir tidak boleh sebelum Tanggal Mulai'
                              : _errorEndAcademicYearDate
                              ? 'Tanggal Berakhir tidak boleh melebihi Tahun Akademik'
                              : 'Tanggal Berakhir Wajib Diisi',
                      borderRadius: AppBorderRadius.left(AppSize.xSmall),
                      isError: _errorEndDate,
                      onChanged: _onChangedEndDate,
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
