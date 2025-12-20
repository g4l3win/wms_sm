import 'dart:developer';
import 'package:get/get.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_keluar/controller/data_stok_keluar_controller.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_keluar/controller/revisi_stock_keluar_controller.dart';
import '../../../../core/util_manager/app_theme.dart';
import '../../../../core/util_manager/snackbar_manager.dart';
import '../../menu_laporan/data/stok_keluar_model.dart';

extension RiwayatStokKeluarController on RevisiStockKeluarController {
  onCheckQRRiwayatData(String scanResult) async {
    searchBarHistory.text = "";
    searchResult.value ="";

    try {
      if (scanResult != "-1") {
        searchBarHistory.text = scanResult;
        searchResult.value = scanResult;

        await onAssignStokKeluar(scanResult);
      }
      isScanned(true);
    } catch (e) {
      log("cek error $e");
      SnackBarManager().onShowSnacbarMessage(
          title: "Gagal mendapatkan scan",
          content: "error $e",
          colors: AppTheme.redColor,
          position: SnackPosition.BOTTOM);
    }
  }

  StokKeluarModel? showDetailKeluar({required String noStokKeluar}) {
    var empty = StokKeluarModel();

    var detailStokKeluar =
    listStokKeluar.firstWhereOrNull((pro) => pro.noStokKeluar == noStokKeluar);

    return detailStokKeluar ?? empty;
  }

  onDeleteStokKeluar() async {
    try {
      isLoading(true);
      var listDetailItem = lsDetailStokKeluar[lsNoStokKeluarGrouped.first];
      if (listDetailItem != null) {
        for (var item in listDetailItem) {
          if (item.noItemWarna != null && item.jumlahKeluar != null && item.leadTimeHari != null) {
            await deleteStokKeluarCascade(
                item.noItemWarna!, lsNoStokKeluarGrouped.first, item.jumlahKeluar!, item.leadTimeHari!, noPermintaan.value);
          } else {
            throw Exception("Ada nilai null no Item warna atau jumlah keluar");
          }
        }
      }
      await onAssignStokKeluar(searchBarHistory.text);
      searchBarHistory.clear();
      await homeController.onAssignCardData();
      SnackBarManager().onShowSnacbarMessage(
          title: "Hapus berhasil",
          content: "Data berhasil dihapus",
          colors: AppTheme.greenColor,
          position: SnackPosition.BOTTOM);
      isLoading(false);
    } catch (e) {
      isLoading(false);
      log("error delete $e");
      SnackBarManager().onShowSnacbarMessage(
          title: "Error hapus",
          content: "Gagal melakukan hapus data",
          colors: AppTheme.redColor,
          position: SnackPosition.BOTTOM);
    }
  }
}