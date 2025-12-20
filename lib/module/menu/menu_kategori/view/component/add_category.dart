import 'package:flutter/material.dart';

import '../../../../../core/util_manager/form_manager.dart';
import '../kategori_stok_container.dart';

extension AddCategory on KategoriStokContainer {
  Widget addCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormInputText(
            title: "No Kategori",
            txtcontroller: controller.fieldAddNoKategori,
            borderColors: Colors.grey.shade300,
            textInputType: TextInputType.text,
            txtEnable: true,
            txtLine: 1,
            txtReadonly: false,
            isMandatory: true,
            errorText: controller.errorNoKategori.value.isEmpty
                ? null
                : controller.errorNoKategori.value,
          ),
          FormInputText(
            title: "Nama Kategori",
            txtcontroller: controller.fieldAddNamaKategori,
            borderColors: Colors.grey.shade300,
            textInputType: TextInputType.text,
            txtEnable: true,
            txtLine: 1,
            txtReadonly: false,
            isMandatory: true,
            errorText: controller.errorNamaKategori.value.isEmpty
                ? null
                : controller.errorNamaKategori.value,
          ),
        ],
      ),
    );
  }
}
