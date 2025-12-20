import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wms_sm/module/home/controller/profile_controller.dart';
import '../../../core/database/data/m_user.dart';
import '../../../login/controller/auth_controller.dart';
import '../../../navigation/routes.dart';
import '../data/m_menu_description.dart';

class HomeController extends GetxController {
  var pageIdx = 0.obs;
  var isLoading = false.obs;
  var token = "";
  final authController = Get.find<AuthController>();

  var listMenu = <MenuItem>[];

  //profil
  var fieldUsername = "".obs;
  var userPosition = "".obs;
  TextEditingController fieldFirstName = TextEditingController();
  TextEditingController fieldLastName = TextEditingController();
  TextEditingController fieldPassword = TextEditingController();

  //coba tambahin fitur change password
  TextEditingController fieldOldPassword = TextEditingController();
  TextEditingController fieldNewPassword = TextEditingController();
  TextEditingController fieldConfirmPassword = TextEditingController();

  // reset semua error dulu
  var errorOldPass = ''.obs;
  var errorNewPass = ''.obs;
  var errorConfirmPass = ''.obs;
  var errorFirstName = ''.obs;
  var errorLastName = ''.obs;

  var dataUser = User().obs;
  late Database db;

  //card data
  var totalRestock = 0.obs;
  var totalEmpty = 0.obs;

  @override
  onInit() async {
    onAssignUser();
    onAssignMenu(false);
    await initDatabase();
    super.onInit();
  }

  @override
  onReady() async {
    await onAssignCardData();
    super.onReady();
  }

  onNavClick(int index) {
    pageIdx.value = index;
  }

  onAssignMenu(bool isDev) {
    if (isDev == true) {
      for (var item in menu) {
        listMenu.add(MenuItem.fromMap(item));
      }
    } else if (isDev == false &&
        userPosition.value.toLowerCase() == "pemilik") {
      for (var item in menuPemilik) {
        listMenu.add(MenuItem.fromMap(item));
      }
    } else if (isDev == false && userPosition.value.toLowerCase() == 'admin') {
      for (var item in menuAdmin) {
        listMenu.add(MenuItem.fromMap(item));
      }
    }
  }

  onAssignUser() {
    dataUser.value = authController.userData;
    fieldUsername.value = dataUser.value.Username ?? "-";
    fieldFirstName.text = dataUser.value.NamaDepan ?? "-";
    fieldLastName.text = dataUser.value.NamaBelakang ?? "-";
    userPosition.value = dataUser.value.Posisi ?? '-';
  }

  Future<void> logout() async {
    authController.clearLoginStatus();
    Get.offAllNamed(Routes.login);
  }

  Future<int> getVariasiToRestock() async {
    final result = await db.rawQuery('''
    SELECT COUNT(*) as needRestock
    FROM VARIASI_WARNA 
    WHERE Jumlah < ROP AND Jumlah > 0 AND isDeleted = 0
  ''');

    if (result.isNotEmpty && result.first['needRestock'] != null) {
      return (result.first['needRestock'] as num).toInt();
    }
    return 0;
  }

  Future<int> getVariasiEmpty() async {
    final result = await db.rawQuery('''
    SELECT COUNT(*) as stockEmpty
    FROM VARIASI_WARNA 
    WHERE Jumlah = 0 AND isDeleted = 0
  ''');

    if (result.isNotEmpty && result.first['stockEmpty'] != null) {
      return (result.first['stockEmpty'] as num).toInt();
    }
    return 0;
  }

  onAssignCardData() async {
    totalRestock.value = await getVariasiToRestock();
    totalEmpty.value = await getVariasiEmpty();
    log("cek restok ${totalRestock.value} cek habis ${totalEmpty.value}");
  }
}

