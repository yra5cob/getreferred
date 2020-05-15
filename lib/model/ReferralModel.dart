import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/constants/ReferralConstants.dart';
import 'package:ReferAll/model/CommentModel.dart';
import 'package:ReferAll/model/ReferralRequestModel.dart';

class ReferralModel {
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
    ReferralConstants.BOOKMARKS: [],
    ReferralConstants.REQUESTER_IDS: [],
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
    ReferralConstants.REQUESTS_NUM: 0,
    ReferralConstants.ACCEPTED_NUM: 0,
    ReferralConstants.REFERRED_NUM: 0,
    ReferralConstants.INTERVIEWED_NUM: 0,
    ReferralConstants.HIRED_NUM: 0,
    ReferralConstants.PENDING_ACTION_NUM: 0,
    ReferralConstants.NUM_COMMENTS: 0,
    ReferralConstants.NUM_SHARES: 0,
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
  }

  void setAll(Map<String, dynamic> map) {
    this.model.addAll(map);
  }
}
