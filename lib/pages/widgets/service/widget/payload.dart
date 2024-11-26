import 'package:flutter/material.dart';

class PayloadWidget extends StatefulWidget {
  const PayloadWidget({super.key});

  @override
  State<PayloadWidget> createState() => _PayloadWidgetState();
}

class _PayloadWidgetState extends State<PayloadWidget> {
  @override
  Widget build(BuildContext context) {
    return const Text('Payload');
  }
}
