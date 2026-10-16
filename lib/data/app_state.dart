import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/order_history.dart';
import 'menu_data.dart';

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  AppState._internal() {
    _initDummyOrder();
  }


  // Saldo KantinPay
  int _saldo = 75000;
  int get saldo => _saldo;

  void tambahSaldo(int nominal) {
    _saldo += nominal;
    notifyListeners();
  }

  bool kurangiSaldo(int nominal) {
    if (_saldo >= nominal) {
      _saldo -= nominal;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Keranjang
  final List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  int get totalItemCount =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  int get totalHargaCart =>
      _cartItems.fold(0, (sum, item) => sum + item.subtotal);

  void tambahKeKeranjang(CartItem item) {
    // Cek jika menu dengan topping & catatan sama persis sudah ada
    final idx = _cartItems.indexWhere((c) =>
        c.menu.nama == item.menu.nama &&
        c.toppings.join(',') == item.toppings.join(',') &&
        c.catatan == item.catatan);

    if (idx >= 0) {
      _cartItems[idx].quantity += item.quantity;
    } else {
      _cartItems.add(item);
    }
    notifyListeners();
  }

  void ubahQty(int index, int delta) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index].quantity += delta;
      if (_cartItems[index].quantity <= 0) {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void hapusItem(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void kosongkanKeranjang() {
    _cartItems.clear();
    notifyListeners();
  }

  // Riwayat Pesanan
  final List<OrderHistory> _orderList = [];
  List<OrderHistory> get orderList => List.unmodifiable(_orderList);

  void tambahOrder(OrderHistory order) {
    _orderList.insert(0, order);
    notifyListeners();
  }

  void updateRating(String orderId, double rating) {
    final idx = _orderList.indexWhere((o) => o.orderId == orderId);
    if (idx >= 0) {
      _orderList[idx].rating = rating;
      notifyListeners();
    }
  }

  void _initDummyOrder() {
    _orderList.addAll([
      OrderHistory(
        orderId: 'KBS-8821',
        orderTime: DateTime.now().subtract(const Duration(minutes: 15)),
        items: [
          CartItem(
            menu: semuaMenu[0], // Ayam Geprek
            quantity: 2,
            toppings: ['Ekstra Sambal Bawang (+Rp 2.000)'],
            hargaTopping: 2000,
            catatan: 'Pedas level 5 ya Bu',
          ),
          CartItem(
            menu: semuaMenu[2], // Es Teh
            quantity: 2,
            catatan: 'Es batunya banyakin',
          ),
        ],
        totalHarga: 42000,
        tipePesanan: 'Dine-in (Makan di Tempat)',
        nomorMeja: 'Meja 07',
        metodeBayar: 'KantinPay (Saldo)',
        currentStep: 1, // Sedang Dimasak
        isCompleted: false,
      ),
      OrderHistory(
        orderId: 'KBS-8790',
        orderTime: DateTime.now().subtract(const Duration(hours: 3)),
        items: [
          CartItem(
            menu: semuaMenu[1], // Nasi Goreng
            quantity: 1,
            toppings: ['Telur Mata Sapi (+Rp 3.000)'],
            hargaTopping: 3000,
          ),
          CartItem(
            menu: semuaMenu[8], // Es Jeruk
            quantity: 1,
          ),
        ],
        totalHarga: 22000,
        tipePesanan: 'Takeaway (Bawa Pulang)',
        nomorMeja: '-',
        metodeBayar: 'QRIS',
        currentStep: 3, // Selesai
        isCompleted: true,
        rating: 5.0,
      ),
    ]);
  }
}

