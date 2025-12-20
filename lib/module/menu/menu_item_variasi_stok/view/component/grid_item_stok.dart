import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/controller/add_variasi_only_controller.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/controller/item_variasi_edit_controller.dart';
import '../../../../../core/util_manager/dialog_manager.dart';
import '../../../../../core/util_manager/number_formatter.dart';
import '../../data/stok_grid_model.dart';
import '../item_variasi_stok_container.dart';

extension GridItemStok on ItemVariasiStokContainer {
  Widget customIconButton({
    Function()? onTap,
    required IconData icon,
    Color? iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: GestureDetector(
        onTap: () {
          onTap != null ? onTap() : {};
        },
        child: Icon(icon, color: iconColor ?? Colors.black),
      ),
    );
  }

  Widget cardInformation(StokGridModel item) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "No: ${item.noItem} ${item.noItemWarna}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          ),
          Text(
            "${item.namaItem ?? "-"} ",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(height: 1),
          ),
          Text(
            "Variasi: ${item.namaWarna ?? "-"}",
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${item.jumlah ?? "-"} ${item.unit ?? "-"}",
                style: const TextStyle(fontSize: 10),
              ),
              Text(
                "Rp ${NumberFormatter().onFormatNumber(texInput: item.harga ?? 0)}",
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
          Text(
            item.namaLokasi ?? "-",
            style: const TextStyle(fontSize: 8),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const Spacer(),
          Obx(
            () =>
                controller.position.value.toLowerCase() != "pemilik"
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customIconButton(
                          icon: Icons.edit,
                          onTap: () {
                            controller.onAssignDataToEdit(item);
                            controller.pageIdx.value = 3;
                          },
                        ),
                        const SizedBox(width: 8),
                        customIconButton(
                          icon: Icons.add,
                          onTap: () {
                            controller.onAssignDatatoAddVariation(item);
                            controller.pageIdx.value = 2;
                          },
                        ),
                        const SizedBox(width: 8),
                        customIconButton(
                          icon: Icons.delete,
                          iconColor: Colors.red,
                          onTap: () {
                            if(Get.isSnackbarOpen){
                              return;
                            }
                            DialogManager().dialogPerhatian(
                              "Perhatian",
                              "Apakah Anda ingin menghapus item?",
                              "Tidak",
                              "Iya",
                              () {
                                Get.back();
                              },
                              () {
                                controller.deleteVariasiWarna(
                                  item.noItemWarna!,
                                );
                                Get.back();
                              },
                            );
                          },
                        ),
                      ],
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget listItemStok(StokGridModel item) {
    var imageFile = File(item.gambarPath!);
    return Card(
      color:
          item.jumlah == 0
              ? Colors.grey.shade300
              : (item.jumlah ?? 0) < (item.rop ?? 0)
              ? Colors.yellow
              : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
              child:
                  item.gambarPath == ''
                      ? Image.asset("assets/wms_splash.jpg")
                      : Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        cacheWidth: 200,
                        cacheHeight: 200,
                      ),
            ),
            cardInformation(item),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey.shade300),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.searchBar,
              onChanged: (value) {
                controller.onFindItemByVarWarna(value);
              },
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(0),
                border: InputBorder.none,
                hintText: "Cari item ",
                icon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.onStartScanner();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.black,
              ),
              child: const Icon(Icons.qr_code, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget gridItemContainer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        searchBar(),
        const SizedBox(height: 4),
        controller.filterStokList.isEmpty
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Image.asset("assets/no-data.png", width: 60),
                      const SizedBox(height: 10),
                      const Text("Tidak ada Data", textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ],
            )
            : SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.filterStokList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  var item = controller.filterStokList[index];
                  return listItemStok(item);
                },
              ),
            ),
      ],
    );
  }
}
