import 'package:flutter/material.dart';
import '../../../core/util_manager/app_theme.dart';
import 'home_page.dart';

extension HomeNavbar on HomePage {
  Widget navbar() {
    var menuItem = ["Home", "Profile"];
    var menuIcon = [
      Icons.home_rounded,
      Icons.person_4_rounded,
    ];

    Color? getColor(int index) {
      return controller.pageIdx.value == index
          ? AppTheme.redColor
          : AppTheme.lightGrey;
    }

    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppTheme.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.greyColor,
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(menuItem.length, (index) {
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.onNavClick(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(menuIcon[index], color: getColor(index)),
                      Text(
                        menuItem[index],
                        style: TextStyle(color: getColor(index), fontSize: 8),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
