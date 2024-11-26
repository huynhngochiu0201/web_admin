import 'dart:typed_data';

class AddProductModel {
  final String cateId;
  final String productName;
  final double price;
  final int quantity;
  final String description;
  final Uint8List? image;

  AddProductModel({
    required this.cateId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.description,
    this.image,
  });

  Map<String, dynamic> toJson() => {
        'cateId': cateId,
        'productName': productName,
        'price': price,
        'quantity': quantity,
        'description': description,
        'image': image,
      };
}
