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
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'helper/Util.dart';

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
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 70),
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, blurRadius: 6, offset: Offset(0, 1))
              ],
            ),
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: ShaderMask(
                      blendMode: BlendMode.srcATop,
                      shaderCallback: (bounds) => RadialGradient(
                        center: Alignment.center,
                        radius: 0.5,
                        colors: [Util.getColor1(), Util.getColor2()],
                        tileMode: TileMode.mirror,
                      ).createShader(bounds),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 28.0,
                        color: Colors.cyan,
                      ),
                    ),
                    onPressed: () {}),
                Spacer(),
                IconButton(
                    icon: ShaderMask(
                      blendMode: BlendMode.srcATop,
                      shaderCallback: (bounds) => RadialGradient(
                        center: Alignment.center,
                        radius: 0.5,
                        colors: [Util.getColor1(), Util.getColor2()],
                        tileMode: TileMode.mirror,
                      ).createShader(bounds),
                      child: Icon(
                        LineAwesomeIcons.ellipsis_v,
                        size: 28.0,
                        color: Colors.cyan,
                      ),
                    ),
                    onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            ReferralItem(
              referralModel: referralModel,
              commentPage: true,
            ),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
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
                            buildCommentItem(snapshot.data[k]),
                          SizedBox(
                            height: 100,
                          )
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
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, -2))
        ], color: Colors.white, border: Border.all(color: Colors.grey[200])),
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
                icon: ShaderMask(
                  blendMode: BlendMode.srcATop,
                  shaderCallback: (bounds) => RadialGradient(
                    center: Alignment.center,
                    radius: 0.5,
                    colors: [Util.getColor1(), Util.getColor2()],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds),
                  child: Icon(
                    Icons.send,
                    size: 28.0,
                    color: Colors.cyan,
                  ),
                ),
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
