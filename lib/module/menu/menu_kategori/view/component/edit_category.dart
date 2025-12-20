import 'package:flutter/material.dart';
import '../../../../../core/util_manager/app_theme.dart';
import '../../../../../core/util_manager/form_manager.dart';
import '../kategori_stok_container.dart';

extension EditCategory on KategoriStokContainer {
  Widget editCategory(){
    return
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormInputText(
            title: "No Kategori",
            txtcontroller: controller.fieldEditNoKategori,
            borderColors: AppTheme.lightGrey,
            textInputType: TextInputType.text,
            txtEnable: false,
            txtLine: 1,
            txtReadonly: true,
            errorText: controller.errorEditNoKategori.value.isEmpty
                ? null
                : controller.errorEditNoKategori.value,
          ),
          FormInputText(
            title: "Nama Kategori",
            txtcontroller: controller.fieldEditNamaKategori,
            borderColors: AppTheme.lightGrey,
            textInputType: TextInputType.text,
            txtEnable: true,
            txtLine: 1,
            txtReadonly: false,
            isMandatory: true,
            errorText: controller.errorEditNamaKategori.value.isEmpty
                ? null
                : controller.errorEditNamaKategori.value,
          ),
        ],
            ),
      );
  }
}
