import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../models/order_history.dart';
import '../utils/currency_formatter.dart';

class HalamanKeranjang extends StatefulWidget {
  const HalamanKeranjang({super.key});

  @override
  State<HalamanKeranjang> createState() => _HalamanKeranjangState();
}

enum TipePesanan { dineIn, takeaway }

class _HalamanKeranjangState extends State<HalamanKeranjang> {
  // 2. SegmentedButton (Dine-in/Takeaway)
  Set<TipePesanan> _tipePesanan = {TipePesanan.dineIn};

  // 3. DropdownButtonFormField (Meja)
  String _nomorMeja = 'Meja 01';
  final List<String> _daftarMeja = [
    'Meja 01',
    'Meja 02',
    'Meja 03',
    'Meja 04',
    'Meja 05',
    'Meja 06',
    'Meja 07',
    'Meja 08',
    'Meja 09',
    'Meja 10',
  ];

  // 4. RadioListTile (Bayar)
  String _metodeBayar = 'KantinPay (Saldo)';
  final List<String> _daftarMetode = [
    'KantinPay (Saldo)',
    'QRIS',
    'Tunai di Kasir',
  ];

  void _tampilkanStrukDialog(OrderHistory order) {
    // 5. AlertDialog (Struk) - Wajib sesuai rubrik
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Column(
            children: [
              Icon(Icons.receipt_long, color: Color(0xFF2C3E50), size: 36),
              SizedBox(height: 6),
              Text(
                'STRUK PEMBAYARAN',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'Kantin Bu Sari',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('No. Order:',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(order.orderId,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tipe Pesanan:',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(order.tipePesanan,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  if (order.nomorMeja != '-') ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Nomor Meja:',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(order.nomorMeja,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Metode Bayar:',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(order.metodeBayar,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Divider(height: 20),
                  const Text('Daftar Item:',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${item.menu.nama} x${item.quantity}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500)),
                              Text(formatHarga(item.subtotal),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          if (item.toppings.isNotEmpty)
                            Text('  + ${item.toppings.join(', ')}',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600)),
                          if (item.catatan.isNotEmpty)
                            Text('  "${item.catatan}"',
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey)),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('TOTAL BAYAR',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      Text(formatHarga(order.totalHarga),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF27AE60))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('LUNAS / PEMBAYARAN BERHASIL',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3E50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context); // Kembali ke Beranda
              },
              child: const Text('Selesai & Lacak Pesanan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final cart = AppState.instance.cartItems;
        final totalHarga = AppState.instance.totalHargaCart;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            title: const Text(
              'Keranjang Pesanan',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: const Color(0xFF2C3E50),
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              if (cart.isNotEmpty)
                IconButton(
                  tooltip: 'Kosongkan Keranjang',
                  icon: const Icon(Icons.delete_sweep_outlined),
                  onPressed: () {
                    AppState.instance.kosongkanKeranjang();
                  },
                ),
            ],
          ),
          body: cart.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined,
                          size: 72, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'Keranjangmu masih kosong',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pilih makanan lezat dari menu untuk mulai pesan',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. ListView Item Keranjang (Wajib sesuai rubrik)
                      const Text(
                        'Daftar Item Menu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cart.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, i) {
                          final item = cart[i];
                          return Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      item.menu.imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.menu.nama,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (item.toppings.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            '+ ${item.toppings.join(', ')}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                        if (item.catatan.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            'Catatan: "${item.catatan}"',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 6),
                                        Text(
                                          formatHarga(item.subtotal),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF27AE60),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Counter +/-
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () => AppState.instance
                                            .ubahQty(i, -1),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Icon(Icons.remove,
                                              size: 14),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(
                                          '${item.quantity}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => AppState.instance
                                            .ubahQty(i, 1),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child:
                                              const Icon(Icons.add, size: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // 2. SegmentedButton (Dine-in / Takeaway) - Wajib sesuai rubrik
                      const Text(
                        'Tipe Pesanan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<TipePesanan>(
                          segments: const [
                            ButtonSegment(
                              value: TipePesanan.dineIn,
                              label: Text('Makan di Tempat'),
                              icon: Icon(Icons.restaurant),
                            ),
                            ButtonSegment(
                              value: TipePesanan.takeaway,
                              label: Text('Bawa Pulang'),
                              icon: Icon(Icons.takeout_dining),
                            ),
                          ],
                          selected: _tipePesanan,
                          onSelectionChanged: (val) {
                            setState(() {
                              _tipePesanan = val;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 18),

                      // 3. DropdownButtonFormField (Meja) - Wajib sesuai rubrik
                      if (_tipePesanan.contains(TipePesanan.dineIn)) ...[
                        const Text(
                          'Pilih Nomor Meja',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: _nomorMeja,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.table_restaurant,
                                color: Color(0xFF2C3E50)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          items: _daftarMeja.map((meja) {
                            return DropdownMenuItem(
                              value: meja,
                              child: Text(meja),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _nomorMeja = val);
                            }
                          },
                        ),
                        const SizedBox(height: 18),
                      ],

                      // 4. RadioListTile (Bayar) - Wajib sesuai rubrik
                      const Text(
                        'Metode Pembayaran',
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
                        child: RadioGroup<String>(
                          groupValue: _metodeBayar,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _metodeBayar = val);
                            }
                          },
                          child: Column(
                            children: _daftarMetode.map((metode) {
                              return RadioListTile<String>(
                                title: Text(
                                  metode,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                value: metode,
                                activeColor: const Color(0xFFE74C3C),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Ringkasan & Tombol Bayar
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total Pembayaran',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                                Text(
                                  formatHarga(totalHarga),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF27AE60),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final tipeStr = _tipePesanan
                                        .contains(TipePesanan.dineIn)
                                    ? 'Dine-in (Makan di Tempat)'
                                    : 'Takeaway (Bawa Pulang)';
                                final mejaStr = _tipePesanan
                                        .contains(TipePesanan.dineIn)
                                    ? _nomorMeja
                                    : '-';

                                final orderBaru = OrderHistory(
                                  orderId:
                                      'KBS-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                                  orderTime: DateTime.now(),
                                  items: List.from(cart),
                                  totalHarga: totalHarga,
                                  tipePesanan: tipeStr,
                                  nomorMeja: mejaStr,
                                  metodeBayar: _metodeBayar,
                                  currentStep: 1, // Sedang Dimasak
                                  isCompleted: false,
                                );

                                AppState.instance.tambahOrder(orderBaru);
                                AppState.instance.kosongkanKeranjang();

                                _tampilkanStrukDialog(orderBaru);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 14),
                                backgroundColor: const Color(0xFFE74C3C),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Bayar Sekarang',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
