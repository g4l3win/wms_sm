import 'package:get/get.dart';
import '../controller/req_stock_in_controller.dart';

class ReqStockInBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<ReqStockInController>(() => ReqStockInController(),
        fenix: true);
  }
}