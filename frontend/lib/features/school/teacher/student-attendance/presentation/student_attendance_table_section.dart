import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:att_school/core/utils/extensions/theme_extension.dart';
import 'package:att_school/features/school/data/attendance/models/attendance_model.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';

class StudentAttendanceTableSection extends StatefulWidget {
  final List<AttendanceModel> students;
  final Function(String studentId, AttendanceStatus status) onStatusChanged;
  final double nameColumnWidth;
  final bool readOnly;

  const StudentAttendanceTableSection({
    super.key,
    required this.students,
    required this.onStatusChanged,
    this.nameColumnWidth = 200.0,
    this.readOnly = false,
  });

  @override
  State<StudentAttendanceTableSection> createState() =>
      _AppAttendanceTableState();
}

class _AppAttendanceTableState extends State<StudentAttendanceTableSection> {
  // Status labels dan colors
  final Map<AttendanceStatus, String> statusLabels = {
    AttendanceStatus.present: 'Hadir',
    AttendanceStatus.sick: 'Sakit',
    AttendanceStatus.permission: 'Izin',
    AttendanceStatus.absent: 'Alpa',
    AttendanceStatus.late: 'Terlambat',
  };

  final Map<AttendanceStatus, Color> statusColors = {
    AttendanceStatus.present: Colors.green,
    AttendanceStatus.sick: Colors.orange,
    AttendanceStatus.permission: Colors.blue,
    AttendanceStatus.absent: Colors.red,
    AttendanceStatus.late: Colors.amber,
  };

  void _onStatusTap(AttendanceModel student, AttendanceStatus newStatus) {
    if (widget.readOnly) return;

    setState(() {
      // Toggle: jika status sama, set null (uncheck)
      if (student.status == newStatus) {
        student.status = null;
      } else {
        student.status = newStatus;
        widget.onStatusChanged(student.id, newStatus);
      }
    });
  }

  Widget _buildStatusCell(AttendanceModel student, AttendanceStatus status) {
    final isSelected = student.status == status;
    final color = statusColors[status]!;

    return GestureDetector(
      onTap: () => _onStatusTap(student, status),
      child: Container(
        padding: AppSpacing.all(AppSize.small),
        child: Center(
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color : Colors.transparent,
              border: Border.all(color: color, width: 2),
            ),
            child:
                isSelected
                    ? Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
          ),
        ),
      ),
    );
  }

  DataRow _buildRow(AttendanceModel student) {
    return DataRow(
      cells: [
        // Nama Siswa
        DataCell(
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: widget.nameColumnWidth,
              maxWidth: widget.nameColumnWidth,
            ),
            child: Padding(
              padding: AppSpacing.vertical(AppSize.small),
              child: AppText(
                student.name,
                variant: AppTextVariant.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),

        // Status: Hadir
        DataCell(_buildStatusCell(student, AttendanceStatus.present)),

        // Status: Sakit
        DataCell(_buildStatusCell(student, AttendanceStatus.sick)),

        // Status: Izin
        DataCell(_buildStatusCell(student, AttendanceStatus.permission)),

        // Status: Alpa
        DataCell(_buildStatusCell(student, AttendanceStatus.absent)),

        // Status: Terlambat
        DataCell(_buildStatusCell(student, AttendanceStatus.late)),
      ],
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: AppSpacing.all(AppSize.medium),
      decoration: BoxDecoration(
        color: context.sectionContainer,
        borderRadius: BorderRadius.circular(AppSize.small),
        border: Border.all(color: context.outline, width: AppSize.tiny),
      ),
      child: Wrap(
        spacing: AppSize.large,
        runSpacing: AppSize.small,
        children:
            AttendanceStatus.values.map((status) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColors[status],
                    ),
                  ),
                  const SizedBox(width: AppSize.small),
                  AppText(
                    statusLabels[status]!,
                    variant: AppTextVariant.caption,
                  ),
                ],
              );
            }).toList(),
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
      spacing: AppSize.medium,
      children: [
        // Legend
        _buildLegend(),

        // Table
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            horizontalMargin: AppSize.small,
            columnSpacing: AppSize.medium,
            columns: [
              DataColumn(
                label: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: widget.nameColumnWidth,
                    maxWidth: widget.nameColumnWidth,
                  ),
                  child: AppText(
                    'Nama Siswa',
                    variant: AppTextVariant.subtitle,
                  ),
                ),
              ),
              DataColumn(
                label: AppText('Hadir', variant: AppTextVariant.subtitle),
              ),
              DataColumn(
                label: AppText('Sakit', variant: AppTextVariant.subtitle),
              ),
              DataColumn(
                label: AppText('Izin', variant: AppTextVariant.subtitle),
              ),
              DataColumn(
                label: AppText('Alpa', variant: AppTextVariant.subtitle),
              ),
              DataColumn(
                label: AppText('Terlambat', variant: AppTextVariant.subtitle),
              ),
            ],
            headingRowHeight: AppSize.xxLarge,
            dataRowMinHeight: AppSize.zero,
            dataRowMaxHeight:
                AppSize.xxLarge * 1.5, // Lebih tinggi untuk 2 baris nama
            border: TableBorder(
              horizontalInside: BorderSide(
                color: context.outline,
                width: AppSize.tiny,
              ),
            ),
            dividerThickness: AppSize.zero,
            rows: widget.students.map(_buildRow).toList(),
          ),
        ),

        // Summary (opsional)
        if (widget.students.isNotEmpty) _buildSummary(),
      ],
    );
  }

  Widget _buildSummary() {
    final totalStudents = widget.students.length;
    final filled = widget.students.where((s) => s.status != null).length;
    final notFilled = totalStudents - filled;

    // Count per status
    final countByStatus = <AttendanceStatus, int>{};
    for (var status in AttendanceStatus.values) {
      countByStatus[status] =
          widget.students.where((s) => s.status == status).length;
    }

    return Container(
      padding: AppSpacing.all(AppSize.medium),
      decoration: BoxDecoration(
        color: context.sectionContainer,
        borderRadius: BorderRadius.circular(AppSize.small),
        border: Border.all(color: context.outline, width: AppSize.tiny),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('Ringkasan', variant: AppTextVariant.subtitle),
          const SizedBox(height: AppSize.small),
          Wrap(
            spacing: AppSize.large,
            runSpacing: AppSize.small,
            children: [
              _buildSummaryItem('Total Siswa', totalStudents.toString()),
              _buildSummaryItem('Sudah Diisi', filled.toString(), Colors.green),
              _buildSummaryItem(
                'Belum Diisi',
                notFilled.toString(),
                Colors.red,
              ),
              const SizedBox(width: AppSize.large),
              ...AttendanceStatus.values.map((status) {
                final count = countByStatus[status] ?? 0;
                if (count == 0) return const SizedBox.shrink();
                return _buildSummaryItem(
                  statusLabels[status]!,
                  count.toString(),
                  statusColors[status],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, [Color? color]) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText('$label: ', variant: AppTextVariant.caption),
        AppText(value, variant: AppTextVariant.body, color: color),
      ],
    );
  }
}
