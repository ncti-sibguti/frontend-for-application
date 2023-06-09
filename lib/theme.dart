import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class AppTheme {
  static final ThemeData light = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(
        primary: Color.fromRGBO(240, 240, 240, 1),
        secondary: Color.fromRGBO(65, 45, 166, 1),
        background: Colors.black),
    cardColor: const Color.fromRGBO(83, 80, 213, 1),
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    primaryColor: const Color.fromRGBO(65, 45, 166, 1),
    textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Color.fromRGBO(65, 45, 166, 1)),
        bodyLarge: TextStyle(color: Color.fromRGBO(241, 246, 252, 1)),
        labelLarge: TextStyle(color: Color.fromRGBO(241, 246, 252, 1)),
        labelMedium: TextStyle(color: Color.fromRGBO(201, 214, 223, 1)),
        titleLarge: TextStyle(color: Color.fromRGBO(65, 45, 166, 1)),
        displayLarge: TextStyle(color: Color.fromRGBO(241, 246, 252, 1))),
  );

  static final ThemeData dark = ThemeData.dark().copyWith(
      colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(15, 15, 15, 1),
          secondary: Color.fromRGBO(65, 45, 166, 1),
          background: Colors.white),
      scaffoldBackgroundColor: const Color.fromRGBO(31, 31, 31, 1),
      primaryColor: const Color.fromRGBO(65, 45, 166, 1),
      cardColor: const Color.fromRGBO(45, 45, 45, 1),
      hintColor: const Color.fromRGBO(72, 137, 234, 1));

  static const DarkChatTheme chatDark = DarkChatTheme(
      backgroundColor: Color.fromRGBO(31, 31, 31, 1),
      inputBackgroundColor: Color.fromRGBO(15, 15, 15, 1),
      secondaryColor: Color.fromRGBO(240, 240, 240, 0.1),
      primaryColor: Color.fromRGBO(65, 45, 166, 0.8));

  static const DefaultChatTheme chatLight = DefaultChatTheme(
      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
      inputBackgroundColor: Color.fromRGBO(65, 45, 166, 1),
      secondaryColor: Color.fromRGBO(65, 45, 166, 0.07),
      primaryColor: Color.fromRGBO(65, 45, 166, 0.8));
}





// button active rgb(65,45,166)
// button passive rgb(241,246,252)
// bg rgb(219,233,246)
// bg card rgb(83,80,213)
// text active rgb(241,246,252)
// text passive rgb(114,108,202)
// title rgb(22,36,68)

// dark 

