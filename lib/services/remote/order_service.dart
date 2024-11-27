import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/define_collection.dart';
import '../../constants/order_status.dart';
import '../../entities/models/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lấy tất cả đơn hàng
  Stream<List<OrderModel>> getAllOrders() {
    return _firestore
        .collection(AppDefineCollection.APP_ORDER)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromJson(doc)).toList();
    });
  }

  Stream<List<OrderModel>> getOrdersByStatus(String status) {
    return _firestore
        .collection('orders')
        .where('status', isEqualTo: status) // Chỉ lọc
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromJson(doc)).toList();
    });
  }

  /// Cập nhật trạng thái đơn hàng
  Future<void> updateOrderStatus(String orderId, String status) async {
    if (!OrderStatus.values.contains(status)) {
      throw Exception("Invalid status");
    }

    await _firestore
        .collection(AppDefineCollection.APP_ORDER)
        .doc(orderId)
        .update({
      'status': status,
    });
  }

  /// Lấy thông tin đơn hàng chi tiết theo ID
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final doc = await _firestore
          .collection(AppDefineCollection.APP_ORDER)
          .doc(orderId)
          .get();
      if (!doc.exists) {
        throw Exception("Order not found");
      }

      return OrderModel.fromJson(doc);
    } catch (e) {
      throw Exception('Error fetching order by ID: $e');
    }
  }

  /// Tìm kiếm đơn hàng theo tên hoặc ID
  Future<List<OrderModel>> searchOrders(String query) async {
    try {
      final snapshot = await _firestore
          .collection(AppDefineCollection.APP_ORDER)
          .where('userName', isGreaterThanOrEqualTo: query)
          .where('userName', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return snapshot.docs.map((doc) => OrderModel.fromJson(doc)).toList();
    } catch (e) {
      throw Exception('Error searching orders: $e');
    }
  }
}
