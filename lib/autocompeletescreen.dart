import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutoCompleteScreen extends StatefulWidget {
  final List<String> lst;
  final String hint;
  final Function textctrl;
  AutoCompleteScreen({Key key, @required this.lst, this.hint, this.textctrl})
      : super(key: key);

  @override
  _AutoCompleteScreenState createState() =>
      _AutoCompleteScreenState(this.lst, this.hint, this.textctrl);
}

class _AutoCompleteScreenState extends State<AutoCompleteScreen> {
  List<String> _list;
  String _hint;
  Object _textctrl;
  _AutoCompleteScreenState(List list, String hint, Function textctrl) {
    this._list = list;
    this._hint = hint;
    this._textctrl = textctrl;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(top: 20, left: 5, right: 5),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          autofocus: true,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 10, bottom: 5, top: 5, right: 15),
                              labelText: _hint,
                              border: new UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white)))),
                      suggestionsCallback: (pattern) {
                        final result = [];
                        _list.forEach((String f) {
                          if (f
                              .toString()
                              .toLowerCase()
                              .contains(pattern.toLowerCase())) {
                            result.add(f);
                          }
                        });
                        if (result.length == 0) {
                          return [pattern];
                        }
                        return result;
                      },
                      itemBuilder: (context, suggestion) {
                        return row(suggestion, this._textctrl, context);
                      },
                      onSuggestionSelected: (suggestion) {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => ProductPage(product: suggestion)));
                      },
                    ),
                  ),
                  Icon(Icons.search)
                ],
              ),
            ],
          )),
    );
  }
}

Widget row(String maker, Function txtctrl, BuildContext context) {
  return InkWell(
      onTap: () {
        txtctrl(maker);
        Navigator.pop(context, maker);
      },
      child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            maker,
            style: TextStyle(
              fontSize: 22,
            ),
          )));
}
