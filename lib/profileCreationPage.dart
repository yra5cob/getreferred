import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:getreferred/model/Profile.dart';
import 'autocompeletescreen.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

final globalKey = GlobalKey<ScaffoldState>();
final GlobalKey<AnimatedListState> _educational_listKey = GlobalKey();
final GlobalKey<AnimatedListState> _professional_listKey = GlobalKey();
GlobalKey<AutoCompleteTextFieldState<String>> _current_location_key =
    new GlobalKey();

class ProfileCreationPage extends StatefulWidget {
  @override
  _ProfileCreationPageState createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  int _currentStep = 0;
  File _image;
  Gender genderState;
  Country countryCode;
  String _character;
  List<Map> languages = [];
  List<Map> colleges = [];
  List<Map> companies = [];
  Yes_No_type sixDaysState;
  Yes_No_type handledTeamState;
  Yes_No_type usaPermitState;
  Yes_No_type relocateState;
  Yes_No_type earlyStartupState;
  Travel_type willingnessTravelState;

  final TextEditingController _firstNameCtrl = new TextEditingController();

  final TextEditingController _lastNameCtrl = new TextEditingController();

  TextEditingController _searchCurrentLocation = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  final TextEditingController _searchpreferredLocation =
      new TextEditingController();

  final TextEditingController _searchindustry = new TextEditingController();

