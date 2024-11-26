import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/button/cr_elevated_button.dart';
import '../../components/text_field/cr_text_field.dart';
import '../../components/text_field/cr_text_field_password.dart';
import '../../pages/auth/login_pages.dart';
import '../../constants/app_color.dart';
import '../../utils/validator.dart';
import '../../entities/models/user_model.dart';
import '../../components/snack_bar/td_snack_bar.dart';
import '../../components/snack_bar/top_snack_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  final _auth = FirebaseAuth.instance;

  // tao tham chieu den collection task luu tru trong firebase
  // de add, update, delete
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users'); // tham chieu

  Future<void> _onSubmit(BuildContext context) async {
    if (formKey.currentState!.validate() == false) {
      return;
    }

    setState(() => isLoading = true);

    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text)
        .then((value) async {
      UserModel user = UserModel()
        ..name = nameController.text.trim()
        ..email = emailController.text.trim();

      _addUser(user);

      if (!context.mounted) return;

      showTopSnackBar(
        context,
        const TDSnackBar.success(
            message: 'Register successfully, please login 😍'),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginPages(
            email: emailController.text.trim(),
          ),
        ),
        (Route<dynamic> route) => false,
      );
    }).catchError((onError) {
      FirebaseAuthException a = onError as FirebaseAuthException;
      showTopSnackBar(
        context,
        TDSnackBar.error(message: a.message ?? ''),
      );
    }).whenComplete(() {
      setState(() => isLoading = false);
    });
  }

  void _addUser(UserModel user) {
    userCollection
        .doc(user.email)
        .set(user.toJson())
        .then((_) {})
        .catchError((error) {
      dev.log("Failed to add Task: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.E7E8E9,
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: FittedBox(
                    child: SizedBox(
                      width: 800,
                      height: 600,
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20)),
                                color: Colors.white,
                              ),
                              height: 500,
                              width: size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Register',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                          "Welcome to car rescue's management page"),
                                      const SizedBox(height: 20.0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: CrTextField(
                                          controller: nameController,
                                          hintText: 'Full Name',
                                          prefixIcon: const Icon(Icons.person,
                                              color: AppColor.grey),
                                          textInputAction: TextInputAction.next,
                                          validator: Validator.required,
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: CrTextField(
                                          controller: emailController,
                                          hintText: 'Email',
                                          prefixIcon: const Icon(Icons.email,
                                              color: AppColor.grey),
                                          textInputAction: TextInputAction.next,
                                          validator: Validator.email,
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: CrTextFieldPassword(
                                          controller: passwordController,
                                          hintText: 'Password',
                                          textInputAction: TextInputAction.next,
                                          validator: Validator.password,
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: CrTextFieldPassword(
                                          controller: confirmPasswordController,
                                          onChanged: (_) => setState(() {}),
                                          hintText: 'Confirm Password',
                                          textInputAction: TextInputAction.done,
                                          validator: Validator.confirmPassword(
                                              passwordController.text),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: CrElevatedButton(
                                          onPressed: () => _onSubmit(context),
                                          color: AppColor.blue,
                                          borderColor: AppColor.white,
                                          text: isLoading
                                              ? 'Loading...'
                                              : 'Register',
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  colors: [
                                    Color(0xFF5038ED),
                                    Color(0xFF9181F4),
                                  ],
                                ),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              height: 500,
                              width: size.width,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    child: Image.asset(
                                      'assets/images/Rectangle.png',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Center(
                                    child: Positioned(
                                      child: Image.asset(
                                        'assets/images/Autocarlogo.png',
                                        width: 450,
                                        height: 450,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
