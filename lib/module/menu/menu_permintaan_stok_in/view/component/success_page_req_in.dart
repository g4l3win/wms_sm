import 'package:flutter/material.dart';
import '../../../../../core/util_manager/form_manager.dart';
import '../req_stock_in_container.dart';

extension SuccessPageReqIn on RequestStockInContainer {
  Widget successPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

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
            "Permintaan Stok Masuk Berhasil Dibuat",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 24),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Stok Disimpan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          InfoRow(label: "No Permintaan", value: controller.lastNoPermintaan),
          InfoRow(label: "Tanggal", value: controller.lastTanggal),
          InfoRow(
            label: "Total Barang",
            value: controller.totalBarang.toString(),
          ),

          const SizedBox(height: 12),

          controller.lastDetail.isNotEmpty
              ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.lastDetail.length,
                itemBuilder: (context, index) {
                  final item = controller.lastDetail[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoRow(
                          label: "Nama",
                          value: "${item.namaItem} ${item.namaWarna}",
                        ),
                        InfoRow(
                          label: "Nomor Stok",
                          value: "${item.noItem} - ${item.noItemWarna}",
                        ),
                        Text(
                          "${controller.lsQtyStockIn[index].text} ${item.unit}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                },
              )
              : const Text("Tidak ada data"),
        ],
      ),
    );
  }
}
