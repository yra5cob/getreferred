import 'package:flutter/cupertino.dart';
import 'package:getreferred/Repository/Repository.dart';
import 'package:getreferred/model/CommentModel.dart';
import 'package:getreferred/model/ReferralModel.dart';

class MyReferralFeedProvider extends ChangeNotifier {
  Map<String, ReferralModel> myReferralFeedCache;
  Repository _repository = new Repository();

  Future<Map<String, ReferralModel>> getMyReferralFeed(String userId) async {
    if (myReferralFeedCache == null)
      myReferralFeedCache = await _repository.getMyReferralFeed(userId, () {
        notifyListeners();
      });
    return myReferralFeedCache;
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
}
