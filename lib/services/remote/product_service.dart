import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../entities/models/add_product_model.dart';
import '../../entities/models/product_model.dart';
import '../../constants/define_collection.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Thêm sản phẩm mới
  Future<void> addNewProduct(AddProductModel product) async {
    try {
      String docId =
          _firestore.collection(AppDefineCollection.APP_PRODUCT).doc().id;
      String imageStoragePath =
          '/${AppDefineCollection.APP_PRODUCT}/${product.cateId}/$docId';

      String imageUrl = '';
      if (product.image != null) {
        final Reference ref = _storage.ref().child(imageStoragePath);
        final UploadTask uploadTask = ref.putData(product.image!);
        final TaskSnapshot downloadUrl = await uploadTask;
        imageUrl = await downloadUrl.ref.getDownloadURL();
      }

      await _firestore
          .collection(AppDefineCollection.APP_PRODUCT)
          .doc(docId)
          .set(ProductModel(
            id: docId,
            categoryId: product.cateId,
            name: product.productName,
            image: imageUrl,
            price: product.price,
            description: product.description,
            viewCount: 0,
            orderCount: 0,
            favourute: 0,
            quantity: product.quantity,
            createAt: Timestamp.now(),
          ).toJson());
    } catch (e) {
      throw Exception('Error adding new product: $e');
    }
  }

  // Cập nhật sản phẩm
  Future<void> updateProduct(AddProductModel product) async {
    try {
      String imageId = product.id!;
      String imageStoragePath =
          '/${AppDefineCollection.APP_PRODUCT}/${product.cateId}/$imageId';

      final Map<String, dynamic> productData = product.toJson();

      if (product.image != null) {
        final Reference ref = _storage.ref().child(imageStoragePath);
        final UploadTask uploadTask = ref.putData(product.image!);
        final TaskSnapshot taskSnapshot = await uploadTask;
        final String imageUrl = await taskSnapshot.ref.getDownloadURL();
        productData['image'] = imageUrl;
      }

      await _firestore
          .collection(AppDefineCollection.APP_PRODUCT)
          .doc(product.id)
          .update(productData);
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  // Xóa sản phẩm theo ID
  Future<void> deleteProductById(String productId, {String? categoryId}) async {
    try {
      // Xóa sản phẩm từ Firestore
      await _firestore
          .collection(AppDefineCollection.APP_PRODUCT)
          .doc(productId)
          .delete();

      // Xóa ảnh sản phẩm từ Firebase Storage nếu tồn tại
      String imageStoragePath =
          '/${AppDefineCollection.APP_PRODUCT}/${categoryId ?? ''}/$productId';
      final Reference ref = _storage.ref().child(imageStoragePath);

      final ListResult result = await _storage.ref().listAll();
      if (result.items.any((item) => item.fullPath == imageStoragePath)) {
        await ref.delete();
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }

  // Lấy tất cả sản phẩm, sắp xếp theo ngày tạo
  Future<List<ProductModel>> fetchAllProductsByCreateAt() async {
    try {
      final querySnapshot = await _firestore
          .collection(AppDefineCollection.APP_PRODUCT)
          .orderBy('createAt', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Tìm kiếm sản phẩm
  Future<List<ProductModel>> searchProducts(String searchText) async {
    String searchTermLower = searchText.toLowerCase();
    List<ProductModel> matchedProducts = [];

    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(AppDefineCollection.APP_PRODUCT).get();
      for (var doc in querySnapshot.docs) {
        String nameLower = doc['name'].toLowerCase();
        if (nameLower.contains(searchTermLower)) {
          matchedProducts
              .add(ProductModel.fromJson(doc.data() as Map<String, dynamic>));
        }
      }
      return matchedProducts;
    } catch (e) {
      throw Exception('Error searching products: $e');
    }
  }
}
