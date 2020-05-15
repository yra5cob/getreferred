import 'dart:ui';

import 'package:ReferAll/widget/ToastUtil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ReferAll/BLoc/DynamicLinkProvider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:ReferAll/BLoc/FeedProvider.dart';
import 'package:ReferAll/BLoc/NotificationProvider.dart';
import 'package:ReferAll/BLoc/ProfileProvider.dart';
import 'package:ReferAll/Comments.dart';
import 'package:ReferAll/JDViewer.dart';
import 'package:ReferAll/ReferralRequestView.dart';
import 'package:ReferAll/RequesterMessageView.dart';
import 'package:ReferAll/ViewReferralScreen.dart';
import 'package:ReferAll/constants/NotificationConstants.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/constants/ReferralConstants.dart';
import 'package:ReferAll/constants/ReferralRequestConstants.dart';
import 'package:ReferAll/helper/UiUtilt.dart';
import 'package:ReferAll/helper/Util.dart';
import 'package:ReferAll/model/NotificationModel.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:ReferAll/model/ReferralModel.dart';
import 'package:ReferAll/model/ReferralModel.dart';
import 'package:ReferAll/model/ReferralRequestModel.dart';
import 'package:ReferAll/my_flutter_app_icons.dart';
import 'package:ReferAll/widget/CustomButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ReferralItem extends StatefulWidget {
  bool commentPage = false;

  ReferralModel referralModel;
  Map<String, String> stageMap = {
    ReferralRequestConstants.STAGE_REQUEST_SENT: "Request Sent",
    ReferralRequestConstants.STAGE_REQUEST_REFERRAL_ACCEPTED:
        "Referral Accepted",
    ReferralRequestConstants.STAGE_IN_PROCESS: "In process",
    ReferralRequestConstants.STAGE_IN_PROCESS: "In process",
    ReferralRequestConstants.STAGE_OUT_OF_PROCESS: "Process ended",
    ReferralRequestConstants.STAGE_HIRED: "Hired",
  };

  ReferralItem({this.commentPage, this.referralModel});

  @override
  _ReferralItemState createState() => _ReferralItemState(referralModel);

  factory ReferralItem.fromDocument(DocumentSnapshot document) {
    return ReferralItem(
      commentPage: false,
    );
  }
}

