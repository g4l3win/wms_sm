class User {
String? Username;
String? NamaDepan;
String? NamaBelakang;
 String? Password;
String? Posisi;

  User({
    this.Username,
    this.NamaDepan,
    this.NamaBelakang,
    this.Password,
    this.Posisi,
  });

  Map<String, dynamic> toMap() {
    return {
      'Username': Username,
      'NamaDepan': NamaDepan,
      'NamaBelakang': NamaBelakang,
      'Password': Password,
      'Posisi': Posisi,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      Username: map['Username'],
      NamaDepan: map['NamaDepan'],
      NamaBelakang: map['NamaBelakang'],
      Password: map['Password'],
      Posisi: map['Posisi'],
    );
  }
}
