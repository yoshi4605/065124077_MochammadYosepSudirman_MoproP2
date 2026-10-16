import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../utils/currency_formatter.dart';

class HalamanDetailMenu extends StatefulWidget {
  final MenuItem menu;

  const HalamanDetailMenu({super.key, required this.menu});

  @override
  State<HalamanDetailMenu> createState() => _HalamanDetailMenuState();
}

class _HalamanDetailMenuState extends State<HalamanDetailMenu> {
  int _quantity = 1;
  final TextEditingController _catatanController = TextEditingController();

  // Topping sesuai kategori menu
  Map<String, int> get _daftarTopping {
    switch (widget.menu.kategori) {
      case 'Minuman':
        return {
          'Tambah Boba': 3000,
          'Ekstra Shot Espresso': 4000,
          'Jelly Kelapa': 2000,
          'Tambah Gula Aren': 1000,
        };
      case 'Snack':
        return {
          'Ekstra Sambal Bawang': 2000,
          'Saus Keju Leleh': 3000,
          'Mayonaise Pedas': 1000,
          'Cocolan Kecap Rawit': 1000,
        };
      default: // Makanan
        return {
          'Telur Mata Sapi': 3000,
          'Ekstra Sambal Bawang': 2000,
          'Kerupuk Gurih': 1000,
          'Porsi Nasi Ekstra': 4000,
        };
    }
  }

  final Set<String> _toppingTerpilih = {};

  int get _totalHargaTopping {
    int total = 0;
    for (var top in _toppingTerpilih) {
      total += _daftarTopping[top] ?? 0;
    }
    return total;
  }

  int get _totalHarga => (widget.menu.harga + _totalHargaTopping) * _quantity;

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // 1. SliverAppBar (Wajib sesuai rubrik)
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF2C3E50),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.menu.nama,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Colors.black54, blurRadius: 4),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.menu.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: const Color(0xFF2C3E50),
                      child: Icon(widget.menu.ikon,
                          size: 70, color: Colors.white70),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Konten Detail
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.menu.nama,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                size: 14, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.menu.rating}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.menu.deskripsi,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    formatHarga(widget.menu.harga),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF27AE60),
                    ),
                  ),
                  const Divider(height: 32),

                  // 2. CheckboxListTile (Topping) - Wajib sesuai rubrik
                  const Text(
                    'Pilihan Topping / Tambahan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    color: Colors.white,
                    child: Column(
                      children: _daftarTopping.entries.map((entry) {
                        final namaTopping = entry.key;
                        final hargaTopping = entry.value;
                        final isChecked = _toppingTerpilih.contains(namaTopping);

                        return CheckboxListTile(
                          title: Text(
                            namaTopping,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            '+${formatHarga(hargaTopping)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF27AE60),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          activeColor: const Color(0xFFE74C3C),
                          value: isChecked,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _toppingTerpilih.add(namaTopping);
                              } else {
                                _toppingTerpilih.remove(namaTopping);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. TextField (Catatan) - Wajib sesuai rubrik
                  const Text(
                    'Catatan untuk Dapur Bu Sari',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _catatanController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Jangan terlalu pedas, kuah dipisah...',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade400, fontSize: 13),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Quantity Counter (Wajib sesuai rubrik)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Jumlah Pesanan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              color: const Color(0xFF2C3E50),
                              onPressed: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),

      // 5. BottomAppBar (Wajib sesuai rubrik)
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 10,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Total Harga',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  formatHarga(_totalHarga),
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF27AE60),
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                final cartItem = CartItem(
                  menu: widget.menu,
                  quantity: _quantity,
                  toppings: _toppingTerpilih.toList(),
                  hargaTopping: _totalHargaTopping,
                  catatan: _catatanController.text.trim(),
                );

                AppState.instance.tambahKeKeranjang(cartItem);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${widget.menu.nama} x$_quantity berhasil ditambah ke keranjang!'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color(0xFF2C3E50),
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart, size: 18),
              label: const Text('Tambah ke Keranjang'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                backgroundColor: const Color(0xFF2C3E50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

