import 'package:flutter/cupertino.dart';
import 'package:getreferred/BLoc/CommentsBloc.dart';
import 'package:getreferred/Repository/Repository.dart';
import 'package:getreferred/model/CommentModel.dart';

class CommentsssProvider extends ChangeNotifier {
  final Map<String, Map<String, CommentModel>> commentsCache = {};
  Repository _repository = new Repository();

  Future<Map<String, CommentModel>> getCommentsBloc(String referralId) async {
    if (commentsCache.containsKey(referralId))
      return commentsCache[referralId];
    else {
      Map<String, CommentModel> cmList =
          await _repository.getComments(referralId, () {
        notifyListeners();
      });
      commentsCache[referralId] = cmList;
      return cmList;
    }
  }
}
