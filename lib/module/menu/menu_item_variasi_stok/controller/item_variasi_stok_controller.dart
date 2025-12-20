import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/controller/variasi_warna_controller.dart';
import '../../../../core/database/data/m_item_stok.dart';
import '../../../../core/database/database_helper/database_helper.dart';
import '../../../../core/util_manager/app_theme.dart';
import '../../../../core/util_manager/dialog_manager.dart';
import '../../../../core/util_manager/snackbar_manager.dart';
import '../../../../navigation/routes.dart';
import '../../../home/controller/home_controller.dart';
import '../../../qr_scanner/view/qr_scanner_page.dart';
import '../data/stok_grid_model.dart';
import '../data/variasi_form_model.dart';
import '../view/component/print_label.dart';

class ItemVariasiStokController extends GetxController {
  late HomeController homeController;

  var prevPage = (Get.arguments?['origin']) ?? {};

  var isLoading = false.obs;
  var pageIdx = 0.obs;
  var categories = <String>[].obs;
  var locations = ["Pilih Lokasi"].obs;
  var unitOption = ["1/2 lusin", "Lusin"].obs;
  var selectedLocation = "Pilih Lokasi".obs;
  var selectedCategory = "".obs;
  var selectedUnit = "".obs;
  var itemData = ItemStok().obs;
  var variasiWarna = StokGridModel().obs;

  var stokList = <StokGridModel>[].obs;
  var filterStokList = <StokGridModel>[].obs;
  var stokListToPrint = <StokGridModel>[].obs;
  var variasiForms = <VariasiFormModel>[].obs;

  late Database db;
  var image = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  var qrCodeResult = "".obs;
  var username = "".obs;
  var position = "".obs;

  var isError = false.obs;

  //field untuk add
  var fieldNamaItem = TextEditingController();
  var fieldNoItem = TextEditingController();
  var searchBar = TextEditingController();
  var fieldTotalVariasi = TextEditingController(text: "0");

  //field untuk edit
  var fieldEditNoItem = TextEditingController();
  var fieldEditNoItemWarna = TextEditingController();
  var fieldEditNamaItem = TextEditingController();
  var fieldEditJumlahStok = TextEditingController();
  var fieldEditVariasiWarna = TextEditingController();
  var fieldEditHarga = TextEditingController();

  //field untuk edit ROP
  var fieldEditAvgDailyDemand = TextEditingController();
  var fieldEditLeadTime = TextEditingController();
  var fieldEditSS = TextEditingController();
  var fieldEditROP = TextEditingController();

  var noItem = ''.obs;
  var namaItem = ''.obs;
  var unitToAdd = ''.obs;
  var locationToAdd = ''.obs;

  var maxIncrement = 10;
  var minIncrement = 1;

  @override
  void onInit() async {
    await initDatabase();
    await onInitController().then((_) {
      onAssignUser();
    });
    super.onInit();
  }

  onInitController() async {
    homeController =
        Get.isRegistered<HomeController>()
            ? Get.find<HomeController>()
            : Get.put(HomeController());
    log("init home di variasi stok ");
  }

  onAssignUser() {
    username.value = homeController.dataUser.value.Username ?? "-";
    position.value = homeController.dataUser.value.Posisi ?? "-";
  }

  onBack() {
    if (pageIdx.value == 2 && noItem.value != "") {
      return DialogManager().dialogPerhatian(
        "Perhatian",
        "Jika anda kembali ke awal, semua data yang Anda masukkan akan hilang",
        "Tetap disini",
        "Kembali ke awal",
        () {
          Get.back();
        },
        () {
          onGoToFirstPage();
        },
      );
    }
    if (pageIdx.value == 1 || pageIdx.value == 3) {
      DialogManager().dialogPerhatian(
        "Perhatian",
        "Jika anda kembali ke awal, semua data yang Anda masukkan akan hilang",
        "Tetap disini",
        "Kembali ke awal",
        () {
          Get.back();
        },
        () {
          onGoToFirstPage();
        },
      );
    } else if (pageIdx.value == 2 || pageIdx.value == 4) {
      pageIdx.value -= 1;
    } else if (pageIdx.value == 5) {
      DialogManager().dialogPerhatian(
        "Perhatian",
        "Apakah Anda ingin kembali ke beranda",
        "Tidak",
        "Iya",
        () {
          Get.back();
        },
        () {
          onGoToHomepage();
        },
      );
    } else {
      Get.offAndToNamed(Routes.home);
      Get.delete<ItemVariasiStokController>();
    }
  }

