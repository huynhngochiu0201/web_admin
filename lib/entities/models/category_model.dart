import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String? name;
  final String? image;
  final Timestamp? createAt;

  CategoryModel({
    required this.id,
    this.name,
    this.image,
    this.createAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      image: json['image'] as String?,
      createAt: json['createAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'createAt': createAt,
    };
  }
}
