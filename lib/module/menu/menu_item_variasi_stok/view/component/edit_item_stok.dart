import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/view/component/bottom_sheet_image_picker.dart';
import '../../../../../core/util_manager/form_manager.dart';
import '../item_variasi_stok_container.dart';

extension EditItemStok on ItemVariasiStokContainer {
 Widget editItemStok() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
                text: "Upload Gambar",
                style: const TextStyle(color: Colors.black, fontWeight:FontWeight.bold, ),
                children:   [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ]

            ),
          ),
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                enableDrag: false,
                bottomSheetImagePicker(),
              );
            },
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: controller.image.value == null ||
                  controller.image.value!.path.isEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/wms_splash.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  controller.image.value!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  cacheHeight: 200,
                  cacheWidth: 200,
                ),
              ),
            ),
          ),
          FormInputText(
            title: "Nomor Stok",
            txtcontroller: controller.fieldEditNoItem,
            borderColors: Colors.grey.shade300,
            textInputType: TextInputType.text,
            txtEnable: false,
            txtLine: 1,
            txtReadonly: true,
          ),
          FormInputText(
            title: "Nama Barang",
            txtcontroller: controller.fieldEditNamaItem,
            borderColors: Colors.grey.shade300,
            textInputType: TextInputType.text,
            txtEnable: true,
            txtLine: 1,
            txtReadonly: false,
            isMandatory: true,
          ),
          FormInputText(
            title: "Jumlah Stok",
            txtcontroller: controller.fieldEditJumlahStok,
            borderColors: Colors.grey.shade300,
            textInputType: TextInputType.number,
            txtEnable: true,
            txtLine: 1,
            txtReadonly: false,
          ),
          RichText(
            text: TextSpan(
                text: "Kategori",
                style: const TextStyle(color: Colors.black),
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
          FormInputText(
            title: "No Variasi Warna",
            txtcontroller: controller.fieldEditNoItemWarna,
            borderColors: Colors.grey.shade300,
            textInputType: TextInputType.number,
            txtEnable: false,
            txtLine: 1,
            txtReadonly: true,
          ),
           const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: FormInputTextMin(
                  title: "Variasi warna",
                  txtcontroller: controller.fieldEditVariasiWarna,
                  borderColors: Colors.grey.shade300,
                  textInputType: TextInputType.text,
                  txtEnable: true,
                  txtLine: 1,
                  txtReadonly: false,
                  isMandatory: true,
                ),
              ),
              SizedBox(width: 4,),
              Expanded(
                child: FormInputTextMin(
                  title: "Harga",
                  txtcontroller: controller.fieldEditHarga,
                  borderColors: Colors.grey.shade300,
                  textInputType: TextInputType.number,
                  txtEnable: true,
                  txtLine: 1,
                  txtReadonly: false,
                  isMandatory: true,
                ),
              ),
            ],
          ),
          DropdownWidget(
            label: "Lokasi",
            value: controller.selectedLocation.value,
            listDropdown: controller.locations,
            isMandatory: true,
            function: (value) {
              if (value != null) {
                controller.setLocation(value);
              }
            },
          ),
          RichText(
            text: TextSpan(
                text: "Unit",
                style: const TextStyle(color: Colors.black),
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
