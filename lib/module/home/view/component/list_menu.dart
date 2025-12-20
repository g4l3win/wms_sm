import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/util_manager/app_theme.dart';
import '../../../../navigation/routes.dart';
import '../../data/m_menu_description.dart';
import '../home_page.dart';

extension ListMenu on HomePage {

Widget cardInfo(BuildContext context, String title, String totalQTY,
      String description, String origin) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Get.toNamed(Routes.itemVariasiStok, arguments: {"origin": origin});
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.greyColor, width: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppTheme.greyColor,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        totalQTY,
                        style:TextStyle(
                            color: AppTheme.blackColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
              Text(description,
                  style: TextStyle(
                    color: AppTheme.greyColor,
                    fontSize: 10,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  
    Widget cardRow(BuildContext context) {
    return Obx(() => Row(
          children: [
            cardInfo(
                context,
                "Stok menipis",
                controller.totalRestock.value.toString(),
                "Tap untuk melihat detail",
                "need_restock"),
            cardInfo(
                context,
                "Stok habis",
                controller.totalEmpty.value.toString(),
                "Tap untuk melihat detail",
                "stock_empty"),
          ],
        ));
  }
  
  Widget listMenuContainer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "Manajemen Gudang",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        controller.listMenu.isNotEmpty ?
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.listMenu.length,
            itemBuilder: (context, index) {
              var item = controller.listMenu[index];
              return listMenu(item);
            }) :
            const Center(
              child: Text("Terjadi kesalahan, tidak ditemukan menu"),
            ),
         cardRow(context)
      ],
    );
  }

 Widget listMenu(MenuItem item) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(item.rute);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            color: AppTheme.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border(bottom: BorderSide(color: AppTheme.greyColor))),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          children: [
            Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: AppTheme.lightGrey,
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(
                  item.icon,
                  size: 40,
                )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    item.subtitle,
                    style: TextStyle(fontSize: 12, color: AppTheme.greyColor),
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
