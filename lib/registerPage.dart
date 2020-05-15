import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'emailVerificationPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ReferAll/BLoc/ProfileProvider.dart';
import 'package:ReferAll/LoginPage.dart';
import 'package:ReferAll/PushNotificationManager.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/helper/UiUtilt.dart';
import 'package:ReferAll/helper/Util.dart';
import 'package:ReferAll/helper/sizeConfig.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:ReferAll/widget/CustomButton.dart';
import 'package:ReferAll/widget/CustomDialog.dart';
import 'package:ReferAll/widget/CustomTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ReferAll/profileCreationPage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldState> registerGlobalKey = GlobalKey<ScaffoldState>();
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
  PushNotificationsManager pushNotificationsManager =
      PushNotificationsManager();
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
  ProfileProvider _profileProvider;
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
    _profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
        key: registerGlobalKey,
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 70),
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: ShaderMask(
                        blendMode: BlendMode.srcATop,
                        shaderCallback: (bounds) => RadialGradient(
                          center: Alignment.center,
                          radius: 0.5,
                          colors: [Util.getColor1(), Util.getColor2()],
                          tileMode: TileMode.mirror,
                        ).createShader(bounds),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 28.0,
                          color: Colors.cyan,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Expanded(
                      child: Center(
                          child: Text(
                    "Register",
                    style: TextStyle(
                        foreground: UIUtil.getTextGradient(), fontSize: 20),
                  ))),
                  Icon(
                    Icons.arrow_downward,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
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
                                          : "Invalid email",
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

  void _register() async {
    setState(() {
      _loading = true;
    });
    pushNotificationsManager.init().then((token) {
      _profileProvider
          .registerUser(_email, _password, _firstName, _lastName, token)
          .then((value) {
        if (value["hasError"]) {
          setState(() {
            _loading = false;
          });
          switch (value["error"]) {
            case "ERROR_EMAIL_ALREADY_IN_USE":
              displayDialog(
                  "Email already in use",
                  "Provided email-id is already registered with. Please user forgot password incase you forgot your password",
                  [
                    CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        isDefaultAction: true,
                        child: new Text("Close"))
                  ]);
              break;
            case "ERROR_INVALID_EMAIL":
              {
                displayDialog("Email Id is invalid",
                    "Please check the entered email id", [
                  CupertinoDialogAction(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      isDefaultAction: true,
                      child: new Text("Close"))
                ]);
              }
              break;
            case "ERROR_WEAK_PASSWORD":
              {
                displayDialog("Weak password",
                    "Please use minimum 8 character alphanumeric password", [
                  CupertinoDialogAction(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      isDefaultAction: true,
                      child: new Text("Close"))
                ]);
              }
              break;
            default:
              {
                //statements;
              }
              break;
          }
        } else {
          _profileProvider.isEmailVerified().then((value) {
            if (value) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileCreationPage(),
                  ),
                  ModalRoute.withName("/Home"));
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmailVeificationPage(),
                  ),
                  ModalRoute.withName("/Home"));
            }
          });
        }
      });
    });
  }
}
