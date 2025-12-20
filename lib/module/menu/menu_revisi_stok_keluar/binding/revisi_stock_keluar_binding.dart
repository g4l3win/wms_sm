import 'package:get/get.dart';

import '../controller/revisi_stock_keluar_controller.dart';

class RevisiStockKeluarBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<RevisiStockKeluarController>(
      () => RevisiStockKeluarController(),
      fenix: true,
    );
  }
}
