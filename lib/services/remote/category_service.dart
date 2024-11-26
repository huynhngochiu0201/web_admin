import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:web_admin/services/remote/product_service.dart';

import '../../constants/define_collection.dart';
import '../../entities/models/category_model.dart';

class CategoryService {
  final ProductService productService = ProductService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection(AppDefineCollection.APP_CATEGORY)
          .orderBy('createAt', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<void> addNewCategory({
    required String name,
    required Uint8List imageBytes,
  }) async {
    try {
      String docId =
          _firestore.collection(AppDefineCollection.APP_CATEGORY).doc().id;
      String imageStoragePath = '${AppDefineCollection.APP_CATEGORY}/$docId';
      final Reference ref = storage.ref().child(imageStoragePath);

      // Upload image
      final UploadTask uploadTask = ref.putData(imageBytes);
      final TaskSnapshot snapshot = await uploadTask;
      final String imageUrl = await snapshot.ref.getDownloadURL();

      // Create category data
      CategoryModel category = CategoryModel(
        id: docId,
        name: name,
        image: imageUrl,
        createAt: Timestamp.now(),
      );

      // Add to Firestore
      await _firestore
          .collection(AppDefineCollection.APP_CATEGORY)
          .doc(docId)
          .set(category.toJson());
    } catch (e) {
      throw Exception('Error adding new category: $e');
    }
  }

  Future<void> updateCategory({
    required String id,
    String? name,
    Uint8List? imageBytes,
  }) async {
    try {
      final Map<String, dynamic> categoryData = {
        'createAt': Timestamp.now(),
      };

      if (name != null) {
        categoryData['name'] = name;
      }

      if (imageBytes != null) {
        final String imageStoragePath =
            '${AppDefineCollection.APP_CATEGORY}/$id';
        final Reference ref = storage.ref().child(imageStoragePath);

        // Upload new image
        final UploadTask uploadTask = ref.putData(imageBytes);
        final TaskSnapshot snapshot = await uploadTask;
        final String imageUrl = await snapshot.ref.getDownloadURL();

        categoryData['image'] = imageUrl;
      }

      // Update Firestore
      await _firestore
          .collection(AppDefineCollection.APP_CATEGORY)
          .doc(id)
          .update(categoryData);
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      // Delete the category image from Firebase Storage
      final String imageStoragePath = '${AppDefineCollection.APP_CATEGORY}/$id';
      final Reference ref = storage.ref().child(imageStoragePath);
      await ref.delete();

      // Delete the category document from Firestore
      await _firestore
          .collection(AppDefineCollection.APP_CATEGORY)
          .doc(id)
          .delete();
    } catch (e) {
      throw Exception('Error deleting category: $e');
    }
  }
}
