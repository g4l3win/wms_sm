import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wms_sm/module/menu/menu_laporan/controller/laporan_data_controller.dart';

import '../../../../core/util_manager/app_theme.dart';
import '../../../../core/util_manager/snackbar_manager.dart';
import '../../../month_year_picker/view/month_year_picker.dart';
import '../data/stok_keluar_model.dart';
import '../data/stok_masuk_model.dart';
import '../view/component/print_laporan_keluar.dart';
import '../view/component/print_laporan_masuk.dart';

class LaporanController extends GetxController {
  var pageIdx = 0.obs;

  var selectedMonthYear = "Pilih Bulan & Tahun".obs;
  var formatQueryMonth = "".obs;
  late Database db;

  var listStokMasuk = <StokMasukModel>[].obs;
  var listStokKeluar = <StokKeluarModel>[].obs;

  var lsNoStokMasukGrouped = [].obs;
  var lsDetailStokMasuk = <String, List<StokMasukModel>>{}.obs;
  var lsNoStokKeluarGrouped = [].obs;
  var lsDetailStokKeluar = <String, List<StokKeluarModel>>{}.obs;

  var forRestock = 0.obs;
  var stockEmpty = 0.obs;

  var isLoading = false.obs;

  @override
  void onInit() async {
    await initDatabase();
    super.onInit();
  }

  @override
  void onReady() async {
    await onInitialReport();
    super.onReady();
  }

  onInitialReport() async {
    var todayDate = DateTime.now();
    var monthYearFormatted = DateFormat("MM-yyyy").format(todayDate);
    await onAssignStokKeluar(monthYearFormatted);
    await onAssignStokMasuk(monthYearFormatted);
  }

  //update month year picker
  Future<String> showPicker(BuildContext context) async {
    final result = await showDialog<DateTime>(
      context: context,
      builder: (context) => CustomMonthYearPicker(),
    );

    if (result != null) {
      log("Bulan dipilih: ${result.month}, Tahun: ${result.year}");
      // contoh format "MM-yyyy"
      log("Format: ${result.month.toString().padLeft(2, '0')}-${result.year}");
      var formatted =
          "${result.month.toString().padLeft(2, '0')}-${result.year}";
      return formatted;
    } else {
      return "error";
    }
  }

  onMonthYearPicker({required BuildContext context}) async {
    formatQueryMonth.value = "";
    var picked = await showPicker(context);

    if (picked != "error") {
      // Format bulan - tahun
      DateTime currDate = DateFormat('MM-yyyy').parse(picked);
      String formatedDate = DateFormat("MMMM-yyyy").format(currDate);

      selectedMonthYear.value = formatedDate; //September-2025 untuk ditampilkan
      formatQueryMonth.value = picked; //DateFormat("MM-yyyy").format(picked);
      if (pageIdx.value == 0) {
        await onAssignStokMasuk(formatQueryMonth.value);
      } else {
        await onAssignStokKeluar(formatQueryMonth.value);
      }
    }
  }

  StokKeluarModel? showDetailKeluar({required String noStokKeluar}) {
    var empty = StokKeluarModel();

    var detailStokKeluar = listStokKeluar.firstWhereOrNull(
      (pro) => pro.noStokKeluar == noStokKeluar,
    );

    return detailStokKeluar ?? empty;
  }

  StokMasukModel? showDetailMasuk({required String noStokMasuk}) {
    var empty = StokMasukModel();

    var detailStokMasuk = listStokMasuk.firstWhereOrNull(
      (pro) => pro.noStokMasuk == noStokMasuk,
    );

    return detailStokMasuk ?? empty;
  }

  String dateFormatter(String input) {
    DateTime currDate = DateFormat('MM-yyyy').parse(input);
    String formatedDate = DateFormat("MMMM-yyyy").format(currDate);

    return formatedDate;
  }

  onPrepareDataToPrint() {
    isLoading(true);
    var todayDate = DateTime.now();
    var monthYearFormatted = DateFormat("MMMM-yyyy").format(todayDate);
    var monthToPrint =
        formatQueryMonth.value != ""
            ? dateFormatter(formatQueryMonth.value)
            : monthYearFormatted;
    if (pageIdx.value == 0) {
      if (listStokMasuk.isEmpty) {
        isLoading(false);
        return SnackBarManager().onShowSnacbarMessage(
          title: "Perhatian",
          content: "Tidak ada data laporan stok masuk yang dapat dicetak",
          colors: AppTheme.redColor,
          position: SnackPosition.BOTTOM,
        );
      } else {
        onToPrintLaporanMasuk(monthToPrint, listStokMasuk);
      }
    } else {
      if (listStokKeluar.isEmpty) {
        isLoading(false);
        return SnackBarManager().onShowSnacbarMessage(
          title: "Perhatian",
          content: "Tidak ada data laporan stok keluar yang dapat dicetak",
          colors: AppTheme.redColor,
          position: SnackPosition.BOTTOM,
        );
      } else {
        onToPrintLaporanKeluar(listStokKeluar, monthToPrint);
      }
    }
  }

  onToPrintLaporanMasuk(String month, List<StokMasukModel> laporanList) {
    isLoading(false);
    Get.to(
      () => LaporanMasukPrintPreview(month: month, laporanList: laporanList),
    );
  }

  onToPrintLaporanKeluar(List<StokKeluarModel> listStokKeluar, String month) {
    isLoading(false);
    Get.to(
      () => LaporanKeluarPrintPreview(
        listStokKeluar: listStokKeluar,
        month: month,
      ),
    );
  }
}

