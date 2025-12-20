import 'package:flutter/material.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/controller/item_variasi_edit_controller.dart';
import '../../../../../core/util_manager/app_theme.dart';
import '../../../../../core/util_manager/form_manager.dart';
import '../item_variasi_stok_container.dart';

extension EditROPForm on ItemVariasiStokContainer {
    Widget editROPForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormInputText(
            title: "Rata-rata permintaan per hari",
            txtcontroller: controller.fieldEditAvgDailyDemand,
            borderColors: AppTheme.lightGrey,
            textInputType: TextInputType.text,
            txtEnable: true,
            txtLine: 1,
            txtReadonly: false,
            isMandatory: true,
            function: (value){
              controller.hitungEditROP();
            },
          ),
          FormInputText(
            title: "Lead Time (hari)",
            txtcontroller: controller.fieldEditLeadTime,
            borderColors: AppTheme.lightGrey,
            textInputType: TextInputType.number,
            txtEnable: true,
            txtLine: 1,
            txtReadonly: false,
            isMandatory: true,
            function: (value){
              controller.hitungEditROP();
            },
          ),
          FormInputText(
            title: "Safety stock",
            txtcontroller: controller.fieldEditSS,
            borderColors: AppTheme.lightGrey,
            textInputType: TextInputType.number,
            txtEnable: true,
            txtLine: 1,
            txtReadonly: false,
            isMandatory: true,
            function: (value){
              controller.hitungEditROP();
            },
          ),
          FormInputText(
            title: "ROP",
            txtcontroller: controller.fieldEditROP,
            borderColors: AppTheme.lightGrey,
            textInputType: TextInputType.number,
            txtEnable: false,
            txtLine: 1,
            txtReadonly: true,
            isMandatory: true,
          ),
          Text(
            "Bagian ini akan menampilkan hasil perhitungan ROP secara otomatis",
            style: TextStyle(fontSize: 8, color: AppTheme.greyColor),
          ),
          Text(
            "Rumus ROP",
            style: TextStyle(
              color: AppTheme.blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 50,
                  child: Image.asset("assets/wms_splash.jpg"),
                ),
              ),
              Expanded(
                flex: 2,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: AppTheme.blackColor, fontSize: 14),
                    children: [
                      TextSpan(
                        text:
                            "ROP = (Average Daily Demand x Lead Time) + Safety Stock\n",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text:
                            "Average Daily Demand = jumlah rata-rata barang laku terjual dalam sehari\n",
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.greyColor,
                        ),
                      ),
                      TextSpan(
                        text:
                            "Lead Time = Waktu yang diperlukan untuk mengisi kembali stok\n",
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.greyColor,
                        ),
                      ),
                      TextSpan(
                        text:
                            "Safety Stock = Stok minimal yang harus tersedia di dalam gudang",
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
