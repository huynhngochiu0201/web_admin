import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  bool get responsive => MediaQuery.sizeOf(this).width < 600;
}
