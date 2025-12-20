import 'package:flutter/material.dart';

class ScreenConfiguration {
  static MediaQueryData _mediaQueryData = MediaQueryData();
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double screenHeight1 = 0;
  static double screenHeight2 = 0;
  static double screenHeight3 = 0;
  static double screenStatusBar = 0;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    screenHeight1 =
        _mediaQueryData.size.height - _mediaQueryData.viewPadding.top;
    screenHeight2 =
        _mediaQueryData.size.height -
        _mediaQueryData.viewPadding.top -
        AppBar().preferredSize.height;
    screenHeight3 =
        _mediaQueryData.size.height -
        kToolbarHeight -
        _mediaQueryData.padding.top -
        kBottomNavigationBarHeight;
    screenStatusBar = _mediaQueryData.padding.top;
  }
}
