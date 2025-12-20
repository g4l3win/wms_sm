import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_masuk/controller/data_stok_masuk_controller.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_masuk/controller/riwayat_stok_masuk_controller.dart';
import '../../../../core/database/database_helper/database_helper.dart';
import '../../../../core/util_manager/app_theme.dart';
import '../../../../core/util_manager/dialog_manager.dart';
import '../../../../core/util_manager/snackbar_manager.dart';
import '../../../home/controller/home_controller.dart';
import '../../../qr_scanner/view/qr_scanner_page.dart';
import '../../menu_laporan/data/stok_masuk_model.dart';
import '../view/component/print_stok_masuk.dart';

class RevisiStockMasukController extends GetxController {
  var pageIdx = 0.obs;
  var isLoading = false.obs;
  var isScanned = false.obs;
  var searchBar = TextEditingController();
  var qrCodeResult = "".obs;

  var stokMasuk = LaporanStokMasuk();
  var username = "".obs;
  var namaDepanAdmin = "".obs;
  var isError = false.obs;
  late Database db;
  late HomeController homeController;

  var detailPermintaan = <Map<String, dynamic>>[].obs;
  var listDetailStokMasuk = <StokMasukModel>[];
  var qtyRealControllers =
      List<TextEditingController>.empty(growable: true).obs;

  var noPermintaan = "".obs;
  var tglPermintaan = "".obs;
  var totalBarang = 0.obs;

  TextEditingController searchBarHistory = TextEditingController();
  TextEditingController fieldNoStokMasuk = TextEditingController();
  TextEditingController fieldTanggal = TextEditingController();
  TextEditingController fieldKeterangan = TextEditingController();

  var searchResult = ''.obs;

  //riwayat stok masuk
  var listStokMasuk = <StokMasukModel>[].obs;
  var lsNoStokMasukGrouped = [].obs;
  var lsDetailStokMasuk = <String, List<StokMasukModel>>{}.obs;

  @override
  void onInit() async {
    await initDatabase();
    await onInitController();
    onAssignUser();
    super.onInit();
  }

  onInitController() async {
    homeController = Get.find<HomeController>();
    log("init home di variasi stok ");
  }

  onAssignUser() {
    username.value = homeController.dataUser.value.Username ?? "-";
    namaDepanAdmin.value = homeController.dataUser.value.NamaDepan ?? "-";
  }

