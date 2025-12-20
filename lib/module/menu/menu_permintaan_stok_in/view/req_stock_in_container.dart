import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms_sm/module/menu/menu_permintaan_stok_in/view/component/form_permintaan_masuk.dart';
import 'package:wms_sm/module/menu/menu_permintaan_stok_in/view/component/success_page_req_in.dart';
import '../../../../core/util_manager/app_theme.dart';
import '../../../../core/util_manager/appbar_manager.dart';
import '../../../../core/util_manager/button_manager.dart';
import '../../../../core/util_manager/dialog_manager.dart';
import '../controller/req_stock_in_controller.dart';

class RequestStockInContainer extends GetView<ReqStockInController> {
  const RequestStockInContainer({super.key});

  @override
  Widget build(BuildContext context) {
    Widget getBody() {
      if (controller.pageIdx.value == 0) {
        return formPermintaanStokMasuk(context);
      } else {
        return successPage();
      }
    }

    Widget bottomButton() {
      if (controller.pageIdx.value == 0) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Button.button(
                  label: "Batal",
                  color: AppTheme.whiteColor,
                  fontColor: AppTheme.blackColor,
                  function: () {
                    controller.onClearData();
                  },
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Button.button(
                  label: "Simpan Permintaan",
                  function: () async {
                   await controller.insertRequestStokMasuk();
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return Button.bottomActionButton(
          icon: Icons.print,
          actionText: "Cetak",
          onTap: () {
           controller.onToPrint();
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => controller.onBack(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppTheme.greyColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: AppTheme.blackColor,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 10),
                Text(
                  "Permintaan Stok Masuk",
                  style: TextStyle(
                    color: AppTheme.blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
          centerTitle: true,
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
