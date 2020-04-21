import 'package:flutter/material.dart';
import 'package:getreferred/Home.dart';
import 'package:getreferred/LoginPage.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/model/ProfileModel.dart';
import 'package:getreferred/profileCreationPage.dart';
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
  @override
  void initState() {
    super.initState();
    final _profileModel = Provider.of<ProfileModel>(context, listen: false);
    storage.read(key: ProfileConstants.USERNAME).then((userName) {
      if (userName != null) {
        _profileModel.setValue(ProfileConstants.USERNAME, userName);
        // StorageReference storageReference =
        //     FirebaseStorage.instance.ref().child("profilePictures/" + userName);
        // storageReference.getDownloadURL().then((onValue) {
        //   _profileModel.setValue(ProfileConstants.PROFILE_PIC_URL, onValue);
        Firestore.instance.document('users/$userName').get().then((data) {
          if (data.exists) {
            _profileModel.setAll(data.data);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
                ModalRoute.withName("/Home"));
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
          // });
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.green[800],
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
