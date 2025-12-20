import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/database/data/m_item_stok.dart';
import '../../../../core/database/data/m_kategori_stok.dart';
import '../../../../core/database/data/m_lokasi_stok.dart';
import '../../../../core/database/database_helper/database_helper.dart';
import '../data/stok_grid_model.dart';
import 'item_variasi_stok_controller.dart';

extension VariasiWarnaController on ItemVariasiStokController {

 Future<void> initDatabase() async {
    db = await DBHelper.initDb();
    await onAssignData();
    await loadLokasi();
  }

  Future<List<Map<String, dynamic>>> getDataGrid() async {
    final result = await db.rawQuery('''
    SELECT 
      i.NoItem,
      i.NamaItem,
      i.Unit,
      v.NoItemWarna,
      v.NamaWarna,
      v.Jumlah,
      v.Harga,
      v.GambarPath,
      v.LeadTimeHari,
      v.SafetyStok,
      v.AvgDailyDemand,
      v.ROP,
      l.NamaLokasi,
      k.NamaKategori
    FROM VARIASI_WARNA v
    JOIN ITEM_STOK i ON v.NoItem = i.NoItem
    JOIN LOKASI_STOK l ON i.NoLokasi = l.NoLokasi
    JOIN KATEGORI_STOK k ON i.NoKategori = k.NoKategori
    WHERE v.isDeleted = 0
  ''');
    return result;
  }

  Future<List<Map<String, dynamic>>> getDataToRestock() async {
    final result = await db.rawQuery('''
    SELECT 
      i.NoItem,
      i.NamaItem,
      i.Unit,
      v.NoItemWarna,
      v.NamaWarna,
      v.Jumlah,
      v.Harga,
      v.GambarPath,
      v.LeadTimeHari,
      v.SafetyStok,
      v.AvgDailyDemand,
      v.ROP,
      l.NamaLokasi,
      k.NamaKategori
    FROM VARIASI_WARNA v
    JOIN ITEM_STOK i ON v.NoItem = i.NoItem
    JOIN LOKASI_STOK l ON i.NoLokasi = l.NoLokasi
    JOIN KATEGORI_STOK k ON i.NoKategori = k.NoKategori
    WHERE v.Jumlah != 0 AND v.Jumlah < v.ROP AND v.isDeleted = 0
  ''');
    return result;
  }

  Future<List<Map<String, dynamic>>> getDataStockEmpty() async {
    final result = await db.rawQuery('''
    SELECT 
      i.NoItem,
      i.NamaItem,
      i.Unit,
      v.NoItemWarna,
      v.NamaWarna,
      v.Jumlah,
      v.Harga,
      v.GambarPath,
      v.LeadTimeHari,
      v.SafetyStok,
      v.AvgDailyDemand,
      v.ROP,
      l.NamaLokasi,
      k.NamaKategori
    FROM VARIASI_WARNA v
    JOIN ITEM_STOK i ON v.NoItem = i.NoItem
    JOIN LOKASI_STOK l ON i.NoLokasi = l.NoLokasi
    JOIN KATEGORI_STOK k ON i.NoKategori = k.NoKategori
    WHERE v.Jumlah = 0 AND v.isDeleted = 0
  ''');
    return result;
  }

 Future<void> loadKategori({String? selectedKategori}) async {
   // Ambil semua kategori
   final List<Map<String, dynamic>> maps = await db.query('KATEGORI_STOK');

   // Convert ke model
   var listTemp = maps.map((e) => KategoriStok.fromMap(e)).toList();

   // Filter tergantung mode
   List<KategoriStok> filtered;
   if (pageIdx.value == 3 && selectedKategori != null) {
     // Saat edit → tampilkan semua yang isDeleted=0 + yang sedang dipilih walau sudah dihapus
     filtered = listTemp.where((item) =>
     item.isDeleted == 0 || item.NamaKategori == selectedKategori).toList();
   } else {
     // Saat tambah → hanya tampilkan yang belum dihapus
     filtered = listTemp.where((item) => item.isDeleted == 0).toList();
   }

   // Update observable list
   categories.assignAll(
       filtered.map((item) => "${item.NoKategori} - ${item.NamaKategori}").toList());
 }


 Future<void> loadLokasi() async {
    final List<Map<String, dynamic>> maps = await db.query('LOKASI_STOK');
    var listTemp = maps.map((e) => LokasiStok.fromMap(e)).toList();
    for (var item in listTemp) {
      locations.add("${item.NoLokasi} - ${item.NamaLokasi}");
    }
  }

  onAssignData() async {
    var result = prevPage == "need_restock" ? await getDataToRestock() :
    prevPage == "stock_empty" ? await getDataStockEmpty() : await getDataGrid();
    stokList.clear();
    filterStokList.clear();
    for (var item in result) {
      stokList.add(StokGridModel.fromMap(item));
      filterStokList.add(StokGridModel.fromMap(item));
    }
  }

