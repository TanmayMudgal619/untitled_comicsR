import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  primaryColor: Colors.black,
  primaryColorBrightness: Brightness.light,
  primaryColorLight: Colors.black,
  primaryColorDark: Colors.white,
  canvasColor: Colors.white,
  shadowColor: Colors.black12,
  scaffoldBackgroundColor: Colors.white,
  bottomAppBarColor: Colors.black26,
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.black),
  brightness: Brightness.light,
  secondaryHeaderColor: Colors.black,
  backgroundColor: Colors.black,
  dialogBackgroundColor: Colors.white,
  indicatorColor: Colors.black54,
  cursorColor: Colors.black,
  primarySwatch: const MaterialColor(0xFFFFFFFF, <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(0xFF000000),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  }),
  toggleableActiveColor: Colors.white,
  primaryIconTheme: const IconThemeData(
    color: Colors.black,
  ),
  sliderTheme: SliderThemeData.fromPrimaryColors(
    primaryColor: Colors.white,
    primaryColorDark: Colors.white,
    primaryColorLight: Colors.white,
    valueIndicatorTextStyle: const TextStyle(color: Colors.black54),
  ),
  tabBarTheme: const TabBarTheme(
    indicatorSize: TabBarIndicatorSize.label,
    labelColor: Colors.black,
    unselectedLabelColor: Colors.black54,
  ),
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: Colors.black,
      )),
  scrollbarTheme: const ScrollbarThemeData(),
  cupertinoOverrideTheme: const CupertinoThemeData(
    barBackgroundColor: Colors.transparent,
    primaryColor: Colors.black,
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(color: Colors.black),
    bodyText2: TextStyle(color: Colors.black),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.black87,
    unselectedItemColor: Colors.black45,
    backgroundColor: Colors.white54,
  ),
);
ThemeData dark = ThemeData(
  primaryColor: Colors.white,
  primaryColorBrightness: Brightness.dark,
  primaryColorLight: const Color(0xFF191A1C),
  primaryColorDark: Colors.black12,
  canvasColor: const Color(0xFF191A1C),
  shadowColor: Colors.white12,
  scaffoldBackgroundColor: const Color(0xFF191A1C),
  bottomAppBarColor: Colors.grey[900],
  brightness: Brightness.dark,
  unselectedWidgetColor: Colors.black26,
  disabledColor: Colors.black26,
  secondaryHeaderColor: Colors.white,
  backgroundColor: Colors.white,
  indicatorColor: Colors.white,
  cursorColor: Colors.white,
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.black12,
    elevation: 0,
  ),
  primarySwatch: const MaterialColor(0xFF191A1C, <int, Color>{
    50: Color(0xFF191A1C),
    100: Color(0xFF191A1C),
    200: Color(0xFF191A1C),
    300: Color(0xFF191A1C),
    400: Color(0xFF191A1C),
    500: Color(0xFF191A1C),
    600: Color(0xFF191A1C),
    700: Color(0xFF191A1C),
    800: Color(0xFF191A1C),
    900: Color(0xFF191A1C),
  }),
  primaryIconTheme: const IconThemeData(
    color: Colors.white,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.white,
  ),
  tabBarTheme: const TabBarTheme(
    indicatorSize: TabBarIndicatorSize.label,
    labelColor: Colors.white,
    unselectedLabelColor: Colors.white54,
  ),
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: Colors.white,
      )),
  scrollbarTheme: const ScrollbarThemeData(),
  cupertinoOverrideTheme: const CupertinoThemeData(
    barBackgroundColor: Colors.transparent,
    primaryColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(color: Colors.white),
    bodyText2: TextStyle(color: Colors.white),
    subtitle1: TextStyle(color: Colors.white),
    subtitle2: TextStyle(color: Colors.white),
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.white,
    textColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white70,
    backgroundColor: Colors.black54,
  ),
);
