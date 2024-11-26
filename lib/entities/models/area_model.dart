import 'package:cloud_firestore/cloud_firestore.dart';

class AreaModel {
  final String id;
  final String? name;
  final double? price;
  final Timestamp? createAt;

  AreaModel({
    required this.id,
    this.name,
    this.price,
    this.createAt,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
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
