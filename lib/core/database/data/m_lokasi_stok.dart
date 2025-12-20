class LokasiStok {
  final String NoLokasi;
  final String NamaLokasi;

  LokasiStok({
    required this.NoLokasi,
    required this.NamaLokasi,
  });

  Map<String, dynamic> toMap() {
    return {
      'NoLokasi': NoLokasi,
      'NamaLokasi': NamaLokasi,
    };
  }

  factory LokasiStok.fromMap(Map<String, dynamic> map) {
    return LokasiStok(
      NoLokasi: map['NoLokasi'],
      NamaLokasi: map['NamaLokasi'],
    );
  }
}