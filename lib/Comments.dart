import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getreferred/BLoc/CommentsBloc.dart';
import 'package:getreferred/BLoc/CommentsProvider.dart';
import 'package:getreferred/BLoc/FeedProvider.dart';
import 'package:getreferred/BLoc/MyReferralFeedProvider.dart';
import 'package:getreferred/CommentItem.dart';
import 'package:getreferred/ReferralItem.dart';
import 'package:getreferred/constants/CommentsConstant.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/constants/ReferralConstants.dart';
import 'package:getreferred/helper/UiUtilt.dart';
import 'package:getreferred/model/CommentModel.dart';
import 'package:getreferred/model/ProfileModel.dart';
import 'package:getreferred/model/ReferralModel.dart';
import 'package:provider/provider.dart';

class Comments extends StatefulWidget {
  final ReferralModel referralModel;

  const Comments({Key key, this.referralModel}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState(referralModel);
}

class _CommentsState extends State<Comments> {
  final TextEditingController _commentController = new TextEditingController();

  final firestore = Firestore.instance;
  final ReferralModel referralModel;
  var _feedProvider;

  _CommentsState(this.referralModel);

  Widget buildCommentItem(CommentModel d) {
    return new CommentItem(
      commentModel: d,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _profile = Provider.of<ProfileModel>(context);
    if (referralModel.getFeedType == "public") {
      _feedProvider = Provider.of<FeedProvider>(context);
    } else {
      _feedProvider = Provider.of<MyReferralFeedProvider>(context);
    }

    return Scaffold(
      appBar: AppBar(
        leading: UIUtil.getBackButton(context),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: ListView(
          children: <Widget>[
            ReferralItem(
              referralModel: referralModel,
              commentPage: true,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 100),
              child: FutureBuilder<Map<String, CommentModel>>(
                  future: _feedProvider.getComments(
                      referralModel.getModel[ReferralConstants.REFERRAL_ID]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          for (var k in snapshot.data.keys)
                            buildCommentItem(snapshot.data[k])
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.white, border: Border.all(color: Colors.grey[200])),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.green[800],
              radius: 25,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: _profile.getModel[ProfileConstants.PROFILE_PIC_URL],
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: TextField(
              controller: _commentController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Post your questions",
                border: InputBorder.none,
              ),
            )),
            IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  final comment = _commentController.text;
                  setState(() {
                    _commentController.text = '';
                  });
                  DocumentReference documentReference = firestore
                      .collection('referrals')
                      .document(
                          referralModel.getModel[ReferralConstants.REFERRAL_ID])
                      .collection('comments')
                      .document();

                  Map<String, dynamic> model = {
                    CommentsConstant.USER: {
                      ProfileConstants.NAME: {
                        ProfileConstants.FIRST_NAME:
                            _profile.getModel[ProfileConstants.NAME]
                                [ProfileConstants.FIRST_NAME],
                        ProfileConstants.LAST_NAME:
                            _profile.getModel[ProfileConstants.NAME]
                                [ProfileConstants.LAST_NAME]
                      },
                      ProfileConstants.USERNAME:
                          _profile.getModel[ProfileConstants.USERNAME],
                      ProfileConstants.PROFILE_PIC_URL:
                          _profile.getModel[ProfileConstants.PROFILE_PIC_URL],
                      ProfileConstants.HEADLINE:
                          _profile.getModel[ProfileConstants.HEADLINE]
                    },
                    CommentsConstant.COMMENT: comment,
                    CommentsConstant.NUM_REPLIES: 0,
                    ReferralConstants.REFERRAL_ID:
                        referralModel.getModel[ReferralConstants.REFERRAL_ID],
                    CommentsConstant.LAST_REPLY: '',
                    CommentsConstant.DATETIME: DateTime.now(),
                    CommentsConstant.COMMENT_ID: documentReference.documentID,
                  };

                  documentReference.setData(model).then((onValue) {
                    setState(() {
                      _commentController.text = '';
                    });
                  });

                  firestore
                      .collection('referrals')
                      .document(
                          referralModel.getModel[ReferralConstants.REFERRAL_ID])
                      .setData({
                    ReferralConstants.NUM_COMMENTS:
                        referralModel.getModel[ReferralConstants.NUM_COMMENTS] +
                            1
                  }, merge: true).then((onValue) {});
                })
          ],
        ),
      ),
    );
  }
}
