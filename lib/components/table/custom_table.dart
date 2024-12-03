import 'package:flutter/material.dart';
import 'package:web_admin/constants/app_color.dart';

class CustomTable extends StatelessWidget {
  const CustomTable({super.key, required this.columns, required this.rows});
  final List<DataColumn> columns;
  final List<DataRow> rows;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: DataTable(
          dataRowHeight: 60,
          headingRowHeight: 50,
          headingRowColor: WidgetStatePropertyAll(AppColor.grey200),
          columns: columns,
          rows: rows,
        ));
  }
}
