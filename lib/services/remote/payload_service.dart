import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/define_collection.dart';
import '../../entities/models/payload_model.dart';

class PayloadService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PayloadModel>> fetchAllPayloadsByCreateAt() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppDefineCollection.APP_PAYLOAD)
          .orderBy('createAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add id to the data map
        return PayloadModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch payloads: $e');
    }
  }

  Future<void> addPayload({
    required String name,
    required double price,
  }) async {
    try {
      String docId =
          _firestore.collection(AppDefineCollection.APP_PAYLOAD).doc().id;
      PayloadModel newPayload = PayloadModel(
        id: docId,
        name: name,
        price: price,
        createAt: Timestamp.now(),
      );

      await _firestore
          .collection(AppDefineCollection.APP_PAYLOAD)
          .doc(docId)
          .set(newPayload.toJson());

      print('Payload added successfully!');
    } catch (e) {
      throw Exception('Failed to add payload: $e');
    }
  }

  Future<void> deletePayloadById(String payloadId) async {
    try {
      await _firestore
          .collection(AppDefineCollection.APP_PAYLOAD)
          .doc(payloadId)
          .delete();
      print('Payload deleted successfully!');
    } catch (e) {
      throw Exception('Failed to delete payload: $e');
    }
  }

  Future<void> updatePayloadById(
    String id,
    String name,
    double price,
  ) async {
    await FirebaseFirestore.instance.collection('payloads').doc(id).update({
      'name': name,
      'price': price,
    });
  }

  Future<void> updatePayload({
    required String id,
    required String name,
    required double price,
  }) async {
    // Implement your update service API call here
  }
}
