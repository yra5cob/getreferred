import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:getreferred/widget/CustomButton.dart';
import 'package:getreferred/widget/CustomTextField.dart';

import 'package:getreferred/profileCreationPage.dart';

import 'package:email_validator/email_validator.dart';

final globalKey = GlobalKey<ScaffoldState>();
final GlobalKey<FormState> _form = GlobalKey<FormState>();
final TextEditingController _pass = TextEditingController();
final TextEditingController _confirmPass = TextEditingController();

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  String _email;
  String _password;
  bool _autoValidate;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;
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
        body: ListView(
          children: <Widget>[
            Stack(children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.40,
              ),
              Transform.translate(
                offset: Offset(20, locationAnimation.value),
                child: Container(
                  child: Text(
                    "Here's\nyour first\nstep with\nus!",
                    style: TextStyle(
                      fontFamily: 'RobotoRegular',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000).withOpacity(opaAnimation.value),
                    ), //textstyle
                  ),
                ),
              ),
            ]),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.40,
                    padding: EdgeInsets.only(left: 30, right: 30),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Form(
                        key: _form,
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
                              validator: (input) => _passwordController.text !=
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
        ));
  }

  void _validateLoginInput() async {
    final FormState form = _form.currentState;
    if (_form.currentState.validate()) {
      form.save();
      _register();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _register() async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: _email,
      password: _password,
    ))
        .user;
    if (user != null) {
    } else {}
  }
}
