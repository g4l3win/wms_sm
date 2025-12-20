import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/database/data/m_kategori_stok.dart';
import '../../../../core/database/database_helper/database_helper.dart';
import '../../../../core/util_manager/app_theme.dart';
import '../../../../core/util_manager/dialog_manager.dart';
import '../../../../core/util_manager/snackbar_manager.dart';

class KategoriStokController extends GetxController{
  var tes = "tes".obs;
  var isLoading = false.obs;

  var pageIdx = 0.obs;

  var listKategori = <KategoriStok>[].obs;
  late Database db;

  TextEditingController fieldAddNoKategori = TextEditingController();
  TextEditingController fieldAddNamaKategori = TextEditingController();
  TextEditingController fieldEditNoKategori = TextEditingController();
  TextEditingController fieldEditNamaKategori = TextEditingController();

  var errorNoKategori = ''.obs;
  var errorNamaKategori = ''.obs;
  var errorEditNoKategori = ''.obs;
  var errorEditNamaKategori = ''.obs;


  @override
  onInit () async {
    await initDatabase();
    super.onInit();
  }

   onBack() {
    if (pageIdx.value > 0) {
      DialogManager().dialogPerhatian(
          "Perhatian",
          "Jika anda kembali ke awal, semua data yang Anda masukkan akan hilang",
          "Tetap disini",
          "Kembali ke awal", () {
        Get.back();
      }, () {
        onToFirstPage ();
      });
    } else {
      Get.back();
    }
  }

  onToFirstPage (){
    pageIdx.value = 0;
    onClearTextField();
    Get.back();
  }

  onClearTextField (){
    fieldAddNoKategori.clear();
    fieldAddNamaKategori.clear();
    fieldEditNamaKategori.clear();
    fieldEditNoKategori.clear();
    errorNoKategori.value = '';
    errorNamaKategori.value = '';
    errorEditNoKategori.value = '';
    errorEditNamaKategori.value = '';
  }

  Future<void> initDatabase() async {
    db = await DBHelper.initDb();
    await loadKategori();
  }

  Future<void> loadKategori() async {
    final List<Map<String, dynamic>> maps = await db.query('KATEGORI_STOK', where: 'isDeleted = 0');
    listKategori.value = maps.map((e) => KategoriStok.fromMap(e)).toList();
  }

  Future<void> addKategori(String NoKategori, String NamaKategori) async {
    await db.insert('KATEGORI_STOK',
      {'NoKategori': NoKategori,'NamaKategori': NamaKategori, 'isDeleted' : 0});
    await loadKategori();
  }

  Future<void> deleteKategori(String id) async {
    await db.delete('KATEGORI_STOK', where: 'NoKategori = ?', whereArgs: [id]);
    await loadKategori();
  }

  Future<void> updateKategori(String noKategori, String namaKategori) async {
    await db.update(
      'KATEGORI_STOK',
      {'NamaKategori': namaKategori,
      'isDeleted' : 0},
      where: 'NoKategori = ?',
      whereArgs: [noKategori],
    );
    await loadKategori();
  }

