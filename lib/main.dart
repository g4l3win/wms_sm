import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'core/util_manager/app_theme.dart';
import 'login/controller/auth_controller.dart';
import 'navigation/pages.dart';
import 'navigation/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Inisialisasi AuthController
  Get.put(AuthController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final authController = Get.find<AuthController>();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    authController.checkLoginStatus();
    authController.requestStoragePermissionOnce();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme:  AppTheme.light,
      initialRoute: Routes.login,
      getPages: AppPages.routes,
    );
  }
}
