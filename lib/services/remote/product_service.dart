import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../entities/models/add_product_model.dart';
import '../../entities/models/product_model.dart';
import '../../constants/define_collection.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách sản phẩm theo thời gian thực
  Stream<List<ProductModel>> fetchProductsStream() {
    return _firestore
        .collection(AppDefineCollection.APP_PRODUCT)
        .orderBy('createAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromJson(doc.data());
      }).toList();
    });
  }

  // Thêm sản phẩm mới
  Future<void> addNewProduct(AddProductModel product) async {
    try {
      String docId =
          _firestore.collection(AppDefineCollection.APP_PRODUCT).doc().id;
      String imageStoragePath =
          '/${AppDefineCollection.APP_PRODUCT}/${product.cateId}/$docId';

      String imageUrl = '';
      if (product.image != null) {
        final Reference ref =
            FirebaseStorage.instance.ref().child(imageStoragePath);
        final UploadTask uploadTask = ref.putData(product.image!);
        final TaskSnapshot downloadUrl = await uploadTask;
        imageUrl = await downloadUrl.ref.getDownloadURL();
      }

      await _firestore
          .collection(AppDefineCollection.APP_PRODUCT)
          .doc(docId)
          .set(
            ProductModel(
              id: docId,
              categoryId: product.cateId,
              name: product.productName,
              image: imageUrl,
              price: product.price,
              description: product.description,
              sold: 0,
              orderCount: 0,
              favourute: 0,
              quantity: product.quantity,
              createAt: Timestamp.now(),
            ).toJson(),
          );
    } catch (e) {
      throw Exception('Error adding new product: $e');
    }
  }

  // Cập nhật sản phẩm
  Future<void> updateProduct(String productId, AddProductModel product) async {
    try {
      String imageUrl = '';

      if (product.image != null) {
        String imageStoragePath =
            '/${AppDefineCollection.APP_PRODUCT}/${product.cateId}/$productId';

        try {
          final Reference oldRef =
              FirebaseStorage.instance.ref().child(imageStoragePath);
          await oldRef.delete();
        } catch (e) {
          // Ignore if no old image exists
        }

        final Reference ref =
            FirebaseStorage.instance.ref().child(imageStoragePath);
        final UploadTask uploadTask = ref.putData(product.image!);
        final TaskSnapshot downloadUrl = await uploadTask;
        imageUrl = await downloadUrl.ref.getDownloadURL();
      }

      final Map<String, dynamic> updateData = {
        'categoryId': product.cateId,
        'name': product.productName,
        'price': product.price,
        'description': product.description,
        'quantity': product.quantity,
      };

      if (imageUrl.isNotEmpty) {
        updateData['image'] = imageUrl;
      }

      await _firestore
          .collection(AppDefineCollection.APP_PRODUCT)
          .doc(productId)
          .update(updateData);
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  // Xóa sản phẩm
  Future<void> deleteProductById(String productId, {String? categoryId}) async {
    try {
      await _firestore
          .collection(AppDefineCollection.APP_PRODUCT)
          .doc(productId)
          .delete();

      String imageStoragePath =
          '/${AppDefineCollection.APP_PRODUCT}/${categoryId ?? ''}/$productId';

      final Reference ref =
          FirebaseStorage.instance.ref().child(imageStoragePath);
      final ListResult result = await FirebaseStorage.instance.ref().listAll();
      if (result.items.any((item) => item.fullPath == imageStoragePath)) {
        await ref.delete();
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }
}
