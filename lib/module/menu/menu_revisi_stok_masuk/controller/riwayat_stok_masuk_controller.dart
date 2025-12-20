import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_masuk/controller/data_stok_masuk_controller.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_masuk/controller/revisi_stock_masuk_controller.dart';
import '../../../../core/util_manager/snackbar_manager.dart';
import '../../menu_laporan/data/stok_masuk_model.dart';

extension RiwayatStokMasukController on RevisiStockMasukController {
  onCheckQRRiwayatData(String scanResult) async {
    searchBarHistory.text = "";
    searchResult.value = "";
    log("cek hello");
    try {
      if (scanResult != "-1") {
        searchBarHistory.text = scanResult;
        searchResult.value = scanResult;
        log("cek hasil scan $scanResult");
        await onAssignStokMasuk(scanResult);
      }
      isScanned(true);
    } catch (e) {
      log("cek error $e");
      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal mendapatkan scan",
        content: "error $e",
        colors: Colors.red,
        position: SnackPosition.BOTTOM,
      );
    }
  }

  StokMasukModel? showDetailMasuk({required String noStokMasuk}) {
    var empty = StokMasukModel();

    var detailStokMasuk = listStokMasuk.firstWhereOrNull(
          (pro) => pro.noStokMasuk == noStokMasuk,
    );

    return detailStokMasuk ?? empty;
  }

  onDeleteStokMasuk() async {
    try {
      var listDetailItem = lsDetailStokMasuk[lsNoStokMasukGrouped.first];
      if (listDetailItem != null) {
        for (var item in listDetailItem) {
          var parseJumlahMasuk = item.jumlahMasuk as num;
          var parseStokSekarang = item.stokSekarang as num;
          if (parseJumlahMasuk > parseStokSekarang) {
            Get.back();
            throw Exception(
              item.isDeleted == 0
                  ? "Transaksi stok masuk tidak dapat dihapus karena menyebabkan stok ${item.namaItem} ${item.namaWarna} menjadi minus, tambahkan dulu jumlah stok terlebih dahulu"
                  : "Transaksi stok masuk tidak dapat dihapus karena ${item.namaItem} ${item.namaWarna} sudah dihapus",
            );
          }
          if (item.noItemWarna != null && item.jumlahMasuk != null) {
            await deleteStokMasukCascade(
              item.noItemWarna!,
              lsNoStokMasukGrouped.first,
              item.jumlahMasuk!,
              item.noPermintaanMasuk!
            );
          } else {
            return SnackBarManager().onShowSnacbarMessage(
              title: "Error hapus",
              content: "Terdapat data null",
              colors: Colors.red,
              position: SnackPosition.BOTTOM,
            );
          }
        }
      }
      await onAssignStokMasuk(searchBarHistory.text);
      searchBarHistory.clear();
      await homeController.onAssignCardData();
      SnackBarManager().onShowSnacbarMessage(
        title: "Hapus berhasil",
        content: "Data berhasil dihapus",
        colors: Colors.green,
        position: SnackPosition.BOTTOM,
      );
    } catch (e) {
      log("error delete $e");
      SnackBarManager().onShowSnacbarMessage(
        title: "Error hapus",
        content: "$e",
        colors: Colors.red,
        position: SnackPosition.BOTTOM,
      );
    }
  }
}