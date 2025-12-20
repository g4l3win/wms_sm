import 'package:get/get.dart';

import '../controller/item_variasi_stok_controller.dart';

class ItemVariasiStokBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ItemVariasiStokController>(() => ItemVariasiStokController(),fenix: true);
  }
}
