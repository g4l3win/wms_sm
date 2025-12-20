
class VariasiWarna {
  final String noItemWarna;
  final String noItem;
  final String namaWarna;
  final int jumlah;
  final int harga;
  final String gambarPath;

  VariasiWarna({
    required this.noItemWarna,
    required this.noItem,
    required this.namaWarna,
    required this.jumlah,
    required this.harga,
    required this.gambarPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'NoItemWarna': noItemWarna,
      'NoItem': noItem,
      'NamaWarna': namaWarna,
      'Jumlah': jumlah,
      'Harga': harga,
      'GambarPath': gambarPath,
    };
  }

  factory VariasiWarna.fromMap(Map<String, dynamic> map) {
    return VariasiWarna(
      noItemWarna: map['NoItemWarna'],
      noItem: map['NoItem'],
      namaWarna: map['NamaWarna'],
      jumlah: map['Jumlah'],
      harga: map['Harga'],
      gambarPath: map['GambarPath'],
    );
  }
}
