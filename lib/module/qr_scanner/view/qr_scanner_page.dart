import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/util_manager/app_theme.dart';
import '../../../core/util_manager/button_manager.dart';
import '../controller/mobile_scanner_controller.dart';

// ignore: must_be_immutable
class QRScannerPage extends StatelessWidget {
  final void Function(String result) scan;
  QRScannerPage({super.key, required this.scan});
  final MobileScanController controller = Get.put(MobileScanController());

  var isScanned = false.obs;
  var startTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
              scanWindow: Rect.fromLTWH(
                  (Get.size.width - controller.boxSize) / 2,
                  (Get.size.height - controller.boxSize) / 2,
                  controller.boxSize.toDouble(),
                  controller.boxSize.toDouble()),
              controller: controller.cameraController,
              onScannerStarted: (args){
                startTime = DateTime.now();
                print("Scanner started at: ${startTime}");
              },
              onDetect: (barcodeCapture) {
                if (isScanned.value) return;

                final barcode = barcodeCapture.barcodes.first;
                final String? code = barcode.rawValue;

                if (code != null && code.isNotEmpty) {
                  isScanned.value = true; // cegah deteksi ulang
                  scan(code);
                  Get.back(); // keluar dari halaman scan
                }
              }),
          Positioned(
            left: (Get.size.width - controller.boxSize) / 2,
            top: (Get.size.height - controller.boxSize) / 2,
            child: Container(
              width: controller.boxSize.toDouble(),
              height: controller.boxSize.toDouble(),
              decoration:
              BoxDecoration(border: Border.all(color: AppTheme.whiteColor)),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Button.button(
                label: "Batal",
                color: AppTheme.whiteColor,
                fontColor: AppTheme.blackColor,
                function: () => Get.back()),
          ),
          Obx(
            () => Positioned(
              bottom: 20,
              right: 20,
              child: Button.button(
                  color: controller.isTorch.isTrue ? AppTheme.blackColor : AppTheme.redColor,
                  label: controller.isTorch.isTrue
                      ? "Matikan flash"
                      : "Nyalakan Flash",
                  function: () => controller.toggleFlash(),),
            ),
          )
        ],
      ),
    );
  }
}
