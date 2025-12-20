import 'dart:developer';

import '../../../../core/database/database_helper/database_helper.dart';
import '../data/stok_keluar_model.dart';
import '../data/stok_masuk_model.dart';
import 'laporan_controller.dart';

extension LaporanDataController on LaporanController {

 Future<void> initDatabase() async {
    db = await DBHelper.initDb();
  }

  Future<List<Map<String, dynamic>>> getDataStokKeluar(String monthYear) async {
    final result = await db.rawQuery('''
    SELECT 
      i.NoItem,
      i.NamaItem,
      i.Unit,
      v.NoItemWarna,
      v.NamaWarna,
      v.Jumlah AS StokSekarang,
      v.ROP,
      v.isDeleted,
      d.Jumlah AS JumlahKeluar,
      k.NoStokKeluar,
      k.Tanggal,
      k.Keterangan,
      u.NamaDepan
    FROM VARIASI_WARNA v
    JOIN ITEM_STOK i ON v.NoItem = i.NoItem
    JOIN DETAIL_STOK_KELUAR d ON d.NoItemWarna = v.NoItemWarna
    JOIN STOK_KELUAR k ON k.NoStokKeluar = d.NoStokKeluar
    JOIN USER u ON u.Username = k.Username
    WHERE k.Tanggal LIKE ?
  ''', ['%$monthYear']
    );
    return result;
  }

  onAssignStokKeluar(String monthYear) async {
    isLoading(true);
    var result = await getDataStokKeluar(monthYear);
    lsNoStokKeluarGrouped.clear();
    lsDetailStokKeluar.clear();
    listStokKeluar.clear();
    for (var item in result) {
      var data = StokKeluarModel.fromMap(item);
      listStokKeluar.add(data);
      if(!lsNoStokKeluarGrouped.contains(data.noStokKeluar)){
        lsNoStokKeluarGrouped.add(data.noStokKeluar);

      }
    }

    onAssignToRestock(listStokKeluar);
    onAssignEmptyStock(listStokKeluar);

    for (int i = 0; i < lsNoStokKeluarGrouped.length; i++) {
      String noStokKeluar = lsNoStokKeluarGrouped[i];
      var tempList = listStokKeluar
          .where((item) => item.noStokKeluar == noStokKeluar)
          .toList();
      lsDetailStokKeluar.addAll({noStokKeluar: tempList});
    }
    isLoading(false);
  }

  onAssignToRestock (List<StokKeluarModel> listStokKeluar){
    forRestock.value = 0;
    Set<String> checkedItems = {};
    for(var item in listStokKeluar){
      var stok = item.stokSekarang as num;
      var rop = item.rop as num;
      var noItemWarna = item.noItemWarna ?? '';
      if(!checkedItems.contains(noItemWarna)  && rop != 0 && stok > 0 && stok < rop ){
        forRestock.value += 1;
        checkedItems.add(noItemWarna);
      }
    }
    log("cek stok menipis bulan ini ${forRestock.value}");
  }

  onAssignEmptyStock (List<StokKeluarModel> listStokKeluar){
    stockEmpty.value = 0;
    Set<String> checkedItems = {};
    for(var item in listStokKeluar){
    var noItemWarna = item.noItemWarna ?? '';
      if(!checkedItems.contains(noItemWarna) && item.stokSekarang == 0 ){
        stockEmpty.value += 1;
        checkedItems.add(noItemWarna);
      }
    }
  }

  Future<List<Map<String, dynamic>>> getDataStokMasuk(String monthYear) async {
    final result = await db.rawQuery('''
    SELECT 
      i.NoItem,
      i.NamaItem,
      i.Unit,
      v.NoItemWarna,
      v.NamaWarna,
      v.Jumlah AS StokSekarang,
      v.ROP,
      v.isDeleted,
      d.Jumlah AS JumlahMasuk,
      m.NoStokMasuk,
      m.Tanggal,
      m.Keterangan,
      u.NamaDepan
    FROM VARIASI_WARNA v
    JOIN ITEM_STOK i ON v.NoItem = i.NoItem
    JOIN DETAIL_STOK_MASUK d ON d.NoItemWarna = v.NoItemWarna
    JOIN STOK_MASUK m ON m.NoStokMasuk = d.NoStokMasuk
    JOIN USER u ON u.Username = m.Username
    WHERE m.Tanggal LIKE ?
  ''', ['%$monthYear']);
    return result;
  }

  onAssignStokMasuk(String monthYear) async {
    isLoading(true);
    var result = await getDataStokMasuk(monthYear);
    listStokMasuk.clear();
    lsDetailStokMasuk.clear();
    lsNoStokMasukGrouped.clear();
    for (var item in result) {

      var data = StokMasukModel.fromMap(item);
      listStokMasuk.add(data);
      if(!lsNoStokMasukGrouped.contains(data.noStokMasuk)){
        lsNoStokMasukGrouped.add(data.noStokMasuk);
      }
    }
    log("cek lsstok masuk ${listStokMasuk.length}");

    for (int i = 0; i < lsNoStokMasukGrouped.length; i++) {
      String noStokMasuk = lsNoStokMasukGrouped[i];
      var tempList = listStokMasuk
          .where((item) => item.noStokMasuk == noStokMasuk)
          .toList();
      lsDetailStokMasuk.addAll({noStokMasuk: tempList});
    }
     isLoading(false);
  }
}
