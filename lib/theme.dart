import 'package:flutter/material.dart';

ThemeData light = ThemeData(
    cardColor: const Color.fromRGBO(83, 80, 213, 1),
    scaffoldBackgroundColor: const Color.fromRGBO(241, 246, 252, 1),
    primaryColor: const Color.fromRGBO(65, 45, 166, 1),
    textTheme: TextTheme(
        bodyMedium: TextStyle(color: Color.fromRGBO(7, 52, 169, 1)),
        labelLarge: TextStyle(color: Color.fromRGBO(241, 246, 252, 1)),
        labelMedium: TextStyle(color: Color.fromRGBO(201, 214, 223, 1)),
        displayLarge: TextStyle(color: Color.fromRGBO(241, 246, 252, 1))));

ThemeData dark = ThemeData(
  scaffoldBackgroundColor: const Color.fromRGBO(3, 33, 36, 1),
  primaryColor: const Color.fromRGBO(65, 45, 166, 1),
);

// button active rgb(65,45,166)
// button passive rgb(241,246,252)
// bg rgb(219,233,246)
// bg card rgb(83,80,213)
// text active rgb(241,246,252)
// text passive rgb(114,108,202)
// title rgb(22,36,68)

// dark 

