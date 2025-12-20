import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_keluar/controller/riwayat_stok_keluar_controller.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_keluar/view/component/riwayat_stok_keluar.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_keluar/view/component/scan_search_req_page.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_keluar/view/component/stok_keluar_detail_page.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_keluar/view/component/stok_keluar_item_page.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_keluar/view/component/sukses_stok_keluar.dart';

import '../../../../core/util_manager/app_theme.dart';
import '../../../../core/util_manager/appbar_manager.dart';
import '../../../../core/util_manager/button_manager.dart';
import '../../../../core/util_manager/dialog_manager.dart';
import '../controller/revisi_stock_keluar_controller.dart';

class RevisiStockKeluarContainer extends GetView<RevisiStockKeluarController> {
  const RevisiStockKeluarContainer({super.key});

  @override
  Widget build(BuildContext context) {
    Widget historyButton() {
      return Center(
        child: GestureDetector(
          onTap: () => controller.pageIdx.value = 3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: AppTheme.lightGrey),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade800,
                  blurRadius: 0.1,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Text(
                  "Riwayat",
                  style: TextStyle(
                    color: AppTheme.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget getBody() {
      if (controller.pageIdx.value == 0) {
        return searchReqKeluar(context); // scan dan search bar cari
      } else if (controller.pageIdx.value == 1) {
        return detailPerminttanKeluar(context); // tampil form pertama
      } else if (controller.pageIdx.value == 2) {
        return editStokKeluar(); // edit jumlah stok yang diterima sesungguhnya
      } else if (controller.pageIdx.value == 3) {
        return formRiwayatKeluar(context); // halaman riwayat stok keluar
      } else {
        return successStokKeluarPage(); // halaman sukses input
      }
    }

    Widget bottomButton() {
      if (controller.pageIdx.value == 0) {
        return SizedBox.shrink();
      } else if(controller.pageIdx.value ==1){
        return Button.bottomActionButton(
          icon: Icons.skip_next,
          actionText: "Lanjut",
          onTap: () {
           controller.pageIdx.value = 2;
          },
        );
      } else if (controller.pageIdx.value == 2){
        return Button.bottomActionButton(
          icon: Icons.save,
          actionText: "Simpan",
          onTap: () {
            controller.insertStokKeluar();
          },
        );
      }
      else if (controller.pageIdx.value == 3) {
        return Button.bottomActionButton(
          icon: Icons.delete,
          actionText: "Hapus Stok Keluar",
          onTap: () {
            DialogManager().dialogPerhatian(
              "Perhatian",
              "Apakah Anda ingin menghapus riwayat stok keluar?",
              "Tidak",
              "Iya",
              () {
                Get.back();
              },
              () async {
                // Tombol Iya
                // Tutup dialog dulu kalau masih terbuka
                if (Get.isDialogOpen ?? false) Get.back();

                  await controller.onDeleteStokKeluar();

                // Setelah fungsi selesai, pastikan tidak ada dialog tersisa
                if (Get.isDialogOpen ?? false) Get.back();
              },
            );
          },
        );
      } else {
        return Button.bottomActionButton(
          icon: Icons.print,
          actionText: "Cetak",
          onTap: () {
             controller.onToPrintStokKeluar();
          },
        );
      }
    }

    AppBar appBarStok() {
      if (controller.pageIdx.value == 0) {
        return AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppTheme.whiteColor,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => controller.onBack(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppTheme.greyColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  Icon(
                    Icons.arrow_back_rounded,
                    color: AppTheme.blackColor,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Cari Permintaan Stok Keluar",
                style: TextStyle(
                  color: AppTheme.blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 5),
              historyButton(),
            ],
          ),
          centerTitle: true,
        );
      } else if (controller.pageIdx.value == 1) {
        return AppBarManager.appbarMenu(
          onTap: () {
            controller.onBack();
          },
          menu: "Data permintaan Keluar",
        );
      } else if (controller.pageIdx.value == 2) {
        return AppBarManager.appbarMenu(
          onTap: () {
            controller.onBack();
          },
          menu: "Edit Stok keluar",
        );
      } else if (controller.pageIdx.value == 3) {
        return AppBarManager.appbarMenu(
          onTap: () {
            controller.onBack();
          },
          menu: "Riwayat Stok Keluar",
        );
      } else {
        return AppBarManager.appbarMenu(
          onTap: () {
            controller.onBack();
          },
          menu: "Konfirmasi",
        );
      }
    }

    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
          controller.onBack();
        },
        child: Scaffold(
          backgroundColor: AppTheme.whiteColor,
          appBar: appBarStok(),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(padding: const EdgeInsets.all(8), child: getBody()),
                controller.isLoading.isTrue
                    ? LoadingIndicatorWithText(title: "Mohon tunggu")
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: bottomButton(),
          ),
        ),
      ),
    );
  }
}
