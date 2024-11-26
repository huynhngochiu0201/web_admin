import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/button/cr_elevated_button.dart';
import '../../components/snack_bar/td_snack_bar.dart';
import '../../components/snack_bar/top_snack_bar.dart';
import '../../components/text_field/cr_text_field.dart';
import '../../components/text_field/cr_text_field_password.dart';
import '../../constants/app_color.dart';
import '../../utils/validator.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({super.key, this.email});
  final String? email;

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final _auth = FirebaseAuth.instance;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email ?? '';
  }

  Future<void> _submitLogin(BuildContext context) async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    setState(() => isLoading = true);
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text)
        .then((value) {
      _getUser();
    }).catchError((onError) {
      setState(() => isLoading = false);
      showTopSnackBar(
        context,
        const TDSnackBar.error(message: 'Email or Password is wrong😐'),
      );
    });
  }

  void _getUser() {
    userCollection
        .doc(emailController.text)
        .get()
        .then((snapshot) {})
        .catchError((onError) {})
        .whenComplete(() => setState(() => isLoading = false));
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
                                  bottomLeft: Radius.circular(20),
                                ),
                                color: Colors.white,
                              ),
                              height: 500,
                              width: size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 90),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Login',
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
                                          controller: emailController,
                                          hintText: 'Email or Phone',
                                          prefixIcon: const Icon(Icons.email,
                                              color: Colors.orange),
                                          validator: Validator.email,
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: CrTextFieldPassword(
                                          controller: passwordController,
                                          hintText: 'Password',
                                          validator: Validator.password,
                                          textInputAction: TextInputAction.done,
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: CrElevatedButton(
                                          onPressed: () =>
                                              _submitLogin(context),
                                          color: AppColor.blue,
                                          borderColor: AppColor.white,
                                          text: isLoading
                                              ? 'Loading...'
                                              : 'Login',
                                        ),
                                      ),
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
