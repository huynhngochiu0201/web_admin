import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/define_collection.dart';
import '../../entities/models/wheel_size_model.dart';

class WheelSizeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<WheelSizeModel>> fetchAllWheelSizesByCreateAt() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppDefineCollection.APP_WHEEL_SIZE)
          .orderBy('createAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add id to the data map
        return WheelSizeModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch wheel sizes: $e');
    }
  }

  Future<void> addWheelSize({
    required String name,
    required double price,
  }) async {
    try {
      String docId =
          _firestore.collection(AppDefineCollection.APP_WHEEL_SIZE).doc().id;
      WheelSizeModel newWheelSize = WheelSizeModel(
        id: docId,
        name: name,
        price: price,
        createAt: Timestamp.now(),
      );

      await _firestore
          .collection(AppDefineCollection.APP_WHEEL_SIZE)
          .doc(docId)
          .set(newWheelSize.toJson());

      print('Service added successfully!');
    } catch (e) {
      throw Exception('Failed to add wheel size: $e');
    }
  }

  Future<void> deleteWheelSizeById(String wheelSizeId) async {
    try {
      await _firestore
          .collection(AppDefineCollection.APP_WHEEL_SIZE)
          .doc(wheelSizeId)
          .delete();
      print('Wheel size deleted successfully!');
    } catch (e) {
      throw Exception('Failed to delete wheel size: $e');
    }
  }

  Future<void> updateWheelSizeById(
    String id,
    String name,
    double price,
  ) async {
    try {
      await _firestore  
          .collection(AppDefineCollection.APP_WHEEL_SIZE)
          .doc(id)
          .update({
        'name': name,
        'price': price,
      });
      print('Wheel size updated successfully!');
    } catch (e) {
      throw Exception('Failed to update wheel size: $e');
    }
  }
}
