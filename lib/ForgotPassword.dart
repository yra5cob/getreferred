import 'package:ReferAll/BLoc/ProfileProvider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ReferAll/LoginPage.dart';
import 'package:ReferAll/widget/CustomButton.dart';
import 'package:ReferAll/widget/CustomDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:ReferAll/widget/CustomTextField.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final _forgotPasswordFormKey = GlobalKey<FormState>();

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController;
  bool loading = false;
  ProfileProvider profileProvider;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = new TextEditingController();
  }

  void mailSent() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        errorText: "Password reset link sent!",
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
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

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text("Forgot Password"),
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.cyan,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Center(
                  child: Form(
                    key: _forgotPasswordFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Please enter your registered Email address",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .merge(GoogleFonts.lato(
                                    fontWeight: FontWeight.w600,
                                  ))),
                        ),
                        CustomTextField(
                          hint: "Email",
                          controller: _emailController,
                          validator: (input) => EmailValidator.validate(input)
                              ? null
                              : "Invalid email address",
                        ),
                        CustomButton(
                          label: "Reset password",
                          onTap: () {
                            final FormState form =
                                _forgotPasswordFormKey.currentState;
                            if (form.validate()) {
                              setState(() {
                                loading = true;
                              });
                              profileProvider
                                  .sendPasswordResetMail(_emailController.text)
                                  .then((value) {
                                setState(() {
                                  loading = false;
                                });
                                if (!value['hasError']) {
                                  displayDialog("Password reset mail sent",
                                      "Please check your inbox", [
                                    CupertinoDialogAction(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        isDefaultAction: true,
                                        child: new Text("Close"))
                                  ]);
                                } else {
                                  displayDialog(
                                      "Invalid email address",
                                      "Please enter a valid registered email address",
                                      [
                                        CupertinoDialogAction(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            isDefaultAction: true,
                                            child: new Text("Close"))
                                      ]);
                                }
                              });
                            }
                          },
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        loading
            ? Center(
                child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.white70,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator()),
                      ),
                    )),
              )
            : Container()
      ],
    );
  }
}
