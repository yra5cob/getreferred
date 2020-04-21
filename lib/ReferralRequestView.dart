import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getreferred/BLoc/ReferralRequestProvider.dart';
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
  ReferralRequestProvider _referralRequestProvider;

  getActionView(ReferralRequestModel rqm) {
    switch (rqm.getModel[ReferralRequestConstants.CURRENT_STAGE]) {
      case ReferralRequestConstants.STAGE_REQUEST_SENT:
        {
          return requestSentView(rqm);
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
          height: 20,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(15)),
                    child: RichText(
                        text: TextSpan(children: [
                      WidgetSpan(
                          child: Icon(
                        Icons.info,
                        color: Colors.blue,
                        size: 16,
                      )),
                      TextSpan(
                          text:
                              " Your profile will be shared with the author. Change what you share in privacy settings.",
                          style: TextStyle(color: Colors.grey[500])),
                    ]))))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                _referralRequestProvider.addReferralRequest(rqm);
              },
            )
          ],
        ),
      ],
    );
  }

  Widget requestSentView(ReferralRequestModel rqm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
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
                          text: Util.readTimestamp(
                              rqm.getModel[ReferralRequestConstants.LAST_ACTION]
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(15)),
              child: Text("Request Sent"),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _profile = Provider.of<ProfileModel>(context);
    _referralRequestProvider = Provider.of<ReferralRequestProvider>(context);

    Future<ReferralRequestModel> getReferalRequestModel() async {
      _referralRequestModel =
          await _referralRequestProvider.getReferralRequestModel(
              referralModel.getModel[ReferralConstants.REFERRAL_ID],
              _profile.getModel[ProfileConstants.USERNAME]);
      return _referralRequestModel;
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
            Row(
              children: <Widget>[
                Text(
                  "Referral request",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            FutureBuilder<ReferralRequestModel>(
                future:
                    getReferalRequestModel(), // a previously-obtained Future<String> or null
                builder: (BuildContext context,
                    AsyncSnapshot<ReferralRequestModel> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]),
                            borderRadius: BorderRadius.circular(15)),
                        child: getActionView(snapshot.data));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