  onBack() {
    if (pageIdx.value == 4) {
      DialogManager().dialogPerhatian(
        "Perhatian",
        "Tekan OK jika Anda ingin kembali ke menu stok masuk",
        "Batal",
        "Ok",
            () {
          Get.back();
        },
            () {
          onClearData();
          pageIdx.value = 0;
          Get.back();
        },
      );
    }
    else if (pageIdx.value > 0) {

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
                    : pageIdx.value == 3
                    ? onCheckQRRiwayatData(result)
                    : null,
      ),
    );
  }

  onCheckQRData(String scanResult) async {
    log("cek hello");
    try {
      if (scanResult != "-1") {
        qrCodeResult.value = scanResult;
        log("cek hasil scan ${qrCodeResult.value}");
        await onAssignRequestData(qrCodeResult.value);
      }
      isScanned(true);
    } catch (e) {
      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal mendapatkan scan kode permintaan masuk",
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
      builder: (context, child) {
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
      },
    );

    if (picked != null) {
      // Format bulan - tahun
      String formatted = DateFormat("dd-MM-yyyy").format(picked);
      fieldTanggal.text = formatted;
    }
  }

  Future<String?> isValidInsert() async {
    if (fieldNoStokMasuk.text.isEmpty) {
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

    var isExistNoStokMasuk = await DBHelper().isKodeExist(
      fieldNoStokMasuk.text,
      'NoStokMasuk',
      'STOK_MASUK',
    );
    if (isExistNoStokMasuk) {
      return "Nomor stok masuk sudah digunakan, silakan ganti dengan yang baru";
    }

    for (int i = 0; i < detailPermintaan.length; i++) {
      final item = detailPermintaan[i];
      final qty = qtyRealControllers[i].text;

      if (item["NoItemWarna"].isEmpty) {
        return "Variasi ke-${i + 1} belum memiliki kode warna";
      }

      if (qty.isEmpty) {
        return "Jumlah masuk pada variasi ke-${i + 1} belum diisi";
      }
    }

    return null; // valid
  }

  insertStokMasuk() async {
    isError(false);
    stokMasuk.clear();
    stokMasuk.detailItems = [];

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

      stokMasuk = LaporanStokMasuk(
        noStokMasuk: fieldNoStokMasuk.text,
        noPermintaanMasuk: noPermintaan.value,
        username: username.value,
        admin: namaDepanAdmin.value,
        tanggal: fieldTanggal.text,
        keterangan: fieldKeterangan.text,
      );

      await addStokMasuk(stokMasuk).then((_) async {
        await insertDetailStokMasuk();
      });

      await homeController.onAssignCardData();
    } catch (e) {
      isLoading(false);
      log("error gagal insert stok masuk $e");
      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal",
        content: "Terjadi kesalahan saat memasukkan data stok masuk",
        colors: AppTheme.redColor,
        position: SnackPosition.TOP,
      );
    }
  }

  int calculateLeadTime (String tglMinta, String tglMasuk){

    var parseDatetglMinta =DateFormat("dd-MM-yyyy").parse(tglMinta);
    var parseDatetglMasuk = DateFormat("dd-MM-yyyy").parse(tglMasuk);

    var durationDays = parseDatetglMasuk.difference(parseDatetglMinta);
    return durationDays.inDays;
  }

  insertDetailStokMasuk() async {
    listDetailStokMasuk.clear();
    try {
      for (int i = 0; i < detailPermintaan.length; i++) {
        var item = detailPermintaan[i];
        var jumlah = double.tryParse(qtyRealControllers[i].text) ?? 0;
        var detailStokMasuk = StokMasukModel(
          noStokMasuk: fieldNoStokMasuk.text,
          noItemWarna: item["NoItemWarna"],
          noItem: item['NoItem'],
          jumlahMasuk: jumlah,
          namaItem: item["NamaItem"],
          namaWarna: item["NamaWarna"],
          unit: item["Unit"],
        );
        //hitung lead time baru
        var newLeadTime = calculateLeadTime(tglPermintaan.value, fieldTanggal.text);
        await addDetailStokMasuk(detailStokMasuk);
        listDetailStokMasuk.add(detailStokMasuk);
        await updateStokVariasiWarna(
          detailStokMasuk.noItemWarna ?? "",
          jumlah,
          false,
          noPermintaan.value,
          newLeadTime
        );
      }
      isLoading(false);
      stokMasuk.detailItems = listDetailStokMasuk;
      pageIdx.value = 4;
      SnackBarManager().onShowSnacbarMessage(
        title: "Sukses",
        content: "Detail stok masuk berhasil ditambahkan",
        colors: AppTheme.greenColor,
        position: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isLoading(false);
      log("error gagal insert stok masuk $e");
      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal",
        content: "Gagal memasukkan data detail stok masuk",
        colors: AppTheme.redColor,
        position: SnackPosition.BOTTOM,
      );
    }
  }

  onToPrintStokMasuk() {
    isLoading(true);
    Get.to(() => StokMasukPreview(stokMasuk: stokMasuk));
    isLoading(false);
  }

  onClearData() {
    qrCodeResult.value = "";
    lsDetailStokMasuk.clear();
    stokMasuk.clear();
    isScanned(false);
    searchBar.clear();
    fieldNoStokMasuk.clear();
    fieldTanggal.clear();
    fieldKeterangan.clear();
  }
}
