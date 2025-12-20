import 'package:flutter/material.dart';
import '../../../../../core/util_manager/app_theme.dart';
import '../../../../../core/util_manager/form_manager.dart';
import '../revisi_stock_masuk_container.dart';

extension StokMasukItemPage on RevisiStockMasukContainer{
  Widget editStokMasuk (){
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Detail permintaan Masuk",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 500,
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.detailPermintaan.length,
              itemBuilder: (context, index) {

                var item = controller.detailPermintaan[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:  EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.lightGrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item["NamaItem"], // tampil NamaItem
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text("Qty: ${item["jumlah_minta"]}"), //tampilkan jumlah_minta
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text("${item["NoItemWarna"]} ${item["NamaWarna"]}"), //tampil noItemWarna dan NamaWarna
                      const SizedBox(height: 12),
                      FormInputText(
                        title: "Jumlah stok Masuk sesungguhnya",
                        textInputType: TextInputType.number,
                        txtReadonly: false,
                        txtLine: 1,
                        txtEnable: true,
                        borderColors: AppTheme.blackColor,
                        txtcontroller: controller.qtyRealControllers[index], //ini nanti dimasukkin jumlah sesungguhnya cuma harusnya beda tiap index listview biar bisa diinsert
                        isMandatory: true,
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

}