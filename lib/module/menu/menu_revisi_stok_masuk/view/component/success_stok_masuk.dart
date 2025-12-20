import 'package:flutter/material.dart';

import '../../../../../core/util_manager/form_manager.dart';
import '../revisi_stock_masuk_container.dart';

extension SuccessStokMasuk on RevisiStockMasukContainer {

  Widget successStokMasukPage() {
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
            "Data stok masuk berhasil ditambahkan",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Judul section stok
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Stok Disimpan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          InfoRow(
            label: "No Stok Masuk",
            value: controller.stokMasuk.noStokMasuk ?? "-",
          ),
          InfoRow(
            label: "Tanggal",
            value: controller.stokMasuk.tanggal ?? "-",
          ),
          InfoRow(
            label: "Total barang",
            value: controller.stokMasuk.detailItems?.length.toString() ?? "-",
          ),
          const SizedBox(height: 12),

          // List stok
          controller.stokMasuk.detailItems != null
              ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.stokMasuk.detailItems?.length,
            itemBuilder: (context, index) {
              var item = controller.stokMasuk.detailItems![index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Detail stok
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoRow(
                            label: "Nama",
                            value: "${item.namaItem ?? "-"} ${item.namaWarna ??
                                "-"}",
                          ),
                          InfoRow(
                            label: "Nomor stok",
                            value: "${item.noItem ?? "-"} ${item.noItemWarna ??
                                "-"}",
                          ),
                          Text(
                            "${item.jumlahMasuk.toString()} ${item.unit ??
                                "-"}",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )
              : const Text("Eror tidak ada data"),
        ],
      ),
    );
  }
}