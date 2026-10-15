import 'package:flutter/material.dart';
import '../data/app_state.dart';
import '../data/menu_data.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../utils/currency_formatter.dart';
import '../widgets/bestseller_card.dart';
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

  String _kategoriAktif = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _terlarisScrollController = ScrollController();

  void _scrollTerlaris(bool keKanan) {
    if (!_terlarisScrollController.hasClients) return;
    final target = _terlarisScrollController.offset + (keKanan ? 190.0 : -190.0);
    _terlarisScrollController.animateTo(
      target.clamp(0.0, _terlarisScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  List<MenuItem> get _menuTerlaris =>
      semuaMenu.where((m) => m.bestseller).toList();

  List<MenuItem> get _menuFiltered {
    return semuaMenu.where((m) {
      final cocokKategori =
          _kategoriAktif == 'Semua' || m.kategori == _kategoriAktif;
      final cocokSearch = _searchQuery.isEmpty ||
          m.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.deskripsi.toLowerCase().contains(_searchQuery.toLowerCase());
      return cocokKategori && cocokSearch;
    }).toList();
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
        content: Text('${menu.nama} berhasil masuk ke keranjang!'),
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

    return CustomScrollView(
      slivers: [
        // 1. SliverAppBar / AppBar (Wajib sesuai rubrik)
        SliverAppBar(
          expandedHeight: 180,
          pinned: true,
          backgroundColor: const Color(0xFF2C3E50),
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 20, bottom: 22),
            title: const Text(
              'Kantin Bu Sari',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -30,
                    bottom: -10,
                    child: Icon(
                      Icons.restaurant,
                      size: 160,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 68,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_filled,
                            color: Colors.white,
                            size: 13,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Buka 07.00 - 17.00 WIB',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
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
        ),

        // 2. TextField (Search) - Wajib sesuai rubrik
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari makanan, minuman, atau snack...',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF2C3E50)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
        ),

        // Pilihan Terlaris Hari Ini
        if (_searchQuery.isEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '⭐ Pilihan Terlaris Hari Ini',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
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
                              size: 18, color: Color(0xFF2C3E50)),
                        ),
                      ),
                      const SizedBox(width: 8),
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
                              size: 18, color: Color(0xFF2C3E50)),
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
              height: 195,
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

        // Header Daftar Menu & ChoiceChip (Filter) - Wajib sesuai rubrik
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              children: [
                Text(
                  'Daftar Menu (${menuList.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 3. ChoiceChip (Filter) - Wajib sesuai rubrik
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: aktif
                            ? const Color(0xFF2C3E50)
                            : Colors.grey.shade300,
                      ),
                      labelStyle: TextStyle(
                        color: aktif ? Colors.white : const Color(0xFF1A1A1A),
                        fontWeight:
                            aktif ? FontWeight.w600 : FontWeight.normal,
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

        // 4. GridView (Card) - Wajib sesuai rubrik
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
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                mainAxisExtent: 240,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final menu = menuList[index];

                  // Card Widget (Wajib sesuai rubrik)
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _bukaDetail(menu),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Foto Menu
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: Image.network(
                              menu.imageUrl,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                height: 120,
                                color: const Color(0xFFF0F3F4),
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
                                        size: 12, color: Colors.amber),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${menu.rating}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A1A1A),
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
                                      onTap: () => _bukaDetail(menu),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFE74C3C),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.add,
                                            size: 16, color: Colors.white),
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
            backgroundColor: const Color(0xFFE74C3C),
            child: Badge(
              isLabelVisible: totalItem > 0,
              label: Text(
                '$totalItem',
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold),
              ),
              child: const Icon(Icons.shopping_cart, color: Colors.white),
            ),
          ),

          // Navigasi di Bawah (NavigationBar)
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
