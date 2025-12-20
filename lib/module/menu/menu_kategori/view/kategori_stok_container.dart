import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms_sm/module/menu/menu_kategori/view/component/add_category.dart';
import 'package:wms_sm/module/menu/menu_kategori/view/component/edit_category.dart';
import 'package:wms_sm/module/menu/menu_kategori/view/component/list_category_container.dart';
import '../../../../core/util_manager/appbar_manager.dart';
import '../../../../core/util_manager/button_manager.dart';
import '../../../../core/util_manager/dialog_manager.dart';
import '../controller/kategori_stok_controller.dart';

class KategoriStokContainer extends GetView<KategoriStokController> {
  const KategoriStokContainer({super.key});

  @override
  Widget build(BuildContext context) {
    Widget getBody() {
      if (controller.pageIdx.value == 0) {
        return listKategoriContainer();
      } else if (controller.pageIdx.value == 1) {
        return addCategory();
      } else {
        return editCategory();
      }
    }

    Widget bottomButton() {
      if (controller.pageIdx.value == 0) {
        return Button.bottomActionButton(
            icon: Icons.add,
            actionText: "Tambah Kategori",
            onTap: () {
              controller.pageIdx.value = 1;
            });
      } else if (controller.pageIdx.value == 1) {
        return Button.bottomActionButton(
            icon: Icons.save,
            actionText: "Simpan Kategori",
            onTap: () async {
              await controller.simpanKategori();
            });
      } else {
        return Button.bottomActionButton(
            icon: Icons.save,
            actionText: "Simpan Edit Kategori",
            onTap: () async {
              await controller.editKategori();
            });
      }
    }


    return Obx(() => PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              return;
            }
            controller.onBack();
          },
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBarManager.appbarMenu(
                  onTap: () {
                    controller.onBack();
                  },
                  menu: controller.pageIdx.value == 0
                      ? "Daftar Kategori Stok"
                      : controller.pageIdx.value == 1
                          ? "Tambah Kategori Stok"
                          : "Edit Kategori Stok"),
              body: SingleChildScrollView(
                child: Stack(children: [
                  Padding(padding: const EdgeInsets.all(8), child: getBody()),
                  controller.isLoading.isTrue
                      ? LoadingIndicatorWithText(
                          title: "Mohon tunggu",
                        )
                      : const SizedBox.shrink()
                ]),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(8.0),
                child: bottomButton(),
              )),
        ));

  }
}
