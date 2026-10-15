import 'menu_item.dart';

class CartItem {
  final MenuItem menu;
  int quantity;
  final List<String> toppings;
  final int hargaTopping;
  final String catatan;

  CartItem({
    required this.menu,
    this.quantity = 1,
    this.toppings = const [],
    this.hargaTopping = 0,
    this.catatan = '',
  });

  int get hargaSatuan => menu.harga + hargaTopping;
  int get subtotal => hargaSatuan * quantity;
}

