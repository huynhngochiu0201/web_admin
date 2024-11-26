import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateProductModel {
  final String? productId;
  final String? cateId;
  final String? productName;
  final double? price;
  final String? description;

  final int? quantity;
  final Uint8List? image;

  UpdateProductModel({
    this.productId,
    this.cateId,
    this.productName,
    this.price,
    this.description,
    this.quantity,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryId': cateId,
      'name': productName,
      'price': price,
      'description': description,
      'quantity': quantity,
      'createAt': Timestamp.now(),
    };
  }
}
