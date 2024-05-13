import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_chat/constants/app_assets.dart';
import 'package:quick_chat/constants/app_colors.dart';

ThemeData theme() {
  return ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: AppAssets.poppinsFontFamily,
      appBarTheme: appBarTheme(),
      useMaterial3: true);
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white, // <-- SEE HERE
      statusBarIconBrightness: Brightness.dark, //<-- For Android SEE HERE (dark icons)
      statusBarBrightness: Brightness.light, //<-- For iOS SEE HERE (dark icons)
    ),
    titleSpacing: 24,
    color: Colors.white,
    elevation: 1,
    toolbarHeight: 70,
    shadowColor: AppColors.gray50,
    centerTitle: false,
    iconTheme: IconThemeData(
      color: AppColors.gray900,
    ),
    titleTextStyle: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
  );
}