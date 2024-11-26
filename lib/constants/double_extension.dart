extension DoubleExtension on double {
  String toVND() {
    return '${toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ';
  }
}
