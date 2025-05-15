
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_styles.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    indicatorColor: AppColors.blackColor,
      primaryColor: AppColors.whiteColor,
      scaffoldBackgroundColor: AppColors.whiteColor,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        showUnselectedLabels: true,
        selectedLabelStyle: AppStyles.bold12white,
        unselectedLabelStyle: AppStyles.bold12white,
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: AppColors.whiteColor,
          iconTheme: IconThemeData(
              color: AppColors.blackColor
          ),
        centerTitle: true
      ),
      textTheme: TextTheme(
          labelLarge: AppStyles.bold16Black,
          labelSmall: AppStyles.medium12Gray,
          labelMedium: AppStyles.medium14black,
          headlineLarge: AppStyles.medium24black,
          headlineMedium: AppStyles.medium20Black,
          displaySmall: AppStyles.medium14white

      ),
  );

  static final ThemeData darkTheme = ThemeData(
      indicatorColor: AppColors.whiteColor,
      primaryColor: AppColors.blackColor,
      scaffoldBackgroundColor: AppColors.blackColor,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        showUnselectedLabels: true,
        selectedLabelStyle: AppStyles.bold12white,
        unselectedLabelStyle: AppStyles.bold12white,
      ),
      appBarTheme: AppBarTheme(
          color: AppColors.blackColor,
          iconTheme: IconThemeData(
              color: AppColors.whiteColor
          ),
        centerTitle: true
      ),
      textTheme: TextTheme(
        labelLarge: AppStyles.bold16White,
        labelSmall: AppStyles.medium12Gray,
        labelMedium: AppStyles.medium14white,
        headlineLarge: AppStyles.medium24White,
        headlineMedium: AppStyles.medium20white,
              displaySmall: AppStyles.medium14black
      ),

  );
}
