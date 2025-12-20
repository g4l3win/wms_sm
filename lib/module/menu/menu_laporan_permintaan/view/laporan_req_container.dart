import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms_sm/module/menu/menu_laporan_permintaan/view/component/permintaan_keluar.dart';
import 'package:wms_sm/module/menu/menu_laporan_permintaan/view/component/permintaan_masuk.dart';
import '../../../../core/util_manager/app_theme.dart';
import '../../../../core/util_manager/appbar_manager.dart';
import '../../../../core/util_manager/button_manager.dart';
import '../../../../core/util_manager/dialog_manager.dart';
import '../controller/laporan_req_controller.dart';

class LaporanReqContainer extends GetView<LaporanReqController> {
  const LaporanReqContainer({super.key});

  @override
  Widget build(BuildContext context) {
    Widget tabBar(int pageIdx, String label, IconData icon) {
      var isSelected = controller.pageIdx.value == pageIdx;
      return Expanded(
        child: InkWell(
          onTap: () {
            controller.pageIdx.value = pageIdx;
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.red.shade300 : AppTheme.greyColor,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: Colors.blue),
                SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget getBody() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Row(
              children: [
                tabBar(0, "Req Masuk", Icons.download),
                const SizedBox(width: 4),
                tabBar(1, "Req Keluar", Icons.upload),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.greyColor400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(controller.selectedMonthYear.value),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Button.button(
                    label: "Terapkan Filter",
                    color: AppTheme.blackColor,
                    fontColor: AppTheme.whiteColor,
                    function: () {
                      controller.onMonthYearPicker(context: context);
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 4),
            controller.pageIdx.value == 0
                ? reqMasukContainer(context)
                : reqKeluarContainer(context)
          ],
        ),
      );
    }

    Widget bottomButton() {
      if (controller.pageIdx.value == 0) {
        return Button.bottomActionButton(
          actionText: "Print Laporan Permintaan Masuk",
          icon: Icons.print,
          onTap: () {
            controller.onPrepareDataToPrint();
          },
        );
      } else {
        return Button.bottomActionButton(
            actionText: "Print Laporan Permintaan Keluar",
            icon: Icons.print,
            onTap: (){
              controller.onPrepareDataToPrint();
            }
        );
      }
    }

    return Obx(
          () => Scaffold(
        backgroundColor: AppTheme.whiteColor,
        appBar: AppBarManager.appbarMenu(menu: "Laporan Permintaan"),
        body: SingleChildScrollView(
            child: Stack(
              children: [
                getBody(),
                controller.isLoading.isTrue
                    ? LoadingIndicatorWithText(
                  title: "Mohon tunggu",
                )
                    : const SizedBox.shrink()
              ],
            )),
        bottomNavigationBar: bottomButton(),
      ),
    );
  }
}
