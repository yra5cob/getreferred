import 'package:flutter/material.dart';

class Globals {
  static final Globals _singleton = Globals._internal();

  factory Globals() {
    return _singleton;
  }

  Globals._internal();

  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
}
