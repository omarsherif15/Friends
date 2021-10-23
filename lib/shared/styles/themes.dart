import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import '../constants.dart';

ThemeData lightMode () => ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    actionsIconTheme: IconThemeData(
        color: Colors.black
    ),
    titleTextStyle: TextStyle(color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 23,
    ),
    iconTheme: IconThemeData(color: Colors.black),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),),
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  inputDecorationTheme: InputDecorationTheme(
    border:OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),),
    contentPadding: EdgeInsetsDirectional.only(top: 5,start: 20),
    hintStyle: TextStyle(color: Colors.black),
  ),
  textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 18)),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed
  ));
ThemeData darkMode () =>   ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor:HexColor('#212121'),
    elevation: 0,
    actionsIconTheme: IconThemeData(
        color: Colors.white
    ),
    titleTextStyle: TextStyle(color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 23,
    ),
    iconTheme: IconThemeData(color: Colors.white),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: HexColor('#212121'),
      statusBarIconBrightness: Brightness.light,
    ),),
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor:HexColor('#181818'),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    contentPadding: EdgeInsetsDirectional.only(top: 5,start: 30),
    hintStyle: TextStyle(color: Colors.white),
  ),
  textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 15)),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: HexColor('#202A44'),
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.white,
    type: BottomNavigationBarType.fixed
  ),
  iconTheme: IconThemeData(color: Colors.white),
  primaryIconTheme: IconThemeData(color: Colors.white),

);