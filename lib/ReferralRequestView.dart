import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ReferAll/BLoc/FeedProvider.dart';
import 'package:ReferAll/BLoc/MyReferralFeedProvider.dart';
import 'package:ReferAll/BLoc/ProfileProvider.dart';

import 'package:ReferAll/CommentItem.dart';
import 'package:ReferAll/ReferralItem.dart';
import 'package:ReferAll/constants/CommentsConstant.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/constants/ReferralConstants.dart';
import 'package:ReferAll/constants/ReferralRequestConstants.dart';
import 'package:ReferAll/helper/UiUtilt.dart';
import 'package:ReferAll/helper/Util.dart';
import 'package:ReferAll/model/ReferralRequestModel.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:ReferAll/model/ReferralModel.dart';
import 'package:ReferAll/widget/CustomButton.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ReferralRequestView extends StatefulWidget {
  final ReferralModel referralModel;

  const ReferralRequestView({Key key, this.referralModel}) : super(key: key);

  @override
  _ReferralRequestViewState createState() =>
      _ReferralRequestViewState(referralModel);
}

class _ReferralRequestViewState extends State<ReferralRequestView> {
  final TextEditingController _messageController =
      new TextEditingController(text: '');

  final firestore = Firestore.instance;
  final ReferralModel referralModel;

  TextEditingController replyController = new TextEditingController();
  _ReferralRequestViewState(this.referralModel);
  ProfileModel _profile;
  FeedProvider feedProvider;
  String currentDate;
  String currentStage;
  MyReferralFeedProvider _myReferralFeedProvider;
  Map<String, String> stageMap = {
    ReferralRequestConstants.STAGE_REQUEST_SENT: "Request Sent",
    ReferralRequestConstants.STAGE_REQUEST_REFERRAL_ACCEPTED:
        "Referral Accepted"
  };

  getActionView(ReferralRequestModel rqm) {
    switch (rqm.getModel[ReferralRequestConstants.CURRENT_STAGE]) {
      case '':
        {
          return defaultReferralRequestView(rqm);
        }
        break;
      default:
        {
          return getTimeLine(rqm);
        }
        break;
    }
  }

