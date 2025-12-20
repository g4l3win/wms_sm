import 'package:get/get.dart';
import '../controller/menu_template_controller.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<LocationController>(() => LocationController(),
        fenix: true);
  }
}