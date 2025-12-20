import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/controller/variasi_warna_controller.dart';
import '../../../../core/database/database_helper/database_helper.dart';
import '../../../../core/util_manager/snackbar_manager.dart';
import '../data/stok_grid_model.dart';
import 'item_variasi_stok_controller.dart';

extension AddVariasiOnlyController on ItemVariasiStokController{
  onAssignDatatoAddVariation (StokGridModel item){
    noItem.value = item.noItem ?? "";
    namaItem.value = item.namaItem ?? "";
    unitToAdd.value = item.unit ?? "";
    locationToAdd.value = item.namaLokasi ?? '';
  }

   updateIncrement(bool isIncrease) async {
    int currentValue = int.parse(fieldTotalVariasi.text);
    
    if (isIncrease) {
      currentValue++;
      if (currentValue > maxIncrement) {
        currentValue = maxIncrement;
        SnackBarManager().onShowSnacbarMessage(
          title: "Perhatian",
          content: "Jumlah variasi melebihi batas maksimum ($maxIncrement)",
          colors: Colors.red,
          position: SnackPosition.TOP,
        );
      }
    }
    
    else {
      currentValue--;
      if (currentValue < minIncrement) {
        currentValue = minIncrement;
        SnackBarManager().onShowSnacbarMessage(
          title: "Perhatian",
          content: "Jumlah variasi minimal $minIncrement",
          colors: Colors.red,
          position: SnackPosition.TOP,
        );
      }
    }
    fieldTotalVariasi.text = currentValue.toString();
    await  addWidgetVarWarna();
  }

  Future<String?> isValidInsertVariation() async {
    if (variasiForms.isEmpty) {
      return "Belum ada variasi yang ditambahkan";
    }
    if (fieldTotalVariasi.text.isEmpty) {
      return "Total variasi wajib diisi";
    }

    for (var i = 0; i < variasiForms.length; i++) {
      final form = variasiForms[i];

      final noVariasiExist = await DBHelper().isKodeExist(
        form.noVariasiController.text,
        'NoItemWarna',
        'VARIASI_WARNA',
      );

      if (form.noVariasiController.text.isEmpty) {
        return "Nomor variasi wajib diisi (form ke-${i + 1})";
      }
      if (noItem.value.isEmpty) {
        return "Nomor item wajib diisi sebelum menambah variasi";
      }
      if (namaItem.value.isEmpty) {
        return "Nama item wajib diisi sebelum menambah variasi";
      }
      if (unitToAdd.value.isEmpty) {
        return "Unit wajib diisi sebelum menambah variasi";
      }
      if (locationToAdd.value.isEmpty) {
        return "Lokasi wajib dipilih sebelum menambah variasi";
      }
      if (form.warnaController.text.isEmpty) {
        return "Warna variasi wajib diisi (form ke-${i + 1})";
      }
      if (form.hargaController.text.isEmpty) {
        return "Harga wajib diisi (form ke-${i + 1})";
      }
      if (form.jumlahController.text.isEmpty) {
        return "Jumlah stok wajib diisi (form ke-${i + 1})";
      }
      if (form.fieldAvgDaily.text.isEmpty) {
        return "Rata-rata penjualan harian wajib diisi (form ke-${i + 1})";
      }
      if (form.fieldLeadTime.text.isEmpty) {
        return "Lead time wajib diisi (form ke-${i + 1})";
      }
      if (form.fieldROP.text.isEmpty) {
        return "ROP wajib diisi (form ke-${i + 1})";
      }
      if (form.fieldSafetyStock.text.isEmpty) {
        return "Safety stock wajib diisi (form ke-${i + 1})";
      }
      if (form.image.value?.path == null || form.image.value?.path == "") {
        return "Gambar variasi wajib dipilih (form ke-${i + 1})";
      }
      if (noVariasiExist) {
        return "Nomor variasi '${form.noVariasiController.text}' sudah terdaftar (form ke-${i + 1})";
      }
    }

    return null; // valid
  }

  insertVariasiROPNew() async {
    variasiWarna.value = StokGridModel();
    stokListToPrint.clear();
    isError(false);

    try {
      isLoading(true);

      final errorMsg = await isValidInsertVariation();

      if (errorMsg != null) {
        isError(true);
        isLoading(false);
        SnackBarManager().onShowSnacbarMessage(
          title: "Validasi Gagal",
          content: errorMsg, // tampilkan pesan spesifik
          colors: Colors.red,
          position: SnackPosition.TOP,
        );
        return;
      }

      for (var form in variasiForms) {
        final model = StokGridModel(
          noItemWarna: form.noVariasiController.text,
          noItem: noItem.value,
          namaItem: namaItem.value,
          avgDailyDemand: double.tryParse(form.fieldAvgDaily.text) ?? 0.0,
          gambarPath: form.image.value?.path ?? "",
          harga: int.tryParse(form.hargaController.text) ?? 0,
          jumlah: double.tryParse(form.jumlahController.text) ?? 0.0,
          leadTimeHari: int.tryParse(form.fieldLeadTime.text) ?? 0,
          namaWarna: form.warnaController.text,
          rop: double.tryParse(form.fieldROP.text) ?? 0.0,
          safetyStok: double.tryParse(form.fieldSafetyStock.text) ?? 0,
          unit: unitToAdd.value,
          namaLokasi: locationToAdd.value,
        );

        stokListToPrint.add(model);
        await addVariasiWarna(model);
      }

      isLoading(false);
      pageIdx.value = 5;
      await onAssignData();
      await homeController.onAssignCardData();

      SnackBarManager().onShowSnacbarMessage(
        title: "Sukses",
        content: "Variasi dan ROP stok baru berhasil ditambahkan",
        colors: Colors.green,
        position: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isLoading(false);
      log("error input variasi ROP $e");
      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal",
        content: "Terjadi kesalahan saat menambahkan variasi dan ROP: $e",
        colors: Colors.red,
        position: SnackPosition.TOP,
      );
    }
  }
}
