import 'package:cloud_firestore/cloud_firestore.dart';

class WheelSizeModel {
  final double? price;
  final String id;
  final String? name;
  final Timestamp? createAt;

  WheelSizeModel({
    required this.id,
    this.name,
    this.price,
    this.createAt,
  });

  factory WheelSizeModel.fromJson(Map<String, dynamic> json) {
    return WheelSizeModel(
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
