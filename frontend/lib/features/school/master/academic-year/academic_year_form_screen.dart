import 'package:att_school/core/constant/item/app_items.dart';
import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/border-radius/app_border_radius.dart';
import 'package:att_school/core/utils/formatter/date_formatter.dart';
import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/features/school/master/academic-year/models/academic_year_model.dart';
import 'package:att_school/features/school/master/academic-year/read/detail/presentation/read_academic_year_detail_page.dart';
import 'package:att_school/features/school/master/academic-year/read/detail/provider/read_academic_year_detail_provider.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/elements/input/date/app_date_input.dart';
import 'package:att_school/shared/widgets/elements/input/select/app_select_one_input.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AcademicYearFormScreen extends StatefulWidget {
  final String title;
  final Future<BackendMessageHelper> Function(AcademicYearModel data) onSubmit;
  final String? id;
  final AcademicYearModel? editData;

  const AcademicYearFormScreen(
    this.title, {
    super.key,
    required this.onSubmit,
    this.id,
    this.editData,
  });

  @override
  State<AcademicYearFormScreen> createState() => _AcademicYearFormScreenState();
}

class _AcademicYearFormScreenState extends State<AcademicYearFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _status = AppItems.status;
  DateTime? _startDate, _endDate;
  String? _selectedStatus;
  bool _errorStartDate = false;
  bool _errorEndDate = false;
  bool _errorDate = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (mounted) {
        final detail = context.read<ReadAcademicYearDetailProvider>();

        detail.ready = false;

        setState(() => _selectedStatus = 'TIDAK AKTIF');

        if (widget.id != null) {
          await detail.fetchById(widget.id!);

          final detailData = detail.data;

          if (detailData != null) {
            final startDate = DateFormatter.toController(detailData.startDate);
            final endDate = DateFormatter.toController(detailData.endDate);

            setState(() {
              _startDateController.text = startDate;
              _endDateController.text = endDate;
              _selectedStatus = detailData.isActive! ? 'AKTIF' : 'TIDAK AKTIF';
            });
          }
        }

        detail.ready = true;
      }
    });
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _onChangedStartDate(_) {
    if (_errorStartDate) setState(() => _errorStartDate = false);
  }

  void _onChangedEndDate(_) {
    if (_errorEndDate) setState(() => _errorEndDate = false);
  }

  dynamic _onChangedStatus(dynamic value) {
    setState(() => _selectedStatus = value);
  }

  bool _validate() {
    setState(() {
      _errorStartDate = _startDateController.text.isEmpty;
      _errorEndDate = _endDateController.text.isEmpty;
    });

    if (_errorStartDate || _errorEndDate) return false;

    _startDate = DateFormatter.fromController(_startDateController.text);
    _endDate = DateFormatter.fromController(_endDateController.text);

    setState(() {
      _errorDate = _startDate!.isAfter(_endDate!);
      _errorEndDate = _errorDate;
    });

    if (_errorEndDate) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<ReadAcademicYearDetailProvider>();

    return AppScreen(
      appBar: AppBar(title: Text(widget.title)),
      children: [
        AppText(widget.title, variant: AppTextVariant.h2),
        AppButton(
          "Save",
          onPressed: () async {
            if (!_validate()) return;

            final result = await widget.onSubmit(
              AcademicYearModel(
                id: widget.id,
                name: "${_startDate!.year}/${_endDate!.year}",
                startDate: _startDate!,
                endDate: _endDate!,
                isActive: _selectedStatus == 'AKTIF',
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
                      builder: (context) => ReadAcademicYearDetailPage(id),
                    ),
                  );
                  return;
                }
                Navigator.pop(context);
              }
            }
          },
          variant: AppButtonVariant.primary,
        ),
        if (detail.isReady)
          Form(
            key: _formKey,
            child: AppSection(
              title: 'Tahun Ajaran',
              children: [
                AppDateInput(
                  controller: _startDateController,
                  initialValue: _startDateController.text,
                  labelText: 'Start Date',
                  hintText: 'dd/mm/yyyy',
                  errorText: 'Start Date Wajib Diisi',
                  borderRadius: AppBorderRadius.left(AppSize.xSmall),
                  isError: _errorStartDate,
                  onChanged: _onChangedStartDate,
                ),
                AppDateInput(
                  controller: _endDateController,
                  initialValue: _endDateController.text,
                  labelText: 'End Date',
                  hintText: 'dd/mm/yyyy',
                  errorText:
                      _errorDate
                          ? 'End Date must be after Start Date'
                          : 'End Date Wajib Diisi',
                  borderRadius: AppBorderRadius.left(AppSize.xSmall),
                  isError: _errorEndDate,
                  onChanged: _onChangedEndDate,
                ),
                AppSelectOneInput(
                  items: _status,
                  labelText: 'Status',
                  initialValue: _selectedStatus,
                  onChanged: _onChangedStatus,
                  enabled: widget.id != null,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
