class ItemStokModel {
  final String noItem;
  final String namaItem;
  final String unit;
  final String noItemWarna;
  final String namaWarna;
  final double jumlah;
  final double rop;
  final int? leadTimeHari;

  ItemStokModel({
    required this.noItem,
    required this.namaItem,
    required this.unit,
    required this.noItemWarna,
    required this.namaWarna,
    required this.jumlah,
    required this.rop,
    this.leadTimeHari
  });

  factory ItemStokModel.fromMap(Map<String, dynamic> map) {
    return ItemStokModel(
        noItem: map['NoItem'] as String,
        namaItem: map['NamaItem'] as String,
        unit: map['Unit'] as String,
        noItemWarna: map['NoItemWarna'] as String,
        namaWarna: map['NamaWarna'] as String,
        jumlah: map['Jumlah'],
        rop: map['ROP'],
        leadTimeHari: map['LeadTimeHari']
    );
  }
}
