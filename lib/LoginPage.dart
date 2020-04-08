import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:getreferred/registerPage.dart';
import 'package:getreferred/widget/CustomButton.dart';
import 'package:getreferred/widget/CustomTextField.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:getreferred/profileCreationPage.dart';

final globalKey = GlobalKey<ScaffoldState>();

final _loginFormKey = GlobalKey<FormState>();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  bool _autoValidate = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Welcome to",
                                    style: TextStyle(
                                      fontFamily: 'RobotoRegular',
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000),
                                    ), //textstyle
                                  ),
                                ), //padding
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Refer",
                                      style: TextStyle(
                                        fontFamily: 'RobotoRegular',
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ), //textstyle
                                    ),
                                    Text(
                                      "All",
                                      style: TextStyle(
                                        fontFamily: 'RobotoRegular',
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[800],
                                      ), //textstyle
                                    ),
                                  ],
                                ),
                              ])),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 5.0, bottom: 5),
                                child: Text(
                                  "Please sign in to your account",
                                  style: TextStyle(
                                    fontFamily: 'RobotoRegular',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w200,
                                    color: Color(0xff000000),
                                  ), //textstyle
                                ),
                              ), //padding
                              Form(
                                  key: _loginFormKey,
                                  autovalidate: _autoValidate,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      CustomTextField(
                                        hint: 'Email',
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        validator: (input) =>
                                            EmailValidator.validate(input)
                                                ? null
                                                : "Enter a valid email.",
                                        onSaved: (String s) {
                                          setState(() {
                                            _email = s;
                                          });
                                        },
                                      ),
                                      CustomTextField(
                                        hint: 'Password',
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        validator: (input) =>
                                            input.isEmpty ? "*Required" : null,
                                        obsecure: true,
                                        onSaved: (String s) {
                                          setState(() {
                                            _password = s;
                                          });
                                        },
                                      ),
                                    ],
                                  )),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: CustomButton(
                                    backgroundColor: Colors.green[800],
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    icon: Icons.arrow_forward_ios,
                                    label: "Login",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileCreationPage()),
                                      );
                                      //_validateLoginInput();
                                    },
                                  ))
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.all(30),
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: Row(children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Text("OR"),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.black,
                                    ),
                                  )
                                ]),
                              ),
                              Container(
                                constraints:
                                    BoxConstraints(minWidth: double.infinity),
                                child: CustomButton(
                                  textColor: Colors.blue,
                                  backgroundColor: Colors.white,
                                  borderColor: Colors.white,
                                  label: "Sign in with Google",
                                  image: Image.asset(
                                      "assets/images/google-logo.png"),
                                  onTap: () {
                                    _signInWithGoogle();
                                  },
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 30, bottom: 0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Not a member yet?",
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300,
                                            color: Color(0xff000000),
                                          )),
                                      InkWell(
                                        child: Text(" Register",
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[800],
                                            )),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterPage()),
                                          );
                                        },
                                      )
                                    ]),
                              )
                            ],
                          )),
                    ]) //listview

                ))); //scaffold
  }

  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        // _success = true;
        // _userID = user.uid;
      } else {
        // _success = false;
      }
    });
  }

  void _signInWithEmailAndPassword() async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: _email,
      password: _password,
    ))
        .user;
    if (user != null) {
      setState(() {
        // _success = true;
        // _userEmail = user.email;
        print("object");
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileCreationPage()),
      );
    } else {
      print("Failed");
      // _success = false;
    }
  }

  void _validateLoginInput() async {
    final FormState form = _loginFormKey.currentState;
    if (_loginFormKey.currentState.validate()) {
      form.save();
      setState(() {
        // _loading = true;
      });
      _signInWithEmailAndPassword();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
