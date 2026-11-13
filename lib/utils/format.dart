/// Format angka ke rupiah, contoh: 1500000 menjadi "Rp 1.500.000".
String rupiah(int value) {
  final negative = value < 0;
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final fromEnd = digits.length - i;
    buffer.write(digits[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write('.');
  }
  return '${negative ? '-' : ''}Rp $buffer';
}

const List<String> _bulan = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];

const List<String> _hari = [
  'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu',
];

/// Contoh: "13 Nov 2026".
String tanggalSingkat(DateTime d) =>
    '${d.day} ${_bulan[d.month - 1].substring(0, 3)} ${d.year}';

/// Contoh: "Jumat, 13 November 2026".
String tanggalLengkap(DateTime d) =>
    '${_hari[d.weekday - 1]}, ${d.day} ${_bulan[d.month - 1]} ${d.year}';

/// Contoh: "November 2026".
String bulanTahun(DateTime d) => '${_bulan[d.month - 1]} ${d.year}';

/// Nama bulan lengkap, bulan 1 sampai 12.
String namaBulan(int month) => _bulan[month - 1];

/// Nama bulan singkat, contoh: "Nov".
String namaBulanSingkat(int month) => _bulan[month - 1].substring(0, 3);
