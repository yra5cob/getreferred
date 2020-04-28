import 'package:flutter/cupertino.dart';
import 'package:getreferred/Repository/Repository.dart';
import 'package:getreferred/model/CommentModel.dart';
import 'package:getreferred/model/ReferralModel.dart';
import 'package:getreferred/model/ReferralRequestModel.dart';

class FeedProvider extends ChangeNotifier {
  Map<String, ReferralModel> referralFeedCache;
  Repository _repository = new Repository();

  Future<Map<String, ReferralModel>> getFeed(String userID) async {
    if (referralFeedCache == null)
      referralFeedCache = await _repository.getFeed(userID, () {
        notifyListeners();
      });
    return referralFeedCache;
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

  Future<void> addReferralRequest(ReferralRequestModel rqm) async {
    return await _repository.addReferralRequest(rqm, () {
      notifyListeners();
    });
  }
}
