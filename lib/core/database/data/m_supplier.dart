class m_supplier {
  String? noSupplier;
  String? namaSupplier;
  String? alamat;
  int? jumlah;
  String? tanggal;

  m_supplier({this.noSupplier, this.namaSupplier, this.alamat});

  m_supplier.fromJson(Map<String, dynamic> json) {
    noSupplier = json['NoSupplier'];
    namaSupplier = json['NamaSupplier'];
    alamat = json['Alamat'];
    jumlah = json['Jumlah'];
    tanggal = json['Tanggal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['NoSupplier'] = this.noSupplier;
    data['NamaSupplier'] = this.namaSupplier;
    data['Alamat'] = this.alamat;
    data['Tanggal'] = this.tanggal;
    return data;
  }
}
