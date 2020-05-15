import 'dart:async';

import 'package:ReferAll/BLoc/ProfileProvider.dart';
import 'package:ReferAll/profileCreationPage.dart';
import 'package:ReferAll/widget/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ReferAll/helper/sizeConfig.dart';

class EmailVeificationPage extends StatefulWidget {
  EmailVeificationPage({Key key}) : super(key: key);

  @override
  _EmailVeificationPageState createState() => _EmailVeificationPageState();
}

class _EmailVeificationPageState extends State<EmailVeificationPage> {
  bool checkingStatus = false;
  ProfileProvider profileProvider;

  void checkEmailVerification() {
    profileProvider.setEmailVerification();
    Timer.periodic(new Duration(seconds: 2), (timer) {
      profileProvider.isEmailVerified().then((value) {
        if (value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileCreationPage(),
              ),
              ModalRoute.withName("/Home"));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    return Container(
      child: Scaffold(
        body: SafeArea(
            child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(40),
                          child: Text(
                            "Verify\nyour\nEmail\n",
                            style: TextStyle(
                                fontFamily: 'RobotoRegular',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black), //textstyle
                          )),
                      if (!checkingStatus)
                        CustomButton(
                          label: "Verify Email",
                          onTap: () {
                            checkEmailVerification();
                            setState(() {
                              checkingStatus = true;
                            });
                          },
                        ),
                      if (checkingStatus)
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "Please click the verification link sent to your register email address!"),
                            ),
                            CircularProgressIndicator(),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
