import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class ToastUtils {
  static Timer toastTimer;
  static OverlayEntry _overlayEntry;

  static void showCustomToast(BuildContext context, String message) {
    if (toastTimer == null || !toastTimer.isActive) {
      _overlayEntry = createOverlayEntry(context, message);
      Overlay.of(context).insert(_overlayEntry);
      toastTimer = Timer(Duration(seconds: 2), () {
        if (_overlayEntry != null) {
          _overlayEntry.remove();
        }
      });
    }
  }

  static OverlayEntry createOverlayEntry(BuildContext context, String message) {
    return OverlayEntry(
        builder: (context) => Positioned(
              bottom: 100.0,
              width: MediaQuery.of(context).size.width - 20,
              left: 10,
              child: Material(
                elevation: 0.0,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 13, bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      message,
                      textAlign: TextAlign.left,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }
}

class ToastMessageAnimation extends StatelessWidget {
  final Widget child;

  ToastMessageAnimation(this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("translateY")
          .add(
            Duration(milliseconds: 2000),
            Tween(begin: -100.0, end: 0.0),
            curve: Curves.easeOut,
          )
          .add(Duration(seconds: 1, milliseconds: 250),
              Tween(begin: 0.0, end: 0.0))
          .add(Duration(milliseconds: 250), Tween(begin: 0.0, end: -100.0),
              curve: Curves.easeIn),
      Track("opacity")
          .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0))
          .add(Duration(seconds: 1), Tween(begin: 1.0, end: 1.0))
          .add(Duration(milliseconds: 500), Tween(begin: 1.0, end: 0.0)),
    ]);

    return ControlledAnimation(
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: Offset(0, animation["translateY"]), child: child),
      ),
    );
  }
}
