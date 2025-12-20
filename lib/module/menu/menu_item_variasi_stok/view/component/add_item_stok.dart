import 'package:flutter/material.dart';

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
            borderColors: Colors.grey.shade300,
            textInputType: TextInputType.text,
            txtEnable: true,
            txtLine: 1,
            txtReadonly: false,
            isMandatory: true,
          ),
          FormInputText(
            title: "Nama Barang",
            txtcontroller: controller.fieldNamaItem,
            borderColors: Colors.grey.shade300,
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
              style: const TextStyle(color: Colors.black, fontSize: 14),
              children:   [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
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
                style: const TextStyle(color: Colors.black, fontSize: 14),
                children:   [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
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
