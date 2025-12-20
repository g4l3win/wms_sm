import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/controller/add_variasi_only_controller.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/controller/item_variasi_edit_controller.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/controller/variasi_warna_controller.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/view/component/add_item_stok.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/view/component/add_variasi_item.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/view/component/edit_item_stok.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/view/component/edit_rop_form.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/view/component/grid_item_stok.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/view/component/success_page.dart';
import '../../../../core/util_manager/app_theme.dart';
import '../../../../core/util_manager/appbar_manager.dart';
import '../../../../core/util_manager/button_manager.dart';
import '../../../../core/util_manager/dialog_manager.dart';
import '../controller/item_variasi_stok_controller.dart';

class ItemVariasiStokContainer extends GetView<ItemVariasiStokController> {
  const ItemVariasiStokContainer({super.key});

  @override
  Widget build(BuildContext context) {
    Widget getBody() {
      if (controller.pageIdx.value == 0) {
        return gridItemContainer(context);
      } else if (controller.pageIdx.value == 1) {
        return addItemStok(); //tambah stok
      } else if (controller.pageIdx.value == 2) {
        return formVariasiWarna(); //tambah variasi warna ROP
      } else if (controller.pageIdx.value == 3) {
        return editItemStok(); //edit
      } else if (controller.pageIdx.value == 4) {
        return editROPForm(); // edit ROP
      } else {
        return successPage();
      }
    }

    Widget bottomButton() {
      if (controller.pageIdx.value == 0 && controller.prevPage.length > 0) {
        return const SizedBox.shrink();
      }
      if (controller.pageIdx.value == 0 && controller.prevPage.length == 0) {
        return
          Button.bottomActionButton(
          icon: Icons.add,
          actionText: "Tambah Item Stok",
          onTap: () async{
           await controller.loadKategori();
            controller.pageIdx.value = 1;
          },
        );
      } else if (controller.pageIdx.value == 1) {
        return Button.bottomActionButton(
          icon: Icons.navigate_next,
          actionText: "Lanjut tambah Variasi",
          onTap: () {
            controller.pageIdx.value = 2;
          },
        );
      } else if (controller.pageIdx.value == 2) {
        return controller.noItem.value == ""
            ? Button.bottomActionButton(
              icon: Icons.save,
              actionText: "Simpan Stok Baru",
              onTap: () {
                controller.insertItemStokData();
              },
            )
            :
            //item ada tapi mau nambah variasi
            Button.bottomActionButton(
              icon: Icons.save,
              actionText: "Simpan Variasi baru",
              onTap: () {
                controller.insertVariasiROPNew();
              },
            );
      } else if (controller.pageIdx.value == 3) {
        return Button.bottomActionButton(
          //EDIT ITEM STOK
          icon: Icons.navigate_next,
          actionText: "Lanjut Edit ROP",
          onTap: () {
            controller.pageIdx.value = 4;
          },
        );
      } else if (controller.pageIdx.value == 4) {
        return Button.bottomActionButton(
          //simpan Edit ROP
          icon: Icons.save,
          actionText: "Simpan edit",
          onTap: () {
            controller.onUpdate();
          },
        );
      } else {
        return Button.bottomActionButton(
          //halaman sukses
          icon: Icons.print,
          actionText: "Print",
          onTap: () {
            controller.printLabel();
          },
        );
      }
    }

    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          controller.onBack();
        },
        child: Scaffold(
          backgroundColor: AppTheme.whiteColor,
          appBar: AppBarManager.appbarMenu(
            onTap: () {
              controller.onBack();
            },
            menu:
                controller.pageIdx.value == 0
                    ? "Daftar Item Stok"
                    : controller.pageIdx.value == 1
                    ? "Tambah Item Stok"
                    : controller.pageIdx.value == 2
                    ? "Tambah Variasi Stok ROP"
                    : controller.pageIdx.value == 3
                    ? "Edit Item Stok"
                    : controller.pageIdx.value == 4
                    ? "Edit Data ROP"
                    : "Konfirmasi",
          ),
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
