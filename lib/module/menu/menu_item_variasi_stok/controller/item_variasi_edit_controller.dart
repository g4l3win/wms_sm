import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/controller/variasi_warna_controller.dart';
import '../../../../core/database/data/m_item_stok.dart';
import '../../../../core/util_manager/app_theme.dart';
import '../../../../core/util_manager/snackbar_manager.dart';
import '../data/stok_grid_model.dart';
import 'item_variasi_stok_controller.dart';

extension ItemVariasiEditController on ItemVariasiStokController{
  onAssignDataToEdit(StokGridModel item) async{
    await loadKategori(selectedKategori: item.namaKategori).then((_){
      selectedCategory.value = categories.firstWhere((element) => element.contains(item.namaKategori!));
    });

    fieldEditNoItem.text = item.noItem ?? "-";
    image.value = File(item.gambarPath!);
    fieldEditNamaItem.text = item.namaItem ?? "-";
    fieldEditJumlahStok.text = item.jumlah.toString();

    fieldEditNoItemWarna.text = item.noItemWarna ?? "-";
    fieldEditVariasiWarna.text = item.namaWarna ?? "-";
    fieldEditHarga.text = item.harga.toString();
    selectedLocation.value = locations.firstWhere((element) => element.contains(item.namaLokasi!));
    selectedUnit.value = unitOption.firstWhere((element) => element.contains(item.unit!));
    fieldEditAvgDailyDemand.text = item.avgDailyDemand.toString();
    fieldEditLeadTime.text = item.leadTimeHari.toString();
    fieldEditSS.text = item.safetyStok.toString();
    fieldEditROP.text = item.rop.toString();
  }

  hitungEditROP() {
    if (fieldEditSS.text.isNotEmpty &&
        fieldEditLeadTime.text.isNotEmpty &&
        fieldEditAvgDailyDemand.text.isNotEmpty) {
      var avgDailyDemand = double.tryParse(fieldEditAvgDailyDemand.text) ?? 0;
      var leadTime = int.tryParse(fieldEditLeadTime.text) ?? 0;
      var safetyStock = double.tryParse(fieldEditSS.text) ?? 0;
      var ROP = avgDailyDemand * leadTime + safetyStock;
      fieldEditROP.text = ROP.toString();
    }
  }

  String? isValidUpdate(String noCategory, String noLocation) {
    if (fieldEditNoItem.text.isEmpty) return "Nomor item wajib diisi";
    if (fieldEditNamaItem.text.isEmpty) return "Nama item wajib diisi";
    if (selectedUnit.value.isEmpty) return "Unit wajib dipilih";
    if (noCategory.isEmpty) return "Kategori wajib dipilih";
    if (noLocation.isEmpty) return "Lokasi wajib dipilih";
    if (fieldEditNoItemWarna.text.isEmpty) return "Nomor variasi wajib diisi";
    if (fieldEditVariasiWarna.text.isEmpty) return "Nama variasi/warna wajib diisi";
    if (fieldEditSS.text.isEmpty) return "Safety stock wajib diisi";
    if (fieldEditROP.text.isEmpty) return "ROP wajib diisi";
    if (fieldEditLeadTime.text.isEmpty) return "Lead time wajib diisi";
    if (fieldEditJumlahStok.text.isEmpty) return "Jumlah stok wajib diisi";
    if (image.value?.path == null || image.value?.path == "") return "Gambar wajib dipilih";
    if (fieldEditAvgDailyDemand.text.isEmpty) return "Rata-rata penjualan harian wajib diisi";
    if (fieldEditHarga.text.isEmpty) return "Harga wajib diisi";

    return null; // tidak ada error
  }

  onUpdate() async {
    itemData.value = ItemStok();
    variasiWarna.value = StokGridModel();
    stokListToPrint.clear();

    final noCategory = selectedCategory.value.split(" - ");
    final noLocation = selectedLocation.value.split(" - ");

    try {
      final errorMsg = isValidUpdate(noCategory[0], noLocation[0]);

      if (errorMsg != null) {

        SnackBarManager().onShowSnacbarMessage(
          title: "Validasi Gagal",
          content: errorMsg,
          colors: AppTheme.redColor,
          position: SnackPosition.TOP,
        );
        return;
      }

      await updateItemStok(
        noItem: fieldEditNoItem.text,
        unit: selectedUnit.value,
        namaItem: fieldEditNamaItem.text,
        noLokasi: noLocation[0],
        noKategori: noCategory[0],
      ).then((_) async {
        variasiWarna.value = StokGridModel(
          noItemWarna: fieldEditNoItemWarna.text,
          noItem: fieldEditNoItem.text,
          namaItem: fieldEditNamaItem.text,
          safetyStok: double.tryParse(fieldEditSS.text) ?? 0,
          rop: double.tryParse(fieldEditROP.text) ?? 0.0,
          namaWarna: fieldEditVariasiWarna.text,
          leadTimeHari: int.tryParse(fieldEditLeadTime.text) ?? 0,
          jumlah: double.tryParse(fieldEditJumlahStok.text) ?? 0.0,
          gambarPath: image.value?.path ?? "",
          avgDailyDemand: double.tryParse(fieldEditAvgDailyDemand.text) ?? 0.0,
          harga: int.tryParse(fieldEditHarga.text) ?? 0,
          unit: selectedUnit.value,
          namaLokasi: noLocation[1],
        );

        await updateVariasiWarna(variasiWarna.value);
      }).then((_) async {
        await homeController.onAssignCardData();
        await onAssignData();

        stokListToPrint.add(variasiWarna.value);
        pageIdx.value = 5;

        SnackBarManager().onShowSnacbarMessage(
          title: "Sukses",
          content: "Stok berhasil diubah",
          colors: AppTheme.greenColor,
          position: SnackPosition.BOTTOM,
        );
      });
    } catch (e) {
      log("print error update $e");
      final errorMsg = e.toString();
      final shortMsg = errorMsg.length > 70
          ? "${errorMsg.substring(0, 70)}..."
          : errorMsg;

      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal",
        content: "Gagal mengubah data item: $shortMsg",
        colors: AppTheme.redColor,
        position: SnackPosition.BOTTOM,
      );
    }
  }
}
