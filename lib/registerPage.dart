import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getreferred/LoginPage.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/helper/sizeConfig.dart';
import 'package:getreferred/model/ProfileModel.dart';
import 'package:getreferred/widget/CustomButton.dart';
import 'package:getreferred/widget/CustomDialog.dart';
import 'package:getreferred/widget/CustomTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getreferred/profileCreationPage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

final registerGlobalKey = GlobalKey<ScaffoldState>();
final GlobalKey<FormState> _registerForm = GlobalKey<FormState>();
final TextEditingController _pass = TextEditingController();
final TextEditingController _userNameController = TextEditingController();
final TextEditingController _confirmPass = TextEditingController();

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  String _email;
  String _uid;
  bool _loading = false;
  String _password;
  String _firstName;
  String _lastName;
  bool _autoValidate;
  final storage = new FlutterSecureStorage();
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;
  TextEditingController _firstNameCtrl;
  TextEditingController _lastNameCtrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AnimationController controller;
  Animation locationAnimation;
  Animation opaAnimation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _autoValidate = false;
    _passwordController = new TextEditingController(text: '');
    _confirmPasswordController = new TextEditingController(text: '');
    _firstNameCtrl = new TextEditingController(text: '');
    _lastNameCtrl = new TextEditingController(text: '');
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    locationAnimation = Tween<double>(begin: 30, end: 50).animate(controller);
    opaAnimation = Tween<double>(begin: 0.0, end: 1).animate(controller);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Register",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.help), color: Colors.black, onPressed: () {}),
          ],
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(40),
                    child: Text(
                      "Here's\nyour first\nstep with\nus!",
                      style: TextStyle(
                        fontFamily: 'RobotoRegular',
                        fontSize: SizeConfig.blockSizeHorizontal * 8,
                        fontWeight: FontWeight.bold,
                        color:
                            Color(0xff000000).withOpacity(opaAnimation.value),
                      ), //textstyle
                    )),
                // Stack(children: [
                //   Container(
                //     height: MediaQuery.of(context).size.height * 0.30,
                //   ),
                //   Transform.translate(
                //     offset: Offset(20, locationAnimation.value),
                //     child: Container(
                //       height: MediaQuery.of(context).size.height * 0.30,
                //       child: Text(
                //         "Here's\nyour first\nstep with\nus!",
                //         style: TextStyle(
                //           fontFamily: 'RobotoRegular',
                //           fontSize: 40,
                //           fontWeight: FontWeight.bold,
                //           color: Color(0xff000000).withOpacity(opaAnimation.value),
                //         ), //textstyle
                //       ),
                //     ),
                //   ),
                // ]),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Form(
                            key: _registerForm,
                            autovalidate: _autoValidate,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                CustomTextField(
                                  hint: "Email",
                                  validator: (input) =>
                                      EmailValidator.validate(input)
                                          ? null
                                          : "Required",
                                  onSaved: (input) {
                                    setState(() {
                                      _email = input;
                                    });
                                  },
                                ),
                                CustomTextField(
                                    hint: "First name",
                                    controller: _firstNameCtrl,
                                    validator: (input) {
                                      if (input.isEmpty) return "Required";
                                    },
                                    onSaved: (input) {
                                      setState(() {
                                        _firstName = input;
                                      });
                                    }),
                                CustomTextField(
                                    hint: "Last name",
                                    validator: (input) {
                                      if (input.isEmpty) return "Required";
                                    },
                                    controller: _lastNameCtrl,
                                    onSaved: (input) {
                                      setState(() {
                                        _lastName = input;
                                      });
                                    }),
                                CustomTextField(
                                  hint: "Password",
                                  obsecure: true,
                                  controller: _passwordController,
                                  validator: (input) =>
                                      input.isEmpty ? "Required" : null,
                                  onSaved: (input) {
                                    setState(() {
                                      _password = input;
                                    });
                                  },
                                ),
                                CustomTextField(
                                  hint: "Confirm password",
                                  obsecure: true,
                                  controller: _confirmPasswordController,
                                  validator: (input) =>
                                      _passwordController.text !=
                                              _confirmPasswordController.text
                                          ? "Password doesn't match"
                                          : null,
                                ),
                                CustomButton(
                                  label: 'Sign up',
                                  backgroundColor: Colors.green[800],
                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                  onTap: () {
                                    _validateLoginInput();
                                  },
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
            _loading
                ? Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: FractionalOffset.center,
                    padding: const EdgeInsets.only(top: 10.0),
                    child: CircularProgressIndicator())
                : Container()
          ],
        ));
  }

  void _validateLoginInput() async {
    final FormState form = _registerForm.currentState;
    if (_registerForm.currentState.validate()) {
      form.save();
      setState(() {
        _loading = true;
      });
      _register();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void addUser() {
    Map<String, dynamic> data = {
      ProfileConstants.NAME: {
        ProfileConstants.FIRST_NAME: _firstName,
        ProfileConstants.LAST_NAME: _lastName
      },
      ProfileConstants.EMAIL: _email
    };
    //check email id
    Firestore.instance
        .collection('users')
        .add(data)
        .then((DocumentReference doc) {
      Map<String, dynamic> _uid = {ProfileConstants.USERNAME: doc.documentID};
      doc.setData(_uid, merge: true);

      setState(() {
        final _profile = Provider.of<ProfileModel>(context, listen: false);
        _profile.model[ProfileConstants.USERNAME] = doc.documentID;
        _profile.model[ProfileConstants.EMAIL] = _email;
        _profile.model[ProfileConstants.NAME][ProfileConstants.FIRST_NAME] =
            _firstName;
        _profile.model[ProfileConstants.NAME][ProfileConstants.LAST_NAME] =
            _lastName;
      });
      storage
          .write(key: ProfileConstants.USERNAME, value: doc.documentID)
          .then((s) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileCreationPage(),
            ),
            ModalRoute.withName("/Home"));
      });
    });
  }

  void emailExistError() {
    setState(() {
      _loading = false;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        errorText: "Email already registered!",
        actions: <Widget>[
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.green[800], fontSize: 18),
              )),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              "Login?",
              style: TextStyle(color: Colors.green[800], fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  void _register() async {
    FirebaseUser user = null;
    try {
      user = (await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      ))
          .user;
      if (user != null) {
        addUser();
      } else {}
    } on PlatformException catch (e) {
      print(e.code);
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          emailExistError();
          break;
        case "ERROR_INVALID_EMAIL ":
          {
            print("Email in use");
          }
          break;
        case "ERROR_WEAK_PASSWORD ":
          {
            print("Email in use");
          }
          break;
        default:
          {
            //statements;
          }
          break;
      }
    }

    // if (user != null) {
    // } else {}
  }
}
