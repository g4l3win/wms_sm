import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms_sm/module/menu/menu_laporan/view/component/stok_keluar_container.dart';
import 'package:wms_sm/module/menu/menu_laporan/view/component/stok_masuk_container.dart';
import '../../../../core/util_manager/appbar_manager.dart';
import '../../../../core/util_manager/button_manager.dart';
import '../../../../core/util_manager/dialog_manager.dart';
import '../controller/laporan_controller.dart';

class LaporanContainer extends GetView<LaporanController> {
  const LaporanContainer({super.key});

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
                color: isSelected ? Colors.red.shade300 : Colors.grey,
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
                tabBar(0, "Stok Masuk", Icons.download),
                const SizedBox(width: 4),
                tabBar(1, "Stok Keluar", Icons.upload),
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
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(controller.selectedMonthYear.value),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Button.button(
                    label: "Terapkan Filter",
                    color: Colors.black,
                    fontColor: Colors.white,
                    function: () {
                      controller.onMonthYearPicker(context: context);
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 4),
            controller.pageIdx.value == 0
                ? stokMasukContainer(context)
                : stokKeluarContainer(context),
          ],
        ),
      );
    }

    Widget bottomButton() {
      if (controller.pageIdx.value == 0) {
        return Button.bottomActionButton(
          actionText: "Print Laporan Stok Masuk",
          icon: Icons.print,
          onTap: () {
            controller.onPrepareDataToPrint();
          },
        );
      } else {
        return Button.bottomActionButton(
          actionText: "Print Laporan Stok Keluar",
          icon: Icons.print,
          onTap: (){
            controller.onPrepareDataToPrint();
          }
        );
      }
    }

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarManager.appbarMenu(menu: "Laporan"),
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
