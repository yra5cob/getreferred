import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:getreferred/widget/CustomButton.dart';
import 'package:getreferred/widget/CustomTextField.dart';

class MultiSelectAutoCompleteScreen extends StatefulWidget {
  final List<String> lst;
  final String hint;
  final Function textctrl;
  MultiSelectAutoCompleteScreen(
      {Key key, @required this.lst, this.hint, this.textctrl})
      : super(key: key);

  @override
  _MultiSelectAutoCompleteScreenState createState() =>
      _MultiSelectAutoCompleteScreenState(this.lst, this.hint, this.textctrl);
}

class _MultiSelectAutoCompleteScreenState
    extends State<MultiSelectAutoCompleteScreen> {
  List<String> _list;
  List<String> _filteredList;
  List<String> _selectedList;
  String _hint;
  Object _textctrl;
  String searchKey;
  bool searchKeyVlaue = false;
  Map<String, bool> _selected;

  _MultiSelectAutoCompleteScreenState(
      List<String> list, String hint, Function textctrl) {
    this._list = list;

    this._hint = hint;
    this._textctrl = textctrl;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selected = Map.fromIterable(_list, key: (v) => v, value: (v) => false);
    _filteredList = _list;
  }

  Widget row(int index, BuildContext context) {
    String label = _filteredList[index];
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Checkbox(
            value: _selected[label] == null ? searchKeyVlaue : _selected[label],
            onChanged: (value) {
              setState(() {
                if (_selected[label] == null) {
                  _selected[searchKey] = value;
                  _list.add(searchKey);
                } else
                  _selected[label] = value;
              });
              print(value);
            }),
        Text(_selected[label] == null ? searchKey : label)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height),
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
                    child: CustomTextField(
                      hint: _hint,
                      icon: Icon(Icons.search),
                      onChangeEvent: (input) {
                        _filteredList = [];
                        if (input == '' || input == null) {
                          _filteredList = _list;
                        } else {
                          _list.forEach((String s) {
                            if (s.contains(input)) _filteredList.add(s);
                          });
                        }
                        if (_filteredList.isEmpty) {
                          _filteredList.add(input);
                          searchKey = input;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredList.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return row(index, context);
                    }),
              ),
              Spacer(),
              Container(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    color: Colors.blueGrey[50],
                  ),
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                            color: Colors.blueGrey[100],
                          ),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Selected",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                      Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          for (int i = 0; i < _list.length; i++)
                            if (_selected[_list[i]])
                              Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blueGrey[100],
                                ),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  children: <Widget>[
                                    Container(
                                      child: Text(_list[i]),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selected[_list[i]] = false;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blueGrey[50],
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: 15,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CustomButton(
                              label: "Done",
                              onTap: () {
                                _selectedList = [];
                                _selected.forEach((k, v) {
                                  if (v) _selectedList.add(k);
                                });
                                Navigator.pop(context, _selectedList);
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
