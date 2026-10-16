import 'package:flutter/material.dart';
import '../utils/app_exit_dialog.dart';
import '../utils/currency_formatter.dart';

class HalamanProfil extends StatefulWidget {
  const HalamanProfil({super.key});

  @override
  State<HalamanProfil> createState() => _HalamanProfilState();
}

class _HalamanProfilState extends State<HalamanProfil> {
  String _nama = 'Yosep';
  String _email = 'yosep@email.com';
  String _telepon = '+62 812-3456-7890';
  String _alamat = 'Jl. Mawar No. 12, Sleman, Yogyakarta';

  int _saldoDompet = 75000;
  bool _notifikasiAktif = true;

  // 4. ChoiceChip (Top Up) - Wajib sesuai rubrik
  void _bukaTopUpDialog() {
    int nominalTerpilih = 50000;
    final nominalList = [10000, 20000, 50000, 100000];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: Color(0xFF2C3E50)),
                  SizedBox(width: 8),
                  Text('Top Up Saldo KantinPay', style: TextStyle(fontSize: 17)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pilih nominal isi saldo:'),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: nominalList.map((nominal) {
                      final isSelected = nominalTerpilih == nominal;
                      // ChoiceChip (Top Up)
                      return ChoiceChip(
                        label: Text(formatHarga(nominal)),
                        selected: isSelected,
                        selectedColor: const Color(0xFF2C3E50),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              nominalTerpilih = nominal;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal'),
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
                    setState(() {
                      _saldoDompet += nominalTerpilih;
                    });
                    Navigator.pop(ctx);

                    // 5. SnackBar feedback (Wajib sesuai rubrik)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Top Up ${formatHarga(nominalTerpilih)} berhasil! Saldo bertambah.'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF2C3E50),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Konfirmasi Isi Saldo'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _bukaDialogEditProfil() {
    final namaCtrl = TextEditingController(text: _nama);
    final emailCtrl = TextEditingController(text: _email);
    final teleponCtrl = TextEditingController(text: _telepon);
    final alamatCtrl = TextEditingController(text: _alamat);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
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
                const Text(
                  'Edit Data Akun',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: namaCtrl,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    labelText: 'Alamat Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: teleponCtrl,
                  decoration: InputDecoration(
                    labelText: 'Nomor WhatsApp / Telp',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: alamatCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Alamat Pengiriman',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _nama = namaCtrl.text.trim();
                        _email = emailCtrl.text.trim();
                        _telepon = teleponCtrl.text.trim();
                        _alamat = alamatCtrl.text.trim();
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Profil berhasil diperbarui!'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: const Color(0xFF2C3E50),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFF2C3E50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Simpan Perubahan'),
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
              'Profil Pengguna',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: const Color(0xFF2C3E50),
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Profil',
                onPressed: _bukaDialogEditProfil,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 1. CircleAvatar (Wajib sesuai rubrik)
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 52, // Ukuran besar
                              backgroundColor: const Color(0xFF2C3E50)
                                  .withValues(alpha: 0.1),
                              child: const Icon(
                                Icons.person,
                                size: 64,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: InkWell(
                                onTap: _bukaDialogEditProfil,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE74C3C),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _nama,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _email,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _bukaDialogEditProfil,
                          icon: const Icon(Icons.edit, size: 15),
                          label: const Text('Edit Profil'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2C3E50),
                            side: const BorderSide(color: Color(0xFF2C3E50)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Card Saldo dengan Tombol ChoiceChip Top Up
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: const Color(0xFF2C3E50),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Saldo KantinPay',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              formatHarga(_saldoDompet),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: _bukaTopUpDialog,
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Top Up'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE74C3C),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. SwitchListTile (Notifikasi) - Wajib sesuai rubrik
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  color: Colors.white,
                  child: SwitchListTile(
                    secondary: const CircleAvatar(
                      backgroundColor: Color(0xFFF0F3F4),
                      child: Icon(Icons.notifications_outlined,
                          color: Color(0xFF2C3E50), size: 20),
                    ),
                    title: const Text('Notifikasi Status Makanan',
                        style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Pemberitahuan saat siap diambil'),
                    value: _notifikasiAktif,
                    activeThumbColor: const Color(0xFF2C3E50),
                    onChanged: (val) {
                      setState(() => _notifikasiAktif = val);
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // 3. ExpansionTile (Wajib sesuai rubrik)
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  color: Colors.white,
                  child: Column(
                    children: [
                      ExpansionTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFF0F3F4),
                          child: Icon(Icons.help_outline,
                              color: Color(0xFF2C3E50), size: 20),
                        ),
                        title: const Text(
                          'Pusat Bantuan & FAQ Kantin',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '• Bagaimana cara memesan?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const Text(
                                  'Pilih menu favorit, tentukan topping di halaman detail, lalu checkout di keranjang.',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '• Apakah bisa bayar tunai?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const Text(
                                  'Bisa, silakan pilih opsi Tunai di Kasir saat menyelesaikan pesanan.',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '• Jam Operasional Kantin Bu Sari:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const Text(
                                  'Buka setiap hari Senin - Sabtu pukul 07.00 s/d 17.00 WIB.',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 1),
                      ExpansionTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFF0F3F4),
                          child: Icon(Icons.info_outline,
                              color: Color(0xFF2C3E50), size: 20),
                        ),
                        title: const Text(
                          'Tentang Kantin Bu Sari',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        children: const [
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Text(
                              'Kantin Bu Sari menyajikan aneka masakan rumahan lezat, higienis, dan terjangkau dengan cita rasa autentik khas nusantara sejak tahun 2015.',
                              style: TextStyle(fontSize: 12, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Keluar dengan Validasi Konfirmasi
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => konfirmasiKeluarAplikasi(context),
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Keluar dari Akun & Tutup Aplikasi'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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

