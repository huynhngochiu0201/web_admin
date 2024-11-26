class UserModel {
  String? id;
  String? name;
  String? email;
  String? avatar;
  // String? role;

  // Constructor with named parameters
  UserModel({
    this.id,
    this.name,
    this.email,
    this.avatar,
    // this.role,
  });

  // Factory method to create a UserModel from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        avatar: json['avatar'] as String?,
        // role: json['role'] as String?,
      );

  // Convert UserModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      // 'role': role,
    };
  }
}
