import 'package:cloud_firestore/cloud_firestore.dart';

class OrderAnalysisService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> getOrderStatsForMonth() async {
    try {
      DateTime now = DateTime.now();
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime endOfMonth = DateTime(now.year, now.month + 1, 1)
          .subtract(const Duration(days: 1));

      Map<String, int> stats = {
        'Delivered': 0,
        'Pending': 0,
        'Canceled': 0,
      };

      QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
          .where('createdAt', isLessThanOrEqualTo: endOfMonth)
          .get();

      for (var doc in snapshot.docs) {
        String status = doc['status'];
        if (stats.containsKey(status)) {
          stats[status] = stats[status]! + 1;
        }
      }

      return stats;
    } catch (e) {
      throw Exception('Error fetching order stats: $e');
    }
  }
}
