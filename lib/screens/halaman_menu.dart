import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../data/menu_data.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../utils/currency_formatter.dart';
import '../widgets/bestseller_card.dart';
import '../widgets/menu_card.dart';
import 'halaman_detail_menu.dart';
import 'halaman_keranjang.dart';
import 'halaman_profil.dart';
import 'halaman_riwayat.dart';

class HalamanMenu extends StatefulWidget {
  const HalamanMenu({super.key});

  @override
  State<HalamanMenu> createState() => _HalamanMenuState();
}

class _HalamanMenuState extends State<HalamanMenu> {
  int _currentIndex = 0;

  // 2 Tab Utama: Rekomendasi & Terlaris
  String _tabAktif = 'Rekomendasi';
  final List<String> _daftarTab = ['Rekomendasi', 'Terlaris'];

  // Kategori ChoiceChip
  String _kategoriAktif = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _terlarisScrollController = ScrollController();

  // Mode Tampilan: default List (bisa toggle ke Grid)
  bool _isGridView = false;

  void _scrollTerlaris(bool keKanan) {
    if (!_terlarisScrollController.hasClients) return;
    final target = _terlarisScrollController.offset + (keKanan ? 180.0 : -180.0);
    _terlarisScrollController.animateTo(
      target.clamp(0.0, _terlarisScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  List<MenuItem> get _menuTerlaris =>
      semuaMenu.where((m) => m.bestseller).toList();

  List<MenuItem> get _menuFiltered {
    List<MenuItem> hasil = semuaMenu.where((m) {
      final cocokKategori =
          _kategoriAktif == 'Semua' || m.kategori == _kategoriAktif;
      final cocokSearch = _searchQuery.isEmpty ||
          m.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.deskripsi.toLowerCase().contains(_searchQuery.toLowerCase());

      return cocokKategori && cocokSearch;
    }).toList();

    // Sesuaikan Tab: Rekomendasi atau Terlaris
    if (_tabAktif == 'Terlaris') {
      hasil = hasil.where((m) => m.bestseller).toList();
    }

    return hasil;
  }

  void _bukaDetail(MenuItem menu) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HalamanDetailMenu(menu: menu),
      ),
    );
  }