class _ReferralItemState extends State<ReferralItem>
    with TickerProviderStateMixin {
  int numComments = 0;
  int updateItem = 0;
  String statusUpdateText = '';
  Function statusUpdateFunction = () {};
  NotificationProvider notificationProvider;
  bool _request = false;
  bool _provideUpdate = false;
  final ReferralModel referralModel;

  FeedProvider feedProvider;
  ProfileModel _profile;
  TextEditingController _messageController = new TextEditingController();

  bool closeOtherOption = false;

  _ReferralItemState(this.referralModel);

  @override
  void initState() {
    super.initState();
  }

  void _optionsModal() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (!referralModel
                                        .getModel[ReferralConstants.BOOKMARKS]
                                        .contains(_profile.getModel[
                                            ProfileConstants.USERNAME]))
                                      referralModel
                                          .getModel[ReferralConstants.BOOKMARKS]
                                          .add(_profile.getModel[
                                              ProfileConstants.USERNAME]);
                                    else
                                      referralModel
                                          .getModel[ReferralConstants.BOOKMARKS]
                                          .remove(_profile.getModel[
                                              ProfileConstants.USERNAME]);
                                  });
                                  feedProvider.updateReferral(referralModel);
                                },
                                child: ListTile(
                                  leading: Icon(
                                    MyFlutterApp.bookmark_solid,
                                    size: 30,
                                    color: referralModel.getModel[
                                                ReferralConstants.BOOKMARKS]
                                            .contains(_profile.getModel[
                                                ProfileConstants.USERNAME])
                                        ? Colors.cyan
                                        : Colors.black,
                                  ),
                                  title: Text(
                                      referralModel.getModel[
                                                  ReferralConstants.BOOKMARKS]
                                              .contains(_profile.getModel[
                                                  ProfileConstants.USERNAME])
                                          ? "Saved"
                                          : "Save",
                                      style: GoogleFonts.lato(
                                          color: referralModel.getModel[
                                                      ReferralConstants
                                                          .BOOKMARKS]
                                                  .contains(_profile.getModel[ProfileConstants.USERNAME])
                                              ? Colors.cyan
                                              : Colors.black,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16)),
                                  subtitle: Text("Save this referral",
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12)),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: ListTile(
                                leading: Icon(
                                  MyFlutterApp.share_solid,
                                  size: 30,
                                  color: Colors.black,
                                ),
                                title: Text("Share",
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16)),
                                subtitle: Text("Share this referral",
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: ListTile(
                                leading: Icon(
                                  MyFlutterApp.flag,
                                  size: 30,
                                  color: Colors.black,
                                ),
                                title: Text("Flag",
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16)),
                                subtitle: Text("Report this referral",
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: ListTile(
                                leading: Icon(
                                  MyFlutterApp.times_circle,
                                  size: 30,
                                  color: Colors.black,
                                ),
                                title: Text("Hide",
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16)),
                                subtitle: Text(
                                    "Hide this referral from my feed",
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            );
          });
        });
  }

  Route _createRoute(ReferralModel referralModel) {
    return PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        if (referralModel.getModel[ReferralConstants.JD_TYPE] ==
            ReferralConstants.JD_TYPE_LINK)
          return JDViewer(
            jdlink: referralModel.getModel[ReferralConstants.JD_TYPE_LINK],
          );
        else
          return JDViewer(
            jdContent: referralModel.getModel[ReferralConstants.JD],
          );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  Widget getStatusStrip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.cyan[50],
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (referralModel
                      .myRequest.getModel[ReferralRequestConstants.IS_ACTIVE])
                    Text(
                        widget.stageMap[referralModel.myRequest
                            .getModel[ReferralRequestConstants.CURRENT_STAGE]],
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            height: 1.38,
                            fontWeight: FontWeight.w600))
                  else
                    Text("Process ended",
                        style: GoogleFonts.lato(
                            fontSize: 16,
                            height: 1.38,
                            fontWeight: FontWeight.w600)),
                  Text(
                      Util.readTimestamp(referralModel.myRequest.getModel[
                          ReferralRequestConstants.LAST_UPDATE_DATETIME]),
                      style: GoogleFonts.lato(
                          fontSize: 12,
                          height: 1.38,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400))
                ],
              ),
              Stack(
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: IconButton(
                          onPressed: () {
                            Util.navigate(
                                context,
                                RequesterMessageVIew(
                                  referralModel: referralModel,
                                ));
                          },
                          icon: UIUtil.getMasked(MyFlutterApp.envelope)),
                    ),
                  ),
                  if (referralModel.getMyRequest.getRequesterUnreadMessage() >
                      0)
                    Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          referralModel.getMyRequest
                              .getRequesterUnreadMessage()
                              .toString(),
                          style: GoogleFonts.lato(color: Colors.white),
                        ))
                ],
              ),
            ],
          ),
          if (referralModel.myRequest
                      .getModel[ReferralRequestConstants.CURRENT_STAGE] !=
                  ReferralRequestConstants.STAGE_REQUEST_SENT &&
              referralModel.myRequest
                      .getModel[ReferralRequestConstants.CURRENT_STAGE] !=
                  ReferralRequestConstants.STAGE_REQUEST_REFERRAL_ACCEPTED)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.cyan,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: Colors.cyan)),
                child: InkWell(
                  splashColor: Colors.cyan[50],
                  onTap: () {
                    setState(() {
                      if (_provideUpdate)
                        _provideUpdate = false;
                      else
                        _provideUpdate = true;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text("Update Status",
                          style: GoogleFonts.lato(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
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
                        style: GoogleFonts.lato(
                            color: Colors.grey[600], height: 1.38)),
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
                setState(() {
                  _request = false;
                });
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
                        _profile.getModel[ProfileConstants.HEADLINE],
                    ProfileConstants.PUSH_TOKEN:
                        _profile.getModel[ProfileConstants.PUSH_TOKEN],
                  },
                  ReferralConstants.REFERRAL_ID: widget
                      .referralModel.getModel[ReferralConstants.REFERRAL_ID],
                  ReferralRequestConstants.REQUEST_DATETIME: DateTime.now(),
                  ReferralRequestConstants.CURRENT_STAGE:
                      ReferralRequestConstants.STAGE_REQUEST_SENT,
                  ReferralRequestConstants.IS_ACTIVE: true,
                  ReferralRequestConstants.LAST_UPDATE_DATETIME:
                      Timestamp.now(),
                  ReferralRequestConstants.NEXT_ACTION_BY: widget.referralModel
                          .getModel[ReferralConstants.REFERRAL_AUTHOR]
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
                referralModel.getModel[ReferralConstants.REQUESTER_IDS]
                    .add(_profile.getModel[ProfileConstants.USERNAME]);
                feedProvider.updateReferral(referralModel);
                feedProvider.addReferralRequest(rqm, widget.referralModel);
                notificationProvider.sendNotification(
                    referralModel.getModel[ReferralConstants.REFERRAL_AUTHOR]
                        [ProfileConstants.PUSH_TOKEN],
                    "Referral Request: " +
                        referralModel.getModel[ReferralConstants.ROLE] +
                        " at " +
                        referralModel.getModel[ReferralConstants.COMPANY],
                    _messageController.text,
                    referralModel.getModel[ReferralConstants.REFERRAL_AUTHOR]
                        [ProfileConstants.PROFILE_PIC_URL],
                    referralModel.getModel[ReferralConstants.REFERRAL_AUTHOR]
                        [ProfileConstants.USERNAME]);
              },
            )
          ],
        ),
      ],
    );
  }

  Widget getUpdateStrip() {
    switch (updateItem) {
      case 0:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            direction: Axis.horizontal,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: ActionChip(
                  label: Text("No referral communication received",
                      style:
                          GoogleFonts.lato(color: Colors.white, fontSize: 12)),
                  backgroundColor: Colors.cyan,
                  onPressed: () {
                    setState(() {
                      updateItem = 2;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: ActionChip(
                  label: Text("Recieved referral mail",
                      style:
                          GoogleFonts.lato(color: Colors.white, fontSize: 12)),
                  backgroundColor: Colors.cyan,
                  onPressed: () {
                    statusUpdateFunction = () {
                      print("updateedddd");
                      updateStatus(
                          "Recieved referral mail",
                          ReferralRequestConstants.STAGE_IN_PROCESS,
                          ReferralRequestConstants
                              .SUB_STAGE_REFERRAL_MAIL_RECEIVED);
                    };
                    statusUpdateText = "Referral Mail received";
                    setState(() {
                      updateItem = 1;
                    });
                    Future.delayed(const Duration(milliseconds: 3000), () {
                      setState(() {
                        // Here you can write your code for open new view
                        statusUpdateFunction();
                        _provideUpdate = false;
                        updateItem = 0;
                      });
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: ActionChip(
                  label: Text("Received HR call",
                      style:
                          GoogleFonts.lato(color: Colors.white, fontSize: 12)),
                  backgroundColor: Colors.cyan,
                  onPressed: () {
                    statusUpdateFunction = () {
                      updateStatus(
                          "Received HR call",
                          ReferralRequestConstants.STAGE_IN_PROCESS,
                          ReferralRequestConstants.SUB_STAGE_HR_CALL_RECEIVED);
                    };
                    statusUpdateText = "Received HR call";
                    setState(() {
                      updateItem = 1;
                    });
                    Future.delayed(const Duration(milliseconds: 3000), () {
                      setState(() {
                        // Here you can write your code for open new view
                        statusUpdateFunction();
                        _provideUpdate = false;
                        updateItem = 0;
                      });
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: ActionChip(
                  label: Text("Phone screening scheduled",
                      style:
                          GoogleFonts.lato(color: Colors.white, fontSize: 12)),
                  backgroundColor: Colors.cyan,
                  onPressed: () {
                    statusUpdateFunction = () {
                      updateStatus(
                          "Phone screening scheduled",
                          ReferralRequestConstants.STAGE_IN_PROCESS,
                          ReferralRequestConstants
                              .SUB_STAGE_TELEPHONE_SCREENING_SCHEDULED);
                    };
                    statusUpdateText = "Phone screening scheduled";
                    setState(() {
                      updateItem = 1;
                    });
                    Future.delayed(const Duration(milliseconds: 3000), () {
                      setState(() {
                        // Here you can write your code for open new view
                        statusUpdateFunction();
                        _provideUpdate = false;
                        updateItem = 0;
                      });
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: ActionChip(
                  label: Text("Phone screening done",
                      style:
                          GoogleFonts.lato(color: Colors.white, fontSize: 12)),
                  backgroundColor: Colors.cyan,
                  onPressed: () {
                    statusUpdateFunction = () {
                      updateStatus(
                          "Phone screening done",
                          ReferralRequestConstants.STAGE_IN_PROCESS,
                          ReferralRequestConstants
                              .SUB_STAGE_TELEPHONE_SCREENING_DONE);
                    };
                    statusUpdateText = "Phone screening done";
                    setState(() {
                      updateItem = 1;
                    });
                    Future.delayed(const Duration(milliseconds: 3000), () {
                      setState(() {
                        // Here you can write your code for open new view
                        statusUpdateFunction();
                        _provideUpdate = false;
                        updateItem = 0;
                      });
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: ActionChip(
                  label: Text("Interview scheduled",
                      style:
                          GoogleFonts.lato(color: Colors.white, fontSize: 12)),
                  backgroundColor: Colors.cyan,
                  onPressed: () {
                    statusUpdateFunction = () {
                      updateStatus(
                          "Interview scheduled",
                          ReferralRequestConstants.STAGE_IN_PROCESS,
                          ReferralRequestConstants
                              .SUB_STAGE_INTERVIEW_SCHEDULED);
                    };
                    statusUpdateText = "Interview scheduled";
                    setState(() {
                      updateItem = 1;
                    });
                    Future.delayed(const Duration(milliseconds: 3000), () {
                      setState(() {
                        // Here you can write your code for open new view
                        statusUpdateFunction();
                        _provideUpdate = false;
                        updateItem = 0;
                      });
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: ActionChip(
                  label: Text("Interview done",
                      style:
                          GoogleFonts.lato(color: Colors.white, fontSize: 12)),
                  backgroundColor: Colors.cyan,
                  onPressed: () {
                    statusUpdateFunction = () {
                      updateStatus(
                          "Interview done",
                          ReferralRequestConstants.STAGE_IN_PROCESS,
                          ReferralRequestConstants.SUB_STAGE_INTERVIEW_DONE);
                    };
                    statusUpdateText = "Interview done";
                    setState(() {
                      updateItem = 1;
                    });
                    Future.delayed(const Duration(milliseconds: 3000), () {
                      setState(() {
                        // Here you can write your code for open new view
                        statusUpdateFunction();
                        _provideUpdate = false;
                        updateItem = 0;
                      });
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: ActionChip(
                  label: Text("Close this process",
                      style:
                          GoogleFonts.lato(color: Colors.white, fontSize: 12)),
                  backgroundColor: Colors.cyan,
                  onPressed: () {
                    setState(() {
                      updateItem = 3;
                    });
                  },
                ),
              ),
            ],
          ),
        );
        break;
      case 1:
        return Container(
          decoration: BoxDecoration(
              color: Colors.black54, borderRadius: BorderRadius.circular(5)),
          width: double.infinity,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "Status updated to",
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16),
                  ),
                  Text(statusUpdateText,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 12)),
                ],
              )),
              Container(
                width: 2,
                color: Colors.white,
              ),
              InkWell(
                onTap: () {
                  statusUpdateFunction = () {};
                  setState(() {
                    _provideUpdate = false;
                    updateItem = 0;
                    ToastUtils.showCustomToast(context, "Action undone");
                  });
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.undo, color: Colors.yellow, size: 30),
                    Text(
                      "undo",
                      style: GoogleFonts.lato(color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          ),
        );
        break;
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    child: IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          updateItem = 0;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ActionChip(
                      label: Text("No referral communication received",
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 12)),
                      backgroundColor: Colors.cyan,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text(
                "Request update from referrer",
                style: GoogleFonts.lato(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
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
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CustomButton(
                  label: "Send Message ",
                  shadow: false,
                  icon: Icons.send,
                  onTap: () {},
                )
              ],
            ),
          ],
        );
        break;
      case 3:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    child: IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          updateItem = 0;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ActionChip(
                      label: Text("Close process",
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 12)),
                      backgroundColor: Colors.cyan,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ActionChip(
                      label: Text("No communication from HR",
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 12)),
                      backgroundColor: Colors.cyan,
                      onPressed: () {
                        statusUpdateFunction = () {
                          updateStatus("No communication from HR",
                              ReferralRequestConstants.STAGE_OUT_OF_PROCESS, "",
                              close: true,
                              closeMessage: ReferralRequestConstants
                                  .CLOSE_REASON_NO_HR_COMMUNICATION);
                        };
                        statusUpdateText = "No communication from HR";
                        setState(() {
                          updateItem = 1;
                        });
                        Future.delayed(const Duration(milliseconds: 3000), () {
                          setState(() {
                            // Here you can write your code for open new view
                            statusUpdateFunction();
                            _provideUpdate = false;
                            updateItem = 0;
                          });
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ActionChip(
                      label: Text("Out of interview process",
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 12)),
                      backgroundColor: Colors.cyan,
                      onPressed: () {
                        statusUpdateFunction = () {
                          updateStatus("Out of interview process",
                              ReferralRequestConstants.STAGE_OUT_OF_PROCESS, "",
                              close: true,
                              closeMessage: ReferralRequestConstants
                                  .CLOSE_REASON_CODE_OUT_OF_PROCESS);
                        };
                        statusUpdateText = "Out of interview process";
                        setState(() {
                          updateItem = 1;
                        });
                        Future.delayed(const Duration(milliseconds: 3000), () {
                          setState(() {
                            // Here you can write your code for open new view
                            statusUpdateFunction();
                            _provideUpdate = false;
                            updateItem = 0;
                          });
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ActionChip(
                      label: Text("No referral communication received",
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 12)),
                      backgroundColor: Colors.cyan,
                      onPressed: () {
                        statusUpdateFunction = () {
                          updateStatus("No referral communication received",
                              ReferralRequestConstants.STAGE_OUT_OF_PROCESS, "",
                              close: true,
                              closeMessage: ReferralRequestConstants
                                  .CLOSE_REASON_NO_REFERRAL_CONFIRMATION);
                        };
                        statusUpdateText = "No referral communication received";
                        setState(() {
                          updateItem = 1;
                        });
                        Future.delayed(const Duration(milliseconds: 3000), () {
                          setState(() {
                            // Here you can write your code for open new view
                            statusUpdateFunction();
                            _provideUpdate = false;
                            updateItem = 0;
                          });
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ActionChip(
                      label: Text("Offer rejected",
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 12)),
                      backgroundColor: Colors.cyan,
                      onPressed: () {
                        statusUpdateFunction = () {
                          updateStatus("Offer rejected",
                              ReferralRequestConstants.STAGE_OUT_OF_PROCESS, "",
                              close: true,
                              closeMessage: ReferralRequestConstants
                                  .CLOSE_REASON_OFFER_REJECTED);
                        };
                        statusUpdateText = "Offer rejected";
                        setState(() {
                          updateItem = 1;
                        });
                        Future.delayed(const Duration(milliseconds: 3000), () {
                          setState(() {
                            // Here you can write your code for open new view
                            statusUpdateFunction();
                            _provideUpdate = false;
                            updateItem = 0;
                          });
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ActionChip(
                      label: Text("Other",
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 12)),
                      backgroundColor: Colors.cyan,
                      onPressed: () {
                        if (closeOtherOption)
                          closeOtherOption = false;
                        else
                          closeOtherOption = true;
                      },
                    ),
                  ),
                ],
              ),
              if (closeOtherOption)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
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
                                  hintText: "Close reason...",
                                ),
                              ),
                            ),
                          ],
                        )),
                    CustomButton(
                      label: "Close",
                    ),
                  ],
                )
            ],
          ),
        );
        break;
    }
    ;
    return Container();
  }

  void updateStatus(String message, String stage, String subStage,
      {bool close = false, String closeMessage = ""}) {
    var data = {
      ReferralRequestConstants.STAGE: stage,
      ReferralRequestConstants.MESSAGE: message,
      ReferralRequestConstants.ACTION_DATETIME: Timestamp.now(),
      ReferralRequestConstants.ATTACHMENT_URL: null,
      ReferralRequestConstants.SUB_STAGE: subStage,
      ReferralRequestConstants.IS_ATTACHMENT: false,
      ReferralRequestConstants.ACTION_BY:
          ReferralRequestConstants.ACTION_BY_REQUESTER,
      ReferralRequestConstants.ACTION_SEEN: false,
    };
    referralModel.myRequest.getModel[ReferralRequestConstants.ACTIONS]
        .add(data);
    referralModel.myRequest.getModel[ReferralRequestConstants.LAST_ACTION] =
        data;
    if (close) {
      referralModel.myRequest.getModel[ReferralRequestConstants.CLOSE_DATE] =
          Timestamp.now();

      referralModel.myRequest.getModel[ReferralRequestConstants.CLOSE_REASON] =
          closeMessage;

      referralModel.myRequest.getModel[ReferralRequestConstants.IS_ACTIVE] =
          false;
    }
    referralModel.myRequest.getModel[ReferralRequestConstants.CURRENT_STAGE] =
        stage;
    feedProvider.saveReferralRequest(referralModel.myRequest);
  }

  @override
  Widget build(BuildContext context) {
    _profile = Provider.of<ProfileProvider>(context).getProfile();
    notificationProvider = Provider.of<NotificationProvider>(context);
    feedProvider = Provider.of<FeedProvider>(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey,
                //     offset: Offset(0, 5),
                //     blurRadius: 3,
                //   )
                // ],
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 5),
                                blurRadius: 3,
                              )
                            ],
                            gradient: LinearGradient(
                                colors: [Util.getColor1(), Util.getColor2()]),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              widget.referralModel
                                      .getModel[ReferralConstants.ROLE] +
                                  " at " +
                                  widget.referralModel
                                      .getModel[ReferralConstants.COMPANY],
                              style: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  height: 1.38),
                            ),
                            Row(
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Icon(
                                    LineAwesomeIcons.map_marker,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    widget.referralModel
                                        .getModel[ReferralConstants.LOCATION],
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.white,
                                        height: 1.38),
                                  )
                                ]),
                                SizedBox(
                                  width: 8,
                                ),
                                Row(children: <Widget>[
                                  Icon(
                                    LineAwesomeIcons.dollar,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    widget.referralModel
                                        .getModel[ReferralConstants.CTC],
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.white,
                                        height: 1.38),
                                  )
                                ])
                              ],
                            ),
                            Divider(color: Colors.white),
                            Wrap(
                              direction: Axis.horizontal,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: <Widget>[
                                if (widget.referralModel
                                    .getModel[ReferralConstants.EXPERIENCE]
                                    .toString()
                                    .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 16.0,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            widget.referralModel.getModel[
                                                    ReferralConstants
                                                        .EXPERIENCE] +
                                                " Years",
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "Experience",
                                            style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (widget
                                    .referralModel
                                    .getModel[ReferralConstants.COLLEGE_REQ]
                                    .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 16.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            widget
                                                .referralModel
                                                .getModel[ReferralConstants
                                                    .COLLEGE_REQ]
                                                .toString()
                                                .replaceAll("[", "")
                                                .replaceAll("]", ""),
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "College",
                                            style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (widget
                                    .referralModel
                                    .getModel[ReferralConstants.GRADUATION_REQ]
                                    .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 16.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            widget
                                                .referralModel
                                                .getModel[ReferralConstants
                                                    .GRADUATION_REQ]
                                                .toString()
                                                .replaceAll("[", "")
                                                .replaceAll("]", ""),
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "Graduation Year",
                                            style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (widget.referralModel
                                    .getModel[ReferralConstants.TRAVEL_REQ]
                                    .toString()
                                    .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 16.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            widget
                                                .referralModel
                                                .getModel[ReferralConstants
                                                    .TRAVEL_REQ]
                                                .toString(),
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "Travel Requirement",
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(_createRoute(widget.referralModel));
                              },
                              highlightColor: Colors.cyan,
                              child: Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "View job description",
                                      style: GoogleFonts.lato(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      LineAwesomeIcons.angle_double_right,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Material(
                        color: Colors.black26,
                        shape: CircleBorder(),
                        child: InkWell(
                          onTap: () {
                            _optionsModal();
                          },
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  margin: EdgeInsets.only(left: 10, right: 10, top: 1),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Wrap(
                          children: <Widget>[
                            Text(
                              widget.referralModel
                                  .getModel[ReferralConstants.AUTHOR_NOTE],
                              textAlign: TextAlign.left,
                              style:
                                  GoogleFonts.lato(fontSize: 14, height: 1.38),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.cyan,
                                radius: 20,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: widget.referralModel.getModel[
                                            ReferralConstants.REFERRAL_AUTHOR]
                                        [ProfileConstants.PROFILE_PIC_URL],
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.cover,
                                    width: 38.0,
                                    height: 38.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.referralModel.getModel[
                                                    ReferralConstants
                                                        .REFERRAL_AUTHOR]
                                                [ProfileConstants.NAME]
                                            [ProfileConstants.FIRST_NAME] +
                                        " " +
                                        widget.referralModel.getModel[
                                                    ReferralConstants
                                                        .REFERRAL_AUTHOR]
                                                [ProfileConstants.NAME]
                                            [ProfileConstants.LAST_NAME],
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    widget.referralModel.getModel[
                                            ReferralConstants.REFERRAL_AUTHOR]
                                        [ProfileConstants.HEADLINE],
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[500]),
                                  ),
                                  Text(
                                    Util.readTimestamp(widget.referralModel
                                        .getModel[ReferralConstants.POST_DATE]),
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        height: 1.38,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 20, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Util.navigate(
                                    context,
                                    Comments(
                                        referralModel: widget.referralModel));
                              },
                              child:
                                  UIUtil.getMasked(LineAwesomeIcons.comments),
                            ),
                            Text(
                                " " +
                                    widget
                                        .referralModel
                                        .getModel[
                                            ReferralConstants.NUM_COMMENTS]
                                        .toString() +
                                    " • ",
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.grey[500])),
                            InkWell(
                              onTap: () {
                                String description = "Location: " +
                                    referralModel
                                        .getModel[ReferralConstants.LOCATION] +
                                    ", Experience required: " +
                                    referralModel.getModel[
                                        ReferralConstants.EXPERIENCE] +
                                    " Years";
                                final RenderBox box =
                                    context.findRenderObject();

                                DynamicLinkProvider dynamicLinkProvider =
                                    Provider.of<DynamicLinkProvider>(context,
                                        listen: false);
                                dynamicLinkProvider
                                    .createDynamicLink(
                                        true,
                                        "referral/" +
                                            referralModel.getModel[
                                                    ReferralConstants
                                                        .REFERRAL_ID]
                                                .toString(),
                                        referralModel.getModel[
                                                ReferralConstants.ROLE] +
                                            " at " +
                                            referralModel.getModel[
                                                ReferralConstants.COMPANY],
                                        description)
                                    .then((link) {
                                  Share.share(link,
                                      subject: referralModel.getModel[
                                              ReferralConstants.ROLE] +
                                          " at " +
                                          referralModel.getModel[
                                              ReferralConstants.COMPANY],
                                      sharePositionOrigin:
                                          box.localToGlobal(Offset.zero) &
                                              box.size);

                                  referralModel.getModel[
                                      ReferralConstants.NUM_SHARES] += 1;
                                  feedProvider.updateReferral(referralModel);
                                });
                              },
                              child: UIUtil.getMasked(LineAwesomeIcons.share),
                            ),
                            Text(
                                " " +
                                    widget.referralModel
                                        .getModel[ReferralConstants.NUM_SHARES]
                                        .toString(),
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.grey[500])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Material(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 500),
                          firstChild: Row(
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (_request)
                                        _request = false;
                                      else {
                                        _request = true;
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.cyan[50],
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          MyFlutterApp.hands_helping_solid,
                                          color: Colors.cyan,
                                        ),
                                        Text(
                                          "  Request",
                                          style: GoogleFonts.lato(
                                              color: Colors.cyan),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          secondChild: referralModel.getMyRequest.getModel[
                                      ReferralRequestConstants.CURRENT_STAGE] ==
                                  ''
                              ? Container()
                              : getStatusStrip(),
                          crossFadeState: referralModel.getMyRequest.getModel[
                                      ReferralRequestConstants.CURRENT_STAGE] ==
                                  ''
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                    vsync: this,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                    child: Container(
                        child: Container(
                            child: !_request
                                ? null
                                : AnimatedOpacity(
                                    opacity: _request ? 1.0 : 0.0,
                                    duration: Duration(milliseconds: 1000),
                                    child: defaultReferralRequestView(
                                        new ReferralRequestModel()))))),
                AnimatedSize(
                    vsync: this,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                    child: Container(
                        child: !_provideUpdate
                            ? null
                            : AnimatedOpacity(
                                opacity: _provideUpdate ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 1000),
                                child: getUpdateStrip()))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
