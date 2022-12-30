import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTheme {
  // primarySwatch: Colors.red,
  // primaryColor: isDarkTheme ? Colors.black : Colors.white,

  // backgroundColor: isDarkTheme ? Colors.black : Color(0xffF1F5FB),

  // indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
  // buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),

  // hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),

  // highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
  // hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),

  // focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
  // disabledColor: Colors.grey,
  // textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
  // cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
  // canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
  // brightness: isDarkTheme ? Brightness.dark : Brightness.light,
  // buttonTheme: Theme.of(context).buttonTheme.copyWith(
  //     colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
  // appBarTheme: AppBarTheme(
  //   elevation: 0.0,
  // ),
  MyTheme._();
  static const MaterialColor blackColor =
      MaterialColor(0x000000, {50: Color.fromRGBO(0, 0, 0, 0.1)});
  static final ThemeData lightTheme = ThemeData(
      primaryColor: Colors.white,
      // primaryColorBrightness: Brightness.dark,
      primaryColorLight: Colors.white,
      brightness: Brightness.light,
      primaryColorDark: Colors.white,
      indicatorColor: Colors.amber,
      canvasColor: Colors.white,
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: Colors.transparent)
      // next line is important!
      // appBarTheme: AppBarTheme(brightness: Brightness.dark)
      );
  static final ThemeData darkTheme = ThemeData(
      // primaryColor: Colors.black,
      // primaryColorBrightness: Brightness.dark,
      // primaryColorLight: Colors.black,
      brightness: Brightness.dark,
      // primaryColorDark: Colors.black,
      // indicatorColor: Colors.white,
      canvasColor: Colors.black,
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: Colors.transparent)

      // next line is important!
      // appBarTheme: AppBarTheme(brightness: Brightness.dark)
      );
}
