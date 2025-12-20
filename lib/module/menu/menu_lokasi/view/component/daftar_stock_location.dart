import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../core/util_manager/app_theme.dart';
import '../../../../../core/util_manager/number_formatter.dart';
import '../../../menu_item_variasi_stok/data/stok_grid_model.dart';
import '../location_container.dart';

extension StockInLocation on LocationContainer{
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
        ],
      ),
    );
  }

  Widget listItemStok(StokGridModel item) {
    var imageFile = File(item.gambarPath!);
    return
      Card(
      color:
      item.jumlah == 0
          ? AppTheme.lightGrey
          : (item.jumlah ?? 0) < (item.rop ?? 0)
          ? Colors.yellow
          : AppTheme.whiteColor,
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

  Widget gridItemContainer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        controller.stokList.isEmpty
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
          height: MediaQuery.of(context).size.height * 0.9,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.stokList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              var item = controller.stokList[index];
              return listItemStok(item);
            },
          ),
        ),
      ],
    );
  }
}