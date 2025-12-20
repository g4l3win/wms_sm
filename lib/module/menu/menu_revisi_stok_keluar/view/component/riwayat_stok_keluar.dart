import 'package:flutter/material.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_keluar/controller/data_stok_keluar_controller.dart';
import 'package:wms_sm/module/menu/menu_revisi_stok_keluar/controller/riwayat_stok_keluar_controller.dart';
import '../../../../../core/util_manager/button_manager.dart';
import '../../../../../core/util_manager/form_manager.dart';
import '../revisi_stock_keluar_container.dart';

extension RiwayatStokKeluar on RevisiStockKeluarContainer {
  Widget containerStokKeluar(int index) {
    String noStokKeluar = controller.lsNoStokKeluarGrouped[index];
    var qtyDetail = controller.lsDetailStokKeluar[noStokKeluar]?.length;
    var header = controller.showDetailKeluar(noStokKeluar: noStokKeluar);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRow(label: "NoStokKeluar", value: header?.noStokKeluar ?? "-"),
          InfoRow(label: "Tanggal", value: header?.tanggal ?? "-"),
          InfoRow(label: "Admin", value: header?.namaDepan ?? "-"),
          InfoRow(label: "Total Barang", value: qtyDetail.toString()),
          Divider(),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.lsDetailStokKeluar[noStokKeluar]?.length,
            itemBuilder: (context, index) {
              var item = controller.lsDetailStokKeluar[noStokKeluar]?[index];
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
                        "Qty: ${item?.jumlahKeluar ?? "0"} ${item?.unit ?? "-"}",
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
                  item?.isDeleted == 1
                      ? Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(4)),
                        color: Colors.red),
                    child: const Text(
                      "Sudah dihapus",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                          color: Colors.white),
                    ),
                  )
                      : const SizedBox.shrink(),
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

  Widget formRiwayatKeluar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          SearchBarWidget(
            controller: controller.searchBarHistory,
            hintText: "Cari Riwayat Stok Keluar",
            onChanged: (value){
              controller.searchResult.value = value;
              controller.onAssignStokKeluar(value);
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
          Text(
            "Riwayat Stok Keluar",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          controller.lsNoStokKeluarGrouped.isNotEmpty ?
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.lsNoStokKeluarGrouped.length,
            itemBuilder: (context, index) {
              return containerStokKeluar(index);
            },
          ) :
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child:
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Tidak ada riwayat stok keluar ',
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: "${controller.searchBarHistory.text}\n",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      TextSpan(
                        text: 'Silakan mencari riwayat stok keluar yang ingin dihapus dengan '
                            'mencari nomor Stok keluar atau melakukan scan kode QR berawal dengan SK ',
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