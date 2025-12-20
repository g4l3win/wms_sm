class StokKeluarModel {
  final String? noItem;
  final String? namaItem;
  final String? noItemWarna;
  final String? no_permintaan_keluar;
  final String? namaWarna;
  final double? stokSekarang;
  final String? unit;
  final double? rop;
  final int? leadTimeHari;
  final double? jumlahKeluar;
  final String? noStokKeluar;
  final String? tanggal;
  final String? keterangan;
  final String? namaDepan;
  final int? isDeleted;

  StokKeluarModel({
    this.noItem,
    this.namaItem,
    this.noItemWarna,
    this.no_permintaan_keluar,
    this.namaWarna,
    this.stokSekarang,
    this.unit,
    this.rop,
    this.leadTimeHari,
    this.jumlahKeluar,
    this.noStokKeluar,
    this.tanggal,
    this.keterangan,
    this.namaDepan,
    this.isDeleted
  });

  factory StokKeluarModel.fromMap(Map<String, dynamic> map) {
    return StokKeluarModel(
      noItem: map['NoItem'],
      namaItem: map['NamaItem'],
      noItemWarna: map['NoItemWarna'],
      no_permintaan_keluar: map['no_permintaan_keluar'],
      namaWarna: map['NamaWarna'],
      stokSekarang: (map['StokSekarang'] as num).toDouble(),
      unit: map['Unit'],
      rop: map['ROP'] != null ? (map['ROP'] as num).toDouble() : null,
      leadTimeHari: map['LeadTimeHari'],
      jumlahKeluar: (map['JumlahKeluar'] as num).toDouble(),
      noStokKeluar: map['NoStokKeluar'],
      tanggal: map['Tanggal'],
      keterangan: map['Keterangan'],
      namaDepan: map['NamaDepan'],
      isDeleted: map['isDeleted']
    );
  }
}

class LaporanStokKeluar {
  String? noStokKeluar;
  String? no_permintaan_keluar;
  String? tanggal;
  int? jumlahKeluar;
  String? admin;
  String? username;
  String? keterangan;
  List<StokKeluarModel>? detailItems;

  LaporanStokKeluar({
    this.noStokKeluar,
    this.no_permintaan_keluar,
    this.tanggal,
    this.jumlahKeluar,
    this.admin,
    this.username,
    this.keterangan,
    this.detailItems,
  });

  void clear() {
    noStokKeluar = null;
    no_permintaan_keluar = null;
    tanggal = null;
    jumlahKeluar = null;
    admin = null;
    username = null;
    keterangan = null;
    detailItems = [];
  }
}
