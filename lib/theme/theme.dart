import 'package:flutter/material.dart';
import 'package:maps_app/theme/colors.dart';

class AppTheme {
  static ThemeData theme = ThemeData(

      // Scaffold Theme
      scaffoldBackgroundColor: AppColors.backgroundColor,

      // AppBar Theme
      appBarTheme: AppBarTheme(
          backgroundColor: AppColors.backgroundColor,
          titleTextStyle: TextStyle(
            fontSize: 25,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: false),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primaryColor,
        selectedItemColor: AppColors.greenAccentColor,
        unselectedItemColor: Colors.grey[600],
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenAccentColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: AppColors.greenAccentColor,
              )),
          floatingLabelStyle: TextStyle(color: AppColors.greenAccentColor)));

  // Constructor
  AppTheme() {
    // You can add any additional initialization here if needed
  }
}