  onGoToFirstPage() {
    pageIdx.value = 0;
    onClearData();
    Get.back();
  }

  onGoToHomepage() async{
    
    Get.offAndToNamed(Routes.home);
    Get.delete<ItemVariasiStokController>();
  }

  Future<bool> requestStoragePermissionOnce() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasRequested = prefs.getBool('hasRequestedPermission') ?? false;

    if (!hasRequested) {
      PermissionStatus status;

      if (Platform.isAndroid) {
        final deviceInfo = await DeviceInfoPlugin().androidInfo;
        int sdkInt = deviceInfo.version.sdkInt;

        if (sdkInt >= 33) {
          status = await Permission.photos.request();
        } else {
          status = await Permission.storage.request();
        }
      } else {
        status = await Permission.storage.request();
      }

      await prefs.setBool('hasRequestedPermission', true);
      return status.isGranted;
    }

    return true; // sudah pernah minta, anggap diizinkan
  }


  Future<String?> saveImageToGallery(File imageFile) async {

    bool permitted = await requestStoragePermissionOnce();
    if (!permitted) {
      print("Permission not granted. Cannot save image.");
      return null;
    }

    // ambil folder DCIM
    Directory? directory = Directory("/storage/emulated/0/DCIM/WMS-SM");
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // bikin nama file unik
    String newPath =
        "${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

    // copy file ke folder DCIM
    File newImage = await imageFile.copy(newPath);

    return newImage.path; // ini yang bisa disimpan ke SQLite
  }

  Future<void> pickImage(ImageSource source, {VariasiFormModel? form}) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (form != null && pickedFile != null) {
      var pathToSave = await saveImageToGallery(File(pickedFile.path));
      form.image.value = File(
        pathToSave ?? "/storage/emulated/0/DCIM/WMS-MS/noimage.jpg",
      );
    }
    if (pickedFile != null && form == null) {
      var pathToSave = await saveImageToGallery(File(pickedFile.path));
      image.value = File(
        pathToSave ?? "/storage/emulated/0/DCIM/WMS-MS/noimage.jpg",
      );
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void setLocation(String location) {
    selectedLocation.value = location;
  }

  void setUnit(String unit) {
    selectedUnit.value = unit;
  }

  onStartScanner() {
    Get.to(() => QRScannerPage(scan: (result) => onCheckQRData(result)));
  }

  onCheckQRData(String scanResult) async {
    log("cek hello");
    qrCodeResult.value = "";
    try {
      if (scanResult != "-1") {
        qrCodeResult.value = scanResult;
        log("cek hasil scan ${qrCodeResult.value}");
        onFindItemByVarWarna(qrCodeResult.value);
      }
      var endTime = DateTime.now();
      print('waktu end: $endTime');

    } catch (e) {
      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal mendapatkan scan",
        content: "error $e",
        colors: AppTheme.redColor,
        position: SnackPosition.BOTTOM,
      );
    }
  }

  onFindItemByVarWarna(String query) {
        if(query.isNotEmpty){
      var lowerQuery = query.toLowerCase();
      var filtered = stokList.where((item) {
        var values = [
          item.noItemWarna,
          item.namaItem,
          item.namaWarna
        ];
        return values.any((element) => element?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
      filterStokList
        ..clear()
        ..addAll(filtered)
        ..refresh();
    } else {
      filterStokList
        ..clear()
        ..addAll(stokList)
        ..refresh();
    }
  }

  addWidgetVarWarna() {
    var totalWidget = int.tryParse(fieldTotalVariasi.text) ?? 0;
    // kalau lebih kecil hapus sisa
    if (totalWidget < variasiForms.length) {
      variasiForms.removeLast();
    }
    // kalau lebih besar tambah baru
    else if (totalWidget > variasiForms.length) {
      variasiForms.add(VariasiFormModel());
    }
  }

  hitungROP(VariasiFormModel form) {
    if (form.fieldSafetyStock.text.isNotEmpty &&
        form.fieldLeadTime.text.isNotEmpty &&
        form.fieldAvgDaily.text.isNotEmpty) {
      var avgDailyDemand = double.tryParse(form.fieldAvgDaily.text) ?? 0;
      var leadTime = int.tryParse(form.fieldLeadTime.text) ?? 0;
      var safetyStock = double.tryParse(form.fieldSafetyStock.text) ?? 0;
      var rop = avgDailyDemand * leadTime + safetyStock;
      form.fieldROP.text = rop.toString();
    }
  }

  Future<String?> isValidInsert() async {
    if (fieldTotalVariasi.text.isEmpty || variasiForms.isEmpty) {
      return "Total variasi wajib diisi";
    }

    for (var i = 0; i < variasiForms.length; i++) {
      final form = variasiForms[i];

      // Cek duplikat kode item dan variasi
      final noItemExist = await DBHelper().isKodeExist(
        fieldNoItem.text,
        "NoItem",
        'ITEM_STOK',
      );
      final noVariasiExist = await DBHelper().isKodeExist(
        form.noVariasiController.text,
        'NoItemWarna',
        'VARIASI_WARNA',
      );

      // Validasi field satu per satu
      if (fieldNoItem.text.isEmpty) return "Nomor item wajib diisi";
      if (fieldNamaItem.text.isEmpty) return "Nama item wajib diisi";
      if (selectedUnit.value.isEmpty) return "Unit wajib dipilih";
      if (selectedCategory.value.isEmpty) return "Kategori wajib dipilih";
      if (selectedLocation.value == "Pilih Lokasi") return "Lokasi wajib dipilih";
      if (form.noVariasiController.text.isEmpty) return "No variasi wajib diisi (form ke-${i + 1})";
      if (form.warnaController.text.isEmpty) return "Warna wajib diisi (form ke-${i + 1})";
      if (form.hargaController.text.isEmpty) return "Harga wajib diisi (form ke-${i + 1})";
      if (form.jumlahController.text.isEmpty) return "Jumlah wajib diisi (form ke-${i + 1})";
      if (form.fieldAvgDaily.text.isEmpty) return "Rata-rata penjualan harian wajib diisi (form ke-${i + 1})";
      if (form.fieldLeadTime.text.isEmpty) return "Lead time wajib diisi (form ke-${i + 1})";
      if (form.fieldROP.text.isEmpty) return "Nilai ROP wajib diisi (form ke-${i + 1})";
      if (form.fieldSafetyStock.text.isEmpty) return "Safety stock wajib diisi (form ke-${i + 1})";
      if (form.image.value?.path == null || form.image.value?.path == "") {
        return "Gambar variasi wajib dipilih (form ke-${i + 1})";
      }

      if (noItemExist) return "Nomor item '${fieldNoItem.text}' sudah terdaftar";
      if (noVariasiExist) return "Nomor variasi '${form.noVariasiController.text}' sudah terdaftar";
    }

    return null; // valid
  }

  insertItemStokData() async {
    itemData.value = ItemStok();
    isError(false);
    try {
      isLoading(true);

      final noCategory = selectedCategory.value.split(" - ");
      final noLocation = selectedLocation.value.split(" - ");

      final errorMsg = await isValidInsert();

      if (errorMsg != null) {
        isError(true);
        isLoading(false);
        SnackBarManager().onShowSnacbarMessage(
          title: "Validasi Gagal",
          content: errorMsg, // tampilkan pesan spesifik
          colors: AppTheme.redColor,
          position: SnackPosition.TOP,
        );
        return;
      }

      // lanjut insert
      itemData.value = ItemStok(
        noItem: fieldNoItem.text,
        namaItem: fieldNamaItem.text,
        noKategori: noCategory[0].trim(),
        noLokasi: noLocation[0].trim(),
        unit: selectedUnit.value,
      );

      await addItemStok(itemData.value)
          .then((_) async {
        await assignVariasiROPData(noLocation[1].trim());
      })
          .then((_) async {
        isLoading(false);
        pageIdx.value = 5;
        await onAssignData();
        await homeController.onAssignCardData();
        SnackBarManager().onShowSnacbarMessage(
          title: "Sukses",
          content: "Stok baru berhasil ditambahkan",
          colors: AppTheme.greenColor,
          position: SnackPosition.BOTTOM,
        );
      });
    } catch (e) {
      isLoading(false);
      log("print error insert $e");
      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal menambahkan data Item baru",
        content: "error $e",
        colors: AppTheme.redColor,
        position: SnackPosition.TOP,
      );
    }
  }

  assignVariasiROPData(String lokasi) async {
    variasiWarna.value = StokGridModel();
    stokListToPrint.clear();
    try {
      for (var form in variasiForms) {
        var model = StokGridModel(
          noItemWarna: form.noVariasiController.text,
          noItem: fieldNoItem.text,
          namaItem: fieldNamaItem.text,
          avgDailyDemand: double.tryParse(form.fieldAvgDaily.text) ?? 0.0,
          gambarPath: form.image.value?.path ?? "",
          harga: int.tryParse(form.hargaController.text) ?? 0,
          jumlah: double.tryParse(form.jumlahController.text) ?? 0.0,
          leadTimeHari: int.tryParse(form.fieldLeadTime.text) ?? 0,
          namaWarna: form.warnaController.text,
          rop: double.tryParse(form.fieldROP.text) ?? 0.0,
          safetyStok: double.tryParse(form.fieldSafetyStock.text) ?? 0,
          unit: selectedUnit.value,
          namaLokasi: lokasi,
        );
        stokListToPrint.add(model);
        await addVariasiWarna(model);
      }

      SnackBarManager().onShowSnacbarMessage(
        title: "Sukses",
        content: "Variasi dan ROP Stok baru berhasil ditambahkan",
        colors: AppTheme.greenColor,
        position: SnackPosition.BOTTOM,
      );
    } catch (e) {
      log("error input variasi ROP $e");
      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal ",
        content: "error menambahkan data variasi dan ROP",
        colors: AppTheme.redColor,
        position: SnackPosition.TOP,
      );
    }
  }

  deleteVariasiWarna(String noItemWarna) async {
    try {
      isLoading(true);
      await deleteVariasiWarnaCascade(noItemWarna).then((_) async {
        await onAssignData();
      });
      isLoading(false);
      SnackBarManager().onShowSnacbarMessage(
        title: "Sukses",
        content: "Data stok berhasil dihapus",
        colors: AppTheme.greenColor,
        position: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isLoading(false);      await onAssignData();
      await homeController.onAssignCardData();
      log("error delete data $e");
      SnackBarManager().onShowSnacbarMessage(
        title: "Perhatian",
        content: "$e",
        colors: AppTheme.redColor,
        position: SnackPosition.BOTTOM,
      );
    }
  }

  printLabel() {
    isLoading(true);
    if (stokListToPrint.isEmpty) {
      isLoading(false);
      return SnackBarManager().onShowSnacbarMessage(
        title: "Perhatian",
        content: "Terjadi kesalahan tidak ada data untuk dicetak",
        colors: AppTheme.redColor,
        position: SnackPosition.BOTTOM,
      );
    } else {
      isLoading(false);
      Get.to(() => PrintLabelPage(listToPrint: stokListToPrint));
    }
  }

  onClearData() {
    isLoading(false);
    itemData.value = ItemStok();
    variasiWarna.value = StokGridModel();

    stokListToPrint.clear();
    variasiForms.clear();

    selectedLocation.value = "Pilih Lokasi";
    selectedCategory.value = "";
    selectedUnit.value = "";
    image = Rx<File?>(null);

    qrCodeResult.value = "";

    //field untuk add
    fieldNamaItem.clear();
    fieldNoItem.clear();
    searchBar.clear();
    fieldTotalVariasi.clear();
    fieldTotalVariasi.text = "0";

    //field untuk edit
    fieldEditNoItem.clear();
    fieldEditNamaItem.clear();
    fieldEditJumlahStok.clear();
    fieldEditVariasiWarna.clear();
    fieldEditHarga.clear();

    //field untuk edit ROP
    fieldEditAvgDailyDemand.clear();
    fieldEditLeadTime.clear();
    fieldEditSS.clear();
    fieldEditROP.clear();

    //add variation only
    noItem.value = '';
    namaItem.value = '';
    unitToAdd.value = '';
    locationToAdd.value = '';
  }
}
