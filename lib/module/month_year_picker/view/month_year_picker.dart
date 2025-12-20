import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/util_manager/button_manager.dart';
import '../controller/month_year_picker_controller.dart';

class CustomMonthYearPicker extends StatelessWidget {
  final MonthYearPickerController controller = Get.put(
    MonthYearPickerController(),
  );

  CustomMonthYearPicker({super.key});

  @override
  Widget build(BuildContext context) {
    Widget dropdownDate(
      int value,
      List<DropdownMenuItem<int>>? items,
      ValueChanged<int?> function,
    ) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: value,
              items: items,
              onChanged: function,
            ),
          ),
        ),
      );
    }

    return AlertDialog(
      icon: const Icon(Icons.calendar_month),
      iconColor: Colors.black,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      title: const Text(
        'Pilih bulan dan tahun',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: Obx(
        () => Row(
          children: [
            dropdownDate(
              controller.selectedMonth.value,
              List.generate(
                controller.listMonth.length,
                (index) => DropdownMenuItem<int>(
                  value: index + 1,
                  child: FittedBox(child: Text(controller.listMonth[index])),
                ),
              ),
              (value) {
                if (value != null) {
                  controller.setMonth(value);
                }
              },
            ),
            const SizedBox(width: 10),
            dropdownDate(
              controller.selectedYear.value,
              controller.listYear
                  .map(
                    (year) => DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    ),
                  )
                  .toList(),
              (value) {
                if (value != null) {
                  controller.setYear(value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Button.button(label: "Batal", function: () => Get.back()),
            const SizedBox(width: 4),
            Button.button(
              label: "OK",
              function: () {
                final pickedMonth = controller.selectedMonth.value;
                final pickedYear = controller.selectedYear.value;

                // kirim balik atau langsung dipakai
                Get.back(result: DateTime(pickedYear, pickedMonth));
              },
            ),
          ],
        ),
      ],
    );
  }
}
