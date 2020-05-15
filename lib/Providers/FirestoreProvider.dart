import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ReferAll/constants/CommentsConstant.dart';
import 'package:ReferAll/constants/NotificationConstants.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/constants/ReferralConstants.dart';
import 'package:ReferAll/constants/ReferralRequestConstants.dart';
import 'package:ReferAll/model/CommentModel.dart';
import 'package:ReferAll/model/NotificationModel.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:ReferAll/model/ReferralModel.dart';
import 'package:ReferAll/model/ReferralRequestModel.dart';
import 'package:ReferAll/constants/NotificationConstants.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future<int> authenticateUser(String email, String password) async {
    final QuerySnapshot result = await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .getDocuments();
    final List<DocumentSnapshot> docs = result.documents;
    if (docs.length == 0) {
      return 0;
    } else {
      return 1;
    }
  }

  Future<ReferralModel> getReferral(String userId, String referralId) async {
    DocumentSnapshot doc =
        await _firestore.collection('referrals').document(referralId).get();
    ReferralModel referralModel = new ReferralModel();
    referralModel.setAll(doc.data);
    await getMyRequest(referralModel, userId, () {});
    return referralModel;
  }

  Future<void> addUser(ProfileModel profileModel) async {
    Completer<void> completer = new Completer();
    Firestore.instance
        .collection('users')
        .document(profileModel.getModel[ProfileConstants.USERNAME])
        .setData(profileModel.getModel, merge: true)
        .then((value) => {completer.complete()});

    return completer.future;
  }

  Future<void> postReferral(
    ReferralModel referralModel,
  ) async {
    DocumentReference docRef =
        Firestore.instance.collection('referrals').document();
    referralModel.getModel[ReferralConstants.REFERRAL_ID] = docRef.documentID;
    await docRef.setData(referralModel.getModel, merge: true);
  }

  Future<void> updateReferral(
    ReferralModel referralModel,
  ) async {
    DocumentReference docRef = Firestore.instance
        .collection('referrals')
        .document(referralModel.getModel[ReferralConstants.REFERRAL_ID]);
    await docRef.setData(referralModel.getModel, merge: true);
  }

  Future<void> updateReferralRequest(
    ReferralRequestModel referralRequestModel,
  ) async {
    DocumentReference docRef = Firestore.instance
        .collection('referrals')
        .document(referralRequestModel.getModel[ReferralConstants.REFERRAL_ID])
        .collection("referralRequests")
        .document(
            referralRequestModel.getModel[ReferralRequestConstants.REQUEST_ID]);
    await docRef.setData(referralRequestModel.getModel, merge: true);
  }

  Future<void> addReferralRequest(ReferralRequestModel referralRequestModel,
      ReferralModel referralModel, Function notifyListeners) async {
    DocumentReference ref = _firestore
        .collection("referrals")
        .document(referralRequestModel.getModel[ReferralConstants.REFERRAL_ID])
        .collection("referralRequests")
        .document();
    referralRequestModel.setValue(
        ReferralRequestConstants.REQUEST_ID, ref.documentID);
    await ref.setData(referralRequestModel.getModel);
    _firestore
        .collection("referrals")
        .document(referralRequestModel.getModel[ReferralConstants.REFERRAL_ID])
        .collection("referralRequests")
        .document(ref.documentID)
        .snapshots()
        .listen((onData) {
      if (onData.exists) {
        referralRequestModel.setAll(onData.data);
        notifyListeners();
      } else {
        notifyListeners();
        referralRequestModel = new ReferralRequestModel();
      }
    });
    referralModel.getModel[ReferralConstants.REQUESTS_NUM] += 1;
    updateReferral(referralModel);
  }

  Future<ProfileModel> loadProfile(
      ProfileModel _profile, Function notify) async {
    String _uid = _profile.getModel[ProfileConstants.USERNAME];
    Completer<ProfileModel> completer = new Completer();
    _firestore.document('users/$_uid').snapshots().listen((doc) {
      if (doc.exists) {
        _profile.setAll(doc.data);
        notify();
      }
      if (!completer.isCompleted) completer.complete(_profile);
    });

    return completer.future;
  }

  Future<void> updateProfile(ProfileModel profileModel) async {
    DocumentReference docRef = Firestore.instance
        .collection('users')
        .document(profileModel.getModel[ProfileConstants.USERNAME]);
    await docRef.setData(profileModel.getModel, merge: true);
  }

  Future<void> updateNotification(NotificationModel notificationModel) async {
    DocumentReference docRef = Firestore.instance
        .collection('notifications')
        .document(
            notificationModel.getModel[NotificationConstants.NOTIFICATION_ID]);
    await docRef.setData(notificationModel.getModel, merge: true);
  }

  Future<Map<String, CommentModel>> getComments(
      String referralId, Function notifyListeners) async {
    Completer<Map<String, CommentModel>> completer = new Completer();
    Map<String, CommentModel> cmList = {};
    _firestore
        .collection('referrals')
        .document(referralId)
        .collection("comments")
        .orderBy(CommentsConstant.DATETIME)
        .snapshots()
        .listen((onData) {
      if (onData.documents.length == 0) {
        if (!completer.isCompleted) {
          completer.complete(cmList);
        }
      }
      onData.documentChanges.forEach((doc) {
        if (doc.document.data[CommentsConstant.COMMENT_ID] != null) {
          if (doc.type == DocumentChangeType.removed) {
            CommentModel cm = new CommentModel();
            cm.setAll(doc.document.data);
            cmList.remove(cm.getModel[CommentsConstant.COMMENT_ID]);

            notifyListeners();
          } else {
            CommentModel cm = new CommentModel();
            cm.setAll(doc.document.data);
            cmList[cm.getModel[CommentsConstant.COMMENT_ID]] = cm;
            notifyListeners();
          }

          if (!completer.isCompleted) {
            completer.complete(cmList);
          }
        }
      });
    });

    return completer.future;
  }

  Future<Map<String, ReferralModel>> getFeed(
      String userID, Function notifyListeners) async {
    Completer<Map<String, ReferralModel>> completer = new Completer();
    Map<String, ReferralModel> feedMap = {};
    _firestore
        .collection('referrals')
        .orderBy(ReferralConstants.POST_DATE)
        .snapshots()
        .listen((onData) {
      if (onData.documents.length == 0) {
        if (!completer.isCompleted) {
          completer.complete(feedMap);
        }
      }
      onData.documentChanges.forEach((doc) async {
        if (doc.type == DocumentChangeType.removed) {
          ReferralModel rm = new ReferralModel();

          rm.setAll(doc.document.data);
          feedMap.remove(rm.getModel[ReferralConstants.REFERRAL_ID]);

          notifyListeners();
        } else {
          ReferralModel rm = new ReferralModel();
          if (doc.type == DocumentChangeType.modified) {
            if (feedMap[doc.document.data[ReferralConstants.REFERRAL_ID]] !=
                null)
              rm = feedMap[doc.document.data[ReferralConstants.REFERRAL_ID]];
          }
          rm.setAll(doc.document.data);
          rm.setFeedType = "public";
          if (doc.type == DocumentChangeType.added) {
            await getMyRequest(rm, userID, notifyListeners);
            print("getMyquesr comepleted");
          }
          feedMap[rm.getModel[ReferralConstants.REFERRAL_ID]] = rm;
          print("return comepleted");
          notifyListeners();
        }

        if (!completer.isCompleted) {
          completer.complete(feedMap);
        }
      });
    });

    return completer.future;
  }

  Future<void> getMyRequest(ReferralModel referralModel, String userID,
      Function notifyListeners) async {
    Completer<void> completer = new Completer();
    _firestore
        .collection('referrals')
        .document(referralModel.getModel[ReferralConstants.REFERRAL_ID])
        .collection('referralRequests')
        .where(
            ReferralRequestConstants.REQUESTER +
                "." +
                ProfileConstants.USERNAME,
            isEqualTo: userID)
        .snapshots()
        .listen((onData) {
      onData.documentChanges.forEach((doc) {
        if (doc.type == DocumentChangeType.removed) {
          referralModel.myRequest = new ReferralRequestModel();
          notifyListeners();
        } else {
          ReferralRequestModel rm = new ReferralRequestModel();
          rm.setAll(doc.document.data);
          referralModel.myRequest = rm;
          notifyListeners();
        }
      });
      if (!completer.isCompleted) {
        completer.complete();
      }
    });
    return await completer.future;
  }

  Future<void> sendNotification(NotificationModel notificationModel) async {
    DocumentReference doc = _firestore.collection('notifications').document();
    notificationModel.getModel[NotificationConstants.NOTIFICATION_ID] =
        doc.documentID;
    doc.setData(notificationModel.getModel, merge: true);
  }

  Future<Map<String, ReferralModel>> getBookmarkedFeed(
      String userID, Function notifyListeners) async {
    Completer<Map<String, ReferralModel>> completer = new Completer();
    Map<String, ReferralModel> feedMap = {};
    _firestore
        .collection('referrals')
        .orderBy(ReferralConstants.POST_DATE)
        .where('bookmarks', arrayContains: userID)
        .snapshots()
        .listen((onData) {
      if (onData.documents.length == 0) {
        if (!completer.isCompleted) {
          completer.complete(feedMap);
        }
      }
      onData.documentChanges.forEach((doc) async {
        if (doc.type == DocumentChangeType.removed) {
          ReferralModel rm = new ReferralModel();

          rm.setAll(doc.document.data);
          feedMap.remove(rm.getModel[ReferralConstants.REFERRAL_ID]);

          notifyListeners();
        } else {
          ReferralModel rm = new ReferralModel();
          if (doc.type == DocumentChangeType.modified) {
            if (feedMap[doc.document.data[ReferralConstants.REFERRAL_ID]] !=
                null)
              rm = feedMap[doc.document.data[ReferralConstants.REFERRAL_ID]];
          }
          rm.setAll(doc.document.data);
          rm.setFeedType = "public";
          if (doc.type == DocumentChangeType.added) {
            await getMyRequest(rm, userID, notifyListeners);
            print("getMyquesr comepleted");
          }
          feedMap[rm.getModel[ReferralConstants.REFERRAL_ID]] = rm;
          print("return comepleted");
          notifyListeners();
        }

        if (!completer.isCompleted) {
          completer.complete(feedMap);
        }
      });
    });

    return completer.future;
  }

  Future<Map<String, NotificationModel>> getNotificationFeed(
      String userID, Function notifyListeners) async {
    Completer<Map<String, NotificationModel>> completer = new Completer();
    Map<String, NotificationModel> feedMap = {};
    _firestore
        .collection('notifications')
        .where("uid", isEqualTo: userID)
        .orderBy(NotificationConstants.NOTIFICATION_TIME, descending: true)
        .snapshots()
        .listen((onData) {
      if (onData.documents.length == 0) {
        if (!completer.isCompleted) {
          completer.complete(feedMap);
        }
      }
      onData.documentChanges.forEach((doc) async {
        if (doc.type == DocumentChangeType.removed) {
          NotificationModel rm = new NotificationModel();

          rm.setModel = doc.document.data;
          feedMap.remove(rm.getModel[NotificationConstants.NOTIFICATION_ID]);

          notifyListeners();
        } else {
          NotificationModel rm = new NotificationModel();
          if (doc.type == DocumentChangeType.modified) {
            if (feedMap[
                    doc.document.data[NotificationConstants.NOTIFICATION_ID]] !=
                null)
              rm = feedMap[
                  doc.document.data[NotificationConstants.NOTIFICATION_ID]];
          }
          rm.setModel = doc.document.data;
          feedMap[rm.getModel[NotificationConstants.NOTIFICATION_ID]] = rm;
          notifyListeners();
        }

        if (!completer.isCompleted) {
          completer.complete(feedMap);
        }
      });
    });

    return completer.future;
  }

  Future<Map<String, ReferralModel>> getRequestedFeed(
      String userID, Function notifyListeners) async {
    Completer<Map<String, ReferralModel>> completer = new Completer();
    Map<String, ReferralModel> feedMap = {};
    _firestore
        .collection('referrals')
        .orderBy(ReferralConstants.POST_DATE)
        .where('requester_ids', arrayContains: userID)
        .snapshots()
        .listen((onData) {
      if (onData.documents.length == 0) {
        if (!completer.isCompleted) {
          completer.complete(feedMap);
        }
      }
      onData.documentChanges.forEach((doc) async {
        print(doc.document.data);
        if (doc.type == DocumentChangeType.removed) {
          ReferralModel rm = new ReferralModel();

          rm.setAll(doc.document.data);
          feedMap.remove(rm.getModel[ReferralConstants.REFERRAL_ID]);

          notifyListeners();
        } else {
          ReferralModel rm = new ReferralModel();
          if (doc.type == DocumentChangeType.modified) {
            if (feedMap[doc.document.data[ReferralConstants.REFERRAL_ID]] !=
                null)
              rm = feedMap[doc.document.data[ReferralConstants.REFERRAL_ID]];
          }
          rm.setAll(doc.document.data);
          rm.setFeedType = "public";
          if (doc.type == DocumentChangeType.added) {
            await getMyRequest(rm, userID, notifyListeners);
            print("getMyquesr comepleted");
          }
          feedMap[rm.getModel[ReferralConstants.REFERRAL_ID]] = rm;
          print("return comepleted");
          notifyListeners();
        }

        if (!completer.isCompleted) {
          completer.complete(feedMap);
        }
      });
    });

    return completer.future;
  }

  Future<Map<String, ReferralModel>> getMyReferralFeed(
      String userID, Function notifyListeners) async {
    Completer<Map<String, ReferralModel>> completer = new Completer();
    Map<String, ReferralModel> feedMap = {};
    _firestore
        .collection('referrals')
        .where(
            ReferralConstants.REFERRAL_AUTHOR + "." + ProfileConstants.USERNAME,
            isEqualTo: userID)
        .orderBy(ReferralConstants.POST_DATE)
        .snapshots()
        .listen((onData) {
      if (onData.documents.length == 0) {
        if (!completer.isCompleted) {
          completer.complete(feedMap);
        }
      }
      onData.documentChanges.forEach((doc) {
        if (doc.type == DocumentChangeType.removed) {
          ReferralModel rm = new ReferralModel();
          rm.setAll(doc.document.data);
          feedMap.remove(rm.getModel[ReferralConstants.REFERRAL_ID]);
          notifyListeners();
        } else {
          ReferralModel rm = new ReferralModel();
          if (doc.type == DocumentChangeType.modified) {
            if (feedMap[doc.document.data[ReferralConstants.REFERRAL_ID]] !=
                null)
              rm = feedMap[doc.document.data[ReferralConstants.REFERRAL_ID]];
          }
          rm.setFeedType = "private";
          rm.setAll(doc.document.data);
          print("herrreererer");
          if (doc.type == DocumentChangeType.added) {
            getReferralRequests(rm, userID, notifyListeners);
          }
          feedMap[rm.getModel[ReferralConstants.REFERRAL_ID]] = rm;
          notifyListeners();
        }

        if (!completer.isCompleted) {
          completer.complete(feedMap);
        }
      });
    });

    return completer.future;
  }

  Future<void> getReferralRequests(
      ReferralModel referralModel, String userId, Function listener) async {
    _firestore
        .collection('referrals')
        .document(referralModel.getModel[ReferralConstants.REFERRAL_ID])
        .collection("referralRequests")
        .orderBy(ReferralRequestConstants.REQUEST_DATETIME)
        .snapshots()
        .listen((onData) {
      onData.documentChanges.forEach((doc) {
        if (doc.document.data[ReferralRequestConstants.REQUEST_ID] != null) {
          if (doc.type == DocumentChangeType.removed) {
            ReferralRequestModel cm = new ReferralRequestModel();
            cm.setAll(doc.document.data);
            print("removed");
            print(referralModel.hashCode);
            referralModel.getRequests
                .remove(cm.getModel[ReferralRequestConstants.REQUEST_ID]);
            listener();
          } else {
            ReferralRequestModel cm = new ReferralRequestModel();
            cm.setAll(doc.document.data);
            print("adedd");
            print(referralModel.hashCode);
            print(doc.document.data);
            referralModel.getRequests[
                cm.getModel[ReferralRequestConstants.REQUEST_ID]] = cm;
            listener();
          }
        }
      });
    });
  }
}
