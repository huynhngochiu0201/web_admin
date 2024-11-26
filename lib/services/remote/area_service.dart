import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/define_collection.dart';
import '../../entities/models/area_model.dart';

class AreaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AreaModel>> fetchAllAreasByCreateAt() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppDefineCollection.APP_AREA)
          .orderBy('createAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return AreaModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }

  Future<void> addArea({
    required String name,
    required double price,
  }) async {
    try {
      String docId =
          _firestore.collection(AppDefineCollection.APP_AREA).doc().id;
      AreaModel newArea = AreaModel(
        id: docId,
        name: name,
        price: price,
        createAt: Timestamp.now(),
      );

      await _firestore
          .collection(AppDefineCollection.APP_AREA)
          .doc(docId)
          .set(newArea.toJson());

      print('Service added successfully!');
    } catch (e) {
      throw Exception('Failed to add area: $e');
    }
  }

  Future<void> deleteAreaById(String areaId) async {
    try {
      await _firestore
          .collection(AppDefineCollection.APP_AREA)
          .doc(areaId)
          .delete();
      print('Area deleted successfully!');
    } catch (e) {
      throw Exception('Failed to delete service: $e');
    }
  }

  Future<void> updateAreaById(
    String id,
    String name,
    double price,
  ) async {
    try {
      await _firestore.collection(AppDefineCollection.APP_AREA).doc(id).update({
        'name': name,
        'price': price,
        'updateAt': Timestamp.now(),
      });
      print('Area updated successfully!');
    } catch (e) {
      throw Exception('Failed to update area: $e');
    }
  }
}
