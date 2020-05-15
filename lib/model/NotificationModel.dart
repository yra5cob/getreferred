import 'package:ReferAll/constants/NotificationConstants.dart';

class NotificationModel {
  Map<String, dynamic> model = {
    NotificationConstants.NOTIFICATION_ID: '',
    NotificationConstants.TITLE: '',
    NotificationConstants.BODY: '',
    NotificationConstants.IS_READ: false,
    NotificationConstants.ICON_URL: '',
    NotificationConstants.NOTIFICATION_TIME: '',
  };

  Map<String, dynamic> get getModel => model;

  set setModel(Map<String, dynamic> model) => this.model = model;
}
