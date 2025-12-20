class ItemStok {
  String? noItem;
  String? noKategori;
  String? noLokasi;
   String? namaItem;
   String? unit;

  ItemStok({
    this.noItem,
    this.noKategori,
    this.noLokasi,
    this.namaItem,
    this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'NoItem': noItem,
      'NoKategori': noKategori,
      'NoLokasi': noLokasi,
      'NamaItem': namaItem,
      'Unit': unit,
    };
  }

  factory ItemStok.fromMap(Map<String, dynamic> map) {
    return ItemStok(
      noItem: map['NoItem'],
      noKategori: map['NoKategori'],
      noLokasi: map['NoLokasi'],
      namaItem: map['NamaItem'],
      unit: map['Unit'],
    );
  }
}