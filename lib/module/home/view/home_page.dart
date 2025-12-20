import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wms_sm/module/home/view/component/list_menu.dart';
import 'package:wms_sm/module/home/view/component/profile_page.dart';
import 'package:wms_sm/module/home/view/home_appbar.dart';
import 'package:wms_sm/module/home/view/home_navbar.dart';
import '../controller/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget getBody() {
      if (controller.pageIdx.value == 0) {
        return listMenuContainer(context);
      } else {
        return profilePageContainer();
      }
    }

    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result){
          if (didPop) {
            return;
          }
        },
        child:
      Scaffold(
        backgroundColor: Colors.white,
        appBar: homeAppbar(),
        body: controller.isLoading.value
            ? const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircularProgressIndicator(color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              "Fetching Data . . .",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        )
            : SingleChildScrollView(
          child:
          Padding(padding: const EdgeInsets.all(8), child: getBody()),
        ),
        bottomNavigationBar: navbar(),
      ),
      )

    );
  }
}
