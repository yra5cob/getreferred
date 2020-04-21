import 'package:flutter/material.dart';

class UIUtil {
  static Widget getBackButton(context) {
    return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        });
  }
}