  void _tambahCepat(MenuItem menu) {
    AppState.instance.tambahKeKeranjang(
      CartItem(menu: menu, quantity: 1),
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${menu.nama} berhasil masuk ke keranjang!',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: const Color(0xFF2C3E50),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _terlarisScrollController.dispose();
    super.dispose();
  }

  Widget _buildBeranda() {
    final menuList = _menuFiltered;
    final totalItem = AppState.instance.totalItemCount;

    return CustomScrollView(
      slivers: [
        // 1. SliverAppBar dengan Judul KANTIN BU SARI di kiri Search & Keranjang di kanan
        SliverAppBar(
          pinned: true,
          floating: true,
          elevation: 0,
          backgroundColor: const Color(0xFF2C3E50),
          foregroundColor: Colors.white,
          toolbarHeight: 64,
          titleSpacing: 16,
          title: Row(
            children: [
              // Judul di samping kiri search
              const Text(
                'KANTIN BU SARI',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.5,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 10),

              // Search Bar
              Expanded(
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() => _searchQuery = val);
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari menu...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12.5,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF2C3E50),
                        size: 18,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  size: 16, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 9),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Badge(
                isLabelVisible: totalItem > 0,
                label: Text(
                  '$totalItem',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: const Color(0xFFE74C3C),
                textColor: Colors.white,
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HalamanKeranjang(),
                  ),
                );
              },
            ),
            const SizedBox(width: 6),
          ],
        ),

        // 2. Tab: Rekomendasi & Terlaris
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            child: Row(
              children: _daftarTab.map((tab) {
                final aktif = tab == _tabAktif;
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() => _tabAktif = tab);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: aktif
                                ? const Color(0xFF2C3E50)
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                      ),
                      child: Text(
                        tab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight:
                              aktif ? FontWeight.bold : FontWeight.w500,
                          color: aktif
                              ? const Color(0xFF2C3E50)
                              : const Color(0xFF7F8C8D),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // 3. ChoiceChip Kategori (Wajib sesuai rubrik)
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: kategoriList.map((kat) {
                  final aktif = kat == _kategoriAktif;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(kat),
                      selected: aktif,
                      selectedColor: const Color(0xFF2C3E50),
                      backgroundColor: const Color(0xFFF1F3F5),
                      side: BorderSide(
                        color: aktif
                            ? const Color(0xFF2C3E50)
                            : Colors.grey.shade300,
                      ),
                      labelStyle: TextStyle(
                        color: aktif ? Colors.white : const Color(0xFF1A1A1A),
                        fontSize: 13,
                        fontWeight:
                            aktif ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) {
                        setState(() => _kategoriAktif = kat);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        // Pilihan Terlaris Hari Ini (Bebas dari overflow garis kuning-hitam)
        if (_searchQuery.isEmpty && _tabAktif == 'Rekomendasi') ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.star, color: Color(0xFFFFB800), size: 20),
                      SizedBox(width: 6),
                      Text(
                        'Pilihan Terlaris Hari Ini',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _scrollTerlaris(false),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.chevron_left,
                              size: 16, color: Color(0xFF2C3E50)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => _scrollTerlaris(true),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.chevron_right,
                              size: 16, color: Color(0xFF2C3E50)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 205,
              child: ListView.builder(
                controller: _terlarisScrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _menuTerlaris.length,
                itemBuilder: (context, index) {
                  final menu = _menuTerlaris[index];
                  return BestsellerCard(
                    menu: menu,
                    onTap: () => _bukaDetail(menu),
                    onPesan: () => _tambahCepat(menu),
                  );
                },
              ),
            ),
          ),
        ],

        // Header Daftar Menu dengan Toggle Tampilan (List / Grid)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Menu (${menuList.length})',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                // Toggle mode list vs grid
                InkWell(
                  onTap: () {
                    setState(() => _isGridView = !_isGridView);
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isGridView ? Icons.view_agenda : Icons.grid_view,
                          size: 15,
                          color: const Color(0xFF2C3E50),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isGridView ? 'List' : 'Grid',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // DAFTAR PRODUK (List Card Modern Bersih / GridView)
        if (menuList.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 56, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    'Tidak ada menu yang sesuai',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (!_isGridView)
          // List Card Produk Rapi & Proporsional
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final menu = menuList[index];
                  return MenuCard(
                    menu: menu,
                    onTap: () => _bukaDetail(menu),
                    onPesan: () => _tambahCepat(menu),
                  );
                },
                childCount: menuList.length,
              ),
            ),
          )
        else
          // GridView (Card) - Wajib sesuai rubrik
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 245,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final menu = menuList[index];
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFE8ECEF)),
                    ),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _bukaDetail(menu),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: Image.network(
                              menu.imageUrl,
                              height: 115,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                height: 115,
                                color: const Color(0xFFF1F3F5),
                                child: Icon(menu.ikon,
                                    size: 36, color: menu.warnaIkon),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menu.nama,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        size: 12, color: Color(0xFFFFB800)),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${menu.rating}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      menu.kategori,
                                      style: const TextStyle(
                                        fontSize: 10.5,
                                        color: Color(0xFF7F8C8D),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatHarga(menu.harga),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF27AE60),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => _tambahCepat(menu),
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF2C3E50),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.add,
                                            size: 15, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: menuList.length,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 5. Scaffold (Wajib sesuai rubrik)
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final totalItem = AppState.instance.totalItemCount;

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: [
              _buildBeranda(),
              const HalamanRiwayat(),
              const HalamanProfil(),
            ],
          ),

          // 6. FloatingActionButton dengan Badge (Wajib sesuai rubrik)
          floatingActionButton: FloatingActionButton(
            heroTag: 'fab_cart',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HalamanKeranjang(),
                ),
              );
            },
            backgroundColor: const Color(0xFF2C3E50),
            child: Badge(
              isLabelVisible: totalItem > 0,
              label: Text(
                '$totalItem',
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color(0xFFE74C3C),
              textColor: Colors.white,
              child: const Icon(Icons.shopping_cart, color: Colors.white),
            ),
          ),

          // Navigasi di Bawah (3 Tab: Beranda, Riwayat, Profil)
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (idx) {
              setState(() => _currentIndex = idx);
            },
            backgroundColor: Colors.white,
            elevation: 8,
            indicatorColor: const Color(0xFF2C3E50).withValues(alpha: 0.15),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home, color: Color(0xFF2C3E50)),
                label: 'Beranda',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon:
                    Icon(Icons.receipt_long, color: Color(0xFF2C3E50)),
                label: 'Riwayat',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person, color: Color(0xFF2C3E50)),
                label: 'Profil',
              ),
            ],
          ),
        );
      },
    );
  }
}
