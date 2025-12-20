import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms_sm/module/menu/menu_lokasi/controller/crud_template_controller.dart';
import 'package:wms_sm/module/menu/menu_lokasi/view/component/daftar_stock_location.dart';
import 'package:wms_sm/module/menu/menu_lokasi/view/component/list_component.dart';
import '../../../../core/util_manager/appbar_manager.dart';
import '../../../../core/util_manager/dialog_manager.dart';
import '../controller/menu_template_controller.dart';

class LocationContainer extends GetView<LocationController> {
  final ScrollController _scrollController = ScrollController();
  LocationContainer({super.key});

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        controller.onAssignPaginationData();
      }
    });

    Widget getBody() {
      if (controller.pageIdx.value == 0) {
        return containerList(context,_scrollController);
      } else  {
        return gridItemContainer(context);
      }
    }


    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarManager.appbarMenu(
          onTap: () {
            controller.getBack();
          },
          menu: "Laporan daftar Lokasi",
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(padding: const EdgeInsets.all(8), child: getBody()),
              controller.isLoading.isTrue
                  ? const LoadingIndicatorWithText(title: "mendapatkan data")
                  : const SizedBox.shrink(),
            ],
          ),
        ),

      ),
    );
  }
}
