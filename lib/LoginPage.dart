import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:getreferred/registerPage.dart';
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
        body: Container(
            child: ListView(children: <Widget>[
          SizedBox(height: 0.0),
          Container(
            width: 250,
            height: 250,
            child: Image.asset('assets/images/logo.jpg'),
          ),
          SizedBox(height: 60.0),
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 20.0),
            child: Text(
              "Welcome!",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xff000000),
              ), //textstyle
            ),
          ), //padding
          Padding(
            padding: EdgeInsets.only(top: 5.0, left: 20.0),
            child: Text(
              "Please sign in to your account",
              style: TextStyle(
                fontFamily: 'Montserrat',
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CustomTextField(
                    hint: 'Email',
                    validator: (input) => EmailValidator.validate(input)
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
                    validator: (input) => input.isEmpty ? "*Required" : null,
                    obsecure: true,
                    onSaved: (String s) {
                      setState(() {
                        _password = s;
                      });
                    },
                  ),
                ],
              )),
          //Padding
          Container(
              margin: EdgeInsets.only(
                  top: 40.0,
                  left: MediaQuery.of(context).size.width * 0.60,
                  right: 20.0),
              width: 164,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(23),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 3),
                    blurRadius: 6,
                    color: const Color(0xff000000).withOpacity(0.16),
                  )
                ],
              ),
              child: InkWell(
                  onTap: () {
                    _validateLoginInput();
                  },
                  child: Container(
                      color: Colors.blue,
                      margin: EdgeInsets.only(right: 30.0, left: 30),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 30.0,
                            )
                          ])))), //container
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
                margin: EdgeInsets.only(left: 10, right: 10),
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
            padding: EdgeInsets.only(right: 30, left: 30),
            child: SignInButton(
              Buttons.Google,
              onPressed: () {
                final snackBar = SnackBar(content: Text('Google login'));
                globalKey.currentState.showSnackBar(snackBar);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 30, left: 30),
            child: SignInButton(
              Buttons.LinkedIn,
              onPressed: () {
                _signInWithGoogle();
              },
            ),
          )
        ]) //listview

            ), //Column
        bottomNavigationBar: BottomAppBar(
            elevation: 0,
            child: Container(
                height: 30,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
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
                                  color: Color(0xff000000),
                                )),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()),
                              );
                            },
                          )
                        ]))))); //scaffold
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
