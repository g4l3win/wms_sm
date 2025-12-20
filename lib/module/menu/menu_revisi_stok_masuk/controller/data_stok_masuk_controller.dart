import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_masuk/controller/revisi_stock_masuk_controller.dart';
import '../../../../core/database/database_helper/database_helper.dart';
import '../../../../core/util_manager/app_theme.dart';
import '../../../../core/util_manager/snackbar_manager.dart';
import '../../menu_laporan/data/stok_masuk_model.dart';

extension DataStokMasukController on RevisiStockMasukController {
  Future<void> initDatabase() async {
    db = await DBHelper.initDb();
  }

  Future<void> addStokMasuk(LaporanStokMasuk masuk) async {
    var data = {
      "noStokMasuk": masuk.noStokMasuk,
      "username": masuk.username,
      "no_permintaan_masuk": masuk.noPermintaanMasuk,
      "tanggal": masuk.tanggal,
      "keterangan": masuk.keterangan,
    };
    await db.insert('STOK_MASUK', data);
  }

  Future<void> addDetailStokMasuk(StokMasukModel detailStokMasuk) async {
    var data = {
      "noStokMasuk": detailStokMasuk.noStokMasuk,
      "NoItemWarna": detailStokMasuk.noItemWarna,
      "Jumlah": detailStokMasuk.jumlahMasuk,
    };
    await db.insert('DETAIL_STOK_MASUK', data);
  }

  Future<void> updateStatusPermintaanMasuk(
      String noPermintaanMasuk, int status
      ) async {
    await db.update(
      'permintaan_stok_masuk',
      {
        'status_masuk': status,
      },
      where: 'no_permintaan_masuk = ?',
      whereArgs: [noPermintaanMasuk],
    );
  }


  Future<List<Map<String, dynamic>>> getDataPermintaan(String noPermintaanMasuk) async {
    final result = await db.rawQuery(
      '''
   SELECT
    p.no_permintaan_masuk,
    p.tgl_permintaan_masuk,
    p.status_masuk,
    p.keterangan,
    d.jumlah_minta,
    v.NoItemWarna,
    v.NamaWarna,
    i.NoItem,
    i.NamaItem,
    i.Unit
  FROM permintaan_stok_masuk p
  JOIN detail_permintaan_masuk d
    ON p.no_permintaan_masuk = d.no_permintaan_masuk
  JOIN variasi_warna v
    ON d.NoItemWarna = v.NoItemWarna
  JOIN item_stok i
    ON v.NoItem = i.NoItem
WHERE p.no_permintaan_masuk = ? AND p.status_masuk = 0
  ORDER BY p.tgl_permintaan_masuk DESC
  
  ''',
      [noPermintaanMasuk],
    );
    return result;
  }

  Future<String> autoGenerateNoStokMasuk() async {
    var last = await db.rawQuery(
      "SELECT NoStokMasuk FROM STOK_MASUK "
          "ORDER BY CAST(SUBSTR(NoStokMasuk, 3) AS INTEGER) DESC LIMIT 1",
    );

    int nextNumber = 1;

    if (last.isNotEmpty) {
      String lastNo = last.first["NoStokMasuk"] as String;
      String numericPart = lastNo.replaceAll("SM", "");
      nextNumber = int.parse(numericPart) + 1;
    }

    String formatted = nextNumber.toString().padLeft(4, "0");
    return "SM$formatted";
  }

  onAssignRequestData(String noPermintaanMasuk) async {
     var result = await getDataPermintaan(noPermintaanMasuk);
     if (result.isEmpty) {
       isLoading(false);
       isScanned(false);
       return;
     }

     detailPermintaan.assignAll(result);

     noPermintaan.value = result.first['no_permintaan_masuk'];
     tglPermintaan.value = result.first['tgl_permintaan_masuk'];
     totalBarang.value = result
         .map((e) => e['NoItemWarna'])
         .toSet()
         .length;

     fieldNoStokMasuk.text = await autoGenerateNoStokMasuk();
     qtyRealControllers.clear();
     for (var _ in detailPermintaan) {
       qtyRealControllers.add(TextEditingController());
     }
      pageIdx.value= 1;
     isScanned(false);
  }

