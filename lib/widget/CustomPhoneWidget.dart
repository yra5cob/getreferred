import 'package:flutter/material.dart';
import 'package:flutter_country_picker/country.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:ReferAll/widget/CustomTextField.dart';

class CustomPhoneWidget extends StatelessWidget {
  final EdgeInsets margin;
  final TextEditingController controller;
  final String hint;
  final Country countryCodeValue;
  final Function onCountryCodeChange;

  CustomPhoneWidget(
      {this.margin,
      this.hint,
      this.countryCodeValue,
      this.onCountryCodeChange,
      this.controller});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: margin == null ? EdgeInsets.all(5) : margin,
        child: Material(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            elevation: 0,
            color: Colors.blueGrey[50],
            shadowColor: Color(0xff000000),
            child: Container(
              padding: EdgeInsets.only(left: 15),
              child: Row(children: [
                CountryPicker(
                  showName: false,
                  showDialingCode: true,
                  onChanged: (Country country) {
                    onCountryCodeChange(country);
                  },
                  selectedCountry: countryCodeValue,
                ),
                Expanded(
                    child: CustomTextField(
                        controller: controller,
                        hint: hint,
                        margin: EdgeInsets.all(0)))
              ]), //Textfiled
            )) //Material
        );
    ;
  }
}
