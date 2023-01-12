import 'package:flutter/material.dart';

class MyTheme {
  MyTheme._();
  static const primaryColor = Color.fromRGBO(235, 94, 40, 1);
  static const darkPrimaryColor = Color.fromRGBO(27, 32, 45, 1);
  static const darkSecondaryColor = Color.fromRGBO(41, 47, 63, 1);
  static const lightPrimaryColor = Color.fromRGBO(255, 255, 255, 1);
  static const lightSecondaryColor = Color.fromRGBO(242, 242, 242, 1);
  static const lightTextSecond = Color.fromRGBO(173, 173, 173, 1);
  static const darkTextSecond = Color.fromRGBO(179, 185, 201, 1);
  static const lightOrderMessageBackground = Color.fromRGBO(240, 242, 248, 1);
  static const darkOrderMessageBackground = Color.fromRGBO(55, 62, 78, 1);
  static const lightOrderMessageForeground = Color.fromRGBO(27, 37, 79, 1);
  static const darkOrderMessageForeground = Color.fromRGBO(255, 255, 255, 1);
  // static const lightMyMessageBackground = Color.fromRGBO(11, 74, 250, 1);
  static const lightMyMessageBackground = primaryColor;

  static const darkMyMessageBackground = Color.fromRGBO(122, 129, 148, 1);
  static const lightMyMessageForeground = Color.fromRGBO(255, 255, 255, 1);
  static const darkMyMessageForeground = Color.fromRGBO(255, 255, 255, 1);
  static const lightScreenMessage = Color.fromRGBO(254, 254, 254, 1);
  static const darkScreenMessage = Color.fromRGBO(36, 36, 28, 1);

  static const MaterialColor blackColor =
      MaterialColor(0x000000, {50: Color.fromRGBO(0, 0, 0, 0.1)});
  static final ThemeData lightTheme = ThemeData(
    fontFamily: "Poppins",
    brightness: Brightness.light,
    canvasColor: lightPrimaryColor,
    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: Colors.transparent),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
      fontFamily: "Poppins",
      brightness: Brightness.dark,
      canvasColor: darkPrimaryColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: Colors.transparent));
  static Map<String, dynamic> getAppBarColor(isLightTheme) => {
        "backgroundColor": Colors.transparent,
        "shadowColor": Colors.transparent,
        "foregroundColor": isLightTheme ? Colors.black : Colors.white,
      };
}
