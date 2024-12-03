import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_admin/components/table/custom_table.dart';
import 'package:web_admin/entities/models/order_model.dart';
import '../../../../services/remote/order_service.dart';

class PendingPage extends StatefulWidget {
  const PendingPage({super.key});

  @override
  State<PendingPage> createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  final OrderService _orderService = OrderService();
  final List<String> _statuses = ['Pending', 'Delivered', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<OrderModel>>(
        stream: _orderService.getOrdersByStatus('Pending'),
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
              child: Text('No orders to ship.'),
            );
          }

          return CustomTable(
            columns: [
              const DataColumn(label: Text('Image')),
              const DataColumn(label: Text('Order ID')),
              const DataColumn(label: Text('Order Date')),
              const DataColumn(label: Text('Customer Name')),
              const DataColumn(label: Text('Total Products')),
              const DataColumn(label: Text('Status')),
            ],
            rows: orders.map((order) {
              return DataRow(cells: [
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
                DataCell(Text(order.id ?? '-')),
                DataCell(Text(
                  order.createdAt != null
                      ? DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt!)
                      : '-',
                )),
                DataCell(Text(order.name ?? 'Unknown')),
                DataCell(Text('${order.totalProduct ?? 0}')),
                DataCell(
                  DropdownButton<String>(
                    value: order.status,
                    items:
                        _statuses.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newStatus) {
                      if (newStatus != null) {
                        _updateOrderStatus(order, newStatus);
                      }
                    },
                  ),
                ),
              ]);
            }).toList(),
          );
        },
      ),
    );
  }

  /// Hàm cập nhật trạng thái đơn hàng
  Future<void> _updateOrderStatus(OrderModel order, String newStatus) async {
    try {
      await _orderService.updateOrderStatus(order.id ?? '', newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order status updated to $newStatus'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update order status: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