  editKategori() async {
    try {
      isLoading(true);

      // Reset error state dulu
      errorEditNoKategori.value = '';
      errorEditNamaKategori.value = '';

      // Validasi manual
      if (fieldEditNoKategori.text.isEmpty) {
        errorEditNoKategori.value = "Nomor kategori wajib diisi";
      }
      if (fieldEditNamaKategori.text.isEmpty) {
        errorEditNamaKategori.value = "Nama kategori wajib diisi";
      }

      // Kalau ada error
      if (errorEditNoKategori.value.isNotEmpty || errorEditNamaKategori.value.isNotEmpty) {
        isLoading(false);
        SnackBarManager().onShowSnacbarMessage(
          title: "Validasi Gagal",
          content: "Mohon lengkapi form kategori",
          colors: AppTheme.deepOrangeColor,
          position: SnackPosition.TOP,
        );
        return;
      }

      // Kalau valid, lanjut update
      await updateKategori(
        fieldEditNoKategori.text,
        fieldEditNamaKategori.text,
      );

      isLoading(false);
      onClearTextField();
      pageIdx.value = 0;

      SnackBarManager().onShowSnacbarMessage(
        title: "Berhasil",
        content: "Kategori berhasil diperbarui",
        colors: AppTheme.greenColor,
        position: SnackPosition.TOP,
      );
    } catch (e) {
      isLoading(false);
      log("error $e");
      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal edit",
        content: e.toString(),
        colors: AppTheme.redColor,
        position: SnackPosition.TOP,
      );
    }
  }

  simpanKategori() async {
    try {
      isLoading(true);

      // reset error
      errorNoKategori.value = '';
      errorNamaKategori.value = '';

      var primaryKeyExist = await DBHelper()
          .isKodeExist(fieldAddNoKategori.text, "NoKategori", "KATEGORI_STOK");

      // validasi manual
      if (fieldAddNoKategori.text.isEmpty) {
        errorNoKategori.value = "Nomor kategori wajib diisi";
      }
      if (fieldAddNamaKategori.text.isEmpty) {
        errorNamaKategori.value = "Nama kategori wajib diisi";
      }
      if (primaryKeyExist) {
        errorNoKategori.value = "Nomor kategori sudah digunakan";
      }

      // kalau ada error
      if (errorNoKategori.value.isNotEmpty || errorNamaKategori.value.isNotEmpty) {
        isLoading(false);
        SnackBarManager().onShowSnacbarMessage(
          title: "Validasi Gagal",
          content: "Mohon periksa kembali form kategori",
          colors: AppTheme.deepOrangeColor,
          position: SnackPosition.TOP,
        );
        return;
      }

      // jika valid
      await addKategori(fieldAddNoKategori.text, fieldAddNamaKategori.text)
          .then((_) {
        fieldAddNamaKategori.clear();
        fieldAddNoKategori.clear();
      });

      isLoading(false);
      pageIdx.value = 0;

      SnackBarManager().onShowSnacbarMessage(
        title: "Berhasil",
        content: "Kategori baru berhasil ditambahkan",
        colors: AppTheme.greenColor,
        position: SnackPosition.TOP,
      );
    } catch (e) {
      isLoading(false);
      log("error $e");
      SnackBarManager().onShowSnacbarMessage(
        title: "Error Simpan",
        content: e.toString(),
        colors: AppTheme.redColor,
        position: SnackPosition.TOP,
      );
    }
  }

  Future<void> softDelete(String id) async {
    await db.update(
      'KATEGORI_STOK',
      {'isDeleted': 1},
      where: 'NoKategori = ?',
      whereArgs: [id],
    );
  }

  deleteCategory(String id) async {
    try {
       isLoading(true);
       var count = await DBHelper().countRecord("ITEM_STOK", "noKategori", id);
      if (count == 0) {
        await deleteKategori(id).then((_) {
           isLoading(false);
          return SnackBarManager().onShowSnacbarMessage(
              title: "Berhasil",
              content: "Kategori $id berhasil dihapus",
              colors: AppTheme.greenColor,
              position: SnackPosition.TOP);
        });
      } else {
         isLoading(false);
        await softDelete(id).then((_) => loadKategori());
        return SnackBarManager().onShowSnacbarMessage(
            title: "Hapus berhasil",
            content:
                "Stok $id Masih ada item stok yang memiliki kategori yang ingin Anda dihapus",
            colors: AppTheme.orangeColor,
            position: SnackPosition.TOP);
      }
    } catch (e) {
       isLoading(false);
      log("error $e");
      SnackBarManager().onShowSnacbarMessage(
          title: "Gagal hapus",
          content: e.toString(),
          colors: AppTheme.redColor,
          position: SnackPosition.TOP);
    }
  }
}
