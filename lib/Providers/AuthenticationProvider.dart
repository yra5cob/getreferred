import 'package:ReferAll/model/ProfileModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> getCurrentUser() {
    return _auth.currentUser();
  }

  Future<void> singOut() {
    _auth.signOut();
    _googleSignIn.signOut();
  }

  Future<Map<String, dynamic>> registerUser(
      String email, String password) async {
    Map<String, dynamic> data = {};
    FirebaseUser user;
    try {
      user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      if (user != null) {
        data["user"] = user;
        data["hasError"] = false;
      }
    } on PlatformException catch (e) {
      print(e.code);
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          {
            data["user"] = null;
            data["hasError"] = true;
            data["error"] = "ERROR_EMAIL_ALREADY_IN_USE";
          }
          break;
        case "ERROR_INVALID_EMAIL":
          {
            data["user"] = null;
            data["hasError"] = true;
            data["error"] = "ERROR_INVALID_EMAIL";
          }
          break;
        case "ERROR_WEAK_PASSWORD":
          {
            data["user"] = null;
            data["hasError"] = true;
            data["error"] = "ERROR_WEAK_PASSWORD";
          }
          break;
        default:
          {
            //statements;
          }
          break;
      }
    }
    return data;
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    Map<String, dynamic> data = {};
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
    if (user != null) {
      data["user"] = currentUser;
      data["hasError"] = false;
    } else {
      data["user"] = user;
      data["hasError"] = true;
      data["error"] = "SIGN_IN_FAILED";
    }
    return data;
  }

  Future<Map<String, dynamic>> sendPasswordResetMail(String email) async {
    Map<String, dynamic> data = {};
    try {
      await _auth.sendPasswordResetEmail(email: email);
      data['mailSent'] = true;
      data['hasError'] = false;
    } on PlatformException catch (e) {
      data['mailSent'] = false;
      data['hasError'] = true;
      switch (e.code) {
        case "ERROR_USER_NOT_FOUND":
          {
            data["error"] = "ERROR_USER_NOT_FOUND";
          }
          break;
      }
    }

    return data;
  }

  Future<Map<String, dynamic>> signInWithEmailAndPassword(
      String _email, String _password) async {
    FirebaseUser user;
    Map<String, dynamic> data = {};
    try {
      user = (await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      ))
          .user;
      if (user != null) {
        data["user"] = user;
        data["hasError"] = false;
      }
    } on PlatformException catch (e) {
      print(e);
      switch (e.code) {
        case "ERROR_WRONG_PASSWORD":
          {
            data["user"] = null;
            data["hasError"] = true;
            data["error"] = "ERROR_WRONG_PASSWORD";
          }
          break;
        case "ERROR_USER_NOT_FOUND":
          {
            data["user"] = null;
            data["hasError"] = true;
            data["error"] = "ERROR_USER_NOT_FOUND";
          }
          break;
      }
    }
    return data;
  }
}
