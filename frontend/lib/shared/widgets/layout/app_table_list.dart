import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:att_school/core/utils/extensions/theme_extension.dart';
// import 'package:att_school/core/utils/formatter/currency_formatter.dart';
// import 'package:att_school/core/utils/formatter/date_time_formatter.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';

class AppTableList extends StatefulWidget {
  final Map<String, String> columns;
  final Map<String, String? Function(dynamic value)>? customData;
  final List<Map<String, dynamic>> data;
  final List<String> cellLink;
  final Function(String) onDetail;
  final Function(dynamic) onRemove;
  final double? nameColumnWidth;
  final bool hasAction;
  final bool hasPagination;
  final double minWidth;
  final double maxWidth;

  const AppTableList({
    super.key,
    required this.columns,
    this.customData,
    required this.data,
    required this.cellLink,
    required this.onDetail,
    required this.onRemove,
    this.nameColumnWidth,
    this.hasAction = true,
    this.hasPagination = true,
    this.minWidth = 80,
    this.maxWidth = 500,
  });

  @override
  State<AppTableList> createState() => _AppTableListState();
}

class _AppTableListState extends State<AppTableList> {
  int currentPage = 0;
  int rowsPerPage = 5;

  final List<int> rowsPerPageOptions = [5, 10, 20, 30, 50];

  int get totalPages => (widget.data.length / rowsPerPage).ceil();

  List<Map<String, dynamic>> get paginatedData {
    if (!widget.hasPagination) return widget.data;

    final start = currentPage * rowsPerPage;
    final end = (start + rowsPerPage).clamp(0, widget.data.length);
    return widget.data.sublist(start, end);
  }

  DataRow _buildRow(Map<String, dynamic> detail) {
    return DataRow(
      cells: [
        ...widget.columns.values.map((key) {
          dynamic value = detail[key];

          if (widget.customData != null) {
            if (widget.customData!.containsKey(key)) {
              value = widget.customData![key]!(value);
            }
          }

          if (widget.cellLink.contains(key)) {
            return DataCell(
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth:
                      key == 'name'
                          ? widget.nameColumnWidth ?? 120
                          : widget.minWidth,
                  maxWidth: widget.maxWidth,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        value ?? '',
                        variant: AppButtonVariant.link,
                        onPressed: () => widget.onDetail(detail['id']),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return DataCell(
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: key == 'grade' ? 50 : widget.minWidth,
                maxWidth: widget.maxWidth,
              ),
              child: Row(
                children: [
                  if (value is String)
                    Expanded(
                      child: AppText(
                        value,
                        variant: AppTextVariant.body,
                        textAlign: key == 'grade' ? TextAlign.center : null,
                      ),
                    )
                  else
                    Expanded(
                      child: AppText(
                        value != null ? value.toString() : '',
                        variant: AppTextVariant.body,
                        textAlign: key == 'grade' ? TextAlign.center : null,
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
        if (widget.hasAction)
          DataCell(
            IconButton(
              padding: AppSpacing.none,
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => widget.onRemove(detail),
            ),
          ),
      ],
    );
  }

  Widget _paginationFooter() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: context.outline, width: AppSize.tiny),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Rows per page
          Row(
            children: [
              AppText('Rows:', variant: AppTextVariant.body),
              const SizedBox(width: AppSize.small),
              DropdownButton<int>(
                value: rowsPerPage,
                dropdownColor: context.surface,
                isDense: true,
                items:
                    rowsPerPageOptions.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: AppText(
                          e.toString(),
                          variant: AppTextVariant.body,
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    rowsPerPage = value!;
                    currentPage = 0;
                  });
                },
              ),
            ],
          ),

          // Page info + navigation
          Row(
            children: [
              AppText(
                '${currentPage * rowsPerPage + 1}'
                '–${((currentPage + 1) * rowsPerPage).clamp(0, widget.data.length)}'
                ' of ${widget.data.length}',
                variant: AppTextVariant.body,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed:
                    currentPage > 0
                        ? () => setState(() => currentPage--)
                        : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed:
                    currentPage < totalPages - 1
                        ? () => setState(() => currentPage++)
                        : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppSection(
      padding: AppSpacing.symetric(
        horizontal: AppSize.medium,
        vertical: AppSize.small,
      ),
      spacing: AppSize.zero,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            horizontalMargin: AppSize.small,
            columnSpacing: AppSize.large,
            columns: [
              ...widget.columns.keys.map(
                (key) => DataColumn(
                  label: AppText(key, variant: AppTextVariant.subtitle),
                ),
              ),
              if (widget.hasAction)
                const DataColumn(
                  label: SizedBox(),
                  columnWidth: FixedColumnWidth(70),
                ),
            ],
            headingRowHeight: AppSize.xxLarge,
            dataRowMinHeight: AppSize.zero,
            dataRowMaxHeight: AppSize.xxLarge,
            border: TableBorder(
              horizontalInside: BorderSide(
                color: context.outline,
                width: AppSize.tiny,
              ),
            ),
            dividerThickness: AppSize.zero,
            rows: paginatedData.map(_buildRow).toList(),
          ),
        ),

        if (widget.hasPagination) _paginationFooter(),
      ],
    );
  }
}
