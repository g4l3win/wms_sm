import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_keluar/controller/data_stok_keluar_controller.dart';
import '../../../../core/database/database_helper/database_helper.dart';
import '../../../../core/util_manager/app_theme.dart';
import '../../../../core/util_manager/snackbar_manager.dart';
import '../../../home/controller/home_controller.dart';
import '../../../qr_scanner/view/qr_scanner_page.dart';
import '../../menu_laporan/data/stok_keluar_model.dart';
import '../view/component/print_stok_keluar.dart';

class RevisiStockKeluarController extends GetxController {
  late HomeController homeController;
  late Database db;
  var username = "".obs;
  var namaDepanAdmin = "".obs;
  var isError = false.obs;

  var pageIdx = 0.obs;
  var isLoading = false.obs;
  var isScanned = false.obs;
  var searchBar = TextEditingController();
  var qrCodeResult = "".obs;

  TextEditingController searchBarHistory = TextEditingController();
  TextEditingController fieldNoStokKeluar = TextEditingController();
  TextEditingController fieldTanggal = TextEditingController();
  TextEditingController fieldKeterangan = TextEditingController();
  TextEditingController tmpQty = TextEditingController();
  var searchResult = ''.obs;

  var stokKeluar = LaporanStokKeluar();
  var listDetailStokKeluar = <StokKeluarModel>[];
  var detailPermintaan = <Map<String, dynamic>>[].obs;

  var listStokKeluar = <StokKeluarModel>[].obs;
  var lsNoStokKeluarGrouped = [].obs;
  var lsDetailStokKeluar = <String, List<StokKeluarModel>>{}.obs;

  var qtyRealControllers =
      List<TextEditingController>.empty(growable: true).obs;

  var noPermintaan = "".obs;
  var tglPermintaan = "".obs;
  var totalBarang = 0.obs;
  @override
  onInit() async {
    await initDatabase();
    await onInitController();
    onAssignUser();
    super.onInit();
  }

  onInitController() async {
    homeController =  Get.find<HomeController>();
  }

  onAssignUser() {
    username.value = homeController.dataUser.value.Username ?? "-";
    namaDepanAdmin.value = homeController.dataUser.value.NamaDepan ?? "-";
  }

  onBack() {
    if (pageIdx.value > 0) {
      pageIdx.value = 0;
    } else {
      onClearData();
      Get.back();
    }
  }

  onStartScanner() {
    Get.to(
      () => QRScannerPage(
        scan:
            (result) =>
                pageIdx.value == 0
                    ? onCheckQRData(result)
                    : pageIdx.value == 1
                    ? onCheckQRRiwayatData(result)
                    : null,
      ),
    );
  }

