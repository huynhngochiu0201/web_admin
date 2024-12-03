// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../constants/define_collection.dart';
// import '../../constants/order_status.dart';

// class OrderAnalysisService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// Tính tổng số đơn hàng cho trạng thái trong tháng gần nhất
//   Future<Map<String, int>> getOrderStatsForLastMonth() async {
//     try {
//       // Lấy ngày đầu tiên của tháng hiện tại
//       DateTime now = DateTime.now();
//       DateTime startOfCurrentMonth = DateTime(now.year, now.month, 1);

//       // Ngày bắt đầu và kết thúc của tháng
//       DateTime startOfMonth =
//           startOfCurrentMonth.subtract(Duration(days: 30)); // 1 tháng trước
//       DateTime endOfMonth =
//           DateTime(startOfMonth.year, startOfMonth.month + 1, 1)
//               .subtract(const Duration(days: 1));

//       // Tạo map kết quả để lưu dữ liệu
//       Map<String, int> result = {
//         'Delivered': 0,
//         'Pending': 0,
//         'Canceled': 0,
//       };

//       // Lấy dữ liệu từ Firestore
//       QuerySnapshot snapshot = await _firestore
//           .collection(AppDefineCollection.APP_ORDER)
//           .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
//           .where('createdAt', isLessThanOrEqualTo: endOfMonth)
//           .get();

//       for (var doc in snapshot.docs) {
//         String status = doc['status'] ?? '';
//         if (status == OrderStatus.delivered) {
//           result['Delivered'] = result['Delivered']! + 1;
//         } else if (status == OrderStatus.pending) {
//           result['Pending'] = result['Pending']! + 1;
//         } else if (status == OrderStatus.cancelled) {
//           result['Canceled'] = result['Canceled']! + 1;
//         }
//       }

//       return result;
//     } catch (e) {
//       throw Exception('Error fetching order stats: $e');
//     }
//   }
// }
