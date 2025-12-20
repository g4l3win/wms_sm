import 'package:get/get.dart';
import '../controller/laporan_req_controller.dart';

class LaporanReqBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<LaporanReqController>(() => LaporanReqController());
  }
}