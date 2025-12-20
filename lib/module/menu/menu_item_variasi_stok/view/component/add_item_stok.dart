import 'package:flutter/material.dart';

import '../../../../../core/util_manager/app_theme.dart';
import '../../../../../core/util_manager/form_manager.dart';
import '../item_variasi_stok_container.dart';

extension AddItemStok on ItemVariasiStokContainer {

  Widget addItemStok() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormInputText(
            title: "Nomor Stok",
            txtcontroller: controller.fieldNoItem,
            borderColors: AppTheme.lightGrey,
            textInputType: TextInputType.text,
            txtEnable: true,
            txtLine: 1,
            txtReadonly: false,
            isMandatory: true,
          ),
          FormInputText(
            title: "Nama Barang",
            txtcontroller: controller.fieldNamaItem,
            borderColors: AppTheme.lightGrey,
            textInputType: TextInputType.text,
            txtEnable: true,
            txtLine: 1,
            txtReadonly: false,
            isMandatory: true,
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              text: "Kategori",
              style: TextStyle(color: AppTheme.blackColor, fontSize: 14),
              children:   [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppTheme.redColor),
                ),
              ]

            ),
          ),
          ScrollSelector(
              list: controller.categories,
              function: (val) => controller.selectCategory(val!),
              selected: controller.selectedCategory.value),
          const SizedBox(height: 4),
          DropdownWidget(
            label: "Lokasi",
            value: controller.selectedLocation.value,
            listDropdown: controller.locations,
            function: (value) {
              if (value != null) {
                controller.setLocation(value);
              }
            },
            isMandatory: true,
          ),
          RichText(
            text: TextSpan(
                text: "Unit",
                style: TextStyle(color: AppTheme.blackColor, fontSize: 14),
                children:   [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppTheme.redColor),
                  ),
                ]

            ),
          ),
          ScrollSelector(
              list: controller.unitOption,
              function: (val) => controller.setUnit(val!),
              selected: controller.selectedUnit.value)
        ],
      ),
    );
  }
}
