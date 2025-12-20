import 'dart:developer';

import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
class MobileScanController extends GetxController{
  MobileScannerController cameraController = MobileScannerController(
      torchEnabled: false
  );
  var isTorch= false.obs;
  var boxSize = 300;


  void toggleFlash(){
    cameraController.toggleTorch();
    isTorch.value = !isTorch.value;
    log("cek is TORCH ${isTorch.value}");
  }

  @override
  void onClose(){
    cameraController.dispose();
    super.onClose();
  }
}