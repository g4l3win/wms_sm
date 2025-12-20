import 'package:get/get.dart';

import '../controller/laporan_controller.dart';


class LaporanBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<LaporanController>(() => LaporanController());
  }
}
