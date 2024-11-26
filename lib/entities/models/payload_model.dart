import 'package:cloud_firestore/cloud_firestore.dart';

class PayloadModel {
  final double? price;
  final String id;
  final String? name;
  final Timestamp? createAt;

  PayloadModel({
    required this.id,
    this.name,
    this.price,
    this.createAt,
  });

  factory PayloadModel.fromJson(Map<String, dynamic> json) {
    return PayloadModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      price: json['price'] as double?,
      createAt: json['createAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'createAt': createAt,
    };
  }
}
