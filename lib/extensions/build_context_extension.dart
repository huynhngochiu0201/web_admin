import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  bool get isMobile => MediaQuery.sizeOf(this).width < 600;
}
