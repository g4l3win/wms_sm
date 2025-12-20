import 'package:flutter/material.dart';
import '../../../core/util_manager/app_theme.dart';
import '../../../core/util_manager/dialog_manager.dart';
import 'home_page.dart';
import 'package:get/get.dart';

extension HomeAppbar on HomePage {
  Widget signoutButton() {
    return Center(
      child:  GestureDetector(
        onTap: () => DialogManager().dialogPerhatian("Perhatian",
            "Apakah Anda ingin keluar dari aplikasi", "Tidak", "Iya", () {
          Get.back();
        }, () {
          controller.logout();
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.redColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Text(
                "Sign Out",
                style: TextStyle(
                  color: AppTheme.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.logout_rounded, color: AppTheme.whiteColor, size: 15),
            ],
          ),
        ),
      ),
    );
  }

  AppBar homeAppbar() {
    return AppBar(
      backgroundColor: AppTheme.whiteColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.person, size: 35),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello,",
                style: TextStyle(color: AppTheme.greyColor, fontSize: 10),
              ),
              Obx(
                () => Text(
                   controller.dataUser.value.NamaDepan?? "..",
                  style: TextStyle(
                    color: AppTheme.blackColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Padding(padding:const EdgeInsets.only(right: 10), child: signoutButton()),
      ],
    );
  }
}
