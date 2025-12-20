import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_masuk/controller/riwayat_stok_masuk_controller.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_masuk/view/component/riwayat_stok_masuk.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_masuk/view/component/search_req_masuk.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_masuk/view/component/stok_masuk_detail_page.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_masuk/view/component/stok_masuk_item_page.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_masuk/view/component/success_stok_masuk.dart';
import '../../../../core/util_manager/app_theme.dart';
import '../../../../core/util_manager/appbar_manager.dart';
import '../../../../core/util_manager/button_manager.dart';
import '../../../../core/util_manager/dialog_manager.dart';
import '../controller/revisi_stock_masuk_controller.dart';

class RevisiStockMasukContainer extends GetView<RevisiStockMasukController> {
  const RevisiStockMasukContainer({super.key});

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
        return searchReqMasuk(context); // scan dan search bar cari
      } else if (controller.pageIdx.value == 1) {
        return detailPermintaanMasuk(context); // tampil form pertama
      } else if (controller.pageIdx.value == 2) {
        return editStokMasuk(); // edit jumlah stok yang diterima sesungguhnya
      } else if (controller.pageIdx.value == 3) {
        return formRiwayatMasuk(context); // halaman riwayat stok Masuk
      } else {
        return successStokMasukPage(); // halaman sukses input/ delete
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
          onTap: () async{
            await controller.insertStokMasuk();
          },
        );
      }
      else if (controller.pageIdx.value == 3) {
        return Button.bottomActionButton(
          icon: Icons.delete,
          actionText: "Hapus Stok Masuk",
          onTap: () {
            DialogManager().dialogPerhatian(
              "Perhatian",
              "Apakah Anda ingin menghapus riwayat stok Masuk?",
              "Tidak",
              "Iya",
                  () {
                Get.back();
              },
                  () async {
                // Tombol Iya
                // Tutup dialog dulu kalau masih terbuka
                if (Get.isDialogOpen ?? false) Get.back();

                  await controller.onDeleteStokMasuk();

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
             controller.onToPrintStokMasuk();
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
                "Cari Permintaan Stok Masuk",
                style:  TextStyle(
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
          menu: "Data permintaan Masuk",
        );
      } else if (controller.pageIdx.value == 2) {
        return AppBarManager.appbarMenu(
          onTap: () {
            controller.onBack();
          },
          menu: "Edit Stok Masuk",
        );
      } else if (controller.pageIdx.value == 3) {
        return AppBarManager.appbarMenu(
          onTap: () {
            controller.onBack();
          },
          menu: "Riwayat Stok Masuk",
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
