import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.icon,
      this.hint,
      this.obsecure = false,
      this.validator,
      this.onSaved,
      this.controller});
  final TextEditingController controller;
  final FormFieldSetter<String> onSaved;
  final Icon icon;
  final String hint;
  final bool obsecure;
  final FormFieldValidator<String> validator;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          elevation: 2.0,
          shadowColor: Color(0xff000000),
          child: TextFormField(
              onSaved: onSaved,
              validator: validator,
              obscureText: obsecure,
              autofocus: true,
              controller: controller,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                border: InputBorder.none,
                labelText: hint,
              )), //Textfiled
        ) //Material
        );
  }
}
