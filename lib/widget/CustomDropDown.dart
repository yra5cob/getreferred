import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final String hint;
  final Function onChanged;
  final EdgeInsets margin;
  final value;
  final list;
  final bool isEnum;

  CustomDropDown(
      {this.hint,
      this.onChanged,
      this.margin,
      this.value,
      this.isEnum = false,
      this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin == null ? EdgeInsets.all(5) : margin,
        constraints: BoxConstraints(maxWidth: double.infinity),
        child: Material(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            elevation: 0,
            color: Colors.blueGrey[50],
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 10, top: 5, bottom: 5),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                isExpanded: true,
                value: value,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 18,
                hint: Text(hint == null ? '' : hint),
                style: TextStyle(color: Colors.black, fontSize: 16),
                onChanged: onChanged == null ? (input) {} : onChanged,
                items: list.map<DropdownMenuItem>((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                        isEnum ? EnumToString.parseCamelCase(value) : value),
                  );
                }).toList(),
              )), //Textfiled
            ) //Material
            ));
  }
}
