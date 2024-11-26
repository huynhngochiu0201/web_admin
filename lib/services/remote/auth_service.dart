import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../entities/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createStaff({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Tạo tài khoản trên Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Tạo một đối tượng UserModel
      UserModel newStaff = UserModel()
        ..id = userCredential.user?.uid
        ..name = name
        ..email = email
       // ..role = 'staff'
        ..avatar = null; // Có thể thêm avatar nếu muốn

      // Lưu thông tin staff vào Firestore
      await _firestore
          .collection('users')
          .doc(newStaff.id)
          .set(newStaff.toJson());
    } catch (e) {
      throw Exception('Failed to create staff: $e');
    }
  }
}
