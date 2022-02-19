import 'package:flutter/material.dart';
import 'package:rfr_cookbook/config/styles.dart';

AppBar appBar(
    {required String title, IconButton? leading, List<Widget>? actions}) {
  return AppBar(
    title: Text(title, style: Styles.navBarTitle),
    backgroundColor: Styles.themeColor,
    leading: leading,
    actions: actions,
  );
}
