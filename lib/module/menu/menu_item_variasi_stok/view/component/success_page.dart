import 'dart:io';
import 'package:flutter/material.dart';

import '../../../../../core/util_manager/app_theme.dart';
import '../item_variasi_stok_container.dart';

extension SuccessPage on ItemVariasiStokContainer {

    Widget successPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Icon sukses
          CircleAvatar(
            radius: 40,
            backgroundColor: AppTheme.blackColor,
            child: Icon(Icons.check, color: AppTheme.whiteColor, size: 40),
          ),
          const SizedBox(height: 16),
          const Text(
            "Sukses!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Anda dapat melakukan print label stok",
            style: TextStyle(color: AppTheme.greyColor),
          ),
          const SizedBox(height: 24),

          // Judul section stok
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Stok Disimpan / Edit",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),

          // List stok
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.stokListToPrint.length,
            itemBuilder: (context, index) {
              final stock = controller.stokListToPrint[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.lightGrey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Gambar placeholder
                    stock.gambarPath == null
                        ? Container(
                            width: 60,
                            height: 60,
                            color: AppTheme.lightGrey,
                            child: Icon(Icons.image, color: AppTheme.greyColor),
                          )
                        : Image.file(
                             File(stock.gambarPath!),
                            width: 60,
                            height: 60,
                          ),
                    const SizedBox(width: 12),

                    // Detail stok
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${stock.noItem ?? ""} - ${stock.noItemWarna}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            stock.namaItem ?? "",
                            style: TextStyle(color: AppTheme.blackColor),
                          ),
                          Text(
                            stock.namaWarna ?? "",
                            style: TextStyle(color: AppTheme.greyColor),
                          ),
                          Text(
                            "${stock.jumlah.toString()} - ${stock.unit ?? ""}",
                            style: TextStyle(color: AppTheme.greyColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
