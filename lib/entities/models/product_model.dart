import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String categoryId;
  final String name;
  final String image;
  final double price;
  final String description;
  final int viewCount;
  final int orderCount;
  final int quantity;
  final int? favourute;
  final Timestamp? createAt;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.viewCount,
    required this.orderCount,
    this.favourute,
    required this.quantity,
    this.createAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      viewCount: json['viewCount'] ?? 0,
      orderCount: json['orderCount'] ?? 0,
      quantity: json['quantity'] ?? 0,
      favourute: json['favourute'],
      createAt: json['createAt'],
    );
  }

  factory ProductModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      categoryId: data['categoryId'] ?? '',
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      viewCount: data['viewCount'] ?? 0,
      orderCount: data['orderCount'] ?? 0,
      quantity: data['quantity'] ?? 0,
      favourute: data['favourute'],
      createAt: data['createAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'name': name,
        'image': image,
        'price': price,
        'description': description,
        'viewCount': viewCount,
        'orderCount': orderCount,
        'quantity': quantity,
        'favourute': favourute,
        'createAt': createAt ?? Timestamp.now(),
      };
}
