import 'dart:io';

import 'package:ReferAll/Providers/AuthenticationProvider.dart';
import 'package:ReferAll/Providers/FirestoreProvider.dart';
import 'package:ReferAll/Providers/LocalStorageProvider.dart';
import 'package:ReferAll/Providers/StorageProvider.dart';
import 'package:ReferAll/model/CommentModel.dart';
import 'package:ReferAll/model/NotificationModel.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:ReferAll/model/ReferralModel.dart';
import 'package:ReferAll/model/ReferralRequestModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();
  final _storageProvider = StorageProvider();
  final _localStorageProvider = LocalStorageProvider();
  final _authProvider = AuthenticationProvider();

  Future<int> authenticateUser(String email, String password) =>
      _firestoreProvider.authenticateUser(email, password);

  Future<void> addReferralRequest(ReferralRequestModel referralRequestModel,
          ReferralModel referralModel, Function notifyListeners) =>
      _firestoreProvider.addReferralRequest(
          referralRequestModel, referralModel, notifyListeners);

  Future<Map<String, CommentModel>> getComments(
      String referralId, Function notifyListeners) async {
    return await _firestoreProvider.getComments(referralId, notifyListeners);
  }

  Future<Map<String, ReferralModel>> getFeed(
      String userID, Function notifyListeners) async {
    return await _firestoreProvider.getFeed(userID, notifyListeners);
  }

  Future<Map<String, ReferralModel>> getMyReferralFeed(
      String userID, Function notifyListeners) async {
    return await _firestoreProvider.getMyReferralFeed(userID, notifyListeners);
  }

  Future<void> postReferral(ReferralModel referralModel) =>
      _firestoreProvider.postReferral(referralModel);

  Future<void> updateReferral(ReferralModel referralModel) =>
      _firestoreProvider.updateReferral(referralModel);

  Future<String> uploadJD(File file, ReferralModel referralModel) =>
      _storageProvider.uploadJD(file, referralModel);

  Future<void> uploadProfilePic(ProfileModel _profile, File img) =>
      _storageProvider.uploadPic(_profile, img);

  Future<String> getLocalStoredValue(String key) =>
      _localStorageProvider.getValue(key);
  Future<ProfileModel> loadProfile(ProfileModel _profile, Function notify) =>
      _firestoreProvider.loadProfile(_profile, notify);
  Future<String> uploadResume(ProfileModel _profile, File resume) =>
      _storageProvider.uploadResume(_profile, resume);
  Future<void> updateProfile(ProfileModel profileModel) =>
      _firestoreProvider.updateProfile(profileModel);

  Future<void> updateReferralRequest(
    ReferralRequestModel referralRequestModel,
  ) =>
      _firestoreProvider.updateReferralRequest(referralRequestModel);

  Future<void> sendNotification(NotificationModel notificationModel) =>
      _firestoreProvider.sendNotification(notificationModel);

  Future<Map<String, ReferralModel>> getBookmarkedFeed(
          String userID, Function notifyListeners) =>
      _firestoreProvider.getBookmarkedFeed(userID, notifyListeners);

  Future<Map<String, ReferralModel>> getRequestedFeed(
          String userID, Function notifyListeners) =>
      _firestoreProvider.getRequestedFeed(userID, notifyListeners);
  Future<Map<String, NotificationModel>> getNotificationFeed(
          String userID, Function notifyListeners) =>
      _firestoreProvider.getNotificationFeed(userID, notifyListeners);

  Future<void> updateNotification(NotificationModel notificationModel) =>
      _firestoreProvider.updateNotification(notificationModel);
  Future<void> addUser(ProfileModel profileModel) =>
      _firestoreProvider.addUser(profileModel);

  Future<Map<String, dynamic>> registerUser(String email, String password) =>
      _authProvider.registerUser(email, password);

  Future<void> setLocalValue(String _key, String _value) =>
      _localStorageProvider.setValue(_key, _value);
  Future<FirebaseUser> getCurrentUser() => _authProvider.getCurrentUser();

  Future<ReferralModel> getReferral(String userId, String referralId) =>
      _firestoreProvider.getReferral(userId, referralId);

  Future<void> uploadCover(ProfileModel _profile, File img) =>
      _storageProvider.uploadCover(_profile, img);

  Future<Map<String, dynamic>> signInWithGoogle() =>
      _authProvider.signInWithGoogle();
  Future<Map<String, dynamic>> signInWithEmailAndPassword(
          String _email, String _password) =>
      _authProvider.signInWithEmailAndPassword(_email, _password);

  Future<void> signOut() => _authProvider.singOut();

  Future<Map<String, dynamic>> sendPasswordResetMail(String email) =>
      _authProvider.sendPasswordResetMail(email);
}
