import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'wms.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE KATEGORI_STOK (
          NoKategori TEXT PRIMARY KEY,
          NamaKategori TEXT,
          isDeleted INTEGER DEFAULT 0
        )
      ''');

        await db.execute('''
        CREATE TABLE LOKASI_STOK (
          NoLokasi TEXT PRIMARY KEY,
          NamaLokasi TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE ITEM_STOK (
          NoItem TEXT PRIMARY KEY,
          NoKategori TEXT,
          NoLokasi TEXT,
          NamaItem TEXT,
          Unit TEXT,  
          FOREIGN KEY (NoKategori) REFERENCES KATEGORI_STOK(NoKategori),
          FOREIGN KEY (NoLokasi) REFERENCES LOKASI_STOK(NoLokasi)
        )
      ''');

        await db.execute('''
        CREATE TABLE VARIASI_WARNA (
          NoItemWarna TEXT PRIMARY KEY,
          NoItem TEXT,
          Username TEXT,
          NamaWarna TEXT,
          Jumlah REAL,
          Harga INTEGER,
          GambarPath TEXT,
          LeadTimeHari INTEGER,
          SafetyStok REAL,
          AvgDailyDemand REAL,
          ROP REAL,
          isDeleted INTEGER DEFAULT 0,
          FOREIGN KEY (NoItem) REFERENCES ITEM_STOK(NoItem),
          FOREIGN KEY (Username) REFERENCES USER(Username)
        )
      ''');

        await db.execute('''
        CREATE TABLE USER (
          Username TEXT PRIMARY KEY,
          NamaDepan TEXT,
          NamaBelakang TEXT,
          Password TEXT,
          Posisi TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE STOK_MASUK (
          NoStokMasuk TEXT PRIMARY KEY,
          no_permintaan_masuk TEXT,
          Username TEXT,
          Tanggal TEXT,
          Keterangan TEXT,
          FOREIGN KEY (Username) REFERENCES USER(Username),
          FOREIGN KEY (no_permintaan_masuk) REFERENCES USER(permintaan_stok_masuk)
        )
      ''');

        await db.execute('''
        CREATE TABLE DETAIL_STOK_MASUK (
          NoStokMasuk TEXT,
          NoItemWarna TEXT,
          Jumlah REAL,
          PRIMARY KEY (NoStokMasuk, NoItemWarna),
          FOREIGN KEY (NoStokMasuk) REFERENCES STOK_MASUK(NoStokMasuk),
          FOREIGN KEY (NoItemWarna) REFERENCES VARIASI_WARNA(NoItemWarna)
        )
      ''');

        await db.execute('''
        CREATE TABLE STOK_KELUAR (
          NoStokKeluar TEXT PRIMARY KEY,
          no_permintaan_keluar TEXT,
          Username TEXT,
          Tanggal TEXT,
          Keterangan TEXT,
          FOREIGN KEY (Username) REFERENCES USER(Username),
          FOREIGN KEY (no_permintaan_keluar) REFERENCES USER(permintaan_stok_keluar)
        )
      ''');

        await db.execute('''
        CREATE TABLE DETAIL_STOK_KELUAR (
          NoStokKeluar TEXT,
          NoItemWarna TEXT,
          Jumlah REAL,
          PRIMARY KEY (NoStokKeluar, NoItemWarna),
          FOREIGN KEY (NoStokKeluar) REFERENCES STOK_KELUAR(NoStokKeluar),
          FOREIGN KEY (NoItemWarna) REFERENCES VARIASI_WARNA(NoItemWarna)
        )
      ''');

        await db.execute('''
      CREATE TABLE permintaan_stok_masuk (
        no_permintaan_masuk TEXT PRIMARY KEY,
        username TEXT,
        tgl_permintaan_masuk TEXT,
        keterangan TEXT,
        status_masuk INTEGER DEFAULT 0,
        FOREIGN KEY (username) REFERENCES user(username)
        )
      ''');

        await db.execute('''
          CREATE TABLE detail_permintaan_masuk (
  no_permintaan_masuk TEXT,
  NoItemWarna TEXT,
  jumlah_minta REAL,
  PRIMARY KEY (no_permintaan_masuk, NoItemWarna),
  FOREIGN KEY (no_permintaan_masuk) REFERENCES permintaan_stok_masuk(no_permintaan_masuk),
  FOREIGN KEY (NoItemWarna) REFERENCES variasi_warna(NoItemWarna)
)
          ''');

        await db.execute('''
        CREATE TABLE permintaan_stok_keluar (
  no_permintaan_keluar TEXT PRIMARY KEY,
  username TEXT,
  tgl_permintaan_keluar TEXT,
  keterangan TEXT,
  status_keluar INTEGER DEFAULT 0,
  FOREIGN KEY (username) REFERENCES user(username)
);

        ''');

        await db.execute('''
        CREATE TABLE detail_permintaan_keluar (
  no_permintaan_keluar TEXT,
  NoItemWarna TEXT,
  jumlah_minta REAL,

  PRIMARY KEY (no_permintaan_keluar, NoItemWarna),
  FOREIGN KEY (no_permintaan_keluar) REFERENCES permintaan_stok_keluar(no_permintaan_keluar),
  FOREIGN KEY (NoItemWarna) REFERENCES variasi_warna(NoItemWarna)
);

        ''');
        await insertData(db);
      },
    );
  }

  static Future<void> insertData(Database db) async {
    // --- USER
    await db.insert('USER', {
      'Username': 'AD01',
      'NamaDepan': 'Admin',
      'NamaBelakang': 'Pertama',
      'Password':
          '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', //admin123
      'Posisi': 'Admin',
    });
    await db.insert('USER', {
      'Username': 'AD02',
      'NamaDepan': 'Admin',
      'NamaBelakang': 'Kedua',
      'Password':
          '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', //admin123
      'Posisi': 'Admin',
    });
    await db.insert('USER', {
      'Username': 'PE01',
      'NamaDepan': 'Pemilik',
      'NamaBelakang': 'Toko',
      'Password':
          '10176e7b7b24d317acfcf8d2064cfd2f24e154f7b5a96603077d5ef813d6a6b6', //staff123
      'Posisi': 'Pemilik',
    });
    // --- KATEGORI
    await db.insert('KATEGORI_STOK', {
      'NoKategori': 'KT0001',
      'NamaKategori': 'Wanita Matakaki',
      'isDeleted': 0,
    });
    await db.insert('KATEGORI_STOK', {
      'NoKategori': 'KT0002',
      'NamaKategori': 'Muslim',
      'isDeleted': 0,
    });
    await db.insert('KATEGORI_STOK', {
      'NoKategori': 'KT0003',
      'NamaKategori': 'Sarung tangan',
      'isDeleted': 0,
    });
    await db.insert('KATEGORI_STOK', {
      'NoKategori': 'KT0004',
      'NamaKategori': 'Stoking',
      'isDeleted': 0,
    });
    await db.insert('KATEGORI_STOK', {
      'NoKategori': 'KT0005',
      'NamaKategori': 'Kaos kaki samsung',
      'isDeleted': 0,
    });
    await db.insert('KATEGORI_STOK', {
      'NoKategori': 'KT0006',
      'NamaKategori': 'Tawaf',
      'isDeleted': 0,
    });

    // --- LOKASI

    await db.rawQuery('''
    INSERT INTO LOKASI_STOK (NoLokasi, NamaLokasi) VALUES
('LK0001','Kamar Bawah (kolong ranjang)'),
('LK0002','Samping tangga'),
('LK0003','Lt. 2 Rak depan kamar lvl 3'),
('LK0004','Kamar bawah rak level 1'),
('LK0005','Kamar bawah Rak meja'),
('LK0006','Rak tangga sebelah kanan atas'),
('LK0007','Rak Tangga sebelah kanan bawah'),
('LK0008','Lt 1 Rak Belakang lvl 1');
    ''');

    // // --- ITEM
    await db.rawQuery('''
    INSERT INTO ITEM_STOK (NoItem, NoKategori, NoLokasi, NamaItem, Unit) VALUES
('IT0009','KT0006','LK0008','Tawaf korea','Lusin'),
('IT0001','KT0001','LK0001','Kaos Kaki wanita polos TiaoTiaoNiao','Lusin'),
('IT0002','KT0001','LK0002','Kaos kaki wanita merek Qiannai','Lusin'),
('IT0003','KT0002','LK0002','Kaos kaki citra matakaki','Lusin'),
('IT0004','KT0002','LK0003','Kaos kaki citra Betis','Lusin'),
('IT0005','KT0003','LK0004','Sarung tangan brukat','Lusin'),
('IT0006','KT0004','LK0005','Stoking brukat matakaki merek Small bird Mate','Lusin'),
('IT0007','KT0005','LK0006','Kaos kaki samsung jempol matakaki','Lusin'),
('IT0008','KT0005','LK0007','Kaos kaki samsung bulat','Lusin'),
('IT0010','KT0002','LK0030','Kaos Kaki Wudhu Jempol doting','Lusin');
    ''');

    // --- VARIASI
    await db.rawQuery('''
    INSERT INTO VARIASI_WARNA (NoItemWarna, NoItem, Username, NamaWarna, Jumlah, Harga, GambarPath, LeadTimeHari, SafetyStok, AvgDailyDemand,ROP ,isDeleted) VALUES
('VW0034','IT0009','AD01','Mix color',18.0,70000,'/storage/emulated/0/DCIM/WMS-SM/1759245927699.jpg',1,1.0,0.666666666666666629,1.66666666666666651,0),
('VW0001','IT0001','AD01','mix color',22.0,74200,'/storage/emulated/0/DCIM/WMS-SM/1759653347683.jpg',2,2.0,1.0,4.0,0),
('VW0002','IT0001','AD01','Putih',13.0,74200,'/storage/emulated/0/DCIM/WMS-SM/1759653600329.jpg',1,1.0,1.0,2.0,0),
('VW0003','IT0001','AD01','Hitam',3.0,74200,'/storage/emulated/0/DCIM/WMS-SM/1759653657913.jpg',1,1.0,1.0,2.0,0),
('VW0004','IT0001','AD01','abu',5.0,70200,'/storage/emulated/0/DCIM/WMS-SM/1759653764241.jpg',1,0.5,0.5,1.0,0),
('VW0005','IT0001','AD01','Krem',5.5,70200,'/storage/emulated/0/DCIM/WMS-SM/1759653854579.jpg',1,0.5,0.5,1.0,0),
('VW0006','IT0002','AD01','mix color',0.5,76900,'/storage/emulated/0/DCIM/WMS-SM/1759654086959.jpg',1,2.0,1.10000000000000008,3.10000000000000008,0),
('VW0007','IT0003','AD01','Hitam',5.0,125000,'/storage/emulated/0/DCIM/WMS-SM/1759654444819.jpg',1,1.0,1.5,2.5,0),
('VW0008','IT0003','AD01','Putih',2.0,122600,'/storage/emulated/0/DCIM/WMS-SM/1759654419038.jpg',1,1.0,1.0,2.0,0),
('VW0009','IT0003','AD01','Krem',1.0,122600,'/storage/emulated/0/DCIM/WMS-SM/1759654491312.jpg',1,1.5,1.0,2.5,0),
('VW0010','IT0003','AD01','Putih tapak hitam',1.5,122600,'/storage/emulated/0/DCIM/WMS-SM/1759654540042.jpg',1,2.0,2.0,4.0,0),
('VW0011','IT0004','AD01','Hitam',5.0,125000,'/storage/emulated/0/DCIM/WMS-SM/1759654844381.jpg',1,1.0,1.5,2.5,0),
('VW0012','IT0004','AD01','Putih',4.5,122600,'/storage/emulated/0/DCIM/WMS-SM/1759654886401.jpg',1,1.0,1.0,2.0,0),
('VW0013','IT0004','AD01','Krem',3.0,122600,'/storage/emulated/0/DCIM/WMS-SM/1759654960214.jpg',1,1.0,1.0,2.0,0),
('VW0014','IT0004','AD01','Putih tapak hitam',4.0,122600,'/storage/emulated/0/DCIM/WMS-SM/1759655002494.jpg',1,0.5,0.5,1.0,0),
('VW0015','IT0005','AD01','Hitam',8.0,109800,'/storage/emulated/0/DCIM/WMS-SM/1759655304069.jpg',1,2.0,2.0,4.0,0),
('VW0016','IT0005','AD01','Putih',0.0,109800,'/storage/emulated/0/DCIM/WMS-SM/1759655350926.jpg',1,2.0,1.5,3.5,0),
('VW0017','IT0005','AD01','Krem',3.5,100600,'/storage/emulated/0/DCIM/WMS-SM/1759655408684.jpg',1,0.5,0.5,1.0,0),
('VW0018','IT0005','AD01','Mix color',0.0,109800,'/storage/emulated/0/DCIM/WMS-SM/1759655458192.jpg',1,0.5,0.5,1.0,0),
('VW0019','IT0006','AD02','Putih',3.0,87000,'/storage/emulated/0/DCIM/WMS-SM/1759655818570.jpg',1,4.0,1.66999999999999992,5.66999999999999992,0),
('VW0020','IT0006','AD02','Hitam',4.0,87000,'/storage/emulated/0/DCIM/WMS-SM/1759655922025.jpg',1,0.5,1.0,1.5,0),
('VW0021','IT0006','AD02','Krem',3.0,87000,'/storage/emulated/0/DCIM/WMS-SM/1759655988097.jpg',1,0.5,1.0,1.5,0),
('VW0022','IT0006','AD02','Mix color',1.5,87000,'/storage/emulated/0/DCIM/WMS-SM/1759656099393.jpg',1,0.5,0.5,1.0,0),
('VW0023','IT0007','AD02','Hitam',13.0,90800,'/storage/emulated/0/DCIM/WMS-SM/1759656342286.jpg',1,0.5,0.5,1.0,0),
('VW0024','IT0007','AD02','Krem',3.0,90800,'/storage/emulated/0/DCIM/WMS-SM/1759656426773.jpg',1,0.5,0.5,1.0,0),
('VW0025','IT0007','AD02','coklat muda',3.0,90800,'/storage/emulated/0/DCIM/WMS-SM/1759656633670.jpg',1,0.5,0.5,1.0,0),
('VW0026','IT0007','AD02','Coklat tua',2.0,90800,'/storage/emulated/0/DCIM/WMS-SM/1759656700912.jpg',1,0.5,0.5,1.0,0),
('VW0027','IT0007','AD02','abu muda',8.5,90800,'/storage/emulated/0/DCIM/WMS-SM/1759656743490.jpg',1,0.5,0.5,1.0,0),
('VW0028','IT0007','AD02','mix color',0.0,90800,'/storage/emulated/0/DCIM/WMS-SM/1759656788112.jpg',1,0.5,0.5,1.0,0),
('VW0029','IT0008','AD02','Krem',5.0,86800,'/storage/emulated/0/DCIM/WMS-SM/1759657229774.jpg',1,0.5,0.5,1.0,0),
('VW0030','IT0008','AD02','Hitam',7.0,86800,'/storage/emulated/0/DCIM/WMS-SM/1759657265967.jpg',1,0.5,0.5,1.0,0),
('VW0031','IT0008','AD02','Abu',1.0,86800,'/storage/emulated/0/DCIM/WMS-SM/1759657305436.jpg',1,0.5,0.5,1.0,0),
('VW0032','IT0008','AD02','Moka',0.5,86800,'/storage/emulated/0/DCIM/WMS-SM/1759657344047.jpg',1,0.5,0.5,1.0,0),
('VW0033','IT0008','AD02','mix color',0.5,86800,'/storage/emulated/0/DCIM/WMS-SM/1759657472382.jpg',1,0.5,0.5,1.0,0),
('VW0035','IT0010','AD01','mix color',2.0,190400,'/storage/emulated/0/DCIM/WMS-SM/1762593420946.jpg',1,1.0,0.5,1.5,0),
('VW0036','IT0010','AD01','krem',0.0,190400,'/storage/emulated/0/DCIM/WMS-SM/1762593481691.jpg',1,2.0,0.5,2.5,0),
('VW0037','IT0010','AD01','putih',5.0,190400,'/storage/emulated/0/DCIM/WMS-SM/1763196753712.jpg',1,1.0,1.0,2.0,0);
    ''');
  }

  Future<bool> isKodeExist(
    String kode,
    String primaryKey,
    String tableName,
  ) async {
    final db = await initDb();
    final result = await db.query(
      tableName,
      where: '$primaryKey = ?',
      whereArgs: [kode],
    );
    return result.isNotEmpty;
  }

  Future<int> countRecord(
    String tableName,
    String column,
    String columnValue,
  ) async {
    final db = await initDb();
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $tableName WHERE $column = ?', [
        columnValue,
      ]),
    );
    return count ?? 0;
  }
}
