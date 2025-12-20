import 'package:flutter/material.dart';
import 'package:wms_sm/module/menu/menu_laporan/view/component/stok_keluar_container.dart';

import '../../../../../core/util_manager/form_manager.dart';
import '../laporan_container.dart';

extension StokMasukContainer on LaporanContainer {

  Widget stokMasukContent(int index) {
    String noStokMasuk = controller.lsNoStokMasukGrouped[index];
    var qtyDetail = controller.lsDetailStokMasuk[noStokMasuk]?.length;
    var header = controller.showDetailMasuk(noStokMasuk: noStokMasuk);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Column(
              children: [
                InfoRow(label: "No Stok Masuk", value: noStokMasuk),
                InfoRow(label: "Jumlah Masuk", value: qtyDetail.toString()),
                InfoRow(label: "Tanggal", value: header?.tanggal ?? "-"),
                InfoRow(label: "Admin", value: header?.namaDepan ?? "-"),
                InfoRow(label: "Keterangan", value: header?.keterangan ?? "-"),
              ],
            ),
          const Divider(),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.lsDetailStokMasuk[noStokMasuk]?.length,
              itemBuilder: (context, i) {
               var dataMasuk =
                controller.lsDetailStokMasuk[noStokMasuk]?[i];
                return detailRow(
                    "${dataMasuk?.namaItem ?? "-"} ${dataMasuk?.namaWarna ?? "-"}",
                    "${dataMasuk?.jumlahMasuk ?? "-"} ${dataMasuk?.unit ?? '-'}",
                    dataMasuk: dataMasuk);
              }
          ),
        ],
      ),
    );
  }

  Widget totalStokMasuk(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Jumlah Stok Masuk",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            controller.lsNoStokMasukGrouped.length.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget stokMasukContainer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       const Text(
           "Laporan Stok Masuk",
           style: TextStyle(fontWeight: FontWeight.bold),
         ),

        const SizedBox(height: 4),
        controller.lsNoStokMasukGrouped.isNotEmpty ?
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.44,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.lsNoStokMasukGrouped.length,
            itemBuilder: (context, index) {
              return stokMasukContent(index);
            },
          ),
        ) :
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.44,
          width: double.infinity,
          child: const Center(
            child: Text(
              "Tidak ada data stok masuk pada bulan ini, "
                  "coba cari lagi pada bulan lain",
              style: TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
       const SizedBox(height: 8),
        totalStokMasuk(context),
      ],
    );
  }
}
