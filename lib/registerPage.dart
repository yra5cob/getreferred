import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

class _RegisterPageState extends State<RegisterPage> {
  String _email;
  String _password;
  bool _autoValidate;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _autoValidate = false;
    _passwordController = new TextEditingController(text: '');
    _confirmPasswordController = new TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        body: ListView(
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
                      'Register',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.help),
                      color: Colors.black,
                      onPressed: () {},
                    ),
                  ],
                )),
            Container(
              width: 250,
              height: MediaQuery.of(context).size.height * 0.20,
              child: Image.asset('assets/images/image_01.png'),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.60,
                    padding: EdgeInsets.only(left: 30, right: 30),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Form(
                        key: _form,
                        autovalidate: _autoValidate,
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
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
                                  validator: (input) =>
                                      _passwordController.text !=
                                              _confirmPasswordController.text
                                          ? "Password doesn't match"
                                          : null,
                                ),
                                _buildSubmitButton(context)
                              ],
                            )
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

  Widget _buildSubmitButton(BuildContext _context) {
    return Padding(
        padding: EdgeInsets.only(top: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
                onTap: () {
                  _validateLoginInput();
                  // Navigator.push(
                  //   _context,
                  //   MaterialPageRoute(
                  //       builder: (context) => ProfileCreationPage()),
                  // );
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 3),
                            blurRadius: 6,
                            color: const Color(0xff000000).withOpacity(0.16),
                          )
                        ]),
                    padding: EdgeInsets.only(
                        left: 30, bottom: 10, top: 10, right: 30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sign up",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 30.0,
                          )
                        ])))
          ],
        ));
  }
}

Widget _buildEmailField() {
  return Padding(
      padding: EdgeInsets.only(top: 30, left: 10.0, right: 10.0),
      child: Material(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        elevation: 2.0,
        shadowColor: Color(0xff000000),
        child: TextField(
            obscureText: false,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 35, bottom: 5, top: 5, right: 15),
              border: InputBorder.none,
              labelText: 'Email',
            )), //Textfiled
      ) //Material
      );
}

Widget _buildPasswordField() {
  return Padding(
      padding: EdgeInsets.only(top: 30, left: 10.0, right: 10.0),
      child: Material(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        elevation: 2.0,
        shadowColor: Color(0xff000000),
        child: TextFormField(
            controller: _pass,
            obscureText: true,
            validator: (val) {
              if (val.isEmpty) return 'Password is empty';
              return null;
            },
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 35, bottom: 5, top: 5, right: 15),
              border: InputBorder.none,
              labelText: 'Password',
            )), //Textfiled
      ) //Material
      );
}

Widget _buildConfirmPasswordField() {
  return Padding(
      padding: EdgeInsets.only(top: 30, left: 10.0, right: 10.0),
      child: Material(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        elevation: 2.0,
        shadowColor: Color(0xff000000),
        child: TextFormField(
            controller: _confirmPass,
            obscureText: true,
            validator: (val) {
              if (val.isEmpty) return 'Empty';
              if (val != _pass.text) return 'Password does not match!';
              return null;
            },
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 35, bottom: 5, top: 5, right: 15),
              border: InputBorder.none,
              labelText: 'Confirm password',
            )), //Textfiled
      ) //Material
      );
}
