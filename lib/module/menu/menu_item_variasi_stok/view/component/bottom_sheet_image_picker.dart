import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/util_manager/button_manager.dart';
import '../../data/variasi_form_model.dart';
import '../item_variasi_stok_container.dart';

extension BottomSheetImagePicker on ItemVariasiStokContainer {
  Widget bottomSheetImagePicker({VariasiFormModel? form}) {
    return Wrap(children: [
      Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih gambar melalui",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Button.button(
                        icon: Icons.camera,
                        iconColor: Colors.white,
                        label: "Kamera",
                        color: Colors.grey.shade700,
                        function: () {
                          controller.pickImage(ImageSource.camera, form: form);
                        })),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Button.button(
                        icon: Icons.browse_gallery,
                        iconColor: Colors.white,
                        label: "Galeri",
                        function: () {
                          controller.pickImage(ImageSource.gallery, form: form);
                        }))
              ],
            ),
            SizedBox(height: kMinInteractiveDimension,)
          ],
        ),
      ),
    ]);
  }
}
