import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import '../../../core/database/database_helper/database_helper.dart';
import '../../../core/util_manager/app_theme.dart';
import '../../../core/util_manager/snackbar_manager.dart';
import 'home_controller.dart';

extension ProfileController on HomeController {
  Future<void> initDatabase() async {
    db = await DBHelper.initDb();
  }

  String encryptPassword(String password) {
    final bytes = utf8.encode(password); // ubah ke byte
    final digest = sha256.convert(bytes); // enkripsi SHA-256
    return digest.toString();
  }

    Future<void> updateUser() async {
    try{
      errorFirstName.value = '';
      errorLastName.value = '';
    if(fieldFirstName.text.isEmpty || fieldLastName.text.isEmpty ){
      if(fieldFirstName.text.isEmpty) errorFirstName.value = "Wajib diisi";
      if(fieldLastName.text.isEmpty) errorLastName.value = 'Wajib diisi';
       throw Exception("Terdapat form kosong");
     }
      Map<String, dynamic> updateData = {
        'NamaDepan': fieldFirstName.text,
        'NamaBelakang': fieldLastName.text,
      };

      // update ke database
      await db.update(
        'USER',
        updateData,
        where: 'Username = ?',
        whereArgs: [fieldUsername.value],
      );

      // perbarui data user di variabel lokal
      dataUser.value.NamaDepan = fieldFirstName.text;
      dataUser.value.NamaBelakang = fieldLastName.text;

      log("User berhasil diperbarui");
      SnackBarManager().onShowSnacbarMessage(
          title: "Update berhasil",
          content: "Update data user berhasil",
          colors: AppTheme.greenColor,
          position: SnackPosition.TOP);
    } catch (e){
      log("error $e");
      SnackBarManager().onShowSnacbarMessage(
          title: "Update Gagal",
          content: "gagal $e",
          colors: AppTheme.redColor,
          position: SnackPosition.TOP);
    }
  }

 Future<void> changePassword() async {
    try {
      // reset semua error dulu
      errorOldPass.value = '';
      errorNewPass.value = '';
      errorConfirmPass.value = '';

      var oldPass = fieldOldPassword.text.trim();
      var newPass = fieldNewPassword.text.trim();
      var confirmPass = fieldConfirmPassword.text.trim();

      // Validasi dasar
      if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
        if (oldPass.isEmpty) errorOldPass.value = 'Password lama wajib diisi';
        if (newPass.isEmpty) errorNewPass.value = 'Password baru wajib diisi';
        if (confirmPass.isEmpty) errorConfirmPass.value = 'Konfirmasi wajib diisi';

        SnackBarManager().onShowSnacbarMessage(
          title: "Error",
          content: "Semua field password harus diisi",
          colors: AppTheme.redColor,
          position: SnackPosition.TOP,
        );
        return;
      }

      if (newPass != confirmPass) {
        errorNewPass.value = 'Password tidak cocok';
        errorConfirmPass.value = 'Password tidak cocok';
        SnackBarManager().onShowSnacbarMessage(
          title: "Error",
          content: "Konfirmasi password tidak cocok",
          colors: AppTheme.redColor,
          position: SnackPosition.TOP,
        );
        return;
      }

      final user = await db.query('USER',
          where: 'Username = ?', whereArgs: [fieldUsername.value]);

      if (user.isEmpty) {
        throw Exception("User tidak ditemukan");
      }

      final currentPasswordHashed = user.first['Password'] as String;

      if (encryptPassword(oldPass) != currentPasswordHashed) {
        errorOldPass.value = 'Password lama salah';
        SnackBarManager().onShowSnacbarMessage(
          title: "Error",
          content: "Password lama salah",
          colors: AppTheme.redColor,
          position: SnackPosition.TOP,
        );
        return;
      }

      final newHashed = encryptPassword(newPass);

      await db.update(
        'USER',
        {'Password': newHashed},
        where: 'Username = ?',
        whereArgs: [fieldUsername.value],
      );

      SnackBarManager().onShowSnacbarMessage(
        title: "Berhasil",
        content: "Password berhasil diubah",
        colors: AppTheme.greenColor,
        position: SnackPosition.TOP,
      );

      onCancelChangePassword();

    } catch (e) {
      log("Error ubah password: $e");
      SnackBarManager().onShowSnacbarMessage(
        title: "Gagal",
        content: "Terjadi kesalahan saat ubah password",
        colors: AppTheme.redColor,
        position: SnackPosition.TOP,
      );
    }
  }

  onCancel() {
    fieldUsername.value = dataUser.value.Username ?? "-";
    fieldFirstName.text = dataUser.value.NamaDepan ?? "-";
    fieldLastName.text = dataUser.value.NamaBelakang ?? "-";
    errorFirstName.value = '';
    errorLastName.value = '';
  }
  onCancelChangePassword() {
    fieldOldPassword.clear();
    fieldNewPassword.clear();
    fieldConfirmPassword.clear();
    errorOldPass.value = '';
    errorNewPass.value = '';
    errorConfirmPass.value = '';
  }
}
