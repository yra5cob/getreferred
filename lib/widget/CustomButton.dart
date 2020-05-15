import 'package:flutter/material.dart';
import 'package:ReferAll/helper/Util.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final Color backgroundColor;
  final String label;
  final IconData icon;
  final Color textColor;
  final EdgeInsets margin;
  final Color borderColor;
  final Image image;
  final double fontSize;
  final bool shadow;
  final EdgeInsets padding;

  CustomButton({
    Key key,
    this.onTap,
    this.backgroundColor,
    this.label,
    this.icon,
    this.textColor,
    this.margin,
    this.borderColor,
    this.image,
    this.fontSize = 14,
    this.shadow = true,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: margin == null ? EdgeInsets.all(5) : margin,
        constraints: BoxConstraints(maxWidth: double.infinity),
        decoration: BoxDecoration(
          border: Border.all(
              color: borderColor == null ? Colors.transparent : borderColor),
          boxShadow: shadow
              ? [
                  BoxShadow(
                    offset: const Offset(0, 5),
                    blurRadius: 6,
                    color: const Color(0xff000000).withOpacity(0.16),
                  ),
                ]
              : [],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: InkWell(
              onTap: onTap == null ? () {} : onTap,
              child: Container(
                  decoration: BoxDecoration(
                      gradient: backgroundColor == null
                          ? LinearGradient(
                              colors: [Util.getColor1(), Util.getColor2()])
                          : null,
                      borderRadius: BorderRadius.circular(15),
                      color: backgroundColor == null
                          ? Colors.green[800]
                          : backgroundColor),
                  padding: padding == null
                      ? EdgeInsets.only(
                          left: 20, right: 20, top: 15, bottom: 15)
                      : padding,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                              color:
                                  textColor == null ? Colors.white : textColor,
                              fontSize: fontSize),
                        ),
                        if (icon != null)
                          Icon(
                            icon == null ? Icons.arrow_forward_ios : icon,
                            color: textColor == null ? Colors.white : textColor,
                            size: fontSize,
                          ),
                        if (image != null) SizedBox(height: 20, child: image)
                      ]))),
        ));
  }
}
