import 'package:flutter/material.dart';

import '../../../../../core/util_manager/app_theme.dart';
import '../../../../../core/util_manager/form_manager.dart';
import '../../data/m_permintaan_masuk.dart';
import '../laporan_req_container.dart';

extension RequestMasukContainer on LaporanReqContainer{
  Widget detailRow(String title, String qty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Text(
            qty,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget stokMasukContent(PermintaanMasukDummy data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.lightGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRow(label: "No Permintaan", value: data.noPermintaan),
          InfoRow(label: "Tanggal", value: data.tanggal),
          InfoRow(
            label: "Status",
            value: data.statusMasuk ? "Sudah Masuk" : "Belum Masuk",
          ),
          InfoRow(label: "Keterangan", value: data.keterangan),

          const Divider(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.detail.length,
            itemBuilder: (context, index) {
              final d = data.detail[index];
              return detailRow(
                "${d.namaItem} (${d.namaWarna})",
                "${d.jumlah} ${d.unit}",
              );
            },
          ),
        ],
      ),
    );
  }


  Widget reqMasukContainer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Laporan Permintaan Stok Masuk",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.44,
          child: controller.dummyPermintaanMasuk.isNotEmpty
              ? ListView.builder(
            itemCount: controller.dummyPermintaanMasuk.length,
            itemBuilder: (context, index) {
              return stokMasukContent(
                controller.dummyPermintaanMasuk[index],
              );
            },
          )
              : const Center(
            child: Text(
              "Tidak ada data permintaan stok masuk",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

}
