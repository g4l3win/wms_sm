import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/database/data/m_item_stok_model.dart';
import '../../../../core/database/database_helper/database_helper.dart';
import '../../../../core/util_manager/app_theme.dart';
import '../../../../core/util_manager/snackbar_manager.dart';
import '../../../home/controller/home_controller.dart';
import '../../../qr_scanner/view/qr_scanner_page.dart';
import '../view/component/preview_print_req_out.dart';

class ReqStockOutController extends GetxController {
  var pageIdx = 0.obs;
  var isLoading = false.obs;

  late HomeController homeController;
  late Database db;
  var username = "".obs;
  var namaDepanAdmin = "".obs;
  var isError = false.obs;
  var isScanned = false.obs;
  var qrCodeResult = "".obs;

  var lsQtyStockOut = List<TextEditingController>.empty(growable: true).obs;
  var lsStockFound = <ItemStokModel>[].obs;
  List<String> listTotalMinta = [];
  TextEditingController searchBar = TextEditingController();
  TextEditingController fieldNoStokKeluar = TextEditingController();
  TextEditingController fieldTanggal = TextEditingController();
  TextEditingController fieldKeterangan = TextEditingController();

  String lastNoPermintaan = "";
  String lastTanggal = "";
  int totalBarang = 0;
  List<ItemStokModel> lastDetail = [];

  @override
  void onInit() async {
    await initDatabase();
    await onInitController();
    onAssignUser();
    super.onInit();
  }

  onInitController() async {
    homeController =Get.find<HomeController>();
    log("init home di variasi stok ");
  }

  Future<void> initDatabase() async {
    db = await DBHelper.initDb();
  }

  onAssignUser() {
    username.value = homeController.dataUser.value.Username ?? "-";
    namaDepanAdmin.value = homeController.dataUser.value.NamaDepan ?? "-";
  }
  onBack() {
    if (pageIdx.value > 0) {
      onClearData();
      pageIdx.value = 0;
    } else {
      onClearData();
      Get.back();
    }
  }

  onStartScanner() {
    Get.to(() => QRScannerPage(scan: (result) => onCheckQRData(result)));
  }

