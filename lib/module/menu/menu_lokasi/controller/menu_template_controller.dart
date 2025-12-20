import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:wms_sm/module/menu/menu_lokasi/controller/crud_template_controller.dart';
import '../../../../core/database/data/m_lokasi_stok.dart';
import '../../../../core/database/database_helper/database_helper.dart';
import '../../menu_item_variasi_stok/data/stok_grid_model.dart';

class LocationController extends GetxController {
  late Database db;
  var pageIdx = 0.obs;

  var isLoading = false.obs;

  var searchBar = TextEditingController();
  var fieldDateSelected = TextEditingController();

  //select range date
  var fieldDateSelectedFrom = TextEditingController();
  var fieldDateSelectedTo = TextEditingController();
  var fromDate = "".obs;
  var toDate = "".obs;

  var listData = List<LokasiStok>.empty(growable: true).obs;
  var filterListData = List<LokasiStok>.empty(growable: true).obs;

  var stokList = List<StokGridModel>.empty(growable: true).obs;
  //pagination
  var limit = 10.obs; // item per halaman
  var page = 0.obs;
  var hasMore = true.obs;

  var lsDaerah = ["Jakarta", "Bandung", "Semarang"];
  var selectedDaerah = "".obs;

  @override
  onInit() async {
    await onInitDBController();
    super.onInit();
  }

  getBack() {
    if (pageIdx.value > 0) {
      pageIdx.value = 0;
    } else {
      Get.back();
    }
  }

  onInitDBController() async {
    db = await DBHelper.initDb();
    await onAssignPaginationData();
  }

  onSearchData(String value) {
    var searchValue = value;
    if (searchValue.isNotEmpty) {
      var filter =
          filterListData.where((element) {
            var values = [element.NoLokasi, element.NamaLokasi];

            return values.any(
              (data) => data.toLowerCase().contains(searchValue.toLowerCase()),
            );
          }).toList();

      filterListData
        ..clear()
        ..addAll(filter)
        ..refresh();
    } else {
      filterListData
        ..clear()
        ..addAll(listData)
        ..refresh();
    }
  }
}
