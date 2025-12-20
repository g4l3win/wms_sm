import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_keluar/controller/revisi_stock_keluar_controller.dart';
import '../../../../core/database/database_helper/database_helper.dart';
import '../../../../core/util_manager/app_theme.dart';
import '../../../../core/util_manager/snackbar_manager.dart';
import '../../menu_laporan/data/stok_keluar_model.dart';

extension DataStokKeluarController on RevisiStockKeluarController {
  Future<void> initDatabase() async {
    db = await DBHelper.initDb();
  }

  Future<void> addStokKeluar(LaporanStokKeluar keluar) async {
    var data = {
      "NoStokKeluar": keluar.noStokKeluar,
      "no_permintaan_keluar": keluar.no_permintaan_keluar,
      "username": keluar.username,
      "tanggal": keluar.tanggal,
      "keterangan": keluar.keterangan,
    };
    await db.insert('STOK_KELUAR', data);
  }

  Future<void> addDetailStokKeluar(StokKeluarModel detailStokKeluar) async {
    var data = {
      "NoStokKeluar": detailStokKeluar.noStokKeluar,
      "NoItemWarna": detailStokKeluar.noItemWarna,
      "Jumlah": detailStokKeluar.jumlahKeluar,
    };
    await db.insert('DETAIL_STOK_KELUAR', data);
  }

  Future<List<Map<String, dynamic>>> getDataPermintaan(String noPermintaanKeluar) async {
    final result = await db.rawQuery(
      '''
   SELECT
    p.no_permintaan_keluar,
    p.tgl_permintaan_keluar,
    p.status_keluar,
    p.keterangan,
    d.jumlah_minta,
    v.NoItemWarna,
    v.NamaWarna,
    v.LeadTimeHari,
    i.NoItem,
    i.NamaItem,
    i.unit
  FROM permintaan_stok_keluar p
  JOIN detail_permintaan_keluar d
    ON p.no_permintaan_keluar = d.no_permintaan_keluar
  JOIN variasi_warna v
    ON d.NoItemWarna = v.NoItemWarna
  JOIN item_stok i
    ON v.NoItem = i.NoItem
WHERE p.no_permintaan_keluar = ? AND p.status_keluar = 0
  ORDER BY p.tgl_permintaan_keluar DESC
  ''',
      [noPermintaanKeluar],
    );
    return result;
  }
  onAssignRequestData(String noPermintaanKeluar) async {
    var result = await getDataPermintaan(noPermintaanKeluar);
    if (result.isEmpty) {
      isLoading(false);
      isScanned(false);
      return;
    }

    detailPermintaan.assignAll(result);

    noPermintaan.value = result.first['no_permintaan_keluar'];
    tglPermintaan.value = result.first['tgl_permintaan_keluar'];
    totalBarang.value = result
        .map((e) => e['NoItemWarna'])
        .toSet()
        .length;
    fieldNoStokKeluar.text = await autoGenerateNoStokKeluar();
    qtyRealControllers.clear();
    for (var _ in detailPermintaan) {
      qtyRealControllers.add(TextEditingController());
    }
    pageIdx.value =1;
    isScanned(false);
  }

  // ambil max stok keluar dalam 30 hari terakhir
  Future<double> getMaxSafetyStockInOneMonth(String noItemWarna) async {

    final result = await db.rawQuery(
      '''
    SELECT MAX(d.Jumlah) as MaxQty
    FROM DETAIL_STOK_KELUAR d
    JOIN STOK_KELUAR k ON k.NoStokKeluar = d.NoStokKeluar
    WHERE d.NoItemWarna = ?
      AND date(substr(k.Tanggal, 7, 4) || '-' || substr(k.Tanggal, 4, 2) || '-' || substr(k.Tanggal, 1, 2))
      >= date('now', '-30 day')
  ''',
      [noItemWarna],
    );

    if (result.isNotEmpty && result.first['MaxQty'] != null) {
      return (result.first['MaxQty'] as num).toDouble();
    }
    return 0;
  }

  // ambil avg demand 30 hari terakhir
  Future<double> getAvgDemandInOneMonth(String noItemWarna) async {
    final result = await db.rawQuery(
      '''
    SELECT AVG(d.Jumlah) as AvgQty
    FROM DETAIL_STOK_KELUAR d
    JOIN STOK_KELUAR k ON k.NoStokKeluar = d.NoStokKeluar
    WHERE d.NoItemWarna = ?
      AND date(substr(k.Tanggal, 7, 4) || '-' || substr(k.Tanggal, 4, 2) || '-' || substr(k.Tanggal, 1, 2))
      >= date('now', '-30 day')
  ''',
      [noItemWarna],
    );

    if (result.isNotEmpty && result.first['AvgQty'] != null) {
      return (result.first['AvgQty'] as num).toDouble();
    }
    return 0;
  }

  // hitung ROP baru
  Future<double> calculateNewROP(
      String noItemWarna,
      int leadTimeDays) async {
    var ss = await getMaxSafetyStockInOneMonth(noItemWarna);
    var avgDemand = await getAvgDemandInOneMonth(noItemWarna);

    final rop = (avgDemand * leadTimeDays) + ss;
    return rop;
  }

  Future<void> updateStatusPermintaanKeluar(
      String noPermintaanKeluar, int status
      ) async {
    await db.update(
      'permintaan_stok_keluar',
      {
        'status_keluar': status,
      },
      where: 'no_permintaan_keluar = ?',
      whereArgs: [noPermintaanKeluar],
    );
  }

