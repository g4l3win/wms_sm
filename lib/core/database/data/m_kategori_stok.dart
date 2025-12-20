class KategoriStok {
  final String NoKategori;
  final String NamaKategori;
  final int isDeleted;

  KategoriStok({
    required this.NoKategori,
    required this.NamaKategori,
    required this.isDeleted
  });

  Map<String, dynamic> toMap() {
    return {
      'NoKategori': NoKategori,
      'NamaKategori': NamaKategori,
      'isDeleted' : isDeleted
    };
  }

  factory KategoriStok.fromMap(Map<String, dynamic> map) {
    return KategoriStok(
      NoKategori: map['NoKategori'],
      NamaKategori: map['NamaKategori'],
      isDeleted: map['isDeleted']
    );
  }
}
