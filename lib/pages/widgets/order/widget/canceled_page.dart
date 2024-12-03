import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_admin/components/table/custom_table.dart';

import '../../../../entities/models/order_model.dart';
import '../../../../services/remote/order_service.dart';

class CanceledPage extends StatefulWidget {
  const CanceledPage({super.key});

  @override
  State<CanceledPage> createState() => _CanceledPageState();
}

class _CanceledPageState extends State<CanceledPage> {
  final OrderService _orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<OrderModel>>(
        stream: _orderService.getOrdersByStatus('Cancelled'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(
              child: Text('No canceled orders.'),
            );
          }

          return CustomTable(
            columns: const [
              DataColumn(label: Text('Image')),
              DataColumn(label: Text('Order ID')),
              DataColumn(label: Text('Order Date')),
              DataColumn(label: Text('Customer Name')),
              DataColumn(label: Text('Total Products')),
              DataColumn(label: Text('Status')),
            ],
            rows: orders.map((order) {
              return DataRow(
                cells: [
                  DataCell(
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        order.cartData.first.productImage,
                        fit: BoxFit.cover,
                        width: 50.0,
                        height: 50.0,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, color: Colors.red);
                        },
                      ),
                    ),
                  ),
                  DataCell(Text(order.id ?? 'N/A')),
                  DataCell(Text(order.createdAt != null
                      ? DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt!)
                      : '-')),
                  DataCell(Text(order.name ?? 'Unknown')),
                  DataCell(Text('${order.totalProduct ?? 0}')),
                  DataCell(Text(order.status ?? 'N/A')),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
