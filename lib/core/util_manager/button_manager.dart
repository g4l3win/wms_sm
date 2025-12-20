import 'package:flutter/material.dart';

import 'app_theme.dart';

class Button {
  static Widget button({
    IconData? icon,
    required String label,
    Function? function,
    Color? color,
    Color? fontColor,
    Color? iconColor,
  }) {
    return ElevatedButton(
      onPressed: () => function != null ? function() : {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppTheme.blackColor,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppTheme.greyColor, width: 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null
              ? Icon(icon, color: iconColor ?? AppTheme.blackColor)
              : const SizedBox.shrink(),

          Text(
            label,
            style: TextStyle(fontSize: 12, color: fontColor ?? AppTheme.whiteColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static Widget bottomActionButton({
    Function()? onTap,
    required IconData icon,
    required String actionText,
    bool isActive = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 22, right: 22, bottom: 4),
      child: GestureDetector(
        onTap: () => onTap != null ? onTap() : {},
        child: IntrinsicHeight(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? AppTheme.blackColor : AppTheme.whiteColor,
              border:
                  isActive ? null : Border.all(width: 1, color: AppTheme.greyColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isActive ? AppTheme.whiteColor : AppTheme.greyColor,
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    actionText,
                    style: TextStyle(
                      color: isActive ? AppTheme.whiteColor : AppTheme.greyColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
