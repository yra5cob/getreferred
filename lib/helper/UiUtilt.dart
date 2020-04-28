import 'package:flutter/material.dart';
import 'package:getreferred/helper/Util.dart';

class UIUtil {
  static Widget getBackButton(context) {
    return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  static Paint getTextGradient() {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Util.hexToColor("#2fc3cf"), Util.hexToColor("#2d91ce")],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    return Paint()..shader = linearGradient;
  }

  static getMasked(IconData icon, {double size = 28}) {
    return ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => RadialGradient(
              center: Alignment.center,
              radius: 0.5,
              colors: [Util.getColor1(), Util.getColor2()],
              tileMode: TileMode.mirror,
            ).createShader(bounds),
        child: Icon(
          icon,
          size: size,
          color: Colors.cyan,
        ));
  }
}
