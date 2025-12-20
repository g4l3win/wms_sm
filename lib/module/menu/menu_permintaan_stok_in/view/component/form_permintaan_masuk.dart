import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/util_manager/button_manager.dart';
import '../../../../../core/util_manager/form_manager.dart';
import '../req_stock_in_container.dart';

extension FormPermintaanMasuk on RequestStockInContainer{
  Widget incomingStockIn({
    required int indexItem,
    required TextEditingController textController,
  }) {
    var unit = controller.lsStockFound[indexItem].unit;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: SizedBox(
        child: Row(
          children: [
            Expanded(
              child: FormInputText(
                title: "Jumlah Stok Masuk ($unit)",
                textInputType: TextInputType.number,
                txtReadonly: false,
                txtLine: 1,
                txtEnable: true,
                borderColors: Colors.black,
                hintColor: Colors.black,
                enableBorderColor: Colors.black,
                txtcontroller: textController,
                isMandatory: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget containerDetailStock(BuildContext context) {
    return controller.lsQtyStockIn.isNotEmpty
        ? ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: controller.lsQtyStockIn.length,
      itemBuilder: (context, index) {
        var item = controller.lsStockFound[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${item.namaItem} ${item.namaWarna}"),
                        Text("${item.noItem} - ${item.noItemWarna}"),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.onDeleteScannedStok(index);
                    },
                    child: const Icon(
                      Icons.delete,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            incomingStockIn(
              indexItem: index,
              textController: controller.lsQtyStockIn[index],
            ),
            const Divider(),
          ],
        );
      },
    )
        : const Text("Tidak ada data");
  }

  Widget formBawah(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Detail Permintaan Masuk",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(height: 160, child: containerDetailStock(context)),
            ],
          ),
        ),
        FormInputText(
          title: "No Permintaan Masuk",
          textInputType: TextInputType.text,
          txtReadonly: false,
          txtLine: 1,
          txtEnable: true,
          borderColors: Colors.black,
          txtcontroller: controller.fieldNoStokMasuk,
          isMandatory: true,
        ),
        Row(
          children: [
            Expanded(
              child: FormInputText(
                title: "Tanggal hari ini",
                textInputType: TextInputType.text,
                txtReadonly: true,
                txtLine: 1,
                txtEnable: false,
                borderColors: Colors.black,
                txtcontroller: controller.fieldTanggal,
                isMandatory: true,
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        FormInputText(
          title: "Keterangan",
          textInputType: TextInputType.text,
          txtReadonly: false,
          txtLine: 1,
          txtEnable: true,
          borderColors: Colors.black,
          txtcontroller: controller.fieldKeterangan,
          isMandatory: true,
        ),
      ],
    );
  }

  Widget formPermintaanStokMasuk(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBarWidget(
            controller: controller.searchBar,
            hintText: "Cari Stok",
            onChanged: (value) {
              controller.onCheckQRData(value);
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
          controller.isScanned.isTrue
              ? formBawah(context)
              : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "Tambahkan stok yang masuk dengan mencari nomor variasi stok atau melakukan scan kode QR",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}