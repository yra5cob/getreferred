import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:getreferred/constants/CommentsConstant.dart';
import 'package:getreferred/model/CommentModel.dart';
import 'package:rxdart/rxdart.dart';

class CommentsBloc extends ChangeNotifier {
  final _commentsSubject = new BehaviorSubject<List<CommentModel>>();
  Stream<List<CommentModel>> get commentsStream => _commentsSubject.stream;

  var _comments = <CommentModel>[];
  final String referralId;

  CommentsBloc({this.referralId}) {
    getComments().then((_) {
      _commentsSubject.add(_comments);
    });
  }

  Future<Null> getComments() async {
    var snap = await Firestore.instance
        .collection('referrals')
        .document(referralId)
        .collection("comments")
        .orderBy(CommentsConstant.DATETIME)
        .snapshots()
        .listen((onData) {
      onData.documentChanges.forEach((doc) {
        if (doc.document.data[CommentsConstant.COMMENT_ID] != null) {
          CommentModel cm = new CommentModel();
          cm.setAll(doc.document.data);
          _comments.add(cm);
        }
      });
    });
  }
}
