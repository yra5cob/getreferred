import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:ReferAll/Repository/Repository.dart';
import 'package:ReferAll/model/CommentModel.dart';
import 'package:ReferAll/model/ReferralModel.dart';
import 'package:ReferAll/model/ReferralRequestModel.dart';

class FeedProvider extends ChangeNotifier {
  Map<String, ReferralModel> referralFeedCache;
  Map<String, ReferralModel> bookmarkedReferralFeedCache;
  Map<String, ReferralModel> sharedReferrals = {};
  Repository _repository = new Repository();

  Future<Map<String, ReferralModel>> getFeed(String userID) async {
    if (referralFeedCache == null)
      referralFeedCache = await _repository.getFeed(userID, () {
        notifyListeners();
      });
    return referralFeedCache;
  }

  Future<ReferralModel> getReferral(String userId, String referralId) async {
    if (sharedReferrals[referralId] == null) {
      ReferralModel referralModel =
          await _repository.getReferral(userId, referralId);
      sharedReferrals[referralId] = referralModel;
    }
    return sharedReferrals[referralId];
  }

  Future<Map<String, ReferralModel>> getBookmarkedFeed(String userID) async {
    if (bookmarkedReferralFeedCache == null)
      bookmarkedReferralFeedCache =
          await _repository.getBookmarkedFeed(userID, () {
        notifyListeners();
      });
    return bookmarkedReferralFeedCache;
  }

  Future<Map<String, CommentModel>> getComments(String referralId) async {
    if (referralFeedCache[referralId].getComments != null)
      return referralFeedCache[referralId].getComments;
    else {
      Map<String, CommentModel> cMap =
          await _repository.getComments(referralId, () {
        notifyListeners();
      });
      referralFeedCache[referralId].setComments = cMap;
      print(cMap);
      return cMap;
    }
  }

  Future<void> addReferralRequest(
      ReferralRequestModel rqm, ReferralModel referralModel) async {
    return await _repository.addReferralRequest(rqm, referralModel, () {
      notifyListeners();
    });
  }

  Future<void> postReferral(ReferralModel referralModel) async {
    return await _repository.postReferral(referralModel);
  }

  Future<void> updateReferral(ReferralModel referralModel) async {
    return await _repository.updateReferral(referralModel);
  }

  Future<String> uploadJD(File file, ReferralModel referralModel) async =>
      _repository.uploadJD(file, referralModel);

  Future<void> saveMyReferralRequest(ReferralRequestModel rqm) =>
      _repository.updateReferralRequest(rqm);

  Future<void> saveReferralRequest(ReferralRequestModel referralRequestModel) =>
      _repository.updateReferralRequest(referralRequestModel);
}
