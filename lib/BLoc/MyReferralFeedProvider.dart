import 'package:flutter/cupertino.dart';
import 'package:ReferAll/Repository/Repository.dart';
import 'package:ReferAll/constants/ReferralRequestConstants.dart';
import 'package:ReferAll/model/CommentModel.dart';
import 'package:ReferAll/model/ReferralModel.dart';
import 'package:ReferAll/model/ReferralRequestModel.dart';

class MyReferralFeedProvider extends ChangeNotifier {
  Map<String, ReferralModel> myReferralFeedCache;
  Map<String, ReferralModel> requestReferralFeedCache;
  Repository _repository = new Repository();

  Future<Map<String, ReferralModel>> getMyReferralFeed(String userId) async {
    if (myReferralFeedCache == null)
      myReferralFeedCache = await _repository.getMyReferralFeed(userId, () {
        notifyListeners();
      });
    return myReferralFeedCache;
  }

  Future<Map<String, ReferralModel>> getRequestedFeed(
    String userID,
  ) async {
    if (requestReferralFeedCache == null)
      requestReferralFeedCache = await _repository.getRequestedFeed(userID, () {
        notifyListeners();
      });
    return requestReferralFeedCache;
  }

  Future<Map<String, CommentModel>> getComments(String referralId) async {
    if (myReferralFeedCache[referralId].getComments != null)
      return myReferralFeedCache[referralId].getComments;
    else {
      Map<String, CommentModel> cMap =
          await _repository.getComments(referralId, () {
        notifyListeners();
      });
      myReferralFeedCache[referralId].setComments = cMap;
      return cMap;
    }
  }

  Future<void> saveReferralRequest(
      ReferralRequestModel referralRequestModel) async {
    _repository.updateReferralRequest(referralRequestModel);
  }

  ReferralModel getReferralModel(String referralId) {
    return myReferralFeedCache[referralId];
  }
}
