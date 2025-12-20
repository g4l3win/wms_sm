import 'package:flutter/material.dart';
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
            color: Colors.red,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(
            children: [
              Text(
                "Sign Out",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.logout_rounded, color: Colors.white, size: 15),
            ],
          ),
        ),
      ),
    );
  }

  AppBar homeAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
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
              const Text(
                "Hello,",
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
              Obx(
                () => Text(
                   controller.dataUser.value.NamaDepan?? "..",
                  style: const TextStyle(
                    color: Colors.black,
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
