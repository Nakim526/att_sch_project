import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/admin/academic-year/academic_year_form_screen.dart';
import 'package:att_school/features/admin/academic-year/create/provider/create_academic_year_provider.dart';
import 'package:att_school/features/admin/academic-year/models/academic_year_model.dart';
import 'package:att_school/features/admin/academic-year/read/detail/presentation/read_academic_year_detail_page.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateAcademicYearScreen extends StatefulWidget {
  const CreateAcademicYearScreen({super.key});

  @override
  State<CreateAcademicYearScreen> createState() =>
      _CreateAcademicYearScreenState();
}

class _CreateAcademicYearScreenState extends State<CreateAcademicYearScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  DateTime? _startDate, _endDate;
  bool _errorStartDate = false;
  bool _errorEndDate = false;
  bool _errorDate = false;

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

  bool _validate() {
    setState(() {
      _errorStartDate = _startDateController.text.isEmpty;
      _errorEndDate = _endDateController.text.isEmpty;
    });

    if (_errorStartDate || _errorEndDate) return false;

    _startDate = DateFormat('dd/MM/yyyy').parse(_startDateController.text);
    _endDate = DateFormat('dd/MM/yyyy').parse(_endDateController.text);

    if (_startDate!.isAfter(_endDate!)) {
      setState(() {
        _errorEndDate = true;
        _errorDate = true;
      });

      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreateAcademicYearProvider>(context);

    return Stack(
      children: [
        AppScreen(
          appBar: AppBar(title: const Text('Create AcademicYear')),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSize.medium,
              children: [
                AppText("Create AcademicYear", variant: AppTextVariant.h2),
                AppButton(
                  "Save",
                  onPressed: () async {
                    if (!_validate()) return;

                    final name = "${_startDate!.year}/${_endDate!.year}";

                    debugPrint(name);
                    debugPrint(_startDate.toString());
                    debugPrint(_endDate.toString());

                    final result = await provider.createAcademicYear(
                      AcademicYearModel(
                        name: name,
                        startDate: _startDate!,
                        endDate: _endDate!,
                      ),
                    );

                    if (context.mounted) {
                      await AppDialog.show(
                        context,
                        title: result.status ? 'Success' : 'Error',
                        message: result.message,
                      );

                      if (result.status && context.mounted) {
                        final id = result.data['id'];
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadAcademicYearDetailPage(id),
                          ),
                        );
                      }
                    }
                  },
                  variant: AppButtonVariant.primary,
                ),
                AcademicYearFormScreen(
                  formKey: _formKey,
                  startDateController: _startDateController,
                  endDateController: _endDateController,
                  errorStartDate: _errorStartDate,
                  errorEndDate: _errorEndDate,
                  errorDate: _errorDate,
                  onChangedStartDate: _onChangedStartDate,
                  onChangedEndDate: _onChangedEndDate,
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
