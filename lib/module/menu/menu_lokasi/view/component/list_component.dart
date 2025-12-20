import 'package:flutter/material.dart';
import 'package:wms_sm/module/menu/menu_lokasi/controller/crud_template_controller.dart';
import '../../../../../core/database/data/m_lokasi_stok.dart';
import '../../../../../core/util_manager/app_theme.dart';
import '../../../../../core/util_manager/form_manager.dart';
import '../location_container.dart';

extension ListComponent on LocationContainer {
  Widget buttonList({
    Function()? onTap,
    required IconData iconData,
    required iconColor,
  }) {
    return GestureDetector(
      onTap: () => onTap != null ? onTap() : null,
      child: Container(
        padding: const EdgeInsets.all(4),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppTheme.whiteColor60,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Icon(iconData, color: iconColor),
      ),
    );
  }

  Widget itemList(LokasiStok item, int index) {
    return GestureDetector(
      onTap: () { controller.onAssignData(item.NoLokasi );},
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.lightGrey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Informasi Lokasi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.NamaLokasi ,
                    style: TextStyle(
                      color: AppTheme.blackColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.NoLokasi ,
                    style: TextStyle(color: AppTheme.lightGrey, fontSize: 13),
                  ),
                ],
              ),
            ),

            // Action
            Row(
              children: [
                Text(
                  "Detail",
                  style: TextStyle(color: AppTheme.greyColor, fontSize: 12),
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, color: AppTheme.greyColor, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget containerList(
    BuildContext context,
    ScrollController scrollController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchBarWidget(
          controller: controller.searchBar,
          hintText: 'Cari lokasi stok',
          onChanged: (value) {
            controller.onSearchData(value);
          },
        ),

        /// select range date
        SizedBox(height: 4),
        controller.filterListData.isNotEmpty
            ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView.builder(
                itemCount: controller.filterListData.length,
                shrinkWrap: true,
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (build, index) {
                  var item = controller.filterListData[index];
                  return itemList(item, index);
                },
              ),
            )
            : Row(
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
            ),
        !controller.hasMore.value
            ? const Center(child: Text("Tidak ada data lagi"))
            : const Center(child: Text("Geser untuk melihat data")),
      ],
    );
  }
}
