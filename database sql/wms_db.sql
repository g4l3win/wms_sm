PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE android_metadata (locale TEXT);
INSERT INTO android_metadata VALUES('en_US');
CREATE TABLE KATEGORI_STOK (
          NoKategori TEXT PRIMARY KEY,
          NamaKategori TEXT,
          isDeleted INTEGER DEFAULT 0
        );
INSERT INTO KATEGORI_STOK VALUES('KT0001','Wanita Matakaki',0);
INSERT INTO KATEGORI_STOK VALUES('KT0002','Muslim',0);
INSERT INTO KATEGORI_STOK VALUES('KT0003','Sarung tangan',0);
INSERT INTO KATEGORI_STOK VALUES('KT0004','Stoking',0);
INSERT INTO KATEGORI_STOK VALUES('KT0005','Kaos kaki samsung',0);
INSERT INTO KATEGORI_STOK VALUES('KT0006','Tawaf',0);
CREATE TABLE LOKASI_STOK (
          NoLokasi TEXT PRIMARY KEY,
          NamaLokasi TEXT
        );
INSERT INTO LOKASI_STOK VALUES('LK0001','Kamar Bawah (kolong ranjang)');
INSERT INTO LOKASI_STOK VALUES('LK0002','Samping tangga');
INSERT INTO LOKASI_STOK VALUES('LK0003','Lt. 2 Rak depan kamar lvl 3');
INSERT INTO LOKASI_STOK VALUES('LK0004','Kamar bawah rak level 1');
INSERT INTO LOKASI_STOK VALUES('LK0005','Kamar bawah Rak meja');
INSERT INTO LOKASI_STOK VALUES('LK0006','Rak tangga sebelah kanan atas');
INSERT INTO LOKASI_STOK VALUES('LK0007','Rak Tangga sebelah kanan bawah');
INSERT INTO LOKASI_STOK VALUES('LK0008','Lt 1 Rak Belakang lvl 1');
CREATE TABLE ITEM_STOK (
          NoItem TEXT PRIMARY KEY,
          NoKategori TEXT,
          NoLokasi TEXT,
          NamaItem TEXT,
          Unit TEXT,  
          FOREIGN KEY (NoKategori) REFERENCES KATEGORI_STOK(NoKategori),
          FOREIGN KEY (NoLokasi) REFERENCES LOKASI_STOK(NoLokasi)
        );
INSERT INTO ITEM_STOK VALUES('IT0009','KT0006','LK0008','Tawaf korea','Lusin');
INSERT INTO ITEM_STOK VALUES('IT0001','KT0001','LK0001','Kaos Kaki wanita polos TiaoTiaoNiao','Lusin');
INSERT INTO ITEM_STOK VALUES('IT0002','KT0001','LK0002','Kaos kaki wanita merek Qiannai','Lusin');
INSERT INTO ITEM_STOK VALUES('IT0003','KT0002','LK0002','Kaos kaki citra matakaki','Lusin');
INSERT INTO ITEM_STOK VALUES('IT0004','KT0002','LK0003','Kaos kaki citra Betis','Lusin');
INSERT INTO ITEM_STOK VALUES('IT0005','KT0003','LK0004','Sarung tangan brukat','Lusin');
INSERT INTO ITEM_STOK VALUES('IT0006','KT0004','LK0005','Stoking brukat matakaki merek Small bird Mate','Lusin');
INSERT INTO ITEM_STOK VALUES('IT0007','KT0005','LK0006','Kaos kaki samsung jempol matakaki','Lusin');
INSERT INTO ITEM_STOK VALUES('IT0008','KT0005','LK0007','Kaos kaki samsung bulat','Lusin');
INSERT INTO ITEM_STOK VALUES('IT0010','KT0002','LK0030','Kaos Kaki Wudhu Jempol doting','Lusin');
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
        );
