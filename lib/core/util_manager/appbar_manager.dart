import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_theme.dart';

class AppBarManager {
   static AppBar appbarMenu({required String menu,Function()? onTap}) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppTheme.whiteColor,
      elevation: 0,
      title:
      Row(
        children: [
          GestureDetector(
            onTap: () => onTap != null ? onTap() : Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: AppTheme.greyColor
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppTheme.blackColor,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 10,),
          Text(
            menu,
            style: TextStyle(
              color: AppTheme.blackColor,
              fontWeight: FontWeight.bold,
              fontSize:16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      centerTitle: true,
    );
  }

   static AppBar appbarConfirmation({required String menu}) {
     return AppBar(
       automaticallyImplyLeading: false,
       backgroundColor: AppTheme.whiteColor,
       elevation: 0,
       title:
       Row(
         children: [
           Text(
             menu,
             style: TextStyle(
               color: AppTheme.blackColor,
               fontWeight: FontWeight.bold,
               fontSize:16,
             ),
             textAlign: TextAlign.center,
           ),
         ],
       ),
       centerTitle: true,
     );
   }

}

