import 'package:flutter/material.dart';

class AppSize {
  static double? screenHeight;
  static double? screenWidth;

  // Initialize the global variables with MediaQuery values
  static void initialize(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }
}