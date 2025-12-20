import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/database/data/m_user.dart';
import '../../core/database/database_helper/database_helper.dart';
import '../../core/util_manager/snackbar_manager.dart';
import '../../navigation/routes.dart';

class AuthController extends GetxController {
  var token = "".obs;

  var statusLogin = false.obs;

  var userData = User();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = true.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> requestStoragePermissionOnce() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasRequested = prefs.getBool('hasRequestedPermission') ?? false;

    if (!hasRequested) {
      PermissionStatus status = PermissionStatus.denied;

      if (Platform.isAndroid) {
        final deviceInfo = await DeviceInfoPlugin().androidInfo;
        int sdkInt = deviceInfo.version.sdkInt;

        if (sdkInt >= 33) {
          // Android 13+ (API 33): izin granular
          // READ_MEDIA_IMAGES (photo) atau video/audio jika perlu
          status = await Permission.photos.request();
        } else if (sdkInt >= 30) {
          //  Android 11–12 (API 30–32): manage external storage
          status = await Permission.storage.request();
        } else {
          // Android 10 ke bawah
          status = await Permission.storage.request();
        }
      } else {
        //  iOS atau platform lain
        status = await Permission.storage.request();
      }

      //  Hasil permintaan
      if (status.isGranted) {
        print(' Storage permission granted');
      } else if (status.isDenied) {
        print('Storage permission denied');
      } else if (status.isPermanentlyDenied) {
        print(' Storage permission permanently denied');
        openAppSettings();
      }

      // Simpan agar tidak minta ulang
      await prefs.setBool('hasRequestedPermission', true);
    } else {
      print('Permission already requested before');
    }
  }


  Future<void> saveLoginStatus(User userData) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(userData.toMap());
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userData', userJson);
  }

  Future<void> clearLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final userJson = prefs.getString('userData') ?? '';
      if (userJson.isNotEmpty){
        userData = User.fromMap(jsonDecode(userJson));
      }
      Get.toNamed(Routes.home);
    } else {
      Get.offAllNamed(Routes.login);
    }
  }

  Future<void> login() async {
    try {
      final db = await DBHelper.initDb();
      final result = await db.query(
        'USER',
        where: 'Username = ?',
        whereArgs: [usernameController.text.toUpperCase()],
      );

      if (result.isNotEmpty) {
        userData = User.fromMap(result.first);
        // Hash password yang dimasukkan user
        final hashedInputPassword = encryptPassword(passwordController.text);
        if(userData.Username == null || userData.Password == null){
          throw Exception("Gagal mengambil data user dari database");
        }

        if (userData.Password == hashedInputPassword &&
            userData.Username == usernameController.text.toUpperCase()) {
          saveLoginStatus(userData);
          Get.offAllNamed(Routes.home);
          usernameController.clear();
          passwordController.clear();
        } else {
          SnackBarManager().onShowSnacbarMessage(
              title: "Login gagal",
              content: "Username atau Password tidak sesuai",
              colors: Colors.red,
              position: SnackPosition.TOP);
        }
      }
      else {
        SnackBarManager().onShowSnacbarMessage(
            title: "Login gagal",
            content: "Data pengguna tidak ditemukan",
            colors: Colors.red,
            position: SnackPosition.TOP);
      }
    } catch (e) {
      SnackBarManager().onShowSnacbarMessage(
          title: "Login gagal",
          content: "Silakan masukkan kembali password",
          colors: Colors.red,
          position: SnackPosition.TOP);
    }
  }
}

// class AuthController extends GetxController {
//   var token = "".obs;
//
//   var statusLogin = false.obs;
//
//   ApiService apiService = ApiService();
//
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   var isPasswordVisible = false.obs;
//
//   void togglePasswordVisibility() {
//     isPasswordVisible.value = !isPasswordVisible.value;
//   }
//
//   Future<void> checkLoginStatus() async {
//     print("token dari check login status $token");
//     await Future.delayed(Duration(seconds: 1));
//     if (token != null && token.isNotEmpty && token.value != "") {
//       Get.offAllNamed(Routes.home);
//     } else {
//       Get.offAllNamed(Routes.login);
//     }
//   }
//
//   Future<void> login() async {
//     Get.offAllNamed(Routes.home);
//         emailController.clear();
//         passwordController.clear();
//     // try {
//     //   final response = await http.post(
//     //     Uri.parse(Url.baseUrl + Url.login),
//     //     headers: {"Accept": "application/json"},
//     //     body: {
//     //       "email": emailController.text,
//     //       "password": passwordController.text,
//     //     },
//     //   );
//     //
//     //   if (response.statusCode == 200) {
//     //     final data = jsonDecode(response.body);
//     //     token.value = data["token"];
//     //     print("Login berhasil! Token: ${token.value}");
//     //     Get.offAllNamed(Routes.home);
//     //     emailController.clear();
//     //     passwordController.clear();
//     //   } else {
//     //     print("Login gagal: ${response.body}");
//     //   }
//     // } catch (e) {
//     //   print("Error: $e");
//     // }
//   }
// }
