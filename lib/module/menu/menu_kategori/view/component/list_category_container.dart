import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/database/data/m_kategori_stok.dart';
import '../../../../../core/util_manager/dialog_manager.dart';
import '../kategori_stok_container.dart';

extension ListKategoriContainer on KategoriStokContainer {
  Widget buttonList({
    Function()? onTap,
    required IconData icon,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: () => onTap != null ? onTap() : {},
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.grey.shade200,
        ),
        child: Icon(icon, color: iconColor ?? Colors.black),
      ),
    );
  }

  Widget listKategoriStok(KategoriStok item) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(item.NamaKategori, style: const TextStyle(fontSize: 16)),
                Text(
                  item.NoKategori,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          const Spacer(),
          buttonList(
            icon: Icons.edit,
            iconColor: Colors.green,
            onTap: () {
              controller.pageIdx.value = 2;
              controller.fieldEditNoKategori.text = item.NoKategori;
              controller.fieldEditNamaKategori.text = item.NamaKategori;
            },
          ),

          const SizedBox(width: 4),
          buttonList(
            icon: Icons.delete,
            iconColor: Colors.red,
            onTap: () {
              DialogManager().dialogPerhatian(
                "Perhatian",
                "Apakah Anda ingin menghapus kategori?",
                "Tidak",
                "Iya",
                () {
                  Get.back();
                },
                () {
                  controller.deleteCategory(item.NoKategori);
                  Get.back();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget listKategoriContainer() {
    return controller.listKategori.isEmpty
        ? const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("No Data")],
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.listKategori.length,
              itemBuilder: (context, index) {
                var item = controller.listKategori[index];
                return listKategoriStok(item);
              },
            ),
          ],
        );
  }
}
