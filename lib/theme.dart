//I know this is not the most important thing,
//we don't need to use it yet and honestly I am afraid 
//to add the code to the other files to make it work.
//we can chat about it on Friday. - Adrianna
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
