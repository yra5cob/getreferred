import 'package:flutter/cupertino.dart';
import 'package:getreferred/constants/CommentsConstant.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/constants/ReferralConstants.dart';
import 'package:getreferred/constants/ReferralRequestConstants.dart';

class ReferralRequestModel extends ChangeNotifier {
  Map<String, dynamic> model = {
    ReferralRequestConstants.REQUESTER: {
      ProfileConstants.NAME: {
        ProfileConstants.FIRST_NAME: '',
        ProfileConstants.LAST_NAME: ''
      },
      ProfileConstants.USERNAME: '',
      ProfileConstants.PROFILE_PIC_URL: '',
      ProfileConstants.HEADLINE: ''
    },
    ReferralRequestConstants.REQUEST_DATETIME: '',
    ReferralRequestConstants.CURRENT_STAGE: '',
    ReferralRequestConstants.IS_ACTIVE: '',
    ReferralRequestConstants.LAST_ACTION: {
      ReferralRequestConstants.STAGE: '',
      ReferralRequestConstants.MESSAGE: '',
      ReferralRequestConstants.ACTION_DATETIME: '',
      ReferralRequestConstants.ATTACHMENT_URL: '',
      ReferralRequestConstants.IS_ATTACHMENT: '',
      ReferralRequestConstants.ACTION_BY: '',
    },
    ReferralRequestConstants.CLOSE_DATE: '',
    ReferralRequestConstants.CLOSE_MESSAGE: '',
  };

  int pendingActions;
  int get getPendingActions => pendingActions;

  set setPendingActions(int pendingActions) =>
      this.pendingActions = pendingActions;

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
