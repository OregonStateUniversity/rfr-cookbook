import 'package:flutter/material.dart';

displaySnackbar(String text, BuildContext context, {int duration = 2}) {
  return ScaffoldMessenger.of(context)
  .showSnackBar(
    SnackBar(
      backgroundColor: Colors.black.withOpacity(0.5),
      content: Text(text, textAlign: TextAlign.center),
      duration: Duration(seconds: duration)
    )
  );
}