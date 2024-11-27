import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Image.network(
              order.cartData.first.productImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.red);
              },
            ),
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
                SizedBox(width: 100.0, child: Text('${order.status}')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
