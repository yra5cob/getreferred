import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getreferred/constants/CommentsConstant.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/constants/ReferralConstants.dart';
import 'package:getreferred/constants/ReferralRequestConstants.dart';
import 'package:getreferred/model/CommentModel.dart';
import 'package:getreferred/model/ReferralModel.dart';
import 'package:getreferred/model/ReferralRequestModel.dart';

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

  Future<void> registerUser(String email, String password) async {
    return _firestore
        .collection("users")
        .document(email)
        .setData({'email': email, 'password': password, 'goalAdded': false});
  }

  Future<void> addReferralRequest(ReferralRequestModel referralRequestModel,
      Function notifyListeners) async {
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
      notifyListeners();
      referralRequestModel.setAll(onData.data);
    });
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
      onData.documentChanges.forEach((doc) {
        print("hereeeeeeeeee");
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

  Future<Map<String, ReferralModel>> getFeed(Function notifyListeners) async {
    Completer<Map<String, ReferralModel>> completer = new Completer();
    Map<String, ReferralModel> feedMap = {};
    _firestore
        .collection('referrals')
        .orderBy(ReferralConstants.POST_DATE)
        .snapshots()
        .listen((onData) {
      onData.documentChanges.forEach((doc) {
        if (doc.type == DocumentChangeType.removed) {
          ReferralModel rm = new ReferralModel();

          rm.setAll(doc.document.data);
          feedMap.remove(rm.getModel[ReferralConstants.REFERRAL_ID]);

          notifyListeners();
        } else {
          ReferralModel rm = new ReferralModel();
          rm.setAll(doc.document.data);
          rm.setFeedType = "public";
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
      onData.documentChanges.forEach((doc) {
        if (doc.type == DocumentChangeType.removed) {
          ReferralModel rm = new ReferralModel();
          rm.setAll(doc.document.data);
          feedMap.remove(rm.getModel[ReferralConstants.REFERRAL_ID]);

          notifyListeners();
        } else {
          ReferralModel rm = new ReferralModel();
          rm.setFeedType = "private";
          rm.setAll(doc.document.data);
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

  Future<ReferralRequestModel> getReferralRequestModel(
      String referralId, String userId, Function listener) async {
    ReferralRequestModel rqm = new ReferralRequestModel();
    Completer<ReferralRequestModel> completer = Completer();
    var doc = await _firestore
        .collection("referrals")
        .document(referralId)
        .collection("referralRequests")
        .where(
            ReferralRequestConstants.REQUESTER +
                "." +
                ProfileConstants.USERNAME,
            isEqualTo: userId)
        .getDocuments();

    if (doc.documents.length == 1) {
      rqm.setAll(doc.documents[0].data);
      _firestore
          .collection("referrals")
          .document(referralId)
          .collection("referralRequests")
          .document(doc.documents[0].documentID)
          .snapshots()
          .listen((onData) {
        rqm.setAll(onData.data);
        listener();
        if (!completer.isCompleted) {
          completer.complete(rqm);
        }

        print("yessss");
      });
    } else {
      completer.complete(rqm);
    }
    return completer.future;
  }
}
