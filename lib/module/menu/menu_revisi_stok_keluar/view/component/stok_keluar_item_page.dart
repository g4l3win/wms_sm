import 'package:flutter/material.dart';

import '../../../../../core/util_manager/form_manager.dart';
import '../revisi_stock_keluar_container.dart';

extension StokKeluarItemPage on RevisiStockKeluarContainer {
  Widget editStokKeluar (){
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Detail permintaan keluar",
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
                  final item = controller.detailPermintaan[index];
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item["NamaItem"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text("Qty: ${item["jumlah_minta"]}"),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text("${item["NoItemWarna"]} ${item["NamaWarna"]}"),
                        const SizedBox(height: 12),
                        FormInputText(
                          title: "Jumlah stok keluar sesungguhnya",
                          textInputType: TextInputType.number,
                          txtReadonly: false,
                          txtLine: 1,
                          txtEnable: true,
                          borderColors: Colors.black,
                          txtcontroller:  controller.qtyRealControllers[index],
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