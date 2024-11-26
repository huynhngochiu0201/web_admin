import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
       backgroundColor: AppColor.Ef5f5f5,
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
