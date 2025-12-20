import 'package:flutter/material.dart';
import 'package:wms_sm/module/home/controller/profile_controller.dart';
import '../../../../core/util_manager/button_manager.dart';
import '../../../../core/util_manager/form_manager.dart';
import '../home_page.dart';

extension ProfilePage on HomePage {
  Widget profilePageContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [header(), form()],
    );
  }

  Widget header() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Username",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            controller.fieldUsername.value,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

    Widget form() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          FormInputText(
            title: "Nama depan",
            txtcontroller: controller.fieldFirstName,
            borderColors: Colors.grey.shade300,
            textInputType: TextInputType.text,
            txtEnable: true,
            txtLine: 1,
            txtReadonly: false,
            errorText: controller.errorFirstName.value.isEmpty ? null : controller.errorFirstName.value,
          ),
          FormInputText(
            title: "Nama belakang",
            txtcontroller: controller.fieldLastName,
            borderColors: Colors.grey.shade300,
            textInputType: TextInputType.text,
            txtEnable: true,
            txtLine: 1,
            txtReadonly: false,
            errorText: controller.errorLastName.value.isEmpty ? null : controller.errorLastName.value,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: Button.button(
                      label: "Batal",
                      color: Colors.white,
                      fontColor: Colors.black,
                      function: () {
                        controller.onCancel();
                      })),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Button.button(
                      label: "Simpan",
                      function: () async {
                        controller.updateUser();
                      })),
            ],
          ),
          const Divider(),
          FormInputText(
            title: "Password Sekarang",
            txtcontroller: controller.fieldOldPassword,
            borderColors: Colors.grey.shade300,
            textInputType: TextInputType.text,
            txtEnable: true,
            txtLine: 1,
            txtReadonly: false,
            obscureText: true,
            errorText: controller.errorOldPass.value.isEmpty ? null : controller.errorOldPass.value,
          ),
          FormInputText(
            title: "Ganti Password",
            txtcontroller: controller.fieldNewPassword,
            borderColors: Colors.grey.shade300,
            textInputType: TextInputType.text,
            txtEnable: true,
            txtLine: 1,
            txtReadonly: false,
            obscureText: true,
            errorText: controller.errorNewPass.value.isEmpty ? null : controller.errorNewPass.value,
          ),
          FormInputText(
            title: "Konfirmasi Password",
            txtcontroller: controller.fieldConfirmPassword,
            borderColors: Colors.grey.shade300,
            textInputType: TextInputType.text,
            txtEnable: true,
            txtLine: 1,
            txtReadonly: false,
            obscureText: true,
            errorText: controller.errorConfirmPass.value.isEmpty ? null : controller.errorConfirmPass.value,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: Button.button(
                      label: "Batal",
                      color: Colors.white,
                      fontColor: Colors.black,
                      function: () {
                        controller.onCancelChangePassword();
                      })),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Button.button(
                      label: "Simpan",
                      function: () async {
                      await controller.changePassword();
                      })),
            ],
          )
        ],
      ),
    );
  }
}



