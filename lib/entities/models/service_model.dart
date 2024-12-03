class ServiceModel {
  final String name;
  final String address;
  final String phone;
  final String note;
  final String nameservice;
  final String? area;
  final String? payload;
  final String? wheelSize;
  final double totalPrice;
  final String? status;
  final DateTime createdAt;
  final String? userId;
  ServiceModel({
    required this.name,
    required this.address,
    required this.phone,
    required this.note,
    required this.nameservice,
    this.area,
    this.payload,
    this.wheelSize,
    required this.totalPrice,
    required this.createdAt,
    this.status,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'note': note,
      'nameservice': nameservice,
      'area': area,
      'payload': payload,
      'wheelSize': wheelSize,
      'totalPrice': totalPrice,
      'createdAt': createdAt,
      'status': status,
      'userId': userId,
    };
  }
}
