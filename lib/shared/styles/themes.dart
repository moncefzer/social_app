import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/styles.dart';

ThemeData darkTheme = ThemeData(
  // inputDecorationTheme: const InputDecorationTheme(
  //   iconColor: Colors.white,
  //   labelStyle: TextStyle(color: Colors.white),
  //   enabledBorder: OutlineInputBorder(
  //     borderSide: BorderSide(color: Colors.white, width: 2.0),
  //   ),
  //   focusedBorder: OutlineInputBorder(
  //     borderSide: BorderSide(color: Colors.deepOrange, width: 2.0),
  //   ),
  // ),
  // primarySwatch: newsAppPrimaryColor,
  primarySwatch: shopAppPrimaryColor,
  scaffoldBackgroundColor: HexColor('333739'),
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('333739'),
    ),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    backgroundColor: HexColor('333739'),
    elevation: 0,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: shopAppPrimaryColor,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
    backgroundColor: HexColor('333739'),
  ),
  textTheme: const TextTheme(
      bodyText1: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  )),
  fontFamily: defaultFontFamily,
);

ThemeData lightTheme = ThemeData(
  // inputDecorationTheme: const InputDecorationTheme(
  //   iconColor: Colors.black,
  //   labelStyle: TextStyle(color: Colors.black),
  //   enabledBorder: OutlineInputBorder(
  //     borderSide: BorderSide(color: Colors.black, width: 2.0),
  //   ),
  //   focusedBorder: OutlineInputBorder(
  //     borderSide: BorderSide(color: Colors.deepOrange, width: 2.0),
  //   ),
  // ),
  // primarySwatch: newsAppPrimaryColor,
  primarySwatch: shopAppPrimaryColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: shopAppPrimaryColor,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
    backgroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),
  fontFamily: defaultFontFamily,
);
