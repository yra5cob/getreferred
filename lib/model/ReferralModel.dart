import 'package:flutter/cupertino.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/constants/ReferralConstants.dart';
import 'package:getreferred/model/CommentModel.dart';
import 'package:getreferred/model/ReferralRequestModel.dart';

class ReferralModel extends ChangeNotifier {
  Map<String, dynamic> model = {
    ReferralConstants.REFERRAL_AUTHOR: {
      ProfileConstants.NAME: {
        ProfileConstants.FIRST_NAME: "",
        ProfileConstants.LAST_NAME: ""
      },
      ProfileConstants.USERNAME: "",
      ProfileConstants.HEADLINE: ""
    },
    ReferralConstants.REFERRAL_ID: "",
    ReferralConstants.LOCATION: "",
    ProfileConstants.USERNAME: "",
    ReferralConstants.ROLE: "",
    ReferralConstants.COMPANY: "",
    ReferralConstants.LEVEL: "",
    ReferralConstants.CTC: "",
    ReferralConstants.EXPERIENCE: "",
    ReferralConstants.TRAVEL_REQ: "",
    ReferralConstants.COLLEGE_REQ: [],
    ReferralConstants.GRADUATION_REQ: [],
    ReferralConstants.JD_TYPE: "",
    ReferralConstants.JD: "",
    ReferralConstants.AUTHOR_NOTE: "",
    ReferralConstants.ACTIVE: "",
    ReferralConstants.CLOSE_REASON: "",
    ReferralConstants.POST_DATE: "",
    ReferralConstants.CLOSE_DATE: "",
    ReferralConstants.HIDE: "",
  };

  Map<String, ReferralRequestModel> referralRequests = {};
  Map<String, CommentModel> comments;
  ReferralRequestModel myRequest = new ReferralRequestModel();
  ReferralRequestModel get getMyRequest => myRequest;

  set setMyRequest(ReferralRequestModel myRequest) =>
      this.myRequest = myRequest;

  String feedType;
  String get getFeedType => feedType;

  set setFeedType(String feedType) => this.feedType = feedType;

  set setComments(Map map) => this.comments = map;

  set setRequests(Map map) => this.referralRequests = map;

  Map get getComments => this.comments;

  Map<String, ReferralRequestModel> get getRequests => this.referralRequests;

  Map get getModel => this.model;

  set setModel(Map map) => this.model = model;

  void setValue(String key, dynamic value) {
    this.model[key] = value;
    notifyListeners();
  }

  void setAll(Map<String, dynamic> map) {
    this.model.addAll(map);
    notifyListeners();
  }
}
