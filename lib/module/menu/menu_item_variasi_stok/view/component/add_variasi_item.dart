import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/controller/add_variasi_only_controller.dart';
import 'package:wms_sm/module/menu/menu_item_variasi_stok/view/component/bottom_sheet_image_picker.dart';
import '../../../../../core/util_manager/dialog_manager.dart';
import '../../../../../core/util_manager/form_manager.dart';
import '../item_variasi_stok_container.dart';

extension AddVariasiItem on ItemVariasiStokContainer {
  Widget containerVariasi(int index) {
    var form = controller.variasiForms[index];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Variasi ${index + 1}"),
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
                  enableDrag: false, bottomSheetImagePicker(form: form));
            },
            child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: Obx(
                  () => form.image.value == null
                      ? const Icon(Icons.image, size: 40, color: Colors.grey)
                      : 
                   ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:Image.file(
                          form.image.value!,
                          fit: BoxFit.cover,
                          cacheWidth: 200,
                          cacheHeight: 200,
                        ),
                     ),
                )),
          ),
          Row(
            children: [
              Expanded(
                child: FormInputTextMin(
                  txtEnable: true,
                  txtLine: 1,
                  txtReadonly: false,
                  title: "No Variasi Warna",
                  txtcontroller: form.noVariasiController,
                  borderColors: Colors.grey.shade300,
                  textInputType: TextInputType.text,
                  isMandatory: true,
                ),
              ),
              Expanded(
                child: FormInputTextMin(
                  txtEnable: true,
                  txtLine: 1,
                  txtReadonly: false,
                  title: "Variasi Warna",
                  txtcontroller: form.warnaController,
                  borderColors: Colors.grey.shade300,
                  textInputType: TextInputType.text,
                  isMandatory: true,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: FormInputTextMin(
                  txtEnable: true,
                  txtLine: 1,
                  txtReadonly: false,
                  title: "Jumlah Stok",
                  txtcontroller: form.jumlahController,
                  borderColors: Colors.grey.shade300,
                  textInputType: TextInputType.number,
                  isMandatory: true,
                ),
              ),
              Expanded(
                child: FormInputTextMin(
                  txtEnable: true,
                  txtLine: 1,
                  txtReadonly: false,
                  title: "Harga",
                  txtcontroller: form.hargaController,
                  borderColors: Colors.grey.shade300,
                  textInputType: TextInputType.number,
                  isMandatory: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: FormInputTextMin(
                  txtEnable: true,
                  txtLine: 1,
                  txtReadonly: false,
                  title: "Rata-rata permintaan",
                  txtcontroller: form.fieldAvgDaily,
                  borderColors: Colors.grey.shade300,
                  textInputType: TextInputType.number,
                  isMandatory: true,
                  function: (value) {
                    controller.hitungROP(form);
                  },
                ),
              ),
              Expanded(
                child: FormInputTextMin(
                  txtEnable: true,
                  txtLine: 1,
                  txtReadonly: false,
                  title: "Lead Time (hari)",
                  txtcontroller: form.fieldLeadTime,
                  borderColors: Colors.grey.shade300,
                  textInputType: TextInputType.number,
                  isMandatory: true,
                  function: (value) {
                    controller.hitungROP(form);
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: FormInputTextMin(
                  txtEnable: true,
                  txtLine: 1,
                  txtReadonly: false,
                  title: "Safety stock",
                  txtcontroller: form.fieldSafetyStock,
                  borderColors: Colors.grey.shade300,
                  textInputType: TextInputType.number,
                  isMandatory: true,
                  function: (value) {
                    controller.hitungROP(form);
                  },
                ),
              ),
              Expanded(
                child: FormInputTextMin(
                  txtEnable: false,
                  txtLine: 1,
                  txtReadonly: true,
                  title: "ROP",
                  txtcontroller: form.fieldROP,
                  borderColors: Colors.grey.shade300,
                  textInputType: TextInputType.number,
                  isMandatory: true,
                ),
              ),
            ],
          ),
          const Divider()
        ],
      ),
    );
  }

  Widget incrementButton({
    required IconData icon,
    required VoidCallback onPressed,
    EdgeInsetsGeometry? padding,
  }) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: MaterialButton(
        minWidth: 1,
        onPressed: onPressed,
        splashColor: Colors.grey.shade300,
        child: Icon(
          icon,
          size: 16,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget formVariasiWarna() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              border: Border.all(color: Colors.grey.shade300)),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    "Variasi Warna \n"
                    "${controller.noItem} ${controller.namaItem}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey.shade300,
                  endIndent: 2,
                  indent: 2,
                ),
                Expanded(
                  flex: 1,
                  child: FormInputTextMin(
                    title: "Qty",
                    txtcontroller: controller.fieldTotalVariasi,
                    borderColors: Colors.grey.shade300,
                    textInputType: TextInputType.number,
                    txtEnable: false,
                    txtLine: 1,
                    txtReadonly: true,
                    function: (value) => controller.addWidgetVarWarna(),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      incrementButton(
                        icon: Icons.arrow_drop_up,
                        padding: const EdgeInsets.only(top: 10),
                        onPressed: () => controller.updateIncrement(true),
                      ),
                      incrementButton(
                        icon: Icons.arrow_drop_down,
                        onPressed: () => controller.updateIncrement(false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            DialogManager().dialogROP();
          },
          child: Container(
            width: Get.size.width,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                border: Border.all(color: Colors.grey.shade300)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Ketuk untuk lihat detail rumus ROP",
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.orange,
                    height: 1.4,
                  ),)

            ),
          ),
        ),
        controller.variasiForms.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.variasiForms.length,
                itemBuilder: (context, index) {
                  return containerVariasi(index);
                })
            : const Center(
                child: Text(
                  "Masukkan jumlah variasi yang ingin ditambahkan",
                  textAlign: TextAlign.center,
                ),
              )
      ],
    );
  }
}
