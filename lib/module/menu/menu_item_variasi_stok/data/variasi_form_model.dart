import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VariasiFormModel {
  TextEditingController noVariasiController = TextEditingController();
  TextEditingController warnaController = TextEditingController();
  TextEditingController jumlahController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController fieldAvgDaily = TextEditingController();
  TextEditingController fieldLeadTime = TextEditingController();
  TextEditingController fieldSafetyStock = TextEditingController();
  TextEditingController fieldROP = TextEditingController();
  Rx<File?> image = Rx<File?>(null);
}