  // update stok + SS + AD + ROP baru
  Future<void> updateStokVariasiWarna(
      String noItemWarna,
      double qtyKeluar,
      int leadTimeHari,
      bool isDelete,
      String noPermintaanKeluar
      ) async {
    final result = await db.query(
      'VARIASI_WARNA',
      columns: ['Jumlah'],
      where: 'NoItemWarna = ?',
      whereArgs: [noItemWarna],
    );

    var stokBaru = 0.0;
    if (result.isNotEmpty) {
      final stokSekarang = (result.first['Jumlah'] as num).toDouble();

      if (isDelete == false) {
        if (stokSekarang < qtyKeluar) {
          throw Exception("Stok tidak mencukupi");
        }
        stokBaru = stokSekarang - qtyKeluar;
        updateStatusPermintaanKeluar(noPermintaanKeluar, 1);
      } else {
        stokBaru = stokSekarang + qtyKeluar;
        updateStatusPermintaanKeluar(noPermintaanKeluar, 0);
      }

      // hitung nilai baru
      final newSS = await getMaxSafetyStockInOneMonth(noItemWarna);
      final newAvgDemand = await getAvgDemandInOneMonth(noItemWarna);
      final newROP = await calculateNewROP(noItemWarna, leadTimeHari);

      await db.update(
        'VARIASI_WARNA',
        {
          'Jumlah': stokBaru,
          'SafetyStok': newSS,
          'AvgDailyDemand': newAvgDemand,
          'ROP': newROP,
        },
        where: 'NoItemWarna = ?',
        whereArgs: [noItemWarna],
      );

      await showStokSnackBar(noItemWarna, stokBaru, newROP);
    }
  }

  Future<void> showStokSnackBar(String noItemWarna, double stokBaru, double rop) async {
    final snackBar = SnackBarManager();

    if (stokBaru == 0) {
      await snackBar.onShowSnacbarMessage(
        title: "Perhatian",
        content: "Stok nomor variasi $noItemWarna habis.",
        colors: Colors.redAccent,
        position: SnackPosition.BOTTOM,
      );
    } else if (stokBaru < rop) {
      await snackBar.onShowSnacbarMessage(
        title: "Perhatian",
        content: "Stok nomor variasi $noItemWarna menipis (di bawah ROP).",
        colors: AppTheme.deepOrangeColor,
        position: SnackPosition.BOTTOM,
      );
    } else {
      await snackBar.onShowSnacbarMessage(
        title: "Info",
        content: "Stok nomor variasi $noItemWarna telah diperbarui menjadi $stokBaru.",
        colors: AppTheme.greenColor,
        position: SnackPosition.BOTTOM,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getDataStokKeluar(
      String noStokKeluar,
      ) async {
    final result = await db.rawQuery(
      '''
   SELECT 
      i.NoItem,
      i.NamaItem,
      i.Unit,
      v.NoItemWarna,
      v.NamaWarna,
      v.Jumlah AS StokSekarang,
      v.LeadTimeHari,
      v.ROP,
      v.isDeleted,
      d.Jumlah AS JumlahKeluar,
      m.NoStokKeluar,
      m.Tanggal,
      m.Keterangan,
      u.NamaDepan
    FROM VARIASI_WARNA v
    JOIN ITEM_STOK i ON v.NoItem = i.NoItem
    JOIN DETAIL_STOK_KELUAR d ON d.NoItemWarna = v.NoItemWarna
    JOIN STOK_KELUAR m ON m.NoStokKeluar = d.NoStokKeluar
    JOIN USER u ON u.Username = m.Username
    WHERE m.NoStokKeluar = ?
  ''',
      [noStokKeluar],
    );
    return result;
  }

  onAssignStokKeluar(String noStokKeluar) async {
    var result = await getDataStokKeluar(noStokKeluar);
    listStokKeluar.clear();
    lsDetailStokKeluar.clear();
    lsNoStokKeluarGrouped.clear();
    for (var item in result) {
      var data = StokKeluarModel.fromMap(item);
      listStokKeluar.add(data);
      if (!lsNoStokKeluarGrouped.contains(data.noStokKeluar)) {
        lsNoStokKeluarGrouped.add(data.noStokKeluar);
      }
    }

    for (int i = 0; i < lsNoStokKeluarGrouped.length; i++) {
      String noStokKeluar = lsNoStokKeluarGrouped[i];
      var tempList =
      listStokKeluar
          .where((item) => item.noStokKeluar == noStokKeluar)
          .toList();
      lsDetailStokKeluar.addAll({noStokKeluar: tempList});
    }
  }

  Future<void> deleteStokKeluarCascade(
      String noItemWarna,
      String noStokKeluar,
      double qtyKeluar,
      int leadTimeHari,
      String noPermintaanKeluar
      ) async {
    // hapus dulu detail stok Keluar sesuai key
    await db.delete(
      'DETAIL_STOK_KELUAR',
      where: 'NoItemWarna = ? AND NoStokKeluar = ?',
      whereArgs: [noItemWarna, noStokKeluar],
    );

    // cek apakah stok Keluar ini masih punya detail lain
    var count = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM DETAIL_STOK_KELUAR WHERE NoStokKeluar = ?',
        [noStokKeluar],
      ),
    );

    // kalau sudah tidak ada detail, hapus header stok Keluar
    if (count == 0) {
      await db.delete(
        'STOK_KELUAR',
        where: 'NoStokKeluar = ?',
        whereArgs: [noStokKeluar],
      );
    }

    await updateStokVariasiWarna(noItemWarna, qtyKeluar,leadTimeHari , true,noPermintaanKeluar);
  }
}