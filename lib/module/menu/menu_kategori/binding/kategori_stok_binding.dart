import 'package:get/get.dart';

import '../controller/kategori_stok_controller.dart';

class KategoriStokBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<KategoriStokController>(() => KategoriStokController());
  }
}
