import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final double fontSize;

  CustomTextField(
      {this.icon,
      this.hint,
      this.fontSize = 14,
      this.obsecure = false,
      this.validator,
      this.onSaved,
      this.controller,
      this.margin,
      this.onTap,
      this.onChangeEvent,
      this.lines = 1,
      this.readonly = false});
  final int lines;
  final Function onChangeEvent;
  final EdgeInsets margin;
  final bool readonly;
  final Function onTap;
  final TextEditingController controller;
  final FormFieldSetter<String> onSaved;
  final Icon icon;
  final String hint;
  final bool obsecure;
  final FormFieldValidator<String> validator;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin == null ? EdgeInsets.all(5) : margin,
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          elevation: 0,
          color: Colors.blueGrey[50],
          shadowColor: Color(0xff000000),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                    onTap: onTap == null ? () {} : onTap,
                    readOnly: readonly,
                    onSaved: onSaved,
                    maxLines: lines,
                    onChanged: (String change) {
                      if (onChangeEvent != null) onChangeEvent(change);
                    },
                    validator: validator,
                    obscureText: obsecure,
                    autofocus: false,
                    controller: controller,
                    style: TextStyle(fontSize: fontSize),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      border: InputBorder.none,
                      labelText: hint,
                    )),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: icon,
              )
            ],
          ), //Textfiled
        ) //Material
        );
  }
}
