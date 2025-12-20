import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constant/screen_configuration.dart';
import '../../core/util_manager/app_theme.dart';
import '../controller/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  final _formKey = GlobalKey<FormState>();

  Widget loginAppname() {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: AppTheme.redColor)),
        const SizedBox(width: 5),
        Text(
          "Sistem Manajemen Gudang",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: AppTheme.redColor,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(child: Divider(thickness: 1, color: AppTheme.loginRedColor )),
      ],
    );
  }

  Widget usernameField() {
    return Container(
      child: TextFormField(
        controller: controller.usernameController,
        validator:
            (value) => value!.trim().isEmpty ? 'Username Required' : null,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: 'Username',
          prefixIcon: Icon(Icons.person, color: AppTheme.redColor),
          contentPadding: EdgeInsets.only(left: 5, right: 5),
          fillColor: AppTheme.greyColor,
        ),
      ),
    );
  }

  SizedBox passwordField() {
    return SizedBox(
      child: Obx(
        () => TextFormField(
          validator:
              (value) => value!.trim().isEmpty ? 'Password Required' : null,
          controller: controller.passwordController,
          textInputAction: TextInputAction.done,
          obscureText: controller.isPasswordVisible.value,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock, color: AppTheme.redColor),
            labelText: 'Password',
            contentPadding: const EdgeInsets.only(left: 5, right: 5),
            suffixIcon: GestureDetector(
              onTap: () {
                controller.togglePasswordVisibility();
              },
              child: Icon(
                controller.isPasswordVisible.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                color:
                    controller.isPasswordVisible.value
                        ? AppTheme.greyColor
                        : AppTheme.redColor
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginForm({required GlobalKey<FormState> formKey}) {
    Widget loginButton() {
      return GestureDetector(
        onTap: () {
          if (formKey.currentState!.validate()) {
            controller.login();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppTheme.redColor,
          ),
          child: Center(
            child: Text(
              "Login",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.whiteColor,
              ),
            ),
          ),
        ),
      );
    }

    return Form(
      key: formKey,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              usernameField(),
              const SizedBox(height: 10),
              passwordField(),
              const SizedBox(height: 20),
              loginButton(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfiguration().init(context);

    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Padding(
            padding:const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: ScreenConfiguration.screenHeight * 0.05),
                loginAppname(),
                SizedBox(height: ScreenConfiguration.screenHeight3 * 0.05),
                Image(
                  image: const AssetImage('assets/wms_splash.jpg'),
                  height: ScreenConfiguration.screenHeight * 0.3,
                ),
                SizedBox(height: ScreenConfiguration.screenHeight3 * 0.05),
                loginForm(formKey: _formKey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
