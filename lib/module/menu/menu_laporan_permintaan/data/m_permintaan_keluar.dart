class PermintaanKeluarDummy {
  final String noPermintaan;
  final String tanggal;
  final bool statusKeluar;
  final String keterangan;
  final List<DetailKeluarDummy> detail;

  PermintaanKeluarDummy({
    required this.noPermintaan,
    required this.tanggal,
    required this.statusKeluar,
    required this.keterangan,
    required this.detail,
  });
}

class DetailKeluarDummy {
  final String namaItem;
  final String namaWarna;
  final double jumlah;
  final String unit;

  DetailKeluarDummy({
    required this.namaItem,
    required this.namaWarna,
    required this.jumlah,
    required this.unit,
  });
}
