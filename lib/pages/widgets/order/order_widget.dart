import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';

class OrderWidget extends StatelessWidget {
  const OrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
       backgroundColor: AppColor.Ef5f5f5,
      body: Center(
        child: Text('Order'),
      ),
    );
  }
}
