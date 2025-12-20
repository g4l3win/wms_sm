class StokGridModel {
  final String? noItem;
  final String? namaItem;
  final String? noItemWarna;
  final String? namaWarna;
  final double? jumlah;
  final String? unit;
  final int? harga;
  final String? gambarPath;
  final int? leadTimeHari;
  final double? safetyStok;
  final double? avgDailyDemand;
  final double? rop;
  final String? noLokasi;
  final String? namaLokasi;
  final String? namaKategori;

  StokGridModel({
    this.noItem,
    this.namaItem,
    this.noItemWarna,
    this.namaWarna,
    this.jumlah,
    this.unit,
    this.harga,
    this.gambarPath,
    this.leadTimeHari,
    this.safetyStok,
    this.avgDailyDemand,
    this.rop,
    this.noLokasi,
    this.namaLokasi,
    this.namaKategori,
  });

  factory StokGridModel.fromMap(Map<String, dynamic> map) {
    return StokGridModel(
      noItem: map['NoItem'],
      namaItem: map['NamaItem'],
      noItemWarna: map['NoItemWarna'],
      namaWarna: map['NamaWarna'],
      jumlah: (map['Jumlah'] as num).toDouble(),
      unit: map['Unit'],
      harga: map['Harga'] as int,
      gambarPath: map['GambarPath'],
      leadTimeHari: map['LeadTimeHari'] != null ? map['LeadTimeHari'] as int : null,
      safetyStok: map['SafetyStok'] != null ? (map['SafetyStok'] as num).toDouble() : null,
      avgDailyDemand: map['AvgDailyDemand'] != null ? (map['AvgDailyDemand'] as num).toDouble() : null,
      rop: map['ROP'] != null ? (map['ROP'] as num).toDouble() : null,
      namaLokasi: map['NamaLokasi'],
      noLokasi: map['NoLokasi'],
      namaKategori: map['NamaKategori'],
    );
  }
}