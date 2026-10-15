import 'package:flutter/material.dart';

class MenuItem {
  final String nama;
  final String deskripsi;
  final int harga;
  final String kategori;
  final String imageUrl;
  final double rating;
  final IconData ikon;
  final Color warnaIkon;
  final bool bestseller;

  const MenuItem({
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.kategori,
    required this.imageUrl,
    this.rating = 4.8,
    required this.ikon,
    required this.warnaIkon,
    this.bestseller = false,
  });
}
