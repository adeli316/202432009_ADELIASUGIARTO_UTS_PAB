MyDuit (Prototype UTS PAB)

Aplikasi pencatatan keuangan pribadi untuk mahasiswa. Dibuat dengan Flutter dan Dart.
Data awal berupa dummy data. Data baru disimpan sementara di list dan hilang saat aplikasi ditutup.

Cara menjalankan

1. Pasang Flutter SDK 3.10 atau lebih baru.
2. Buka folder proyek ini di terminal.
3. Jalankan: flutter create . --platforms=android
   Perintah ini membuat folder android. File lib, pubspec.yaml, dan assets tidak ditimpa.
4. Jalankan: flutter pub get
5. Jalankan: flutter run

Halaman

1. Beranda, dua tab: Transaksi (anggaran, pengeluaran, sisa, daftar transaksi) dan Kategori
2. Detail Transaksi
3. Form Tambah Transaksi
4. Transaksi per Kategori
5. Atur Anggaran

Materi yang dipakai

Widget dan layout, input data (TextFormField), button, Navigator.push dan Navigator.pop,
ListView.builder, ListView.separated, TabBar dan TabBarView, Image.asset.

Struktur

lib/main.dart
lib/theme/        warna dan tema pastel
lib/models/       Category, Transaction
lib/data/         AppState (dummy data dan perhitungan)
lib/utils/        format rupiah dan tanggal
lib/pages/        lima halaman
lib/widgets/      komponen yang dipakai ulang
assets/images/    logo