  onCheckQRData(String scanResult) async {
    try {
      if (scanResult != "-1") {
        qrCodeResult.value = scanResult;

        await onAssignStokData(qrCodeResult.value);
      }
      isScanned(true);
    } catch (e) {
      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal mendapatkan scan kode item variasi warna",
        content: "error $e",
        colors: AppTheme.redColor,
        position: SnackPosition.BOTTOM,
      );
    }
  }

  onDeleteScannedStok(int index) {
    lsStockFound.removeAt(index);
    lsQtyStockOut.removeAt(index);
  }

  Future<List<Map<String, dynamic>>> getDataStok(String noItemWarna) async {
    final result = await db.rawQuery(
      '''
   SELECT 
      i.NoItem,
      i.NamaItem,
      i.Unit,
      v.NoItemWarna,
      v.NamaWarna,
      v.Jumlah,
      v.ROP
    FROM VARIASI_WARNA v
    JOIN ITEM_STOK i ON v.NoItem = i.NoItem
    WHERE v.NoItemWarna = ? AND v.isDeleted = 0
  ''',
      [noItemWarna],
    );
    return result;
  }

  onAssignStokData(String noItemWarna) async {
    var result = await getDataStok(noItemWarna);

    for (var item in result) {
      var data = ItemStokModel.fromMap(item);
      var alreadyExist = lsStockFound.any(
            (x) => x.noItemWarna == data.noItemWarna,
      );
      if (!alreadyExist) {
        lsStockFound.add(data);
        lsQtyStockOut.add(TextEditingController());
        fieldTanggal.text = DateFormat("dd-MM-yyyy").format(DateTime.now());

        SnackBarManager().onShowSnacbarMessage(
          title: "Sukses",
          content:
          "Dapat data stok keluar ${data.namaItem} ${data.namaWarna} kode ${data.noItem} - ${data.noItemWarna}",
          colors: AppTheme.greenColor,
          position: SnackPosition.BOTTOM,
        );
      } else {
        SnackBarManager().onShowSnacbarMessage(
          title: "Perhatian",
          content:
          "Data stok yang discan / dicari duplikat, perhatikan daftar stok yang sudah discan",
          colors: AppTheme.orangeColor,
          position: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<String?> validateInsertRequestStokKeluar() async {
    // Validasi header
    if (fieldNoStokKeluar.text.trim().isEmpty) {
      return "No permintaan stok keluar wajib diisi";
    }

    if (fieldTanggal.text.trim().isEmpty) {
      return "Tanggal permintaan wajib diisi";
    }

    if (username.value.trim().isEmpty) {
      return "User belum tersedia";
    }

    // Validasi detail
    if (lsStockFound.isEmpty) {
      return "Belum ada item stok yang dipilih";
    }

    bool hasValidQty = false;

    for (int i = 0; i < lsStockFound.length; i++) {
      final qtyText = lsQtyStockOut[i].text.trim();

      if (qtyText.isEmpty) continue;

      final qty = double.tryParse(qtyText);
      if (qty == null || qty <= 0) {
        return "Jumlah keluar harus lebih dari 0";
      }

      hasValidQty = true;
    }

    if (!hasValidQty) {
      return "Minimal satu item harus memiliki jumlah keluar";
    }

    return null; // valid
  }

  Future<void> insertRequestStokKeluar() async {
    try {
      isLoading(true);

      final validationMessage = await validateInsertRequestStokKeluar();
      if (validationMessage != null) {
        SnackBarManager().onShowSnacbarMessage(
          title: "Validasi gagal",
          content: validationMessage,
          colors: AppTheme.deepOrangeColor,
          position: SnackPosition.BOTTOM,
        );
        return;
      }

      await db.transaction((txn) async {
        // insert header
        await txn.insert('permintaan_stok_keluar', {
          'no_permintaan_keluar': fieldNoStokKeluar.text,
          'username': username.value,
          'tgl_permintaan_keluar': fieldTanggal.text,
          'keterangan': fieldKeterangan.text,
          'status_keluar': 0,
        });

        // insert detail
        for (int i = 0; i < lsStockFound.length; i++) {
          final item = lsStockFound[i];
          final qtyText = lsQtyStockOut[i].text.trim();

          if (qtyText.isEmpty) continue;

          await txn.insert('detail_permintaan_keluar', {
            'no_permintaan_keluar': fieldNoStokKeluar.text,
            'NoItemWarna': item.noItemWarna,
            'jumlah_minta': double.parse(qtyText),
          });
        }
      });

      setSuccessData();
      pageIdx.value = 1;
    } catch (e) {
      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal",
        content: "Gagal menyimpan permintaan stok keluar",
        colors: AppTheme.redColor,
        position: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }


  void setSuccessData() {
    lastNoPermintaan = fieldNoStokKeluar.text;
    lastTanggal = fieldTanggal.text;
    totalBarang = lsStockFound.length;
    lastDetail = List.from(lsStockFound);
    listTotalMinta = lsQtyStockOut
        .map((e) => e.text)
        .toList();
  }

  onToPrint() async {
    await Get.to(
      PreviewPrintReqOut(
        lastNoPermintaan: lastNoPermintaan,
        lastTanggal: lastTanggal,
        totalBarang: totalBarang,
        lastDetail: lastDetail,
        namaAdmin: namaDepanAdmin.value,
        listTotalMinta: listTotalMinta,
      ),
    );
  }

  void onClearData() {
    // clear text field utama
    fieldNoStokKeluar.clear();
    fieldTanggal.clear();
    fieldKeterangan.clear();
    searchBar.clear();

    // clear list stok & qty
    for (var controllerQty in lsQtyStockOut) {
      controllerQty.dispose();
    }

    lsQtyStockOut.clear();
    lsStockFound.clear();

    // reset state
    isScanned(false);
    qrCodeResult.value = "";
    pageIdx.value = 0;

    lastNoPermintaan = "";
    lastTanggal = "";
    totalBarang = 0;
    lastDetail = [];
    listTotalMinta =[];
  }
}