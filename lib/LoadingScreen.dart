import 'package:ReferAll/BLoc/DynamicLinkProvider.dart';
import 'package:ReferAll/emailVerificationPage.dart';
import 'package:flutter/material.dart';
import 'package:ReferAll/BLoc/ProfileProvider.dart';
import 'package:ReferAll/Home.dart';
import 'package:ReferAll/LoginPage.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/helper/Util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:ReferAll/profileCreationPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final storage = new FlutterSecureStorage();
  DynamicLinkProvider dynamicLinkProvider;
  ProfileProvider _profileProvider;
  @override
  void initState() {
    super.initState();
    dynamicLinkProvider =
        Provider.of<DynamicLinkProvider>(context, listen: false);
    dynamicLinkProvider.initDynamicLinks(context);
    _profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _profileProvider.loadProfile().then((_profile) {
      if (_profile.getModel[ProfileConstants.EMAIL].toString().isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        _profileProvider.isEmailVerified().then((value) {
          if (value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Util.getColor1(), Util.getColor2()])),
        child: Center(
          child: Text(
            "Loading..",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
