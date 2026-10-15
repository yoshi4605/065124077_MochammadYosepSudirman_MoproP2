import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../utils/currency_formatter.dart';

class HalamanPembayaran extends StatefulWidget {
  final List<Map<String, dynamic>> pesanan;
  final int totalHarga;
  final VoidCallback onSelesai;

  const HalamanPembayaran({
    super.key,
    required this.pesanan,
    required this.totalHarga,
    required this.onSelesai,
  });

  @override
  State<HalamanPembayaran> createState() => _HalamanPembayaranState();
}

class _HalamanPembayaranState extends State<HalamanPembayaran> {
  String _metodeBayar = 'KantinPay (Saldo)';

  final List<Map<String, dynamic>> _metodeList = const [
    {'nama': 'KantinPay (Saldo)', 'ikon': Icons.account_balance_wallet, 'warna': Color(0xFF2C3E50)},
    {'nama': 'QRIS', 'ikon': Icons.qr_code_2, 'warna': Color(0xFF1565C0)},
    {'nama': 'GoPay', 'ikon': Icons.account_balance_wallet_outlined, 'warna': Color(0xFF00ACC1)},
    {'nama': 'OVO', 'ikon': Icons.circle, 'warna': Color(0xFF6A1B9A)},
    {'nama': 'Tunai (Kasir)', 'ikon': Icons.money, 'warna': Color(0xFF2E7D32)},
  ];

  void _prosesBayar() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 56,
                    color: Colors.green.shade600,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Pembayaran Berhasil!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total ${formatHarga(widget.totalHarga)} via $_metodeBayar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pesananmu sedang disiapkan dengan senang hati 😊',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onSelesai();
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFF2C3E50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Kembali ke Menu'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C3E50),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -- Ringkasan pesanan --
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.receipt_long, size: 20, color: Color(0xFF2C3E50)),
                      SizedBox(width: 8),
                      Text(
                        'Ringkasan Pesanan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  ...widget.pesanan.map((item) {
                    final menu = item['menu'] as MenuItem;
                    final qty = item['qty'] as int;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              menu.imageUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => CircleAvatar(
                                radius: 18,
                                backgroundColor: const Color(0xFFF0F3F4),
                                child: Icon(menu.ikon, color: menu.warnaIkon, size: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menu.nama,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                                Text(
                                  '${formatHarga(menu.harga)} x$qty',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            formatHarga(menu.harga * qty),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Bayar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        formatHarga(widget.totalHarga),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF27AE60),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // -- Pilih metode bayar --
            const Text(
              'Metode Pembayaran',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),
            ...(_metodeList.map((metode) {
              final nama = metode['nama'] as String;
              final ikon = metode['ikon'] as IconData;
              final warna = metode['warna'] as Color;
              final dipilih = _metodeBayar == nama;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => setState(() => _metodeBayar = nama),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: dipilih
                            ? const Color(0xFFE74C3C)
                            : Colors.grey.shade200,
                        width: dipilih ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: warna.withValues(alpha: 0.12),
                          child: Icon(ikon, color: warna, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            nama,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: dipilih
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        if (dipilih)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFFE74C3C),
                            size: 22,
                          )
                        else
                          Icon(
                            Icons.radio_button_off,
                            color: Colors.grey.shade300,
                            size: 22,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            })),

            const SizedBox(height: 24),

            // -- Tombol bayar warna Secondary Coral Red --
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _prosesBayar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFFE74C3C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Bayar ${formatHarga(widget.totalHarga)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
