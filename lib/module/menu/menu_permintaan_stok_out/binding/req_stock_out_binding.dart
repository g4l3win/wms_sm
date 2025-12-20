import 'package:get/get.dart';

import '../controller/req_stock_out_controller.dart';

class ReqStockOutBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<ReqStockOutController>(() => ReqStockOutController(),
        fenix: true);
  }
}