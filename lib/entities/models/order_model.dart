import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_model.dart';

class OrderModel {
  final String? id;
  final String? userId;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? status;
  final DateTime? createdAt;
  final double? totalPrice;
  final int? totalProduct;
  final List<CartModel> cartData;

  OrderModel({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.phoneNumber,
    this.address,
    this.status,
    this.createdAt,
    this.totalPrice,
    this.totalProduct,
    required this.cartData,
  });

  factory OrderModel.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return OrderModel(
      id: doc.id,
      userId: data['uId'],
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      address: data['address'],
      status: data['status'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      totalPrice: (data['totalPrice'] as num?)?.toDouble(),
      totalProduct: data['totalProduct'] as int?,
      cartData: (data['cartData'] as List<dynamic>)
          .map((item) => CartModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': userId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'status': status,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'totalPrice': totalPrice,
      'totalProduct': totalProduct,
      'cartData': cartData.map((item) => item.toJson()).toList(),
    };
  }
}
