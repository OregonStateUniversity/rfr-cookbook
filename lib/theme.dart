import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme { //1
    return ThemeData( //2
      appBarTheme: AppBarTheme(
        color: Colors.redAccent[700],
        foregroundColor: Colors.white,
      ),
      primaryColor: Colors.redAccent[700],
      scaffoldBackgroundColor: Colors.white,
    );
  }
}