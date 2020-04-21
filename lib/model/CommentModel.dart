import 'package:flutter/cupertino.dart';
import 'package:getreferred/constants/CommentsConstant.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/constants/ReferralConstants.dart';

class CommentModel extends ChangeNotifier {
  Map<String, dynamic> model = {
    CommentsConstant.USER: {
      ProfileConstants.NAME: {
        ProfileConstants.FIRST_NAME: '',
        ProfileConstants.LAST_NAME: ''
      },
      ProfileConstants.USERNAME: '',
      ProfileConstants.PROFILE_PIC_URL: '',
      ProfileConstants.HEADLINE: ''
    },
    CommentsConstant.COMMENT_ID: '',
    CommentsConstant.COMMENT: '',
    CommentsConstant.NUM_REPLIES: '',
    ReferralConstants.REFERRAL_ID: '',
    CommentsConstant.LAST_REPLY: '',
    CommentsConstant.DATETIME: '',
  };

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
