import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/util_manager/app_theme.dart';
import '../../../../../core/util_manager/button_manager.dart';
import '../../../../../core/util_manager/form_manager.dart';
import '../revisi_stock_masuk_container.dart';

extension ScanSearchReqPage on RevisiStockMasukContainer {
  Widget searchReqMasuk(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBarWidget(
            controller: controller.searchBar,
            hintText: "Cari Stok",
            onChanged: (value) {
              controller.onCheckQRData(value);
            },
          ),
          const SizedBox(height: 10),
          Button.button(
            label: "Pindai kode QR",
            color: AppTheme.blackColor,
            icon: Icons.qr_code,
            fontColor: AppTheme.whiteColor,
            function: () {
              controller.onStartScanner();
            },
          ),
          const SizedBox(height: 8),
          controller.isScanned.isTrue
              ? Text("is scanning")
              : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "Cari atau pindai nomor permintaan stok masuk yang ingin Anda lihat",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}