import 'cart_item.dart';

class OrderHistory {
  final String orderId;
  final DateTime orderTime;
  final List<CartItem> items;
  final int totalHarga;
  final String tipePesanan; // 'Dine-in' atau 'Takeaway'
  final String nomorMeja;
  final String metodeBayar;
  int currentStep; // 0: Diterima, 1: Dimasak, 2: Siap Diambil, 3: Selesai
  bool isCompleted;
  double? rating;

  OrderHistory({
    required this.orderId,
    required this.orderTime,
    required this.items,
    required this.totalHarga,
    required this.tipePesanan,
    required this.nomorMeja,
    required this.metodeBayar,
    this.currentStep = 1,
    this.isCompleted = false,
    this.rating,
  });
}

