import 'package:flutter/material.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_masuk/controller/data_stok_masuk_controller.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_masuk/controller/riwayat_stok_masuk_controller.dart';
import '../../../../../core/util_manager/button_manager.dart';
import '../../../../../core/util_manager/form_manager.dart';
import '../revisi_stock_masuk_container.dart';

extension RiwayatStokMasuk on RevisiStockMasukContainer {

  Widget containerStokMasuk(int index) {
    String noStokMasuk = controller.lsNoStokMasukGrouped[index];
    var qtyDetail = controller.lsDetailStokMasuk[noStokMasuk]?.length;
    var header = controller.showDetailMasuk(noStokMasuk: noStokMasuk);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRow(label: "NoStokMasuk", value: header?.noStokMasuk ?? "-"),
          InfoRow(label: "Tanggal", value: header?.tanggal ?? "-"),
          InfoRow(label: "Admin", value:  header?.namaDepan ?? "-"),
          InfoRow(label: "Total Barang", value: qtyDetail.toString()),
          const Divider(),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.lsDetailStokMasuk[noStokMasuk]?.length,
            itemBuilder: (context, index) {
              var item = controller.lsDetailStokMasuk[noStokMasuk]?[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item?.namaItem ?? "-",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        "Qty: ${item?.jumlahMasuk ?? "0"} ${item?.unit ?? "-"}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Variasi
                  Text(
                    item?.namaWarna ?? "",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  item?.isDeleted == 1 ?
                  Container(
                    padding:const EdgeInsets.all(2),
                    decoration: const BoxDecoration (
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        color: Colors.red
                    ),
                    child: const Text(
                      "Sudah dihapus",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8, color: Colors.white),
                    ),
                  ) : const SizedBox.shrink(),
                  const SizedBox(height: 8),
                  Divider(thickness: 1, color: Colors.grey.shade300),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget formRiwayatMasuk(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          SearchBarWidget(
            controller: controller.searchBarHistory,
            hintText: "Cari Riwayat Stok Masuk",
            onChanged: (value){
              controller.onAssignStokMasuk(value);
            },
          ),
          const SizedBox(height: 10),
          Button.button(
            label: "Pindai kode QR",
            color: Colors.black,
            icon: Icons.qr_code,
            fontColor: Colors.white,
            function: () {
              controller.onStartScanner();
            },
          ),
          const SizedBox(height: 8),
          const Text(
            "Riwayat Stok Masuk",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          controller.lsNoStokMasukGrouped.isNotEmpty ?
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.lsNoStokMasukGrouped.length,
            itemBuilder: (context, index) {
              return containerStokMasuk(index);
            },
          ) :
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child:
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Tidak ada riwayat stok masuk ',
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: "${controller.searchBarHistory.text}\n",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      TextSpan(
                        text: 'Silakan mencari riwayat stok masuk yang ingin dihapus dengan '
                            'mencari nomor stok masuk atau melakukan scan kode QR yang berawal dengan SM',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
