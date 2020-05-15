import 'package:ReferAll/PushNotificationManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:ReferAll/BLoc/ProfileProvider.dart';
import 'package:ReferAll/ForgotPassword.dart';
import 'package:ReferAll/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/helper/UiUtilt.dart';
import 'package:ReferAll/helper/sizeConfig.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:ReferAll/registerPage.dart';
import 'package:ReferAll/widget/CustomButton.dart';
import 'package:ReferAll/widget/CustomDialog.dart';
import 'package:ReferAll/widget/CustomTextField.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ReferAll/profileCreationPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final GlobalKey<ScaffoldState> _loginGlobalKey = GlobalKey<ScaffoldState>();

final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  PushNotificationsManager pushNotificationsManager =
      PushNotificationsManager();
  String _email;
  bool _loading;
  String _password;
  bool _autoValidate = false;
  ProfileProvider profileProvider;
  AnimationController controller;
  Animation colorAnimation;
  final storage = new FlutterSecureStorage();
  final quots = [
    "\"No one has ever become poor by giving (Referring)\"",
    "There is no exercise better for the heart than reaching down and lifting people up",
    "Help from a stranger is better than sympathy from a relative",
    "Helping others is the secret sauce to a happy life.",
    "If we always helped one another, no one would need luck"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    colorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.green[800],
    ).animate(controller);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    SizeConfig().init(context);
    return Scaffold(
        key: _loginGlobalKey,
        body: Stack(children: [
          Container(
              constraints: BoxConstraints(
                maxHeight: SizeConfig.screenHeight,
                maxWidth: SizeConfig.screenWidth,
              ),
              padding: EdgeInsets.all(20),
              child: Container(
                  child: Container(
                child: ListView(
                  children: <Widget>[
                    Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeHorizontal * 8,
                            child: Image.asset("assets/images/logo.png"),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          Container(
                            child: Text(
                              "Welcome to",
                              style: GoogleFonts.lato(
                                fontSize: SizeConfig.blockSizeHorizontal * 8,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000),
                              ), //GoogleFonts.lato
                            ),
                          ), //padding
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Refer",
                                style: GoogleFonts.lato(
                                  fontSize: SizeConfig.blockSizeHorizontal * 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ), //GoogleFonts.lato
                              ),
                              Text(
                                "All",
                                style: GoogleFonts.lato(
                                  fontSize: SizeConfig.blockSizeHorizontal * 8,
                                  fontWeight: FontWeight.bold,
                                  foreground: UIUtil.getTextGradient(),
                                ), //GoogleFonts.lato
                              ),
                            ],
                          ),
                        ])),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 5.0, bottom: 5),
                          child: Text(
                            "Please sign in to your account",
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000),
                            ), //GoogleFonts.lato
                          ),
                        ), //padding
                        Form(
                            key: _loginFormKey,
                            autovalidate: _autoValidate,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                CustomTextField(
                                  fontSize: SizeConfig.blockSizeHorizontal * 3,
                                  hint: 'Email',
                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                  validator: (input) {
                                    return EmailValidator.validate(input)
                                        ? null
                                        : "Enter a valid email.";
                                  },
                                  onSaved: (String s) {
                                    setState(() {
                                      _email = s;
                                    });
                                  },
                                ),
                                CustomTextField(
                                  fontSize: SizeConfig.blockSizeHorizontal * 3,
                                  hint: 'Password',
                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                  validator: (input) {
                                    return input.isEmpty ? "*Required" : null;
                                  },
                                  obsecure: true,
                                  onSaved: (String s) {
                                    _password = s;
                                  },
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: CustomButton(
                              fontSize: SizeConfig.blockSizeHorizontal * 3,
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              icon: Icons.arrow_forward_ios,
                              label: "Login",
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           ProfileCreationPage()),
                                // );
                                _validateLoginInput();
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
                          constraints:
                              BoxConstraints(minWidth: double.infinity),
                          child: CustomButton(
                            fontSize: SizeConfig.blockSizeHorizontal * 3,
                            textColor: Colors.blue,
                            backgroundColor: Colors.white,
                            borderColor: Colors.white,
                            label: "Sign in with Google",
                            image: Image.asset("assets/images/google-logo.png"),
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
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff000000),
                                    )),
                                InkWell(
                                  child: Text(" Register",
                                      style: GoogleFonts.lato(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          foreground:
                                              UIUtil.getTextGradient())),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegisterPage()),
                                    );
                                  },
                                )
                              ]),
                        )
                      ],
                    ))
                  ],
                ),
              ))),
          if (_loading)
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              padding: EdgeInsets.only(left: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                      child: Image.asset("assets/images/logo.png"),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          quots[4],
                          style: GoogleFonts.lato(
                              fontStyle: FontStyle.normal,
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey),
                        ))
                      ],
                    ),
                    CircularProgressIndicator()
                  ],
                ),
              ),
            )
        ]));
    //   if (_loading)
    //     Container(
    //       height: MediaQuery.of(context).size.height,
    //       width: MediaQuery.of(context).size.width,
    //       color: Colors.white,
    //       padding: EdgeInsets.only(left: 20),
    //       child: Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             SizedBox(
    //               height: 100,
    //               child: Image.asset("assets/images/logo.png"),
    //             ),
    //             SizedBox(
    //               height: 40,
    //             ),
    //             Row(
    //               children: <Widget>[
    //                 Expanded(
    //                     child: Text(
    //                   quots[4],
    //                   style: GoogleFonts.lato(
    //                       fontStyle: FontStyle.normal,
    //                       fontSize: 20,
    //                       fontWeight: FontWeight.w300,
    //                       color: Colors.grey),
    //                 ))
    //               ],
    //             )
    //           ],
    //         ),
    //       ),
    //     )
    // ])); //scaffold
  }

  void _signInWithGoogle() async {
    setState(() {
      _loading = true;
    });
    String token = await pushNotificationsManager.init();
    var data = await profileProvider.signInWithGoogle(token);

    if (!data['hasError']) {
      if (data['signUp']) {
        Get.off(ProfileCreationPage());
      } else {
        Get.off(Home());
      }
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  void displayDialog(String title, String message, List<Widget> actions) {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: actions,
      ),
    );
  }

  void _signInWithEmailAndPassword() async {
    String token = await pushNotificationsManager.init();
    var data = await profileProvider.signInWithEmailAndPassword(
        _email, _password, token);
    if (!data['hasError']) {
      Get.off(Home());
    } else {
      switch (data['error']) {
        case "ERROR_WRONG_PASSWORD":
          {
            setState(() {
              _loading = false;
            });
            displayDialog("Password incorrect",
                "Please try again or use forget password", [
              CupertinoDialogAction(
                  onPressed: () {
                    Get.to(ForgotPassword());
                  },
                  isDefaultAction: true,
                  child: new Text("Forgot Password")),
              CupertinoDialogAction(
                  onPressed: () {
                    Get.back();
                  },
                  isDefaultAction: true,
                  child: new Text("Close"))
            ]);
          }
          break;
        case "ERROR_USER_NOT_FOUND":
          {
            setState(() {
              _loading = false;
            });
            displayDialog("Email not registered",
                "Please check the email address or register", [
              CupertinoDialogAction(
                  onPressed: () {
                    Get.to(RegisterPage());
                  },
                  isDefaultAction: true,
                  child: new Text("Register")),
              CupertinoDialogAction(
                  onPressed: () {
                    Get.back();
                  },
                  isDefaultAction: true,
                  child: new Text("Close"))
            ]);
          }
          break;
      }
    }
  }

  void wrongPasswordError() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        errorText: "Wrong password!",
        actions: <Widget>[
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.lato(color: Colors.green[800], fontSize: 18),
              )),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgotPassword()),
              );
            },
            child: Text(
              "Forgot password?",
              style: GoogleFonts.lato(color: Colors.green[800], fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  void notRegisteredError() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        errorText: "Email not registered!",
        actions: <Widget>[
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.lato(color: Colors.cyan, fontSize: 18),
              )),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage()),
              );
            },
            child: Text(
              "Register",
              style: GoogleFonts.lato(color: Colors.cyan, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  void _validateLoginInput() async {
    final FormState form = _loginFormKey.currentState;
    if (_loginFormKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });
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
