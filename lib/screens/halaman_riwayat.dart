import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../models/order_history.dart';
import '../utils/currency_formatter.dart';

class HalamanRiwayat extends StatefulWidget {
  const HalamanRiwayat({super.key});

  @override
  State<HalamanRiwayat> createState() => _HalamanRiwayatState();
}

class _HalamanRiwayatState extends State<HalamanRiwayat>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 1. TabBar & TabBarView (Wajib sesuai rubrik)
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 5. Rating Stars Dialog (Wajib sesuai rubrik)
  void _bukaRatingDialog(OrderHistory order) {
    double selectedRating = order.rating ?? 5.0;
    final reviewCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Center(
                child: Text(
                  'Beri Penilaian Rasa',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Bagaimana hidangan dari Kantin Bu Sari untuk pesanan ${order.orderId}?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starValue = index + 1.0;
                      return IconButton(
                        icon: Icon(
                          starValue <= selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            selectedRating = starValue;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: reviewCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Tulis komentar (opsional)...',
                      hintStyle:
                          TextStyle(fontSize: 12, color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Nanti Saja'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE74C3C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    AppState.instance
                        .updateRating(order.orderId, selectedRating);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Terima kasih atas ulasan bintang ${selectedRating.toInt()} kamu!'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF2C3E50),
                      ),
                    );
                  },
                  child: const Text('Kirim Penilaian'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 4. BottomSheet (Wajib sesuai rubrik)
  void _bukaDetailPesananBottomSheet(OrderHistory order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detail ${order.orderId}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: order.isCompleted
                          ? Colors.green.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order.isCompleted ? 'Selesai' : 'Sedang Diproses',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: order.isCompleted
                            ? Colors.green.shade800
                            : Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Waktu: ${order.orderTime.hour.toString().padLeft(2, '0')}:${order.orderTime.minute.toString().padLeft(2, '0')} WIB',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const Divider(height: 24),
              const Text('Menu yang Dipesan:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...order.items.map((it) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          it.menu.imageUrl,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${it.menu.nama} x${it.quantity}',
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600)),
                            if (it.toppings.isNotEmpty)
                              Text('+ ${it.toppings.join(', ')}',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Text(formatHarga(it.subtotal),
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Pembayaran',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(formatHarga(order.totalHarga),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF27AE60))),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final orders = AppState.instance.orderList;
        final orderBerjalan = orders.where((o) => !o.isCompleted).toList();
        final orderSelesai = orders.where((o) => o.isCompleted).toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            title: const Text(
              'Riwayat Pesanan',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: const Color(0xFF2C3E50),
            foregroundColor: Colors.white,
            elevation: 0,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFFE74C3C),
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Sedang Diproses'),
                      if (orderBerjalan.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE74C3C),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${orderBerjalan.length}',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Tab(text: 'Selesai'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // TAB 1: Sedang Diproses
              orderBerjalan.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.soup_kitchen_outlined,
                              size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text(
                            'Tidak ada pesanan yang sedang diproses',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: orderBerjalan.length,
                      itemBuilder: (ctx, i) {
                        final order = orderBerjalan[i];
                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      order.orderId,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2C3E50),
                                      ),
                                    ),
                                    Text(
                                      order.tipePesanan,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // 2. LinearProgressIndicator (Wajib sesuai rubrik)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Estimasi Selesai (~10 menit)',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    Text(
                                      '${((order.currentStep + 1) / 4 * 100).toInt()}%',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFE74C3C),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: (order.currentStep + 1) / 4,
                                    minHeight: 7,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Color(0xFFE74C3C)),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // 3. Stepper Tracker (Wajib sesuai rubrik)
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: const Color(0xFF2C3E50),
                                    ),
                                  ),
                                  child: Stepper(
                                    physics: const NeverScrollableScrollPhysics(),
                                    currentStep: order.currentStep,
                                    controlsBuilder: (ctx, details) =>
                                        const SizedBox.shrink(),
                                    steps: [
                                      Step(
                                        title: const Text('Pesanan Diterima'),
                                        subtitle: const Text('Kasir & Dapur'),
                                        content: const SizedBox.shrink(),
                                        isActive: order.currentStep >= 0,
                                        state: order.currentStep > 0
                                            ? StepState.complete
                                            : StepState.indexed,
                                      ),
                                      Step(
                                        title: const Text('Sedang Dimasak'),
                                        subtitle:
                                            const Text('Chef Bu Sari menyiapkan'),
                                        content: const SizedBox.shrink(),
                                        isActive: order.currentStep >= 1,
                                        state: order.currentStep > 1
                                            ? StepState.complete
                                            : StepState.indexed,
                                      ),
                                      Step(
                                        title: const Text('Siap Diambil'),
                                        subtitle: Text(
                                            'Diantar ke ${order.nomorMeja} / Ambil di kasir'),
                                        content: const SizedBox.shrink(),
                                        isActive: order.currentStep >= 2,
                                        state: order.currentStep > 2
                                            ? StepState.complete
                                            : StepState.indexed,
                                      ),
                                      Step(
                                        title: const Text('Selesai'),
                                        subtitle:
                                            const Text('Selamat menikmati!'),
                                        content: const SizedBox.shrink(),
                                        isActive: order.currentStep >= 3,
                                        state: StepState.indexed,
                                      ),
                                    ],
                                  ),
                                ),

                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${order.items.length} Menu • Total ${formatHarga(order.totalHarga)}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () =>
                                          _bukaDetailPesananBottomSheet(order),
                                      icon: const Icon(Icons.receipt, size: 16),
                                      label: const Text('Rincian'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

              // TAB 2: Selesai
              orderSelesai.isEmpty
                  ? Center(
                      child: Text(
                        'Belum ada pesanan yang selesai',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: orderSelesai.length,
                      itemBuilder: (ctx, i) {
                        final order = orderSelesai[i];
                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      order.orderId,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2C3E50),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Selesai',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Waktu: ${order.orderTime.day}/${order.orderTime.month}/${order.orderTime.year} • ${order.tipePesanan}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500),
                                ),
                                const Divider(height: 20),
                                ...order.items.map((it) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${it.menu.nama} x${it.quantity}',
                                            style: const TextStyle(fontSize: 13),
                                          ),
                                          Text(
                                            formatHarga(it.subtotal),
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    )),
                                const Divider(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Total Pembayaran',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey)),
                                        Text(
                                          formatHarga(order.totalHarga),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF27AE60),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Tombol Rating Bintang
                                    ElevatedButton.icon(
                                      onPressed: () => _bukaRatingDialog(order),
                                      icon: Icon(
                                        order.rating != null
                                            ? Icons.star
                                            : Icons.star_border,
                                        size: 16,
                                        color: Colors.amber,
                                      ),
                                      label: Text(
                                        order.rating != null
                                            ? 'Bintang ${order.rating!.toInt()}'
                                            : 'Beri Rating',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF2C3E50),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
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
            ],
          ),
        );
      },
    );
  }
}

