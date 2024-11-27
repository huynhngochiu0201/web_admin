import 'package:flutter/material.dart';

import '../../../../constants/columndata.dart';

class DeliveredPage extends StatefulWidget {
  const DeliveredPage({super.key});

  @override
  State<DeliveredPage> createState() => _DeliveredPageState();
}

class _DeliveredPageState extends State<DeliveredPage> {
  List<ColumnData> get columns => const [
        ColumnData(title: 'Order ID', width: 100),
        ColumnData(title: 'Name', width: 100),
        ColumnData(title: 'Items', width: 60),
        ColumnData(title: 'Order Status', width: 90),
      ];

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
      child: Row(
        children: [
          for (var i = 0; i < columns.length; i++) ...[
            SizedBox(
              width: columns[i].width,
              child: Text(columns[i].title),
            ),
            if (i == 0) const SizedBox(width: 400.0),
            if (i > 0 && i < columns.length - 1) const SizedBox(width: 150.0),
            if (i == columns.length - 1) const SizedBox(width: 10.0),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTableHeader(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order ID: 1234567890'),
                            Text('Order Date: 2024-01-01'),
                          ],
                        ),
                        const SizedBox(width: 20.0),
                        const SizedBox(
                            width: 150.0, child: Text('Name: Nguyen Van A')),
                        const SizedBox(width: 100.0, child: Text('Items')),
                        const SizedBox(
                            width: 100.0, child: Text('Order Status')),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