  Widget requesterMessage(String time, String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.cyan[50],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  message,
                  style: TextStyle(
                      color: Colors.black, fontSize: 14, height: 1.38),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      time,
                      style: TextStyle(
                          color: Colors.grey, fontSize: 12, height: 1.38),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget authorMessage(String time, String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  message,
                  style: TextStyle(
                      color: Colors.black, fontSize: 14, height: 1.38),
                ),
                Text(
                  time,
                  style:
                      TextStyle(color: Colors.grey, fontSize: 12, height: 1.38),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget defaultReferralRequestView(ReferralRequestModel rqm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 8,
        ),
        Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.cyan[50],
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.info,
                  color: Colors.blue,
                  size: 16,
                ),
                SizedBox(
                  width: 2,
                ),
                Expanded(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text:
                            " Your profile information will be shared with the author. Change what you share in privacy settings.",
                        style:
                            TextStyle(color: Colors.grey[600], height: 1.38)),
                  ])),
                ),
              ],
            )),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Text(
            "Send Request",
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.cyan,
              radius: 25,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: _profile.getModel[ProfileConstants.PROFILE_PIC_URL],
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                  width: 48.0,
                  height: 48.0,
                ),
              ),
            ),
            Expanded(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey[300]),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Type your message...",
                                  ),
                                ),
                              ),
                            ],
                          ))
                    ]))),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            CustomButton(
              label: "Send request ",
              shadow: false,
              icon: Icons.send,
              onTap: () {
                Map<String, dynamic> model = {
                  ReferralRequestConstants.REQUESTER: {
                    ProfileConstants.NAME: {
                      ProfileConstants.FIRST_NAME:
                          _profile.getModel[ProfileConstants.NAME]
                              [ProfileConstants.FIRST_NAME],
                      ProfileConstants.LAST_NAME:
                          _profile.getModel[ProfileConstants.NAME]
                              [ProfileConstants.LAST_NAME],
                    },
                    ProfileConstants.USERNAME:
                        _profile.getModel[ProfileConstants.USERNAME],
                    ProfileConstants.PROFILE_PIC_URL:
                        _profile.getModel[ProfileConstants.PROFILE_PIC_URL],
                    ProfileConstants.HEADLINE:
                        _profile.getModel[ProfileConstants.HEADLINE]
                  },
                  ReferralConstants.REFERRAL_ID:
                      referralModel.getModel[ReferralConstants.REFERRAL_ID],
                  ReferralRequestConstants.REQUEST_DATETIME: DateTime.now(),
                  ReferralRequestConstants.CURRENT_STAGE:
                      ReferralRequestConstants.STAGE_REQUEST_SENT,
                  ReferralRequestConstants.IS_ACTIVE: true,
                  ReferralRequestConstants.NEXT_ACTION_BY:
                      referralModel.getModel[ReferralConstants.REFERRAL_AUTHOR]
                          [ProfileConstants.USERNAME],
                  ReferralRequestConstants.LAST_ACTION: {
                    ReferralRequestConstants.STAGE:
                        ReferralRequestConstants.STAGE_REQUEST_SENT,
                    ReferralRequestConstants.MESSAGE: _messageController.text,
                    ReferralRequestConstants.ACTION_DATETIME: DateTime.now(),
                    ReferralRequestConstants.ATTACHMENT_URL: null,
                    ReferralRequestConstants.IS_ATTACHMENT: false,
                    ReferralRequestConstants.ACTION_BY:
                        ReferralRequestConstants.ACTION_BY_REQUESTER,
                    ReferralRequestConstants.ACTION_SEEN: false,
                  },
                  ReferralRequestConstants.ACTIONS: [
                    {
                      ReferralRequestConstants.STAGE:
                          ReferralRequestConstants.STAGE_REQUEST_SENT,
                      ReferralRequestConstants.MESSAGE: _messageController.text,
                      ReferralRequestConstants.ACTION_DATETIME: DateTime.now(),
                      ReferralRequestConstants.ATTACHMENT_URL: null,
                      ReferralRequestConstants.IS_ATTACHMENT: false,
                      ReferralRequestConstants.ACTION_BY:
                          ReferralRequestConstants.ACTION_BY_REQUESTER,
                      ReferralRequestConstants.ACTION_SEEN: false,
                    }
                  ],
                  ReferralRequestConstants.CLOSE_DATE: null,
                  ReferralRequestConstants.CLOSE_REASON: null,
                };

                rqm.setAll(model);
                feedProvider.addReferralRequest(rqm, referralModel);
              },
            )
          ],
        ),
      ],
    );
  }

  Widget requestInProcessView(ReferralRequestModel rqm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          child: Text("Request timeline",
              style: Theme.of(context).textTheme.title),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            Container(
              height: 10,
              width: 10,
              margin: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Util.getColor2(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 2),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: LinearGradient(
                      colors: [Util.getColor1(), Util.getColor2()])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Request sent",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 7, vertical: 0),
          constraints: BoxConstraints(minHeight: 100),
          decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.cyan, width: 5))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        borderRadius: BorderRadius.circular(50)),
                    child: Text("27 March 2020"),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.cyan[50],
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          rqm.getModel[ReferralRequestConstants.LAST_ACTION]
                              [ReferralRequestConstants.MESSAGE],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: Util.readTimestamp(rqm.getModel[
                                        ReferralRequestConstants.LAST_ACTION]
                                    [ReferralRequestConstants.ACTION_DATETIME]),
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12)),
                          ]),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              height: 10,
              width: 10,
              margin: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Util.getColor2(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 2),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: LinearGradient(
                      colors: [Colors.grey[500], Colors.grey[800]])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Referrer action pending",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  getTimeLine(ReferralRequestModel rqm) {
    List<Widget> _widgets = [];
    var formatter = new DateFormat('dd MMMM, yyyy');
    String currentDate;
    String currentStage;
    for (int i = 0;
        i < rqm.getModel[ReferralRequestConstants.ACTIONS].length;
        i++) {
      var f = rqm.getModel[ReferralRequestConstants.ACTIONS][i];

      if (currentStage != f[ReferralRequestConstants.STAGE]) {
        _widgets.add(
          Row(
            children: <Widget>[
              Container(
                height: 10,
                width: 10,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Util.getColor2(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 2, top: 10),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                        colors: [Util.getColor1(), Util.getColor2()])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      stageMap[f[ReferralRequestConstants.STAGE]],
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
        currentStage = f[ReferralRequestConstants.STAGE];
      }
      if (currentDate !=
          formatter.format(Util.TimeStampToDateTime(
              f[ReferralRequestConstants.ACTION_DATETIME]))) {
        currentDate = formatter.format(Util.TimeStampToDateTime(
            f[ReferralRequestConstants.ACTION_DATETIME]));
        _widgets.add(Container(
          decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.cyan, width: 5))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Chip(label: Text(currentDate)),
            ],
          ),
        ));
      }
      if (f[ReferralRequestConstants.ACTION_BY] ==
              ReferralRequestConstants.ACTION_BY_AUTHOR &&
          f[ReferralRequestConstants.MESSAGE].toString().isNotEmpty)
        _widgets.add(Container(
            decoration: BoxDecoration(
                border: Border(left: BorderSide(color: Colors.cyan, width: 5))),
            child: authorMessage(
                Util.readTimestamp(f[ReferralRequestConstants.ACTION_DATETIME]),
                f[ReferralRequestConstants.MESSAGE])));
      else if (f[ReferralRequestConstants.ACTION_BY] ==
              ReferralRequestConstants.ACTION_BY_REQUESTER &&
          f[ReferralRequestConstants.MESSAGE].toString().isNotEmpty)
        _widgets.add(Container(
            decoration: BoxDecoration(
                border: Border(left: BorderSide(color: Colors.cyan, width: 5))),
            child: requesterMessage(
                Util.readTimestamp(f[ReferralRequestConstants.ACTION_DATETIME]),
                f[ReferralRequestConstants.MESSAGE])));

      if (i == rqm.getModel[ReferralRequestConstants.ACTIONS].length - 1) {
        if (f[ReferralRequestConstants.NEXT_ACTION_BY] !=
            rqm.getModel[ReferralRequestConstants.REQUESTER]
                [ProfileConstants.USERNAME]) {
          _widgets.add(
            Row(
              children: <Widget>[
                Container(
                  height: 10,
                  width: 10,
                  margin: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Util.getColor2(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 2),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(
                          colors: [Colors.grey[500], Colors.grey[800]])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Referrer action pending",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
      }
    }

    _widgets.add(Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      height: 80,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[200]),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: replyController,
              decoration: InputDecoration(
                  hintText: "Type your message...", border: InputBorder.none),
            ),
          ),
          InkWell(
            child: UIUtil.getMasked(Icons.attach_file, size: 40),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Map<String, dynamic> action = {
                ReferralRequestConstants.STAGE:
                    rqm.getModel[ReferralRequestConstants.CURRENT_STAGE],
                ReferralRequestConstants.MESSAGE: replyController.text,
                ReferralRequestConstants.ACTION_DATETIME: Timestamp.now(),
                ReferralRequestConstants.ATTACHMENT_URL: null,
                ReferralRequestConstants.IS_ATTACHMENT: false,
                ReferralRequestConstants.ACTION_SEEN: false,
                ReferralRequestConstants.ACTION_BY:
                    ReferralRequestConstants.ACTION_BY_REQUESTER,
              };
              rqm.getModel[ReferralRequestConstants.ACTIONS].add(action);
              rqm.getModel[ReferralRequestConstants.LAST_ACTION] = action;
              replyController.text = '';
              feedProvider.saveMyReferralRequest(rqm).then((onValue) {});
            },
            child: UIUtil.getMasked(LineAwesomeIcons.send, size: 40),
          )
        ],
      ),
    ));

    return Column(children: _widgets);
  }

  @override
  Widget build(BuildContext context) {
    _profile = Provider.of<ProfileProvider>(context).getProfile();
    feedProvider = Provider.of<FeedProvider>(context);
    Future<ReferralRequestModel> getReferalRequestModel() async {
      if (referralModel.getMyRequest == null) {
        return new ReferralRequestModel();
      }
      return referralModel.getMyRequest;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 70),
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey, blurRadius: 6, offset: Offset(0, 1))
              // ],
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
              height: 10,
            ),

            // a previously-obtained Future<String> or null

            Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: getActionView(referralModel.getMyRequest)),
          ],
        ),
      ),
    );
  }
}
