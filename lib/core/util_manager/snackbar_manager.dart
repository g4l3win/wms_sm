import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarManager{
  onShowSnacbarMessage({
    required String title,
    required String content,
    required Color colors,
    required SnackPosition position,
    Function? function
  }){

    Get.snackbar(
      title,
      content,
      snackPosition: position,
      backgroundColor: colors,
      colorText: Colors.white,
      animationDuration: const Duration(milliseconds: 500),
      duration: const Duration(milliseconds: 4500),
      borderRadius: 5,
      mainButton: function != null ?
      TextButton(onPressed: (){function();}, child: Text("OpenFile")) : null
    );
  }
}

