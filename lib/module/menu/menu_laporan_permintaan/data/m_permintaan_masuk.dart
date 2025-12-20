class PermintaanMasukDummy {
  final String noPermintaan;
  final String tanggal;
  final bool statusMasuk;
  final String keterangan;
  final List<DetailMasukDummy> detail;

  PermintaanMasukDummy({
    required this.noPermintaan,
    required this.tanggal,
    required this.statusMasuk,
    required this.keterangan,
    required this.detail,
  });
}

class DetailMasukDummy {
  final String namaItem;
  final String namaWarna;
  final double jumlah;
  final String unit;

  DetailMasukDummy({
    required this.namaItem,
    required this.namaWarna,
    required this.jumlah,
    required this.unit,
  });
}
