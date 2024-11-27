class OrderStatus {
  static const String toShip = "To Ship";
  static const String pending = "Pending";
  static const String delivered = "Delivered";
  static const String cancelled = "Cancelled";

  /// Trả về danh sách tất cả trạng thái đơn hàng
  static List<String> get values => [
        toShip,
        pending,
        delivered,
        cancelled,
      ];
}
