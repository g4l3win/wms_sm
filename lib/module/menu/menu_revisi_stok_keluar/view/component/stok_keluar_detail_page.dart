import 'package:flutter/material.dart';

import '../../../../../core/util_manager/app_theme.dart';
import '../../../../../core/util_manager/button_manager.dart';
import '../../../../../core/util_manager/form_manager.dart';
import '../revisi_stock_keluar_container.dart';

extension StokKeluarDetailPage on RevisiStockKeluarContainer {
  Widget detailPerminttanKeluar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detail permintaan keluar",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          InfoRow(label: "No Minta keluar", value: controller.noPermintaan.value),
          InfoRow(label: "Tgl Minta", value: controller.tglPermintaan.value),
          InfoRow(label: "Total Barang", value: controller.totalBarang.value.toString()),
          Divider(),
          const SizedBox(height: 16),
          const Text("Masukkan Data Stok Keluar",
            style: TextStyle(fontWeight: FontWeight.bold),),
          const SizedBox(height: 6),
          FormInputText(
            title: "No Stok Keluar",
            textInputType: TextInputType.text,
            txtReadonly: false,
            txtLine: 1,
            txtEnable: true,
            borderColors: AppTheme.blackColor,
            txtcontroller: controller.fieldNoStokKeluar,
            isMandatory: true,
          ),
          Row(
            children: [
              Expanded(
                child: FormInputText(
                  title: "Tanggal Stok Keluar",
                  textInputType: TextInputType.text,
                  txtReadonly: true,
                  txtLine: 1,
                  txtEnable: true,
                  borderColors: AppTheme.blackColor,
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
                    color: AppTheme.blackColor,
                    fontColor: AppTheme.whiteColor,
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
            borderColors: AppTheme.blackColor,
            txtcontroller: controller.fieldKeterangan,
            isMandatory: true,
          ),
        ],
      ),
    );
  }
}
