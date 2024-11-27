import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderCard(order);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(),
            child: order.cartData.isNotEmpty
                ? ClipRRect(
                    child: Image.network(
                      order.cartData.first.productImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, color: Colors.red);
                      },
                    ),
                  )
                : const Icon(Icons.local_shipping,
                    size: 40, color: Colors.blue),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order ID: ${order.id}'),
                    Text(
                        'Order Date: ${order.createdAt != null ? DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt!) : '-'}'),
                  ],
                ),
                const SizedBox(width: 20.0),
                SizedBox(width: 150.0, child: Text(order.name ?? "Unknown")),
                SizedBox(
                    width: 100.0, child: Text('${order.totalProduct ?? 0}')),
                DropdownButton<String>(
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  value: order.status,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? newStatus) {
                    if (newStatus != null) {
                      _updateOrderStatus(order, newStatus);
                    }
                  },
                  items:
                      _statuses.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
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
