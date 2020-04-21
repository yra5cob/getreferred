import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getreferred/LoginPage.dart';
import 'package:getreferred/widget/CustomButton.dart';
import 'package:getreferred/widget/CustomDialog.dart';
import 'package:getreferred/widget/CustomTextField.dart';

final _forgotPasswordFormKey = GlobalKey<FormState>();

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        child: Center(
          child: Form(
            key: _forgotPasswordFormKey,
            child: Column(
              children: <Widget>[
                CustomTextField(
                  hint: "Email",
                  controller: _emailController,
                  validator: (input) =>
                      EmailValidator.validate(input) ? null : "Required",
                ),
                CustomButton(
                  label: "Reset password",
                  onTap: () {
                    final FormState form = _forgotPasswordFormKey.currentState;
                    if (form.validate()) {
                      _firebaseAuth
                          .sendPasswordResetEmail(email: _emailController.text)
                          .then((v) {
                        mailSent();
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
