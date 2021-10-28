import 'package:flutter/material.dart';

class Styles {
  static const _textSizeDefault = 16.0;
  static const _textSizeButton = 30.0;
  static const String _fontNameDefault = 'Muli';
  static final Color _textColorDefault = _hexToColor('000000');
  static final Color _textColorButton = _hexToColor('FFFFFF');
  static final Color _firefighterRed = _hexToColor('CE2029');

  static const navBarTitle = TextStyle(
    fontFamily: _fontNameDefault,
  );

  static final navBarColor = _firefighterRed;

  static final textDefault = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeDefault,
    color: _textColorDefault,
  );

  static final buttonText = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeButton,
    color: _textColorButton
  );

  static final buttonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(_firefighterRed)
  );

  static Color _hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }
}