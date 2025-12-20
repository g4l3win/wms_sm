import 'package:get/get.dart';

import '../controller/revisi_stock_masuk_controller.dart';

class RevisiStockMasukBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<RevisiStockMasukController>(
      () => RevisiStockMasukController(),
      fenix: true,
    );
  }
}
