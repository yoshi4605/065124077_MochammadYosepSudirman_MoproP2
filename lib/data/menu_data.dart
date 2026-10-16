import 'package:flutter/material.dart';
import '../models/menu_item.dart';

const List<MenuItem> semuaMenu = [
  MenuItem(
    nama: 'Ayam Geprek Sambal Bawang',
    deskripsi: 'Ayam crispy geprek sambal bawang pedas nampol + lalapan segar',
    harga: 15000,
    kategori: 'Makanan',
    imageUrl:
        'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=600&auto=format&fit=crop&q=80',
    rating: 4.9,
    ikon: Icons.set_meal,
    warnaIkon: Color(0xFFE74C3C),
    bestseller: true,
  ),
  MenuItem(
    nama: 'Nasi Goreng Spesial Bu Sari',
    deskripsi: 'Nasi goreng harum dengan telur mata sapi, suwiran ayam, dan kerupuk',
    harga: 14000,
    kategori: 'Makanan',
    imageUrl:
        'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=600&auto=format&fit=crop&q=80',
    rating: 4.8,
    ikon: Icons.rice_bowl,
    warnaIkon: Color(0xFFF39C12),
    bestseller: true,
  ),
  MenuItem(
    nama: 'Es Teh Manis Jumbo',
    deskripsi: 'Teh melati dingin segar racikan khas porsi jumbo pelepas dahaga',
    harga: 4000,
    kategori: 'Minuman',
    imageUrl:
        'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=600&auto=format&fit=crop&q=80',
    rating: 4.9,
    ikon: Icons.local_cafe,
    warnaIkon: Color(0xFF795548),
    bestseller: true,
  ),
  MenuItem(
    nama: 'Kopi Susu Gula Aren',
    deskripsi: 'Espresso blend mantap dengan susu segar dan manisnya aren asli',
    harga: 8000,
    kategori: 'Minuman',
    imageUrl:
        'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=600&auto=format&fit=crop&q=80',
    rating: 4.8,
    ikon: Icons.coffee,
    warnaIkon: Color(0xFF6D4C41),
    bestseller: true,
  ),
  MenuItem(
    nama: 'Tempe Mendoan Hangat (3 Pcs)',
    deskripsi: 'Tempe mendoan gurih khas Banyumas dengan cocolan kecap rawit',
    harga: 6000,
    kategori: 'Snack',
    imageUrl:
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&fit=crop&q=80',
    rating: 4.9,
    ikon: Icons.fastfood,
    warnaIkon: Color(0xFFD35400),
    bestseller: true,
  ),
  MenuItem(
    nama: 'Mie Ayam Bakso Komplit',
    deskripsi: 'Mie kenyal gurih dengan topping ayam manis, bakso sapi halus & pangsit',
    harga: 13000,
    kategori: 'Makanan',
    imageUrl:
        'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80',
    rating: 4.8,
    ikon: Icons.ramen_dining,
    warnaIkon: Color(0xFFE67E22),
  ),
  MenuItem(
    nama: 'Soto Ayam Kuning Spesial',
    deskripsi: 'Kuah kaldu soto kaya rempah dengan sohun, suwiran ayam, dan kol segar',
    harga: 12000,
    kategori: 'Makanan',
    imageUrl:
        'https://images.unsplash.com/photo-1547928576-a4a33237cbc3?w=600&auto=format&fit=crop&q=80',
    rating: 4.7,
    ikon: Icons.soup_kitchen,
    warnaIkon: Color(0xFFF1C40F),
  ),
  MenuItem(
    nama: 'Gado-Gado Bumbu Kacang',
    deskripsi: 'Sayuran rebus segar disiram bumbu kacang medok khas Bu Sari',
    harga: 11000,
    kategori: 'Makanan',
    imageUrl:
        'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=600&auto=format&fit=crop&q=80',
    rating: 4.6,
    ikon: Icons.eco,
    warnaIkon: Color(0xFF27AE60),
  ),
  MenuItem(
    nama: 'Es Jeruk Peras Segar',
    deskripsi: 'Perasan jeruk asli murni dingin segar',
    harga: 5000,
    kategori: 'Minuman',
    imageUrl:
        'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=600&auto=format&fit=crop&q=80',
    rating: 4.8,
    ikon: Icons.local_drink,
    warnaIkon: Color(0xFFE67E22),
  ),
  MenuItem(
    nama: 'Jus Alpukat Coklat',
    deskripsi: 'Jus buah alpukat mentega kental disiram kental manis coklat',
    harga: 10000,
    kategori: 'Minuman',
    imageUrl:
        'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=600&auto=format&fit=crop&q=80',
    rating: 4.8,
    ikon: Icons.blender,
    warnaIkon: Color(0xFF2ECC71),
  ),
  MenuItem(
    nama: 'Risol Mayo Gurih (2 Pcs)',
    deskripsi: 'Risol kulit renyah isi smoked beef, telur, dan saus mayo melimpah',
    harga: 5000,
    kategori: 'Snack',
    imageUrl:
        'https://images.unsplash.com/photo-1608897013039-887f21d8c804?w=600&auto=format&fit=crop&q=80',
    rating: 4.7,
    ikon: Icons.bakery_dining,
    warnaIkon: Color(0xFFF39C12),
  ),
];

const List<String> kategoriList = [
  'Semua',
  'Makanan',
  'Minuman',
  'Snack',
];
