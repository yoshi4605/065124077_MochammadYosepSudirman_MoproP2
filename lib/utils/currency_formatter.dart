String formatHarga(int harga) {
  String h = harga.toString();
  String hasil = '';
  int count = 0;
  for (int i = h.length - 1; i >= 0; i--) {
    hasil = h[i] + hasil;
    count++;
    if (count % 3 == 0 && i != 0) {
      hasil = '.$hasil';
    }
  }
  return 'Rp $hasil';
}

