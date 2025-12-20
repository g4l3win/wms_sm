import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'button_manager.dart';

class DialogManager {
  dialogPerhatian(
      String judul, String content, String textBtnCancel, String textBtnConfirm,
      dynamic onCancel, dynamic onConfirm) {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button.button(
                label: textBtnCancel,
                function: () {
                  onCancel();
                }),
            const SizedBox(
              width: 4,
            ),
            Button.button(
                label: textBtnConfirm,
                function: () {
                  onConfirm();
                })
          ],
        )
      ],

      content: SizedBox(
        height: 150,
        child: Center(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Text(
                  judul,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                top: 22,
                left: 0,
                right: 0,
                child: Text(
                  content,
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

    dialogROP() {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 4,
            ),
            Button.button(
                label: "OK",
                function: () {
                  Get.back();
                })
          ],
        )
      ],
      content: const SizedBox(
        height: 250,
        child: Center(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Text(
                  "ROP = (Average Daily Demand × Lead Time) + Safety Stock",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Text(
                  "Average Daily Demand = jumlah rata-rata barang laku terjual dalam sehari\n\n"
                      "Lead Time = Waktu yang diperlukan untuk mengisi kembali stok\n\n"
                      "Safety Stock = Stok minimal yang harus tersedia di dalam gudang",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}


class LoadingIndicatorWithText extends StatelessWidget {
  final String title;

  const LoadingIndicatorWithText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/loading.json', // Path file Lottie
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
