import 'package:flutter/material.dart';

const Color redLight = Color(0xFFE44125);
const Color blackShade = Color(0xFF222222);
const Color darkRed = Color(0xff800000);
const Color green = Color(0xff0e6b0e);
const Color greyShadeLight = Color(0xFFE5E5E5);
const Color grey = Colors.black54;

ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: blackShade,
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
    fontFamily: 'SFUIDisplay',
    hintColor: grey,
    errorColor: darkRed,
    textTheme: TextTheme(
      headline1: TextStyle(fontWeight: FontWeight.w700, fontSize: 66, height: 1.2),
      headline3: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, height: 1.2),
      bodyText1: TextStyle(fontWeight: FontWeight.w400, fontSize: 20, height: 1.2),
      bodyText2: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, height: 1.44),
      button: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, height: 1.0),
    ));

ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: greyShadeLight,
    accentColor: Colors.black,
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.black54,
    fontFamily: 'SFUIDisplay',
    hintColor: grey,
    errorColor: darkRed,
    textTheme: TextTheme(
      headline1: TextStyle(fontWeight: FontWeight.w700, fontSize: 66, height: 1.2),
      headline3: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, height: 1.2),
      bodyText1: TextStyle(fontWeight: FontWeight.w400, fontSize: 20, height: 1.2),
      bodyText2: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, height: 1.44),
      button: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, height: 1.0),
    ));
