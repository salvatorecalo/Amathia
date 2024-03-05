import 'dart:ui';

import 'package:amathia/src/costants/costants.dart';
import 'package:flutter/material.dart';

 class Styles {
   
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: isDarkTheme ? const Color.fromARGB(255, 28, 28, 28) : Colors.white,
      indicatorColor: isDarkTheme ? const Color(0xff0E1D36) : blue,
      hintColor: isDarkTheme ? const Color(0xff280C0B) : const Color(0xff1d1d1d),
      focusColor: isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor: isDarkTheme ? const Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Color(0xff272727) : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? const ColorScheme.dark() : const ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        backgroundColor: blue,
        elevation: 0.0,
      ),
    );
    
  }
}