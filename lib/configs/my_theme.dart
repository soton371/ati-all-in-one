import 'package:flutter/material.dart';

class MyTheme {
  Color primaryColor = const Color(0xff1a237e);
  Color darkPrimaryColor = const Color.fromARGB(255, 53, 69, 248);

  static ThemeData lightTheme = ThemeData(
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.light().copyWith(primary: _myTheme.primaryColor),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    colorScheme:
        const ColorScheme.dark().copyWith(primary: _myTheme.darkPrimaryColor),
  );

  static bool isDarkMode(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    if (brightness == Brightness.dark) {
      return true;
    } else {
      return false;
    }
  }

  static Color activeColor(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    if (brightness == Brightness.dark) {
      return _myTheme.darkPrimaryColor;
    } else {
      return _myTheme.primaryColor;
    }
  }

}

MyTheme _myTheme = MyTheme();
