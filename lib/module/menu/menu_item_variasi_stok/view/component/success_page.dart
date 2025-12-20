import 'dart:io';
import 'package:flutter/material.dart';

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
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.black,
            child: Icon(Icons.check, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 16),
          const Text(
            "Sukses!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Anda dapat melakukan print label stok",
            style: TextStyle(color: Colors.grey),
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
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Gambar placeholder
                    stock.gambarPath == null
                        ? Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image, color: Colors.grey),
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
                            style: const TextStyle(color: Colors.black),
                          ),
                          Text(
                            stock.namaWarna ?? "",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            "${stock.jumlah.toString()} - ${stock.unit ?? ""}",
                            style: const TextStyle(color: Colors.grey),
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
