import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getreferred/BLoc/FeedProvider.dart';
import 'package:getreferred/BLoc/MyReferralFeedProvider.dart';

import 'package:getreferred/CommentItem.dart';
import 'package:getreferred/ReferralItem.dart';
import 'package:getreferred/constants/CommentsConstant.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/constants/ReferralConstants.dart';
import 'package:getreferred/constants/ReferralRequestConstants.dart';
import 'package:getreferred/helper/UiUtilt.dart';
import 'package:getreferred/helper/Util.dart';
import 'package:getreferred/model/ReferralRequestModel.dart';
import 'package:getreferred/model/ProfileModel.dart';
import 'package:getreferred/model/ReferralModel.dart';
import 'package:getreferred/widget/CustomButton.dart';
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
  ReferralRequestModel _referralRequestModel;
  _ReferralRequestViewState(this.referralModel);
  ProfileModel _profile;
  FeedProvider feedProvider;

  getActionView(ReferralRequestModel rqm) {
    switch (rqm.getModel[ReferralRequestConstants.CURRENT_STAGE]) {
      case ReferralRequestConstants.STAGE_REQUEST_SENT:
        {
          return requestInProcessView(rqm);
        }
        break;
      default:
        {
          return defaultReferralRequestView(rqm);
        }
        break;
    }
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
                    }
                  ],
                  ReferralRequestConstants.CLOSE_DATE: null,
                  ReferralRequestConstants.CLOSE_MESSAGE: null,
                };

                rqm.setAll(model);
                feedProvider.addReferralRequest(rqm);
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

  @override
  Widget build(BuildContext context) {
    _profile = Provider.of<ProfileModel>(context);
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
            SizedBox(
              height: 10,
            ),

            // a previously-obtained Future<String> or null

            Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]),
                    borderRadius: BorderRadius.circular(15)),
                child: getActionView(referralModel.getMyRequest)),
          ],
        ),
      ),
    );
  }
}
