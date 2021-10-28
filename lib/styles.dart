import 'package:flutter/material.dart';

class Styles {
  static const _textSizeDefault = 16.0;
  static const String _fontNameDefault = 'Muli';
  static final Color _textColorDefault = _hexToColor('000000');
  static final Color _textColorForButton = _hexToColor('FFFFFF');

  static const navBarTitle = TextStyle(
    fontFamily: _fontNameDefault,
  );

  static final textDefault = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeDefault,
    color: _textColorDefault,
  );

  static final buttonText = TextStyle(
    fontFamily: _fontNameDefault,
    fontSize: _textSizeDefault,
    color: _textColorForButton
  );

  static Color _hexToColor(String code) {
    return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
  }
}