  Future<List<Map<String, dynamic>>> getDataStokMasuk(
      String noStokMasuk,
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
      v.ROP,
      v.isDeleted,
      d.Jumlah AS JumlahMasuk,
      m.NoStokMasuk,
      m.no_permintaan_masuk,
      m.Tanggal,
      m.Keterangan,
      u.NamaDepan
    FROM VARIASI_WARNA v
    JOIN ITEM_STOK i ON v.NoItem = i.NoItem
    JOIN DETAIL_STOK_MASUK d ON d.NoItemWarna = v.NoItemWarna
    JOIN STOK_MASUK m ON m.NoStokMasuk = d.NoStokMasuk
    JOIN USER u ON u.Username = m.Username
    WHERE m.NoStokMasuk = ?
  ''',
      [noStokMasuk],
    );
    return result;
  }

  onAssignStokMasuk(String noStokMasuk) async {
    var result = await getDataStokMasuk(noStokMasuk);
    listStokMasuk.clear();
    lsDetailStokMasuk.clear();
    lsNoStokMasukGrouped.clear();
    for (var item in result) {
      var data = StokMasukModel.fromMap(item);
      listStokMasuk.add(data);
      if (!lsNoStokMasukGrouped.contains(data.noStokMasuk)) {
        lsNoStokMasukGrouped.add(data.noStokMasuk);
      }
    }
    log("cek lsstok masuk ${listStokMasuk.length}");

    for (int i = 0; i < lsNoStokMasukGrouped.length; i++) {
      String noStokMasuk = lsNoStokMasukGrouped[i];
      var tempList =
      listStokMasuk
          .where((item) => item.noStokMasuk == noStokMasuk)
          .toList();
      lsDetailStokMasuk.addAll({noStokMasuk: tempList});
    }
  }

  Future<void> updateStokVariasiWarna(
      String noItemWarna,
      double qtyKeluar,
      bool isDelete,
      String noPermintaanMasuk,
      int leadTimeBaru
      ) async {
    final result = await db.query(
      'VARIASI_WARNA',
      columns: ['Jumlah', 'isDeleted'],
      where: 'NoItemWarna = ?',
      whereArgs: [noItemWarna],
    );

    var stokBaru = 0.0;
    if (result.isNotEmpty) {
      final stokSekarang = (result.first['Jumlah'] as num).toDouble();

      if (isDelete == false) {
        stokBaru = stokSekarang + qtyKeluar;
        updateStatusPermintaanMasuk(noPermintaanMasuk, 1);
      } else {
        stokBaru = stokSekarang - qtyKeluar;
       updateStatusPermintaanMasuk(noPermintaanMasuk, 0);
      }

      await db.update(
        'VARIASI_WARNA',
        {'Jumlah': stokBaru,
         'LeadTimeHari' : leadTimeBaru
        },
        where: 'NoItemWarna = ?',
        whereArgs: [noItemWarna],
      );

      return SnackBarManager().onShowSnacbarMessage(
        title: "Perhatian",
        content:
        result.first['isDeleted'] == 0
            ? "Jumlah Stok nomor variasi $noItemWarna diubah menjadi $stokBaru"
            : "Perubahan disimpan",
        colors: AppTheme.greenColor,
        position: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteStokMasukCascade(
      String noItemWarna,
      String noStokMasuk,
      double qtyKeluar,
      String noPermintaanMasuk
      ) async {
    // hapus dulu detail stok masuk sesuai key
    await db.delete(
      'DETAIL_STOK_MASUK',
      where: 'NoItemWarna = ? AND NoStokMasuk = ?',
      whereArgs: [noItemWarna, noStokMasuk],
    );

    // cek apakah stok masuk ini masih punya detail lain
    var count = await DBHelper().countRecord(
      'DETAIL_STOK_MASUK',
      'NoStokMasuk',
      noStokMasuk,
    );

    // kalau sudah tidak ada detail, hapus header stok masuk
    if (count == 0) {
      await db.delete(
        'STOK_MASUK',
        where: 'NoStokMasuk = ?',
        whereArgs: [noStokMasuk],
      );
    }

    await updateStokVariasiWarna(noItemWarna, qtyKeluar, true, noPermintaanMasuk,1);
  }
}