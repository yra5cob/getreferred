import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:getreferred/Comments.dart';
import 'package:getreferred/JDViewer.dart';
import 'package:getreferred/ReferralRequestView.dart';
import 'package:getreferred/ViewReferralScreen.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/constants/ReferralConstants.dart';
import 'package:getreferred/constants/ReferralRequestConstants.dart';
import 'package:getreferred/helper/UiUtilt.dart';
import 'package:getreferred/helper/Util.dart';
import 'package:getreferred/model/ReferralModel.dart';
import 'package:getreferred/model/ReferralModel.dart';
import 'package:getreferred/my_flutter_app_icons.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:line_icons/line_icons.dart';

class ReferralItem extends StatelessWidget {
  bool commentPage = false;
  ReferralModel referralModel = new ReferralModel();
  int numComments = 0;
  final firestore = Firestore.instance;
  ReferralItem({DocumentSnapshot doc, this.commentPage, this.referralModel}) {
    if (referralModel == null) {
      referralModel = new ReferralModel();
    }
    if (doc != null) referralModel.setAll(doc.data);
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

  @override
  Widget build(BuildContext context) {
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
                Container(
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
                        referralModel.getModel[ReferralConstants.ROLE] +
                            " at " +
                            referralModel.getModel[ReferralConstants.COMPANY],
                        style: TextStyle(
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
                              referralModel
                                  .getModel[ReferralConstants.LOCATION],
                              style: TextStyle(
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
                              referralModel.getModel[ReferralConstants.CTC],
                              style: TextStyle(
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
                          if (referralModel
                              .getModel[ReferralConstants.EXPERIENCE]
                              .toString()
                              .isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 16.0,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      referralModel.getModel[
                                              ReferralConstants.EXPERIENCE] +
                                          " Years",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "Experience",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (referralModel
                              .getModel[ReferralConstants.COLLEGE_REQ]
                              .isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 16.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      referralModel.getModel[
                                              ReferralConstants.COLLEGE_REQ]
                                          .toString()
                                          .replaceAll("[", "")
                                          .replaceAll("]", ""),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "College",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (referralModel
                              .getModel[ReferralConstants.GRADUATION_REQ]
                              .isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 16.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      referralModel.getModel[
                                              ReferralConstants.GRADUATION_REQ]
                                          .toString()
                                          .replaceAll("[", "")
                                          .replaceAll("]", ""),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "Graduation Year",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (referralModel
                              .getModel[ReferralConstants.TRAVEL_REQ]
                              .toString()
                              .isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 16.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      referralModel.getModel[
                                              ReferralConstants.TRAVEL_REQ]
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "Travel Requirement",
                                      style: TextStyle(
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
                              .push(_createRoute(referralModel));
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
                                style: TextStyle(
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
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Wrap(
                          children: <Widget>[
                            Text(
                              referralModel
                                  .getModel[ReferralConstants.AUTHOR_NOTE],
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 14, height: 1.38),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.cyan,
                                    radius: 20,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: referralModel.getModel[
                                                ReferralConstants
                                                    .REFERRAL_AUTHOR]
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        referralModel.getModel[ReferralConstants
                                                        .REFERRAL_AUTHOR]
                                                    [ProfileConstants.NAME]
                                                [ProfileConstants.FIRST_NAME] +
                                            " " +
                                            referralModel.getModel[
                                                        ReferralConstants
                                                            .REFERRAL_AUTHOR]
                                                    [ProfileConstants.NAME]
                                                [ProfileConstants.LAST_NAME],
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        referralModel.getModel[ReferralConstants
                                                .REFERRAL_AUTHOR]
                                            [ProfileConstants.HEADLINE],
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[500]),
                                      ),
                                      Text(
                                        Util.readTimestamp(
                                            referralModel.getModel[
                                                ReferralConstants.POST_DATE]),
                                        style: TextStyle(
                                            fontSize: 12,
                                            height: 1.38,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Util.navigate(
                                  context,
                                  ReferralRequestView(
                                    referralModel: referralModel,
                                  ));
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 3,
                                      offset: Offset(0, 2))
                                ],
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                color: referralModel.getMyRequest.getModel[
                                            ReferralRequestConstants
                                                .CURRENT_STAGE] ==
                                        ''
                                    ? Colors.cyan[50]
                                    : Colors.green[50],
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    MyFlutterApp.hands_helping_solid,
                                    color: referralModel.getMyRequest.getModel[
                                                ReferralRequestConstants
                                                    .CURRENT_STAGE] ==
                                            ''
                                        ? Colors.cyan
                                        : Colors.green,
                                  ),
                                  referralModel.getMyRequest.getModel[
                                              ReferralRequestConstants
                                                  .CURRENT_STAGE] ==
                                          ''
                                      ? Text(
                                          "  Request",
                                          style: TextStyle(color: Colors.cyan),
                                        )
                                      : Text(
                                          "  Requested",
                                          style: TextStyle(
                                              color: Colors.green[700]),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 20, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Util.navigate(context,
                                    Comments(referralModel: referralModel));
                              },
                              child: UIUtil.getMasked(LineAwesomeIcons.comment),
                            ),
                            Text(
                                " " +
                                    referralModel.getModel[
                                            ReferralConstants.NUM_COMMENTS]
                                        .toString() +
                                    " • ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.grey[500])),
                            UIUtil.getMasked(LineAwesomeIcons.share),
                            Text(
                                " " +
                                    referralModel
                                        .getModel[ReferralConstants.NUM_SHARES]
                                        .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.grey[500]))
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  factory ReferralItem.fromDocument(DocumentSnapshot document) {
    return ReferralItem(
      doc: document,
      commentPage: false,
    );
  }
}
