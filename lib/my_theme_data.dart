import 'package:flutter/material.dart';
import 'package:movies_app/AppColors.dart';

class MyThemeData{
  static ThemeData appTheme = ThemeData(
appBarTheme: AppBarTheme(
  color: Appcolors.primary,
  titleTextStyle: TextStyle(
      color: Appcolors.whiteColor,
     fontSize: 22,
      fontWeight: FontWeight.w400
  ),
  iconTheme: IconThemeData(
    color: Appcolors.whiteColor,
    size: 25
  ),
),
    textTheme: TextTheme(
      bodySmall: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 10,
        color: Appcolors.whiteColor
      ),
          bodyMedium: TextStyle(
        fontWeight: FontWeight.w400,
      fontSize: 13,
            color: Appcolors.whiteColor
    ),
      bodyLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize:17,
        color: Appcolors.whiteColor
      )
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Appcolors.primary,
          selectedItemColor: Appcolors.yellowColor,
      unselectedItemColor: Appcolors.whiteColor
    )

  );
}