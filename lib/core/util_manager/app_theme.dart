import 'package:flutter/material.dart';

class AppTheme {
  static var blackColor = Colors.black;
  static var blackColor87 = Colors.black87;
  static var redColor = Colors.red;
  static var loginRedColor = Colors.red.shade900;
  static var greyColor = Colors.grey;
  static var greyColor400 = Colors.grey.shade400;
  static var lightGrey = Colors.grey.shade300;
  static var lighterGrey = Colors.grey.shade100;
  static var whiteColor = Colors.white;
  static var whiteColor60 =  Colors.white60;
  static var greenColor = Colors.green;
  static var purpleColor = Colors.purple;
  static var deepOrangeColor = Colors.deepOrange;
  static var orangeColor = Colors.orange;

  static ThemeData light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      primary: Colors.purple,
      onPrimary: Colors.white,
    ),

    // Text theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      bodyLarge: TextStyle(fontSize: 16,  color: Colors.black),
      bodyMedium:  TextStyle(fontSize: 14,  color: Colors.black),
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
    ),

    // ElevatedButton (aktif: hitam background, putih text)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white, // text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // TextButton
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.purple,
      ),
    ),

    // OutlinedButton
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        side: BorderSide(color: Colors.grey.shade300),
      ),
    ),

    // TabBar
    tabBarTheme: TabBarTheme(
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey.shade300,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(width: 2.5, color: Colors.black),
      ),
    ),

    // SnackBar default (safe default) - override by helper for success/error/warn
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.purple,
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
  );

//cara pakai ==> theme: AppTheme.light,
}