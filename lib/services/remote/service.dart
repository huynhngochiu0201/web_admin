import 'package:cloud_firestore/cloud_firestore.dart';
import '../../entities/models/service_model.dart';

class Service {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = "services";

  // Tạo mới service
  Future<void> createService(ServiceModel serviceModel) async {
    try {
      await _firestore.collection(collection).add(serviceModel.toJson());
      print("Service created successfully");
    } catch (e) {
      print("Error creating service: $e");
    }
  }

  // Lấy danh sách services qua Stream (Realtime)
  Stream<List<ServiceModel>> streamAllServices() {
    return _firestore.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return ServiceModel(
          name: data['name'],
          address: data['address'],
          phone: data['phone'],
          note: data['note'],
          service: data['service'],
          area: data['area'],
          payload: data['payload'],
          wheelSize: data['wheelSize'],
          totalPrice: data['totalPrice'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          status: data['status'],
          userId: doc.id, // Document ID
        );
      }).toList();
    });
  }

  // Cập nhật service
  Future<void> updateService(String id, String newStatus) async {
    try {
      DocumentReference docRef = _firestore.collection(collection).doc(id);

      // Kiểm tra tài liệu tồn tại
      DocumentSnapshot docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        print("Service with ID $id does not exist.");
        throw Exception("Service not found.");
      }

      // Cập nhật trạng thái
      await docRef.update({'status': newStatus});
      print("Service with ID $id updated successfully to $newStatus.");
    } catch (e) {
      print("Error updating service: $e");
      throw Exception("Failed to update service: $e");
    }
  }
}
