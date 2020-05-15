import 'package:flutter/material.dart';
import 'package:ReferAll/widget/CustomTextField.dart';

import '../autocompeletescreen.dart';

class CustomTouchSearch extends StatelessWidget {
  CustomTouchSearch(
      {this.icon,
      this.hint,
      this.obsecure = false,
      this.validator,
      this.onSaved,
      this.controller,
      this.margin,
      this.onTap,
      this.readonly = false,
      this.list,
      this.onResult});
  final EdgeInsets margin;
  final Function onResult;
  final List<String> list;
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
    return CustomTextField(
      hint: hint,
      icon: icon,
      margin: margin,
      controller: controller,
      obsecure: obsecure,
      validator: validator,
      onSaved: onSaved,
      readonly: readonly,
      onTap: () {
        final r = Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AutoCompleteScreen(
              lst: list == null ? [] : list,
              hint: "Search " + hint,
              textctrl: (String s) => {},
            ),
          ),
        );
        r.then((r) {
          String s = r as String;
          onResult == null ? () {} : onResult(s);
        });
        onTap;
      },
    );
  }
}