  final TextEditingController _searchfunctionalarea =
      new TextEditingController();
  var formatter = new DateFormat('dd-MM-yyyy');
  final TextEditingController _dob_ctrl = new TextEditingController();
  Future<Null> _selectDate(
      BuildContext context, DateTime getDate, Function setDate) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: getDate == null ? DateTime.now() : getDate,
        firstDate: DateTime(1970, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != getDate) {
      setDate(picked);
    }
  }

  @override
  void initState() {
    super.initState();
    final _profile = Provider.of<Profile>(context, listen: false);
    _profile.getCompanies().forEach((Company c) {
      Map _company = {};
      _company[ProfileConstants.COMPANY_NAME_CONTROLLER] =
          new TextEditingController(text: c.company_name);
      _company[ProfileConstants.COMPANY_POSITION_CONTROLLER] =
          new TextEditingController(text: c.position);
      _company[ProfileConstants.COMPANY_LOCATION_CONTROLLER] =
          new TextEditingController(text: c.location);
      _company[ProfileConstants.COMPANY_IS_CURRENT] = c.current_company;
      _company[ProfileConstants.COMPANY_EMPLOYE_TYPE] = c.getEmp_type;
      _company[ProfileConstants.COMPANY_FROM] = c.from;
      _company[ProfileConstants.COMPANY_TO] = c.to;
      companies.add(_company);
    });
    _profile.getCollegeList().forEach((College c) {
      Map _college = {};
      _college[ProfileConstants.COLLEGE_NAME_CONTROLLER] =
          new TextEditingController(text: c.college_name);
      _college[ProfileConstants.COLLEGE_DEGREE] =
          new TextEditingController(text: c.getDegree);
      _college[ProfileConstants.COLLEGE_FIELD_OF_STUDY_CONTROLLER] =
          new TextEditingController(text: c.field_of_study);
      _college[ProfileConstants.COLLEGE_COURSE_TYPE] = c.course_type;
      _college[ProfileConstants.COLLEGE_FROM] = c.from;
      _college[ProfileConstants.COLLEGE_TO] = c.to;
      colleges.add(_college);
    });

    _profile.getLanguages.forEach((Language l) {
      Map language = {};
      language[ProfileConstants.LANGUAGE_NAME] =
          new TextEditingController(text: l.name);
      language[ProfileConstants.LANGUAGE_READ] = l.read;
      language[ProfileConstants.LANGUAGE_WRITE] = l.write;
      language[ProfileConstants.LANGUAGE_SPEAK] = l.speak;
      languages.add(language);
    });
    genderState = _profile.getGender;
    countryCode = _profile.getCountryCode;
    _firstNameCtrl.text = _profile.firstname;
    _phoneNumberController.text =
        _profile.phonenumber == null ? "" : _profile.phonenumber.toString();
    _lastNameCtrl.text = _profile.lastname;
    _searchCurrentLocation.text = _profile.getCurrentLocation;
    _searchpreferredLocation.text = _profile.getPreferredLocation;
    _searchindustry.text = _profile.getIndustry;
    _searchfunctionalarea.text = _profile.getFunctionalArea;
    _dob_ctrl.text =
        _profile.getDob == null ? "" : formatter.format(_profile.getDob);
    Yes_No_type sixDaysState = _profile.six_days_week;
    Yes_No_type handledTeamState = _profile.handled_team;
    Yes_No_type usaPermitState = _profile.usa_premit;
    Yes_No_type relocateState = _profile.getRelocate;
    Yes_No_type earlyStartupState = _profile.getEarlyStartup;
    Travel_type willingnessTravelState = _profile.getWillingnessTravel;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

  Future uploadPic(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'Create your profile',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.help),
                          color: Colors.black,
                          onPressed: () {},
                        ),
                      ],
                    )),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _stepper(context),
                )
              ],
            )));
  }

  Widget _personalForm() {
    final _profile = Provider.of<Profile>(context, listen: false);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Divider(
                color: Colors.black,
              ),
            ),
            Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  child: Image.asset("assets/images/profile.png"),
                ),
                Positioned(
                    bottom: -5,
                    right: -25,
                    child: RawMaterialButton(
                      onPressed: () {
                        getImage();
                      },
                      child: new Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 18.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                    ))
              ],
            ),
            Expanded(
                child: Divider(
              color: Colors.black,
            ))
          ],
        ),
        Padding(
            padding:
                EdgeInsets.only(top: 10, bottom: 10, left: 5.0, right: 5.0),
            child: _text(
              "First name",
              ctr: _firstNameCtrl,
            ) //Material
            ),
        Padding(
            padding:
                EdgeInsets.only(top: 10, bottom: 10, left: 5.0, right: 5.0),
            child: _text(
              "Last name",
              ctr: _lastNameCtrl,
            ) //Material
            ),
        Padding(
            padding:
                EdgeInsets.only(top: 10, bottom: 10, left: 20.0, right: 5.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              elevation: 2.0,
              shadowColor: Color(0xff000000),
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(children: [
                  CountryPicker(
                    showName: false,
                    showDialingCode: true,
                    onChanged: (Country country) {
                      setState(() {
                        countryCode = country;
                      });
                    },
                    selectedCountry: countryCode,
                  ),
                  Expanded(
                      child: TextField(
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration.collapsed(
                      hintText: 'Phone',
                      border: InputBorder.none,
                    ),
                  ))
                ]),
              ), //Textfiled
            ) //Material
            ),
        Padding(
            padding:
                EdgeInsets.only(top: 10, bottom: 10, left: 5.0, right: 5.0),
            child: _textwithtap("Date of birth", readonly: true, ctr: _dob_ctrl,
                tap: () {
              _selectDate(context, _profile.getDob, (DateTime d) {
                setState(() {
                  _dob_ctrl.text = d == null ? "" : formatter.format(d);
                });
              });
            }) //Material
            ),
        Row(mainAxisSize: MainAxisSize.max, children: [
          Expanded(
              child: Padding(
                  padding:
                      EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                  child: Padding(
                      padding:
                          EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                      child: _genericDropdown(
                        DropdownButtonHideUnderline(
                            child: DropdownButton<Gender>(
                          value: genderState,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 25,
                          elevation: 3,
                          hint: Text("Gender"),
                          style: TextStyle(color: Colors.black),
                          onChanged: (Gender newValue) {
                            setState(() {
                              genderState = newValue;
                            });
                          },
                          items: Gender.values
                              .map<DropdownMenuItem<Gender>>((Gender value) {
                            return DropdownMenuItem<Gender>(
                              value: value,
                              child: Text(_profile.Gender_values[value]),
                            );
                          }).toList(),
                        )),
                      ))))
        ]),
        Padding(
            padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
            child: Container(
              child: _textwithtap("Current location",
                  readonly: true, ctr: this._searchCurrentLocation, tap: () {
                final r = Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AutoCompleteScreen(
                      lst: ["Chennai", "Bangalore", "Mumbai"],
                      hint: "Search location",
                      textctrl: (String s) => {},
                    ),
                  ),
                );
                r.then((r) {
                  String s = r as String;
                  setState(() {
                    _searchCurrentLocation.text = s;
                  });
                });
              }),
            )),
        Padding(
          padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
          child: Container(
              child: _textwithtap("Preferred location",
                  readonly: true, ctr: _searchpreferredLocation, tap: () {
            final r = Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AutoCompleteScreen(
                  lst: ["Chennai", "Bangalore", "Mumbai"],
                  hint: "Search location",
                  textctrl: (String s) => {},
                ),
              ),
            );
            r.then((r) {
              String s = r as String;
              setState(() {
                _searchpreferredLocation.text = s;
              });
            });
          })),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
          child: Container(
              child: _textwithtap("Industry",
                  readonly: true, ctr: _searchindustry, tap: () {
            final r = Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AutoCompleteScreen(
                  lst: ["FMCG", "Ecommerce", "Oil & Gas"],
                  hint: "Search Industry",
                  textctrl: (String s) => {},
                ),
              ),
            );
            r.then((r) {
              String s = r as String;
              setState(() {
                _searchindustry.text = s;
              });
            });
          })),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
          child: Container(
              child: _textwithtap("Functional area",
                  readonly: true, ctr: _searchfunctionalarea, tap: () {
            final r = Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AutoCompleteScreen(
                  lst: ["Sales", "Marketing", "Operations"],
                  hint: "Search functional area",
                  textctrl: (String s) => {},
                ),
              ),
            );
            r.then((r) {
              String s = r as String;
              setState(() {
                _searchfunctionalarea.text = s;
              });
            });
          })),
        ),
        Padding(
            padding:
                EdgeInsets.only(top: 10, bottom: 10, left: 5.0, right: 5.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              elevation: 2.0,
              shadowColor: Color(0xff000000),
              child: TextField(
                  obscureText: false,
                  maxLines: 3,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: 35, bottom: 5, top: 5, right: 15),
                    border: InputBorder.none,
                    labelText: 'Headline',
                  )), //Textfiled
            ) //Material
            ),
      ],
    );
  }

  Widget _profession() {
    return Column(
      children: <Widget>[
        AnimatedList(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            key: _professional_listKey,
            initialItemCount: companies.length,
            itemBuilder:
                (BuildContext context, int index, Animation animation) {
              return FadeTransition(
                  opacity: animation,
                  child: ListTile(
                    title: _addJob(index),
                  ));
            }),
        Row(children: <Widget>[
          Expanded(
              child: Divider(
            color: Colors.black,
          )),
          RawMaterialButton(
            onPressed: () {
              setState(() {
                int index = companies.length;
                Map _company = {};
                _company[ProfileConstants.COMPANY_NAME_CONTROLLER] =
                    new TextEditingController(text: '');
                _company[ProfileConstants.COMPANY_POSITION_CONTROLLER] =
                    new TextEditingController(text: '');
                _company[ProfileConstants.COMPANY_LOCATION_CONTROLLER] =
                    new TextEditingController(text: '');
                _company[ProfileConstants.COMPANY_IS_CURRENT] = false;
                _company[ProfileConstants.COMPANY_EMPLOYE_TYPE] = null;
                _company[ProfileConstants.COMPANY_FROM] = null;
                _company[ProfileConstants.COMPANY_TO] = null;
                companies.add(_company);
                _professional_listKey.currentState
                    .insertItem(index, duration: Duration(milliseconds: 500));
              });
            },
            child: new Icon(
              Icons.add,
              color: Colors.white,
              size: 18.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.blue,
            padding: const EdgeInsets.all(0.0),
          ),
          Expanded(
              child: Divider(
            color: Colors.black,
          ))
        ])
      ],
    );
  }

  Widget _addJob(int index, {Map company = null, bool remove = false}) {
    return Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(child: Divider(color: Colors.black)),
                RawMaterialButton(
                  onPressed: () {
                    setState(() {
                      AnimatedListRemovedItemBuilder builder =
                          (context, animation) {
                        // A method to build the Card widget.
                        return new Container();
                      };
                      _professional_listKey.currentState
                          .removeItem(index, builder);
                      Map item = companies.removeAt(index);
                    });
                  },
                  child: new Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  shape: new CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.red,
                  padding: const EdgeInsets.all(0.0),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
              child: Container(
                  child: _textwithtap("Organization name",
                      readonly: true,
                      ctr: companies[index]
                          [ProfileConstants.COMPANY_NAME_CONTROLLER], tap: () {
                final r = Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AutoCompleteScreen(
                      lst: ["Amazon", "Tia tech", "Sterlite Tech"],
                      hint: "Search organization name",
                      textctrl: (String s) => {},
                    ),
                  ),
                );
                r.then((r) {
                  String s = r as String;
                  setState(() {
                    companies[index][ProfileConstants.COMPANY_NAME_CONTROLLER]
                        .text = s;
                  });
                });
              })),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 5),
                        child: _genericDropdown(
                          DropdownButtonHideUnderline(
                              child: DropdownButton<Emp_type>(
                            value: companies[index]
                                [ProfileConstants.COMPANY_EMPLOYE_TYPE],
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 25,
                            elevation: 3,
                            hint: Text("Employement Type"),
                            style: TextStyle(color: Colors.black),
                            onChanged: (Emp_type newValue) {
                              setState(() {
                                companies[index][ProfileConstants
                                    .COMPANY_EMPLOYE_TYPE] = newValue;
                              });
                            },
                            items: Emp_type.values
                                .map<DropdownMenuItem<Emp_type>>(
                                    (Emp_type value) {
                              return DropdownMenuItem<Emp_type>(
                                value: value,
                                child: Text(Profile.Emp_type_values[value]),
                              );
                            }).toList(),
                          )),
                        )))
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
              child: Container(
                  child: _textwithtap("Position",
                      readonly: true,
                      ctr: companies[index]
                          [ProfileConstants.COMPANY_POSITION_CONTROLLER],
                      tap: () {
                final r = Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AutoCompleteScreen(
                      lst: [
                        "Product Manager",
                        "Brand Manager",
                        "Operation Manager"
                      ],
                      hint: "Search position",
                      textctrl: (String s) => {},
                    ),
                  ),
                );
                r.then((r) {
                  String s = r as String;
                  setState(() {
                    companies[index]
                            [ProfileConstants.COMPANY_POSITION_CONTROLLER]
                        .text = s;
                  });
                });
              })),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
              child: Container(
                  child: _textwithtap("Location",
                      ctr: companies[index]
                          [ProfileConstants.COMPANY_LOCATION_CONTROLLER],
                      readonly: true, tap: () {
                final r = Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AutoCompleteScreen(
                      lst: ["Chennai", "Bangalore", "Mumbai"],
                      hint: "Search location",
                      textctrl: (String s) => {},
                    ),
                  ),
                );
                r.then((r) {
                  String s = r as String;
                  setState(() {
                    companies[index]
                            [ProfileConstants.COMPANY_LOCATION_CONTROLLER]
                        .text = s;
                  });
                });
              })),
            ),
            CheckboxListTile(
              title: Text("Current organization"),
              value:
                  companies[index][ProfileConstants.COMPANY_IS_CURRENT] == null
                      ? false
                      : companies[index][ProfileConstants.COMPANY_IS_CURRENT],
              onChanged: (newValue) {
                setState(() {
                  companies[index][ProfileConstants.COMPANY_IS_CURRENT] =
                      newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 5.0, right: 5.0),
                    width: 150,
                    child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 2.0,
                        shadowColor: Color(0xff000000),
                        child: Container(
                            padding: EdgeInsets.only(left: 20),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                              value: companies[index]
                                  [ProfileConstants.COMPANY_FROM],
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 25,
                              elevation: 3,
                              hint: Text("From"),
                              style: TextStyle(color: Colors.black),
                              onChanged: (String newValue) {
                                setState(() {
                                  companies[index]
                                          [ProfileConstants.COMPANY_FROM] =
                                      newValue;
                                });
                              },
                              items: Profile.years
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ))))),
                Container(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 5.0, right: 5.0),
                    width: 150,
                    child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 2.0,
                        shadowColor: Color(0xff000000),
                        child: Container(
                            padding: EdgeInsets.only(left: 20),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                              value: companies[index]
                                  [ProfileConstants.COMPANY_TO],
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 25,
                              elevation: 3,
                              hint: Text("To"),
                              style: TextStyle(color: Colors.black),
                              onChanged: (String newValue) {
                                setState(() {
                                  companies[index]
                                      [ProfileConstants.COMPANY_TO] = newValue;
                                });
                              },
                              items: Profile.years
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ))))),
              ],
            ),
          ],
        ));
  }

  Widget _textwithtap(String _placeholder,
      {Function tap, TextEditingController ctr, bool readonly = false}) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 2.0,
      shadowColor: Color(0xff000000),
      child: TextFormField(
          onTap: () {
            tap();
          },
          controller: ctr,
          readOnly: readonly,
          obscureText: false,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(left: 35, bottom: 5, top: 5, right: 15),
            border: InputBorder.none,
            labelText: _placeholder,
          )), //Textfiled
    );
  }

  Widget _textwithonChange(String _placeholder,
      {Function changed, TextEditingController ctr, bool readonly = false}) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 2.0,
      shadowColor: Color(0xff000000),
      child: TextFormField(
          onChanged: (String value) {
            changed(value);
          },
          controller: ctr,
          readOnly: readonly,
          obscureText: false,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(left: 35, bottom: 5, top: 5, right: 15),
            border: InputBorder.none,
            labelText: _placeholder,
          )), //Textfiled
    );
  }

  Widget _text(String _placeholder,
      {TextEditingController ctr, bool readonly = false}) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 2.0,
      shadowColor: Color(0xff000000),
      child: TextFormField(
          onTap: () {},
          controller: ctr,
          readOnly: readonly,
          obscureText: false,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(left: 35, bottom: 5, top: 5, right: 15),
            border: InputBorder.none,
            labelText: _placeholder,
          )), //Textfiled
    );
  }

  Widget _genericDropdown(
    Widget dropdown,
  ) {
    return Material(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        elevation: 2.0,
        shadowColor: Color(0xff000000),
        child: Container(padding: EdgeInsets.only(left: 20), child: dropdown));
  }

  Widget _educational() {
    return Column(
      children: <Widget>[
        AnimatedList(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            key: _educational_listKey,
            initialItemCount: colleges.length,
            itemBuilder:
                (BuildContext context, int index, Animation animation) {
              return FadeTransition(
                  opacity: animation,
                  child: ListTile(
                    title: _addCollege(index),
                  ));
            }),
        Row(children: <Widget>[
          Expanded(
              child: Divider(
            color: Colors.black,
          )),
          RawMaterialButton(
            onPressed: () {
              int _index = colleges.length;
              Map _college = {};
              _college[ProfileConstants.COLLEGE_NAME_CONTROLLER] =
                  new TextEditingController(text: '');
              _college[ProfileConstants.COLLEGE_FIELD_OF_STUDY_CONTROLLER] =
                  new TextEditingController(text: '');
              _college[ProfileConstants.COLLEGE_FROM] = null;
              _college[ProfileConstants.COLLEGE_TO] = null;
              _college[ProfileConstants.COLLEGE_DEGREE] =
                  new TextEditingController(text: '');
              _college[ProfileConstants.COLLEGE_COURSE_TYPE] = null;
              ;

              colleges.add(_college);

              _educational_listKey.currentState
                  .insertItem(_index, duration: Duration(milliseconds: 500));
            },
            child: new Icon(
              Icons.add,
              color: Colors.white,
              size: 18.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.blue,
            padding: const EdgeInsets.all(0.0),
          ),
          Expanded(
              child: Divider(
            color: Colors.black,
          ))
        ])
      ],
    );
  }

  Widget _addCollege(int index) {
    return Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(child: Divider(color: Colors.black)),
                RawMaterialButton(
                  onPressed: () {
                    AnimatedListRemovedItemBuilder builder =
                        (context, animation) {
                      // A method to build the Card widget.
                      return new Container();
                    };
                    _educational_listKey.currentState
                        .removeItem(index, builder);
                    colleges.removeAt(index);
                  },
                  child: new Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  shape: new CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.red,
                  padding: const EdgeInsets.all(0.0),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
              child: Container(
                  child: _textwithtap("College name",
                      ctr: colleges[index]
                          [ProfileConstants.COLLEGE_NAME_CONTROLLER],
                      readonly: true, tap: () {
                final r = Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AutoCompleteScreen(
                      lst: ["Chennai", "Bangalore", "Mumbai"],
                      hint: "Search location",
                      textctrl: (String s) => {},
                    ),
                  ),
                );
                r.then((r) {
                  String s = r as String;
                  setState(() {
                    colleges[index][ProfileConstants.COLLEGE_NAME_CONTROLLER]
                        .text = s;
                  });
                });
              })),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
              child: Container(
                  child: _textwithtap("Degree",
                      ctr: colleges[index][ProfileConstants.COLLEGE_DEGREE],
                      readonly: true, tap: () {
                final r = Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AutoCompleteScreen(
                      lst: ["Chennai", "Bangalore", "Mumbai"],
                      hint: "Search location",
                      textctrl: (String s) => {},
                    ),
                  ),
                );
                r.then((r) {
                  String s = r as String;
                  setState(() {
                    colleges[index][ProfileConstants.COLLEGE_DEGREE].text = s;
                  });
                });
              })),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
              child: Container(
                  child: _textwithtap("Field of study",
                      ctr: colleges[index]
                          [ProfileConstants.COLLEGE_FIELD_OF_STUDY_CONTROLLER],
                      readonly: true, tap: () {
                final r = Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AutoCompleteScreen(
                      lst: ["Chennai", "Bangalore", "Mumbai"],
                      hint: "Search location",
                      textctrl: (String s) => {},
                    ),
                  ),
                );
                r.then((r) {
                  String s = r as String;
                  setState(() {
                    colleges[index]
                            [ProfileConstants.COLLEGE_FIELD_OF_STUDY_CONTROLLER]
                        .text = s;
                  });
                });
              })),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 5),
                        child: _genericDropdown(
                          DropdownButtonHideUnderline(
                              child: DropdownButton<Course_type>(
                            value: colleges[index]
                                [ProfileConstants.COLLEGE_COURSE_TYPE],
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 25,
                            elevation: 3,
                            hint: Text("Course Type"),
                            style: TextStyle(color: Colors.black),
                            onChanged: (Course_type newValue) {
                              setState(() {
                                colleges[index]
                                        [ProfileConstants.COLLEGE_COURSE_TYPE] =
                                    newValue;
                              });
                            },
                            items: Course_type.values
                                .map<DropdownMenuItem<Course_type>>(
                                    (Course_type value) {
                              return DropdownMenuItem<Course_type>(
                                value: value,
                                child: Text(Profile.Course_type_values[value]),
                              );
                            }).toList(),
                          )),
                        )))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 5.0, right: 5.0),
                    width: 150,
                    child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 2.0,
                        shadowColor: Color(0xff000000),
                        child: Container(
                            padding: EdgeInsets.only(left: 20),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                              value: colleges[index]
                                  [ProfileConstants.COLLEGE_FROM],
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 25,
                              elevation: 3,
                              hint: Text("From"),
                              style: TextStyle(color: Colors.black),
                              onChanged: (String newValue) {
                                setState(() {
                                  colleges[index]
                                          [ProfileConstants.COLLEGE_FROM] =
                                      newValue;
                                });
                              },
                              items: Profile.years
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ))))),
                Container(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 5.0, right: 5.0),
                    width: 150,
                    child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 2.0,
                        shadowColor: Color(0xff000000),
                        child: Container(
                            padding: EdgeInsets.only(left: 20),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                              value: colleges[index]
                                  [ProfileConstants.COLLEGE_TO],
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 25,
                              elevation: 3,
                              hint: Text("To"),
                              style: TextStyle(color: Colors.black),
                              onChanged: (String newValue) {
                                setState(() {
                                  colleges[index][ProfileConstants.COLLEGE_TO] =
                                      newValue;
                                });
                              },
                              items: Profile.years
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ))))),
              ],
            ),
          ],
        ));
  }

  Widget _additionalInfo(BuildContext context) {
    return ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Card(
              child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Have you handled a team?"),
                        Row(children: [
                          Text("Yes"),
                          RadioGroup(
                            value: Yes_No_type.Yes,
                            groupValue: handledTeamState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                handledTeamState = value;
                              });
                            },
                          ),
                          Text("No"),
                          RadioGroup(
                            value: Yes_No_type.No,
                            groupValue: handledTeamState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                handledTeamState = value;
                              });
                            },
                          )
                        ])
                      ]))),
          Card(
              child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Are you willing to work 6 days a week?"),
                        Row(children: [
                          Text("Yes"),
                          RadioGroup(
                            value: Yes_No_type.Yes,
                            groupValue: sixDaysState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                sixDaysState = value;
                              });
                            },
                          ),
                          Text("No"),
                          RadioGroup(
                            value: Yes_No_type.No,
                            groupValue: sixDaysState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                sixDaysState = value;
                              });
                            },
                          )
                        ])
                      ]))),
          Card(
              child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Are you willing to relocate?"),
                        Row(children: [
                          Text("Yes"),
                          RadioGroup(
                            value: Yes_No_type.Yes,
                            groupValue: relocateState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                relocateState = value;
                              });
                            },
                          ),
                          Text("No"),
                          RadioGroup(
                            value: Yes_No_type.No,
                            groupValue: relocateState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                relocateState = value;
                              });
                            },
                          )
                        ])
                      ]))),
          Card(
              child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                            "Are you open to joining an early stage start-up?"),
                        Row(children: [
                          Text("Yes"),
                          RadioGroup(
                            value: Yes_No_type.Yes,
                            groupValue: earlyStartupState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                earlyStartupState = value;
                              });
                            },
                          ),
                          Text("No"),
                          RadioGroup(
                            value: Yes_No_type.No,
                            groupValue: earlyStartupState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                earlyStartupState = value;
                              });
                            },
                          )
                        ])
                      ]))),
          Card(
              child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Willingness to Travel?"),
                        Row(children: [
                          Text("No"),
                          RadioGroup(
                            value: Travel_type.No,
                            groupValue: willingnessTravelState,
                            onChange: (Travel_type value) {
                              setState(() {
                                willingnessTravelState = value;
                              });
                            },
                          ),
                          Text("Occasional"),
                          RadioGroup(
                            value: Travel_type.Occasional,
                            groupValue: willingnessTravelState,
                            onChange: (Travel_type value) {
                              setState(() {
                                willingnessTravelState = value;
                              });
                            },
                          ),
                          Text("Extensive"),
                          RadioGroup(
                            value: Travel_type.Extensive,
                            groupValue: willingnessTravelState,
                            onChange: (Travel_type value) {
                              setState(() {
                                willingnessTravelState = value;
                              });
                            },
                          )
                        ])
                      ]))),
          Card(
              child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Work Permit for USA"),
                        Row(children: [
                          Text("Yes"),
                          RadioGroup(
                            value: Yes_No_type.Yes,
                            groupValue: usaPermitState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                usaPermitState = value;
                              });
                            },
                          ),
                          Text("No"),
                          RadioGroup(
                            value: Yes_No_type.No,
                            groupValue: usaPermitState,
                            onChange: (Yes_No_type value) {
                              setState(() {
                                usaPermitState = value;
                              });
                            },
                          )
                        ])
                      ]))),
        ]);
  }

  Widget _languageWidget(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext ctxt, int index) {
                return Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(children: <Widget>[
                          Expanded(
                              child: TextField(
                            decoration:
                                InputDecoration(hintText: "Search language"),
                            controller: languages[index]
                                [ProfileConstants.LANGUAGE_NAME],
                            readOnly: true,
                            onTap: () {
                              final r = Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AutoCompleteScreen(
                                    lst: ["Tamil", "English", "Hindi"],
                                    hint: "Search Language",
                                    textctrl: (String s) => {},
                                  ),
                                ),
                              );
                              r.then((r) {
                                String s = r as String;
                                setState(() {
                                  languages[index]
                                          [ProfileConstants.LANGUAGE_NAME]
                                      .text = s;
                                });
                              });
                            },
                          )),
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                Map item = languages.removeAt(index);
                              });
                            },
                            child: new Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 20.0,
                            ),
                            shape: new CircleBorder(),
                            elevation: 2.0,
                            fillColor: Colors.red,
                            padding: const EdgeInsets.all(0.0),
                          )
                        ]),
                        CheckboxListTile(
                          title: Text("Speak"),
                          value: languages[index]
                                      [ProfileConstants.LANGUAGE_SPEAK] ==
                                  null
                              ? false
                              : languages[index]
                                  [ProfileConstants.LANGUAGE_SPEAK],
                          onChanged: (newValue) {
                            setState(() {
                              languages[index]
                                  [ProfileConstants.LANGUAGE_SPEAK] = newValue;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                        CheckboxListTile(
                          title: Text("Read"),
                          value: languages[index]
                                      [ProfileConstants.LANGUAGE_READ] ==
                                  null
                              ? false
                              : languages[index]
                                  [ProfileConstants.LANGUAGE_READ],
                          onChanged: (newValue) {
                            setState(() {
                              languages[index][ProfileConstants.LANGUAGE_READ] =
                                  newValue;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                        CheckboxListTile(
                          title: Text("Write"),
                          value: languages[index]
                                      [ProfileConstants.LANGUAGE_WRITE] ==
                                  null
                              ? false
                              : languages[index]
                                  [ProfileConstants.LANGUAGE_WRITE],
                          onChanged: (newValue) {
                            setState(() {
                              languages[index]
                                  [ProfileConstants.LANGUAGE_WRITE] = newValue;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ],
                    ));
              }),
          Row(children: <Widget>[
            Expanded(
                child: Divider(
              color: Colors.black,
            )),
            RawMaterialButton(
              onPressed: () {
                setState(() {
                  int index = languages.length;
                  Map _language = {};
                  _language[ProfileConstants.LANGUAGE_NAME] =
                      new TextEditingController(text: '');
                  _language[ProfileConstants.LANGUAGE_READ] = false;
                  _language[ProfileConstants.LANGUAGE_WRITE] = false;
                  _language[ProfileConstants.LANGUAGE_SPEAK] = false;
                  languages.add(_language);
                });
              },
              child: new Icon(
                Icons.add,
                color: Colors.white,
                size: 18.0,
              ),
              shape: new CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.blue,
              padding: const EdgeInsets.all(0.0),
            ),
            Expanded(
                child: Divider(
              color: Colors.black,
            ))
          ])
        ]),
      ),
    );
  }

  Widget _stepper(BuildContext context) {
    return Stepper(
      physics: ClampingScrollPhysics(),
      currentStep: _currentStep,
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Container(
            padding: EdgeInsets.only(top: 30),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _currentStep != 0
                    ? InkWell(
                        onTap: () {
                          onStepCancel();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffe0e0e0),
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 3),
                                    blurRadius: 6,
                                    color: const Color(0xff000000)
                                        .withOpacity(0.16),
                                  )
                                ]),
                            padding: EdgeInsets.only(
                                left: 30, bottom: 10, top: 10, right: 30),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                    size: 15.0,
                                  ),
                                  Text(
                                    "Previous",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  )
                                ])))
                    : new Container(),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: InkWell(
                        onTap: () {
                          onStepContinue();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 3),
                                    blurRadius: 6,
                                    color: const Color(0xff000000)
                                        .withOpacity(0.16),
                                  )
                                ]),
                            padding: EdgeInsets.only(
                                left: 30, bottom: 10, top: 10, right: 30),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Next",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 15.0,
                                  )
                                ])))),
              ],
            ));
      },
      onStepContinue: () {
        if (_currentStep >= 5) return;
        setState(() {
          _currentStep += 1;
        });
      },
      onStepCancel: () {
        if (_currentStep <= 0) return;
        setState(() {
          _currentStep -= 1;
        });
      },
      onStepTapped: (step) {
        setState(() {
          _currentStep = step;
        });
      },
      steps: <Step>[
        Step(
          title: Text('Personal'),
          content: _personalForm(),
        ),
        Step(
          title: Text('Educational details'),
          content: _educational(),
        ),
        Step(
          title: Text('Career'),
          content: _profession(),
        ),
        Step(
          title: Text('Resume'),
          content: new Container(),
        ),
        Step(
          title: Text('Languages'),
          content: _languageWidget(context),
        ),
        Step(
          title: Text('Additional Information'),
          content: _additionalInfo(context),
        ),
      ],
    );
  }
}

class RadioGroup extends StatelessWidget {
  final groupValue;
  final value;
  final onChange;

  const RadioGroup({this.groupValue, this.value, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Radio(
      value: value,
      groupValue: groupValue,
      onChanged: (value) {
        onChange(value);
      },
    );
  }
}
