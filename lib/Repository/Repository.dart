import 'package:getreferred/Providers/FirestoreProvider%20.dart';
import 'package:getreferred/Providers/StorageProvider.dart';
import 'package:getreferred/model/CommentModel.dart';
import 'package:getreferred/model/ReferralModel.dart';
import 'package:getreferred/model/ReferralRequestModel.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();
  final _storageProvider = StorageProvider();

  Future<int> authenticateUser(String email, String password) =>
      _firestoreProvider.authenticateUser(email, password);

  Future<void> registerUser(String email, String password) =>
      _firestoreProvider.registerUser(email, password);

  Future<void> addReferralRequest(ReferralRequestModel referralRequestModel,
          Function notifyListeners) =>
      _firestoreProvider.addReferralRequest(
          referralRequestModel, notifyListeners);

  Future<ReferralRequestModel> getReferralRequestModel(
      String referralId, String userId, Function listener) async {
    return await _firestoreProvider.getReferralRequestModel(
        referralId, userId, listener);
  }

  Future<Map<String, CommentModel>> getComments(
      String referralId, Function notifyListeners) async {
    return await _firestoreProvider.getComments(referralId, notifyListeners);
  }

  Future<Map<String, ReferralModel>> getFeed(Function notifyListeners) async {
    return await _firestoreProvider.getFeed(notifyListeners);
  }

  Future<Map<String, ReferralModel>> getMyReferralFeed(
      String userID, Function notifyListeners) async {
    return await _firestoreProvider.getMyReferralFeed(userID, notifyListeners);
  }
}
