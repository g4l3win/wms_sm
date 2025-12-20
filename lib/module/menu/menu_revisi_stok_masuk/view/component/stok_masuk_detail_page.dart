import 'package:flutter/material.dart';

import '../../../../../core/util_manager/button_manager.dart';
import '../../../../../core/util_manager/form_manager.dart';
import '../revisi_stock_masuk_container.dart';

extension StokMasukDetailPage on RevisiStockMasukContainer {
  Widget detailPermintaanMasuk(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detail permintaan Masuk",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          InfoRow(label: "No Minta Masuk", value: controller.noPermintaan.value), //masukkin no_permintaan_masuk
          InfoRow(label: "Tgl Minta", value: controller.tglPermintaan.value), //masukkin tgl_permintaan_masuk
          InfoRow(label: "Total Barang", value: controller.totalBarang.value.toString(),), //total variasi warna yang distinct
          Divider(),
          const SizedBox(height: 16),
          const Text("Masukkan Data Stok Masuk",
            style: TextStyle(fontWeight: FontWeight.bold),),
          const SizedBox(height: 6),
          FormInputText(
            title: "No Stok Masuk",
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
                  title: "Tanggal Stok Masuk",
                  textInputType: TextInputType.text,
                  txtReadonly: true,
                  txtLine: 1,
                  txtEnable: true,
                  borderColors: Colors.black,
                  txtcontroller: controller.fieldTanggal,
                  isMandatory: true,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  const SizedBox(height: 20),
                  Button.button(
                    label: "Pilih Tanggal",
                    color: Colors.black,
                    fontColor: Colors.white,
                    function: () {
                      controller.onDatePick(context: context);
                    },
                  ),
                ],
              ),
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
      ),
    );
  }
}