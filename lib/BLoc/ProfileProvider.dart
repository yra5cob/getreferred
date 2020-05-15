import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:ReferAll/Repository/Repository.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/model/ProfileModel.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel _profileModel;
  Repository _repository = new Repository();
  FirebaseUser user;

  Future<void> signOut() async {
    _repository.signOut();
  }

  Future<Map<String, dynamic>> sendPasswordResetMail(String email) async {
    Map<String, dynamic> data = await _repository.sendPasswordResetMail(email);
    return data;
  }

  Future<ProfileModel> loadProfile() async {
    if (_profileModel != null) {
      return _profileModel;
    } else {
      user = await _repository.getCurrentUser();

      String _uid = user != null ? user.uid : null;
      _profileModel = new ProfileModel();
      _profileModel.setValue(ProfileConstants.USERNAME, _uid);
      if (_uid != null) {
        _profileModel = await _repository.loadProfile(_profileModel, () {
          notifyListeners();
        });
      }
      return _profileModel;
    }
  }

  ProfileModel getProfile() {
    return _profileModel;
  }

  Future<String> uploadResume(ProfileModel _profile, File resume) =>
      _repository.uploadResume(_profile, resume);

  Future<void> saveProfile() async {
    await _repository.updateProfile(_profileModel);
    notifyListeners();
  }

  Future<String> getLoginInfor(String key) =>
      _repository.getLocalStoredValue(key);

  Future<void> uploadPic(ProfileModel _profile, File img) =>
      _repository.uploadProfilePic(_profile, img);

  Future<bool> isEmailVerified() async {
    user = await _repository.getCurrentUser();
    user.reload();
    return user.isEmailVerified;
  }

  void setEmailVerification() async {
    user.sendEmailVerification();
  }

  Future<Map<String, dynamic>> signInWithEmailAndPassword(
      String email, String password, String token) async {
    Map<String, dynamic> returnData = {};
    Map<String, dynamic> data =
        await _repository.signInWithEmailAndPassword(email, password);
    if (!data["hasError"]) {
      user = data["user"];
      returnData["hasError"] = false;
      _profileModel = await loadProfile();
      returnData["profile"] = _profileModel;
    } else {
      returnData["hasError"] = true;
      returnData["error"] = data["error"];
    }
    return returnData;
  }

  Future<Map<String, dynamic>> registerUser(String email, String password,
      String firstName, String lastName, String token) async {
    Map<String, dynamic> returnData = {};
    Map<String, dynamic> data = await _repository.registerUser(email, password);
    if (!data["hasError"]) {
      user = data["user"];
      _profileModel = new ProfileModel();
      _profileModel.model[ProfileConstants.USERNAME] = user.uid;
      _profileModel.model[ProfileConstants.EMAIL] = email;
      _profileModel.model[ProfileConstants.PUSH_TOKEN] = token;
      _profileModel.model[ProfileConstants.NAME][ProfileConstants.FIRST_NAME] =
          firstName;
      _profileModel.model[ProfileConstants.NAME][ProfileConstants.LAST_NAME] =
          lastName;
      await _repository.addUser(_profileModel);
      await _repository.setLocalValue(ProfileConstants.USERNAME, user.uid);
      returnData["hasError"] = false;
      returnData["profile"] = _profileModel;
    } else {
      returnData["hasError"] = true;
      returnData["error"] = data["error"];
    }

    return returnData;
  }

  Future<Map<String, dynamic>> signInWithGoogle(String token) async {
    Map<String, dynamic> returnData = {};
    Map<String, dynamic> data = await _repository.signInWithGoogle();
    if (!data["hasError"]) {
      user = data["user"];
      returnData["hasError"] = false;
      _profileModel = await loadProfile();
      if (_profileModel.getModel[ProfileConstants.EMAIL] == null ||
          _profileModel.getModel[ProfileConstants.EMAIL] == "") {
        print("singing up");
        returnData["signUp"] = true;
        _profileModel = new ProfileModel();
        _profileModel.model[ProfileConstants.USERNAME] = user.uid;
        _profileModel.model[ProfileConstants.EMAIL] = user.email;
        _profileModel.model[ProfileConstants.PUSH_TOKEN] = token;
        _profileModel.model[ProfileConstants.PHONE] = user.phoneNumber;
        _profileModel.model[ProfileConstants.PROFILE_PIC_URL] = user.photoUrl;
        _profileModel.model[ProfileConstants.NAME]
            [ProfileConstants.FIRST_NAME] = user.displayName;
        _profileModel.model[ProfileConstants.NAME][ProfileConstants.LAST_NAME] =
            "";

        await _repository.addUser(_profileModel);
        returnData["profile"] = _profileModel;
      } else {
        returnData["signUp"] = false;
        returnData["profile"] = _profileModel;
      }
    } else {
      returnData["signUp"] = false;
      returnData["hasError"] = true;
      returnData["error"] = data["error"];
    }
    return returnData;
  }

  Future<void> uploadCover(ProfileModel _profile, File img) =>
      _repository.uploadCover(_profile, img);
}