  Future<void> addItemStok(ItemStok data) async {
    await db.insert('ITEM_STOK', {
      'NoItem': data.noItem,
      'NoKategori': data.noKategori,
      'NoLokasi': data.noLokasi,
      'NamaItem': data.namaItem,
      'Unit': data.unit
    });
  }

  Future<void> addVariasiWarna(StokGridModel data) async {
    await db.insert('VARIASI_WARNA', {
      'NoItemWarna': data.noItemWarna,
      'NoItem': data.noItem,
      'Username': username.value,
      'NamaWarna': data.namaWarna,
      'Jumlah': data.jumlah,
      'Harga' : data.harga,
      'GambarPath': data.gambarPath,
      'LeadTimeHari': data.leadTimeHari,
      'SafetyStok': data.safetyStok,
      'AvgDailyDemand': data.avgDailyDemand,
      'ROP': data.rop,
      'isDeleted' : 0
    });
  }

   Future<void> softDelete(String id) async {
    await db.update(
      'VARIASI_WARNA',
      {'isDeleted': 1},
      where: 'NoItemWarna = ?',
      whereArgs: [id],
    );
  }

 Future<void> deleteVariasiWarnaCascade(String noItemWarna) async {
    // cek apakah masih dipakai di detail stok masuk
    final countMasuk = await DBHelper()
        .countRecord("DETAIL_STOK_MASUK", "NoItemWarna", noItemWarna);

    // cek apakah masih dipakai di detail stok keluar
    final countKeluar = await DBHelper()
        .countRecord("DETAIL_STOK_KELUAR", "NoItemWarna", noItemWarna);

    if ((countMasuk) > 0 || (countKeluar) > 0) {
      softDelete (noItemWarna);
      throw Exception("Stok berhasil dihapus dari daftar stok, Variasi ini masih dipakai di histori stok masuk/keluar");
    }

    // 1. Ambil NoItem dari variasi yang mau dihapus
    final result = await db.query(
      'VARIASI_WARNA',
      columns: ['NoItem'],
      where: 'NoItemWarna = ?',
      whereArgs: [noItemWarna],
    );

    if (result.isEmpty) return; // variasi tidak ditemukan
    final noItem = result.first['NoItem'] as String;

    // 2. Hapus variasi
    await db.delete(
      'VARIASI_WARNA',
      where: 'NoItemWarna = ?',
      whereArgs: [noItemWarna],
    );

    // 3. Cek apakah item ini masih punya variasi lain
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM VARIASI_WARNA WHERE NoItem = ?',
      [noItem],
    ));

    // 4. Kalau tidak ada variasi tersisa hapus ITEM_STOK juga
    if (count == 0) {
      await db.delete(
        'ITEM_STOK',
        where: 'NoItem = ?',
        whereArgs: [noItem],
      );
    }
    await homeController.onAssignCardData();
  }

  Future<int> updateItemStok({
    required String noItem,
    String? noKategori,
    String? noLokasi,
    String? namaItem,
    String? unit,
  }) async {

    final data = <String, dynamic>{};
    if (noKategori != null) data['NoKategori'] = noKategori;
    if (noLokasi != null) data['NoLokasi'] = noLokasi;
    if (namaItem != null) data['NamaItem'] = namaItem;
    if (unit != null) data['Unit'] = unit;

    return await db.update(
      'ITEM_STOK',
      data,
      where: 'NoItem = ?',
      whereArgs: [noItem],
    );
  }

  Future<int> updateVariasiWarna(
      StokGridModel dataWarna
  ) async {

    final data = <String, dynamic>{};
    if (dataWarna.namaWarna != null) data['NamaWarna'] = dataWarna.namaWarna;
    if (dataWarna.jumlah != null) data['Jumlah'] = dataWarna.jumlah;
    if (dataWarna.harga != null) data['Harga'] = dataWarna.harga;
    if (dataWarna.gambarPath != null) data['GambarPath'] = dataWarna.gambarPath;
    if (dataWarna.leadTimeHari != null) data['LeadTimeHari'] = dataWarna.leadTimeHari;
    if (dataWarna.safetyStok != null) data['SafetyStok'] = dataWarna.safetyStok;
    if (dataWarna.avgDailyDemand != null) data['AvgDailyDemand'] = dataWarna.avgDailyDemand;
    if (dataWarna.rop != null) data['ROP'] = dataWarna.rop;

    return await db.update(
      'VARIASI_WARNA',
      data,
      where: 'NoItemWarna = ?',
      whereArgs: [dataWarna.noItemWarna],
    );
  }
}
