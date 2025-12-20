import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_theme.dart';
import 'button_manager.dart';

class FormInputText extends StatelessWidget {
  final String title;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormat;
  final int txtLine;
  final bool txtEnable;
  final bool txtReadonly;
  final Color borderColors;
  final Color? hintColor;
  final Color? enableBorderColor;
  final TextEditingController txtcontroller;
  final TextInputAction? textInputAction;
  final bool? obscureText;
  final ValueChanged<String?>? function;
  final String? errorText;
  final bool isMandatory;

  const FormInputText({
    super.key,
    required this.title,
    required this.txtcontroller,
    required this.textInputType,
    required this.txtLine,
    required this.txtEnable,
    required this.txtReadonly,
    this.textInputAction,
    this.inputFormat,
    required this.borderColors,
    this.hintColor,
    this.enableBorderColor,
    this.obscureText,
    this.function,
    this.errorText,
    this.isMandatory = false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Align(
              alignment: Alignment.topLeft,
              child:RichText(
                text: TextSpan(
                  text: title,
                  style: TextStyle(color: AppTheme.blackColor, fontSize: 14),
                  children: isMandatory
                      ?  [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppTheme.redColor),
                    ),
                  ]
                      : [],
                ),
              ),
            ),
          ),
          TextFormField(
            obscureText: obscureText ?? false,
            keyboardType: textInputType,
            controller: txtcontroller,
            maxLines: txtLine,
            enabled: txtEnable,
            readOnly: txtReadonly,
            inputFormatters: inputFormat ?? [],
            textInputAction: TextInputAction.done,
            onChanged: function,
            decoration: InputDecoration(
              hintText: title,
              hintStyle: TextStyle(color: hintColor ?? AppTheme.greyColor400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: txtLine > 1 ? 12 : 0,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColors, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1,
                    color: enableBorderColor ??
                AppTheme.lightGrey),
                borderRadius: BorderRadius.circular(8),
              ),
              errorText: errorText,
              errorStyle: const TextStyle(color: Colors.redAccent)
            ),
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class FormInputTextMin extends StatelessWidget {
  final String title;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormat;
  final int txtLine;
  final bool txtEnable;
  final bool txtReadonly;
  final Color borderColors;
  final TextEditingController txtcontroller;
  final ValueChanged<String?>? function;
  final bool isMandatory;

  const FormInputTextMin({
    super.key,
    required this.title,
    required this.txtcontroller,
    required this.textInputType,
    required this.txtLine,
    required this.txtEnable,
    required this.txtReadonly,
    this.inputFormat,
    required this.borderColors,
    this.function,
    this.isMandatory = false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Align(
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                  text: title,
                  style: TextStyle(color: AppTheme.blackColor, fontSize: 14),
                  children: isMandatory
                      ?  [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppTheme.redColor),
                    ),
                  ]
                      : [],
                ),
              ),

            ),
          ),
          TextFormField(
            keyboardType: textInputType,
            controller: txtcontroller,
            maxLines: txtLine,
            enabled: txtEnable,
            readOnly: txtReadonly,
            inputFormatters: inputFormat ?? [],
            onChanged: function,
            decoration: InputDecoration(
              hintText: title,
              hintStyle: TextStyle(color: AppTheme.greyColor400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColors, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: AppTheme.lightGrey),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class DropdownWidget extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> listDropdown;
  final ValueChanged<String?> function;
  final bool isMandatory;

  const DropdownWidget({
    super.key,
    required this.label,
    required this.value,
    required this.listDropdown,
    required this.function,
    this.isMandatory = false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(color: AppTheme.blackColor, fontSize: 14),
            children: isMandatory
                ?  [
              TextSpan(
                text: ' *',
                style: TextStyle(color: AppTheme.redColor),
              ),
            ]
                : [],
          ),
        ),

        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.greyColor400),
            borderRadius: BorderRadius.circular(8),
            color: AppTheme.whiteColor,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Pilih lokasi stok", style: TextStyle(fontSize: 23),),
              value: value,
              items:
                  listDropdown.map((loc) {
                    return DropdownMenuItem(
                      value: loc,
                      child: Text(
                        loc,
                        style: TextStyle(color: AppTheme.blackColor, fontSize: 12),
                      ),
                    );
                  }).toList(),
              onChanged: function,
            ),
          ),
        ),
      ],
    );
  }
}

class ScrollSelector extends StatelessWidget {
  final List<String> list;
  final ValueChanged<String?> function;
  final String selected;

  const ScrollSelector({super.key,
    required this.list,
    required this.function,
    required this.selected
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
        list.map((category) {
          final isSelected = selected == category;
          return GestureDetector(
            onTap: () => function(category),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.blackColor : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.blackColor : AppTheme.greyColor,
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? AppTheme.whiteColor : AppTheme.blackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = "Cari stok",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: AppTheme.lightGrey),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          hintText: hintText,
          icon: const Icon(Icons.search_rounded),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final double? sizeLabel;
  final double? sizeValue;

  const InfoRow({super.key, required this.label, required this.value, this.sizeLabel, this.sizeValue});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style:  TextStyle(fontWeight: FontWeight.bold, fontSize: sizeLabel ?? 12),
          ),
        ),
        Text(" : "),
        Expanded(
          flex: 2,
          child: Text(value, style: TextStyle(fontSize: sizeValue ?? 12),),
        ),
      ],
    );
  }
}


class SelectDate extends StatelessWidget {
  final TextEditingController textController;
  final Future<void> Function() onPickDate;
  SelectDate({super.key, required this.textController, required this.onPickDate});

  @override
  Widget build(BuildContext context) {
    return
    Row(
      children: [
        Expanded(
          child: FormInputText(
            title: "Tanggal",
            textInputType: TextInputType.text,
            txtReadonly: true,
            txtLine: 1,
            txtEnable: false,
            borderColors: AppTheme.blackColor,
            txtcontroller: textController,
            isMandatory: true,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          children: [
            const SizedBox(height: 20),
            Button.button(
              label: "Pilih Tanggal",
              color: AppTheme.blackColor,
              fontColor: AppTheme.whiteColor,
              function: onPickDate
            ),
          ],
        ),
      ],
    );
  }
}
