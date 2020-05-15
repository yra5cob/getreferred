import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:ReferAll/Repository/Repository.dart';
import 'package:ReferAll/constants/NotificationConstants.dart';
import 'package:ReferAll/model/NotificationModel.dart';

class NotificationProvider extends ChangeNotifier {
  Repository _repository = new Repository();
  Map<String, NotificationModel> notificationFeed;

  Future<void> sendNotification(String token, String title, String body,
      String url, String userID) async {
    NotificationModel notificationModel = new NotificationModel();
    Map<String, dynamic> notification = {
      NotificationConstants.PUSH_TOKEN: token,
      NotificationConstants.TITLE: title,
      NotificationConstants.BODY: body,
      NotificationConstants.ICON_URL: url,
      NotificationConstants.USER_ID: userID,
      NotificationConstants.NOTIFICATION_TIME: Timestamp.now(),
      NotificationConstants.IS_READ: false,
    };
    notificationModel.setModel = notification;
    _repository.sendNotification(notificationModel);
  }

  Future<Map<String, NotificationModel>> getNotificationFeed(
    String userID,
  ) async {
    if (notificationFeed == null)
      notificationFeed = await _repository.getNotificationFeed(userID, () {
        notifyListeners();
      });
    return notificationFeed;
  }

  Future<int> getUnreadMessage(String userID) async {
    int i = 0;
    if (notificationFeed == null)
      notificationFeed = await _repository.getNotificationFeed(userID, () {
        notifyListeners();
      });
    notificationFeed.keys.forEach((f) {
      if (!notificationFeed[f].getModel[NotificationConstants.IS_READ]) i += 1;
    });
    return i;
  }

  Future<void> clearNotification() {
    notificationFeed.keys.forEach((f) {
      if (!notificationFeed[f].getModel[NotificationConstants.IS_READ])
        notificationFeed[f].getModel[NotificationConstants.IS_READ] = true;
      _repository.updateNotification(notificationFeed[f]);
    });
  }
}
