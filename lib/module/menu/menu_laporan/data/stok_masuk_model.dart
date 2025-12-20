class StokMasukModel {
  final String? noItem;
  final String? namaItem;
  final String? noItemWarna;
  final String? noPermintaanMasuk;
  final String? namaWarna;
  final double? stokSekarang;
  final String? unit;
  final double? rop;
  final double? jumlahMasuk;
  final String? noStokMasuk;
  final String? tanggal;
  final String? keterangan;
  final String? namaDepan;
  final int? isDeleted;

  StokMasukModel({
    this.noItem,
    this.namaItem,
    this.noItemWarna,
    this.noPermintaanMasuk,
    this.namaWarna,
    this.stokSekarang,
    this.unit,
    this.rop,
    this.jumlahMasuk,
    this.noStokMasuk,
    this.tanggal,
    this.keterangan,
    this.namaDepan,
    this.isDeleted
  });

  factory StokMasukModel.fromMap(Map<String, dynamic> map) {
    return StokMasukModel(
      noItem: map['NoItem'],
      namaItem: map['NamaItem'],
      noItemWarna: map['NoItemWarna'],
      noPermintaanMasuk: map['no_permintaan_masuk'],
      namaWarna: map['NamaWarna'],
      stokSekarang: (map['StokSekarang'] as num).toDouble(),
      unit: map['Unit'],
      rop: map['ROP'] != null ? (map['ROP'] as num).toDouble() : null,
      jumlahMasuk: (map['JumlahMasuk'] as num).toDouble(),
      noStokMasuk: map['NoStokMasuk'],
      tanggal: map['Tanggal'],
      keterangan: map['Keterangan'],
      namaDepan: map['NamaDepan'],
      isDeleted: map['isDeleted']
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'NoItem' : noItem,
      'NamaItem' : namaItem,
      'NoItemWarna' : noItemWarna,
      'no_permintaan_masuk': noPermintaanMasuk,
      'NamaWarna' : namaWarna,
      'StokSekarang' : stokSekarang,
      'Unit' : unit,
      'ROP' : rop,
      'JumlahMasuk' : jumlahMasuk,
      'NoStokMasuk' : noStokMasuk,
      'Tanggal' : tanggal,
      'Keterangan' : keterangan,
      'NamaDepan' : namaDepan,
      'isDeleted' : isDeleted,
    };
  }
}

class LaporanStokMasuk {
  String? noStokMasuk;
  String? noPermintaanMasuk;
  String? tanggal;
  int? jumlahMasuk;
  String? admin;
  String? username;
  String? keterangan;
  List<StokMasukModel>? detailItems;

  LaporanStokMasuk({
    this.noStokMasuk,
    this.noPermintaanMasuk,
    this.tanggal,
    this.jumlahMasuk,
    this.admin,
    this.username,
    this.keterangan,
    this.detailItems,
  });

  void clear() {
    noStokMasuk = null;
    noPermintaanMasuk = null;
    tanggal = null;
    jumlahMasuk = null;
    admin = null;
    username = null;
    keterangan = null;
    detailItems = [];
  }
}
