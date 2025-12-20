import 'package:flutter/material.dart';
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
          ? Colors.red
          : Colors.grey.shade300;
    }

    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
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
