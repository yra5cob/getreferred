import 'package:flutter/cupertino.dart';
import 'package:getreferred/Repository/Repository.dart';
import 'package:getreferred/model/ReferralRequestModel.dart';

class ReferralRequestProvider extends ChangeNotifier {
  Repository _repository = new Repository();

  Map<String, ReferralRequestModel> referralRequestModelCache = {};

  Map<String, ReferralRequestProvider> addReferralRequest(
      ReferralRequestModel referralRequestModel) {
    _repository.addReferralRequest(referralRequestModel, () {
      notifyListeners();
    });
  }

  Future<ReferralRequestModel> getReferralRequestModel(
      String referralId, String userId) async {
    if (referralRequestModelCache.containsKey(referralId))
      return referralRequestModelCache[referralId];
    else {
      ReferralRequestModel requestModel =
          await _repository.getReferralRequestModel(referralId, userId, () {
        notifyListeners();
      });
      referralRequestModelCache[referralId] = requestModel;
      return requestModel;
    }
  }
}
