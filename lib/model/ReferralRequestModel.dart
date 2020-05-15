import 'package:flutter/cupertino.dart';
import 'package:ReferAll/constants/CommentsConstant.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/constants/ReferralConstants.dart';
import 'package:ReferAll/constants/ReferralRequestConstants.dart';

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
    ReferralRequestConstants.LAST_ACTION: {
      ReferralRequestConstants.STAGE: '',
      ReferralRequestConstants.MESSAGE: '',
      ReferralRequestConstants.ACTION_DATETIME: '',
      ReferralRequestConstants.ATTACHMENT_URL: '',
      ReferralRequestConstants.IS_ATTACHMENT: '',
      ReferralRequestConstants.ACTION_BY: '',
    },
    ReferralRequestConstants.CLOSE_DATE: '',
    ReferralRequestConstants.CLOSE_REASON: '',
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

  int getAuthorUnreadMessage() {
    int i = 0;
    List a = model[ReferralRequestConstants.ACTIONS];
    a.forEach((f) {
      if (!f[ReferralRequestConstants.ACTION_SEEN] &&
          f[ReferralRequestConstants.ACTION_BY] ==
              ReferralRequestConstants.ACTION_BY_REQUESTER) {
        i = i + 1;
      }
    });
    return i;
  }

  void clearAuthorUnread() {
    List a = model[ReferralRequestConstants.ACTIONS];
    a.forEach((f) {
      if (!f[ReferralRequestConstants.ACTION_SEEN] &&
          f[ReferralRequestConstants.ACTION_BY] ==
              ReferralRequestConstants.ACTION_BY_REQUESTER) {
        f[ReferralRequestConstants.ACTION_SEEN] = true;
      }
    });
  }

  void clearRequesterUnreadMEssages() {
    List a = model[ReferralRequestConstants.ACTIONS];
    a.forEach((f) {
      if (!f[ReferralRequestConstants.ACTION_SEEN] &&
          f[ReferralRequestConstants.ACTION_BY] ==
              ReferralRequestConstants.ACTION_BY_AUTHOR) {
        f[ReferralRequestConstants.ACTION_SEEN] = true;
      }
    });
  }

  int getRequesterUnreadMessage() {
    int i = 0;
    List a = model[ReferralRequestConstants.ACTIONS];
    a.forEach((f) {
      if (!f[ReferralRequestConstants.ACTION_SEEN] &&
          f[ReferralRequestConstants.ACTION_BY] ==
              ReferralRequestConstants.ACTION_BY_AUTHOR) {
        i = i + 1;
      }
    });
    return i;
  }

  void setAll(Map<String, dynamic> map) {
    this.model.addAll(map);
    notifyListeners();
  }
}
