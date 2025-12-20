import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper/database_helper.dart';
import '../../../../core/util_manager/snackbar_manager.dart';
import '../../../month_year_picker/view/month_year_picker.dart';
import '../data/m_permintaan_keluar.dart';
import '../data/m_permintaan_masuk.dart';
import '../view/component/print_laporan_req_keluar.dart';
import '../view/component/print_laporan_req_masuk.dart';

class LaporanReqController extends GetxController {
  var pageIdx = 0.obs;
  var isLoading = false.obs;
  var selectedMonthYear = ''.obs;
  var formatQueryMonth = ''.obs;
  late Database db;

  var dummyPermintaanKeluar =
      List<PermintaanKeluarDummy>.empty(growable: true).obs;
  var dummyPermintaanMasuk =
      List<PermintaanMasukDummy>.empty(growable: true).obs;

  void onInit() async {
    await initDatabase();
    super.onInit();
  }

  Future<void> initDatabase() async {
    db = await DBHelper.initDb();
    var currDate = DateFormat("MM-yyyy").format(DateTime.now());
    dummyPermintaanMasuk.value = await getLaporanPermintaanMasuk(
      currDate,
    ); //tampilin bulan ini
    dummyPermintaanKeluar.value = await getLaporanPermintaanKeluar(
      currDate,
    ); //tampilin bulan ini
    update(); // GetX
  }

  onBack() {
    if (pageIdx.value > 0) {
      pageIdx.value = 0;
    } else {
      // onClearData();
      Get.back();
    }
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
        dummyPermintaanMasuk.value = await getLaporanPermintaanMasuk(
          formatQueryMonth.value,
        );
      } else {
        dummyPermintaanKeluar.value = await getLaporanPermintaanKeluar(
          formatQueryMonth.value,
        );
      }
    }
  }

  Future<List<PermintaanMasukDummy>> getLaporanPermintaanMasuk(
    String queryDate,
  ) async {
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

    i.NamaItem,
    i.unit

  FROM permintaan_stok_masuk p
  JOIN detail_permintaan_masuk d
    ON p.no_permintaan_masuk = d.no_permintaan_masuk
  JOIN variasi_warna v
    ON d.NoItemWarna = v.NoItemWarna
  JOIN item_stok i
    ON v.NoItem = i.NoItem
Where p.tgl_permintaan_masuk LIKE ?
  ORDER BY p.tgl_permintaan_masuk DESC
''',
      ['%$queryDate'],
    );

    final Map<String, PermintaanMasukDummy> grouped = {};

    for (final row in result) {
      final no = row['no_permintaan_masuk'] as String;

      if (!grouped.containsKey(no)) {
        grouped[no] = PermintaanMasukDummy(
          noPermintaan: no,
          tanggal: row['tgl_permintaan_masuk'].toString(),
          statusMasuk: (row['status_masuk'] as int) == 1,
          keterangan: row['keterangan']?.toString() ?? '',
          detail: [],
        );
      }

      grouped[no]!.detail.add(
        DetailMasukDummy(
          namaItem: row['NamaItem'].toString(),
          namaWarna: row['NamaWarna'].toString(),
          jumlah: (row['jumlah_minta'] as num).toDouble(),
          unit: row['Unit'].toString(),
        ),
      );
    }

    return grouped.values.toList();
  }

  Future<List<PermintaanKeluarDummy>> getLaporanPermintaanKeluar(
    String queryDate,
  ) async {
    final result = await db.rawQuery(
      '''
   SELECT
    p.no_permintaan_keluar,
    p.tgl_permintaan_keluar,
    p.status_keluar,
    p.keterangan,

    d.jumlah_minta,

    v.NoItemWarna,
    v.NamaWarna,

    i.NamaItem,
    i.unit

  FROM permintaan_stok_keluar p
  JOIN detail_permintaan_keluar d
    ON p.no_permintaan_keluar = d.no_permintaan_keluar
  JOIN variasi_warna v
    ON d.NoItemWarna = v.NoItemWarna
  JOIN Item_Stok i
    ON v.NoItem = i.NoItem
Where p.tgl_permintaan_keluar LIKE ?
  ORDER BY p.tgl_permintaan_keluar DESC
''',
      ['%$queryDate'],
    );

    final Map<String, PermintaanKeluarDummy> grouped = {};

    for (final row in result) {
      final no = row['no_permintaan_keluar'] as String;

      if (!grouped.containsKey(no)) {
        grouped[no] = PermintaanKeluarDummy(
          noPermintaan: no,
          tanggal: row['tgl_permintaan_keluar'].toString(),
          statusKeluar: (row['status_keluar'] as int) == 1,
          keterangan: row['keterangan']?.toString() ?? '',
          detail: [],
        );
      }

      grouped[no]!.detail.add(
        DetailKeluarDummy(
          namaItem: row['NamaItem'].toString(),
          namaWarna: row['NamaWarna'].toString(),
          jumlah: (row['jumlah_minta'] as num).toDouble(),
          unit: row['Unit'].toString(),
        ),
      );
    }

    return grouped.values.toList();
  }

  String dateFormatter(String input) {
    DateTime currDate = DateFormat('MM-yyyy').parse(input);
    String formatedDate = DateFormat("MMMM-yyyy").format(currDate);

    return formatedDate;
  }

  onPrepareDataToPrint() {
    var todayDate = DateTime.now();
    var monthYearFormatted = DateFormat("MMMM-yyyy").format(todayDate);
    var monthToPrint =
    formatQueryMonth.value != ""
        ? dateFormatter(formatQueryMonth.value)
        : monthYearFormatted;

    if (pageIdx.value == 0) {
      if (dummyPermintaanMasuk.isEmpty) {
        return SnackBarManager().onShowSnacbarMessage(
          title: "Perhatian",
          content: "Tidak ada data permintaan stok masuk yang dapat dicetak",
          colors: Colors.red,
          position: SnackPosition.BOTTOM,
        );
      } else {
        onToPrintLaporanReqMasuk(monthToPrint, dummyPermintaanMasuk);
      }
    } else {
      if (dummyPermintaanKeluar.isEmpty) {
        return SnackBarManager().onShowSnacbarMessage(
          title: "Perhatian",
          content: "Tidak ada data laporan stok keluar yang dapat dicetak",
          colors: Colors.red,
          position: SnackPosition.BOTTOM,
        );
      } else {
        onToPrintLaporanReqKeluar(monthToPrint, dummyPermintaanKeluar);
      }
    }
  }

  onToPrintLaporanReqMasuk(
    String month,
    List<PermintaanMasukDummy> laporanList,
  ) {

    Get.to(() => PrintLaporanReqMasuk(data: laporanList, periode: month));
  }

  onToPrintLaporanReqKeluar(
      String month,
      List<PermintaanKeluarDummy> laporanList,
      ) {

    Get.to(() => PrintLaporanReqKeluar(data: laporanList, periode: month));
  }
}