  onCheckQRData(String scanResult) async {
    try {
      if (scanResult != "-1") {
        qrCodeResult.value = scanResult;
        log("cek hasil scan ${qrCodeResult.value}");
        await onAssignRequestData(qrCodeResult.value);
      }
      isScanned(false);
    } catch (e) {
      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal mendapatkan scan kode permintaan",
        content: "error $e",
        colors: AppTheme.redColor,
        position: SnackPosition.BOTTOM,
      );
    }
  }

  onCheckQRRiwayatData(String scanResult) async {
    searchBarHistory.text = "";
    searchResult.value = "";
    log("cek hello");
    try {
      if (scanResult != "-1") {
        searchBarHistory.text = scanResult;
        searchResult.value = scanResult;
        log("cek hasil scan $scanResult");

      }
      isScanned(false);
    } catch (e) {
      log("cek error $e");
      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal mendapatkan scan",
        content: "error $e",
        colors: AppTheme.redColor,
        position: SnackPosition.BOTTOM,
      );
    }
  }

  onDatePick({required BuildContext context}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        helpText: "Pilih Tanggal Stok Keluar",
        builder: (context, child){
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppTheme.blackColor, // header background color
                onPrimary: AppTheme.whiteColor, // header text color
                onSurface: AppTheme.blackColor, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.blackColor, // button text color
                ),
              ),
            ),
            child: child!,
          );
        }
    );

    if (picked != null) {
      // Format bulan - tahun
      String formatted = DateFormat("dd-MM-yyyy").format(picked);
      fieldTanggal.text = formatted;
    }
  }

  Future<String> autoGenerateNoStokKeluar() async {
    var last = await db.rawQuery(
      "SELECT NoStokKeluar FROM STOK_KELUAR "
          "ORDER BY CAST(SUBSTR(NoStokKeluar, 3) AS INTEGER) DESC LIMIT 1",
    );

    int nextNumber = 1;

    if (last.isNotEmpty) {
      String lastNo = last.first["NoStokKeluar"] as String;
      String numericPart = lastNo.replaceAll("SK", "");
      nextNumber = int.parse(numericPart) + 1;
    }

    String formatted = nextNumber.toString().padLeft(4, "0");
    return "SK$formatted";
  }

  Future<String?> isValidInsert() async {
    if (fieldNoStokKeluar.text.isEmpty) {
      return "Nomor stok masuk wajib diisi";
    }

    if (username.value.isEmpty) {
      return "Nama pengguna wajib diisi";
    }

    if (fieldTanggal.text.isEmpty) {
      return "Tanggal stok masuk belum dipilih";
    }

    if (fieldKeterangan.text.isEmpty) {
      return "Keterangan stok masuk belum diisi";
    }

    var isExistNoStokKeluar = await DBHelper().isKodeExist(
      fieldNoStokKeluar.text,
      'NoStokKeluar',
      'STOK_KELUAR',
    );
    if (isExistNoStokKeluar) {
      return "Nomor stok Keluar sudah digunakan, silakan ganti dengan yang baru";
    }

    for (int i = 0; i < detailPermintaan.length; i++) {
      final item = detailPermintaan[i];
      final qty = qtyRealControllers[i].text;

      if (item["NoItemWarna"].isEmpty) {
        return "Variasi ke-${i + 1} belum memiliki kode warna";
      }

      if (qty.isEmpty) {
        return "Jumlah Keluar pada variasi ke-${i + 1} belum diisi";
      }
    }

    return null; // valid
  }

  insertStokKeluar() async {
    isError(false);
    stokKeluar.clear();
    stokKeluar.detailItems = [];

    try {
      isLoading(true);

      final validationMessage = await isValidInsert();
      if (validationMessage != null) {
        isLoading(false);
        SnackBarManager().onShowSnacbarMessage(
          title: "Validasi gagal",
          content: validationMessage,
          colors: AppTheme.deepOrangeColor,
          position: SnackPosition.TOP,
        );
        return;
      }

      stokKeluar = LaporanStokKeluar(
        noStokKeluar: fieldNoStokKeluar.text,
        no_permintaan_keluar: noPermintaan.value,
        username: username.value,
        admin: namaDepanAdmin.value,
        tanggal: fieldTanggal.text,
        keterangan: fieldKeterangan.text,
      );

      await addStokKeluar(stokKeluar).then((_) async {
        await insertDetailStokKeluar();
      });

      await homeController.onAssignCardData();
    } catch (e) {
      isLoading(false);
      log("error gagal insert stok Keluar $e");
      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal",
        content: "Terjadi kesalahan saat meKeluarkan data stok Keluar",
        colors: AppTheme.redColor,
        position: SnackPosition.TOP,
      );
    }
  }

  insertDetailStokKeluar() async {
    listDetailStokKeluar.clear();
    try {
      for (int i = 0; i < detailPermintaan.length; i++) {
        var item = detailPermintaan[i];
        var jumlah = double.tryParse(qtyRealControllers[i].text) ?? 0;
        var leadTime = item['LeadTimeHari'];
        var detailStokKeluar = StokKeluarModel(
          noStokKeluar: fieldNoStokKeluar.text,
          noItemWarna: item["NoItemWarna"],
          noItem: item['NoItem'],
          jumlahKeluar: jumlah,
          leadTimeHari: leadTime,
          namaItem: item["NamaItem"],
          namaWarna: item["NamaWarna"],
          unit: item["Unit"],
        );
        await addDetailStokKeluar(detailStokKeluar);
        listDetailStokKeluar.add(detailStokKeluar);
        await updateStokVariasiWarna(
          detailStokKeluar.noItemWarna ?? "",
          jumlah,
          detailStokKeluar.leadTimeHari ?? 1,
          false,
          noPermintaan.value,
        );
      }
      isLoading(false);
      stokKeluar.detailItems = listDetailStokKeluar;
      pageIdx.value = 4;
      SnackBarManager().onShowSnacbarMessage(
        title: "Sukses",
        content: "Detail stok Keluar berhasil ditambahkan",
        colors: AppTheme.greenColor,
        position: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isLoading(false);
      log("error gagal insert stok Keluar $e");
      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal",
        content: "Gagal meKeluarkan data detail stok Keluar",
        colors: AppTheme.redColor,
        position: SnackPosition.BOTTOM,
      );
    }
  }

  onToPrintStokKeluar() {
    isLoading(true);
    Get.to(() => StokKeluarPreview(stokKeluar: stokKeluar));
    isLoading(false);
  }

  onClearData() {
    searchBar.clear();
    qrCodeResult.value = "";
    lsDetailStokKeluar.clear();
    stokKeluar.clear();
    isScanned(false);
    searchBar.clear();
    fieldNoStokKeluar.clear();
    fieldTanggal.clear();
    fieldKeterangan.clear();
  }
}