INSERT INTO VARIASI_WARNA VALUES('VW0034','IT0009','AD01','Mix color',18.0,70000,'/storage/emulated/0/DCIM/WMS-SM/1759245927699.jpg',1,1.0,0.666666666666666629,1.66666666666666651,0);
INSERT INTO VARIASI_WARNA VALUES('VW0001','IT0001','AD01','mix color',22.0,74200,'/storage/emulated/0/DCIM/WMS-SM/1759653347683.jpg',2,2.0,1.0,4.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0002','IT0001','AD01','Putih',13.0,74200,'/storage/emulated/0/DCIM/WMS-SM/1759653600329.jpg',1,1.0,1.0,2.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0003','IT0001','AD01','Hitam',3.0,74200,'/storage/emulated/0/DCIM/WMS-SM/1759653657913.jpg',1,1.0,1.0,2.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0004','IT0001','AD01','abu',5.0,70200,'/storage/emulated/0/DCIM/WMS-SM/1759653764241.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0005','IT0001','AD01','Krem',5.5,70200,'/storage/emulated/0/DCIM/WMS-SM/1759653854579.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0006','IT0002','AD01','mix color',0.5,76900,'/storage/emulated/0/DCIM/WMS-SM/1759654086959.jpg',1,2.0,1.10000000000000008,3.10000000000000008,0);
INSERT INTO VARIASI_WARNA VALUES('VW0007','IT0003','AD01','Hitam',5.0,125000,'/storage/emulated/0/DCIM/WMS-SM/1759654444819.jpg',1,1.0,1.5,2.5,0);
INSERT INTO VARIASI_WARNA VALUES('VW0008','IT0003','AD01','Putih',2.0,122600,'/storage/emulated/0/DCIM/WMS-SM/1759654419038.jpg',1,1.0,1.0,2.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0009','IT0003','AD01','Krem',1.0,122600,'/storage/emulated/0/DCIM/WMS-SM/1759654491312.jpg',1,1.5,1.0,2.5,0);
INSERT INTO VARIASI_WARNA VALUES('VW0010','IT0003','AD01','Putih tapak hitam',1.5,122600,'/storage/emulated/0/DCIM/WMS-SM/1759654540042.jpg',1,2.0,2.0,4.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0011','IT0004','AD01','Hitam',5.0,125000,'/storage/emulated/0/DCIM/WMS-SM/1759654844381.jpg',1,1.0,1.5,2.5,0);
INSERT INTO VARIASI_WARNA VALUES('VW0012','IT0004','AD01','Putih',4.5,122600,'/storage/emulated/0/DCIM/WMS-SM/1759654886401.jpg',1,1.0,1.0,2.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0013','IT0004','AD01','Krem',3.0,122600,'/storage/emulated/0/DCIM/WMS-SM/1759654960214.jpg',1,1.0,1.0,2.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0014','IT0004','AD01','Putih tapak hitam',4.0,122600,'/storage/emulated/0/DCIM/WMS-SM/1759655002494.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0015','IT0005','AD01','Hitam',8.0,109800,'/storage/emulated/0/DCIM/WMS-SM/1759655304069.jpg',1,2.0,2.0,4.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0016','IT0005','AD01','Putih',0.0,109800,'/storage/emulated/0/DCIM/WMS-SM/1759655350926.jpg',1,2.0,1.5,3.5,0);
INSERT INTO VARIASI_WARNA VALUES('VW0017','IT0005','AD01','Krem',3.5,100600,'/storage/emulated/0/DCIM/WMS-SM/1759655408684.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0018','IT0005','AD01','Mix color',0.0,109800,'/storage/emulated/0/DCIM/WMS-SM/1759655458192.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0019','IT0006','AD02','Putih',3.0,87000,'/storage/emulated/0/DCIM/WMS-SM/1759655818570.jpg',1,4.0,1.66999999999999992,5.66999999999999992,0);
INSERT INTO VARIASI_WARNA VALUES('VW0020','IT0006','AD02','Hitam',4.0,87000,'/storage/emulated/0/DCIM/WMS-SM/1759655922025.jpg',1,0.5,1.0,1.5,0);
INSERT INTO VARIASI_WARNA VALUES('VW0021','IT0006','AD02','Krem',3.0,87000,'/storage/emulated/0/DCIM/WMS-SM/1759655988097.jpg',1,0.5,1.0,1.5,0);
INSERT INTO VARIASI_WARNA VALUES('VW0022','IT0006','AD02','Mix color',1.5,87000,'/storage/emulated/0/DCIM/WMS-SM/1759656099393.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0023','IT0007','AD02','Hitam',13.0,90800,'/storage/emulated/0/DCIM/WMS-SM/1759656342286.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0024','IT0007','AD02','Krem',3.0,90800,'/storage/emulated/0/DCIM/WMS-SM/1759656426773.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0025','IT0007','AD02','coklat muda',3.0,90800,'/storage/emulated/0/DCIM/WMS-SM/1759656633670.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0026','IT0007','AD02','Coklat tua',2.0,90800,'/storage/emulated/0/DCIM/WMS-SM/1759656700912.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0027','IT0007','AD02','abu muda',8.5,90800,'/storage/emulated/0/DCIM/WMS-SM/1759656743490.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0028','IT0007','AD02','mix color',0.0,90800,'/storage/emulated/0/DCIM/WMS-SM/1759656788112.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0029','IT0008','AD02','Krem',5.0,86800,'/storage/emulated/0/DCIM/WMS-SM/1759657229774.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0030','IT0008','AD02','Hitam',7.0,86800,'/storage/emulated/0/DCIM/WMS-SM/1759657265967.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0031','IT0008','AD02','Abu',1.0,86800,'/storage/emulated/0/DCIM/WMS-SM/1759657305436.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0032','IT0008','AD02','Moka',0.5,86800,'/storage/emulated/0/DCIM/WMS-SM/1759657344047.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0033','IT0008','AD02','mix color',0.5,86800,'/storage/emulated/0/DCIM/WMS-SM/1759657472382.jpg',1,0.5,0.5,1.0,0);
INSERT INTO VARIASI_WARNA VALUES('VW0035','IT0010','AD01','mix color',2.0,190400,'/storage/emulated/0/DCIM/WMS-SM/1762593420946.jpg',1,1.0,0.5,1.5,0);
INSERT INTO VARIASI_WARNA VALUES('VW0036','IT0010','AD01','krem',0.0,190400,'/storage/emulated/0/DCIM/WMS-SM/1762593481691.jpg',1,2.0,0.5,2.5,0);
INSERT INTO VARIASI_WARNA VALUES('VW0037','IT0010','AD01','putih',5.0,190400,'/storage/emulated/0/DCIM/WMS-SM/1763196753712.jpg',1,1.0,1.0,2.0,0);
CREATE TABLE USER (
          Username TEXT PRIMARY KEY,
          NamaDepan TEXT,
          NamaBelakang TEXT,
          Password TEXT,
          Posisi TEXT
        );
INSERT INTO USER VALUES('AD01','Admin','Pertama','240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9','Admin');
INSERT INTO USER VALUES('AD02','Admin','Kedua','240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9','Admin');
INSERT INTO USER VALUES('PE01','Pemilik','Toko','10176e7b7b24d317acfcf8d2064cfd2f24e154f7b5a96603077d5ef813d6a6b6','Pemilik');
CREATE TABLE STOK_MASUK (
          NoStokMasuk TEXT PRIMARY KEY,
          no_permintaan_masuk TEXT,
          Username TEXT,
          Tanggal TEXT,
          Keterangan TEXT,
          FOREIGN KEY (Username) REFERENCES USER(Username),
          FOREIGN KEY (no_permintaan_masuk) REFERENCES USER(permintaan_stok_masuk)
        );
CREATE TABLE DETAIL_STOK_MASUK (
          NoStokMasuk TEXT,
          NoItemWarna TEXT,
          Jumlah REAL,
          PRIMARY KEY (NoStokMasuk, NoItemWarna),
          FOREIGN KEY (NoStokMasuk) REFERENCES STOK_MASUK(NoStokMasuk),
          FOREIGN KEY (NoItemWarna) REFERENCES VARIASI_WARNA(NoItemWarna)
        );
CREATE TABLE STOK_KELUAR (
          NoStokKeluar TEXT PRIMARY KEY,
          no_permintaan_keluar TEXT,
          Username TEXT,
          Tanggal TEXT,
          Keterangan TEXT,
          FOREIGN KEY (Username) REFERENCES USER(Username),
          FOREIGN KEY (no_permintaan_keluar) REFERENCES USER(permintaan_stok_keluar)
        );
CREATE TABLE DETAIL_STOK_KELUAR (
          NoStokKeluar TEXT,
          NoItemWarna TEXT,
          Jumlah REAL,
          PRIMARY KEY (NoStokKeluar, NoItemWarna),
          FOREIGN KEY (NoStokKeluar) REFERENCES STOK_KELUAR(NoStokKeluar),
          FOREIGN KEY (NoItemWarna) REFERENCES VARIASI_WARNA(NoItemWarna)
        );
CREATE TABLE permintaan_stok_masuk (
        no_permintaan_masuk TEXT PRIMARY KEY,
        username TEXT,
        tgl_permintaan_masuk TEXT,
        keterangan TEXT,
        status_masuk INTEGER DEFAULT 0,
        FOREIGN KEY (username) REFERENCES user(username)
        );
CREATE TABLE detail_permintaan_masuk (
  no_permintaan_masuk TEXT,
  NoItemWarna TEXT,
  jumlah_minta REAL,
  PRIMARY KEY (no_permintaan_masuk, NoItemWarna),
  FOREIGN KEY (no_permintaan_masuk) REFERENCES permintaan_stok_masuk(no_permintaan_masuk),
  FOREIGN KEY (NoItemWarna) REFERENCES variasi_warna(NoItemWarna)
);
CREATE TABLE permintaan_stok_keluar (
  no_permintaan_keluar TEXT PRIMARY KEY,
  username TEXT,
  tgl_permintaan_keluar TEXT,
  keterangan TEXT,
  status_keluar INTEGER DEFAULT 0,
  FOREIGN KEY (username) REFERENCES user(username)
);
CREATE TABLE detail_permintaan_keluar (
  no_permintaan_keluar TEXT,
  NoItemWarna TEXT,
  jumlah_minta REAL,
  PRIMARY KEY (no_permintaan_keluar, NoItemWarna),
  FOREIGN KEY (no_permintaan_keluar) REFERENCES permintaan_stok_keluar(no_permintaan_keluar),
  FOREIGN KEY (NoItemWarna) REFERENCES variasi_warna(NoItemWarna)
);
COMMIT;