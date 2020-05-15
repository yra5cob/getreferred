import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:ReferAll/Comments.dart';
import 'package:ReferAll/JDViewer.dart';
import 'package:ReferAll/ReferralRequestView.dart';

import 'package:ReferAll/ViewReferralScreen.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/constants/ReferralConstants.dart';
import 'package:ReferAll/helper/UiUtilt.dart';
import 'package:ReferAll/helper/Util.dart';
import 'package:ReferAll/model/ReferralModel.dart';
import 'package:ReferAll/model/ReferralModel.dart';

import 'package:ReferAll/widget/CustomButton.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:line_icons/line_icons.dart';

class MyReferralItem3 extends StatefulWidget {
  bool viewPage = false;
  ReferralModel referralModel = new ReferralModel();

  MyReferralItem3({DocumentSnapshot doc, this.viewPage, this.referralModel}) {
    if (referralModel == null) {
      referralModel = new ReferralModel();
    }
    if (doc != null) referralModel.setAll(doc.data);
  }
  @override
  _MyReferralItemState createState() =>
      _MyReferralItemState(referralModel, viewPage);

  factory MyReferralItem3.fromDocument(DocumentSnapshot document) {
    return MyReferralItem3(
      doc: document,
      viewPage: false,
    );
  }
}

class _MyReferralItemState extends State<MyReferralItem3>
    with SingleTickerProviderStateMixin {
  int numComments = 0;
  final bool viewPage;
  final firestore = Firestore.instance;

  bool _viewProfile = false;
  final ReferralModel referralModel;

  _MyReferralItemState(this.referralModel, this.viewPage);

  Route _createRoute() {
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
      margin: EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 3),
        ],
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.cyan,
                      radius: 25,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: referralModel
                                  .getModel[ReferralConstants.REFERRAL_AUTHOR]
                              [ProfileConstants.PROFILE_PIC_URL],
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                          width: 48.0,
                          height: 48.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.referralModel.getModel[ReferralConstants
                                      .REFERRAL_AUTHOR][ProfileConstants.NAME]
                                  [ProfileConstants.FIRST_NAME] +
                              " " +
                              widget.referralModel.getModel[ReferralConstants
                                      .REFERRAL_AUTHOR][ProfileConstants.NAME]
                                  [ProfileConstants.LAST_NAME],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          widget.referralModel
                                  .getModel[ReferralConstants.REFERRAL_AUTHOR]
                              [ProfileConstants.HEADLINE],
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500]),
                        ),
                        Text(
                          Util.readTimestamp(widget.referralModel
                              .getModel[ReferralConstants.POST_DATE]),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500]),
                        )
                      ],
                    ),
                    Spacer(),
                    IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: Colors.black,
                        ),
                        onPressed: () {})
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: 50,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 6),
                                      blurRadius: 5,
                                      color: Colors.grey)
                                ]),
                            child: Center(
                              child: ShaderMask(
                                blendMode: BlendMode.srcATop,
                                shaderCallback: (bounds) => RadialGradient(
                                  center: Alignment.center,
                                  radius: 0.5,
                                  colors: [Util.getColor1(), Util.getColor2()],
                                  tileMode: TileMode.mirror,
                                ).createShader(bounds),
                                child: Icon(
                                  LineAwesomeIcons.black_tie,
                                  size: 30.0,
                                  color: Colors.cyan,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Wrap(children: [
                            Text(referralModel.getModel[ReferralConstants.ROLE],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500))
                          ])
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: 50,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 6),
                                      blurRadius: 5,
                                      color: Colors.grey)
                                ]),
                            child: Center(
                              child: ShaderMask(
                                blendMode: BlendMode.srcATop,
                                shaderCallback: (bounds) => RadialGradient(
                                  center: Alignment.center,
                                  radius: 0.5,
                                  colors: [Util.getColor1(), Util.getColor2()],
                                  tileMode: TileMode.mirror,
                                ).createShader(bounds),
                                child: Icon(
                                  LineAwesomeIcons.building,
                                  size: 30.0,
                                  color: Colors.cyan,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Wrap(children: [
                            Text(
                                referralModel
                                    .getModel[ReferralConstants.COMPANY],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500))
                          ])
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: 50,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 6),
                                      blurRadius: 5,
                                      color: Colors.grey)
                                ]),
                            child: Center(
                              child: ShaderMask(
                                blendMode: BlendMode.srcATop,
                                shaderCallback: (bounds) => RadialGradient(
                                  center: Alignment.center,
                                  radius: 0.5,
                                  colors: [Util.getColor1(), Util.getColor2()],
                                  tileMode: TileMode.mirror,
                                ).createShader(bounds),
                                child: Icon(
                                  LineAwesomeIcons.map_marker,
                                  size: 30.0,
                                  color: Colors.cyan,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Wrap(children: [
                            Text(
                                referralModel
                                    .getModel[ReferralConstants.LOCATION],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500))
                          ])
                        ],
                      ),
                    ),
                    if (referralModel.getModel[ReferralConstants.CTC] != '')
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 50,
                              width: 50,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 6),
                                        blurRadius: 5,
                                        color: Colors.grey)
                                  ]),
                              child: Center(
                                child: ShaderMask(
                                  blendMode: BlendMode.srcATop,
                                  shaderCallback: (bounds) => RadialGradient(
                                    center: Alignment.center,
                                    radius: 0.5,
                                    colors: [
                                      Util.getColor1(),
                                      Util.getColor2()
                                    ],
                                    tileMode: TileMode.mirror,
                                  ).createShader(bounds),
                                  child: Icon(
                                    LineAwesomeIcons.dollar,
                                    size: 30.0,
                                    color: Colors.cyan,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Wrap(children: [
                              Text(
                                  referralModel.getModel[ReferralConstants.CTC],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500))
                            ])
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.cyan[50],
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (_viewProfile)
                          _viewProfile = false;
                        else
                          _viewProfile = true;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Requirements",
                          style: TextStyle(
                              fontSize: 14,
                              height: 1.38,
                              fontWeight: FontWeight.w500),
                        ),
                        Icon(
                          _viewProfile
                              ? LineAwesomeIcons.angle_up
                              : LineAwesomeIcons.angle_down,
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedSize(
                    vsync: this,
                    duration: Duration(milliseconds: 150),
                    curve: Curves.fastOutSlowIn,
                    child: Container(
                        child: Container(
                            child: !_viewProfile
                                ? null
                                : AnimatedOpacity(
                                    opacity: _viewProfile ? 1.0 : 0.0,
                                    duration: Duration(milliseconds: 1000),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Wrap(
                                            direction: Axis.horizontal,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.start,
                                            children: <Widget>[
                                              if (referralModel.getModel[
                                                      ReferralConstants
                                                          .EXPERIENCE]
                                                  .toString()
                                                  .isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0, top: 8),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .cyan),
                                                            gradient:
                                                                LinearGradient(
                                                                    colors: [
                                                                  Util.getColor1(),
                                                                  Util.getColor2()
                                                                ]),
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        50),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        50))),
                                                        child: Text(
                                                          "Experience",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .cyan),
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        50),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        50))),
                                                        child: Text(referralModel
                                                                    .getModel[
                                                                ReferralConstants
                                                                    .EXPERIENCE] +
                                                            " Years"),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              if (referralModel
                                                  .getModel[ReferralConstants
                                                      .COLLEGE_REQ]
                                                  .isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0, top: 8),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .cyan),
                                                            gradient:
                                                                LinearGradient(
                                                                    colors: [
                                                                  Util.getColor1(),
                                                                  Util.getColor2()
                                                                ]),
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        50),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        50))),
                                                        child: Text(
                                                          "College",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .cyan),
                                                              borderRadius: BorderRadius.only(
                                                                  topRight:
                                                                      Radius.circular(
                                                                          50),
                                                                  bottomRight:
                                                                      Radius.circular(
                                                                          50))),
                                                          child: Text(referralModel
                                                              .getModel[
                                                                  ReferralConstants
                                                                      .COLLEGE_REQ]
                                                              .toString()
                                                              .replaceAll("[", "")
                                                              .replaceAll("]", "")))
                                                    ],
                                                  ),
                                                ),
                                              if (referralModel
                                                  .getModel[ReferralConstants
                                                      .GRADUATION_REQ]
                                                  .isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0, top: 8),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .cyan),
                                                            gradient:
                                                                LinearGradient(
                                                                    colors: [
                                                                  Util.getColor1(),
                                                                  Util.getColor2()
                                                                ]),
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        50),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        50))),
                                                        child: Text(
                                                          "Graduation",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .cyan),
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        50),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        50))),
                                                        child: Text(referralModel
                                                            .getModel[
                                                                ReferralConstants
                                                                    .GRADUATION_REQ]
                                                            .toString()
                                                            .replaceAll("[", "")
                                                            .replaceAll(
                                                                "]", "")),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              if (referralModel.getModel[
                                                      ReferralConstants
                                                          .TRAVEL_REQ]
                                                  .toString()
                                                  .isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0, top: 8),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .cyan),
                                                            gradient:
                                                                LinearGradient(
                                                                    colors: [
                                                                  Util.getColor1(),
                                                                  Util.getColor2()
                                                                ]),
                                                            borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        50),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        50))),
                                                        child: Text(
                                                          "Travel",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .cyan),
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        50),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        50))),
                                                        child: Text(referralModel
                                                            .getModel[
                                                                ReferralConstants
                                                                    .TRAVEL_REQ]
                                                            .toString()),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(_createRoute());
                                            },
                                            highlightColor: Colors.cyan,
                                            child: Container(
                                              color: Colors.transparent,
                                              padding: EdgeInsets.all(5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    "View job description",
                                                    style: TextStyle(
                                                        color: Colors.cyan,
                                                        fontSize: 16),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Icon(
                                                    LineAwesomeIcons
                                                        .angle_double_right,
                                                    color: Colors.cyan,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Note",
                                            style: TextStyle(
                                                fontSize: 14,
                                                height: 1.38,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Wrap(
                                            children: <Widget>[
                                              Text(
                                                "You Can Wrap your widget with Flexible Widget and than you can set property of Text using overflow property of Text Widget. you have to set TextOverflow.clip for example:-",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 14, height: 1.38),
                                              )
                                            ],
                                          ),
                                        ]))))),
                Divider(
                  color: Colors.grey,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Center(
                                child: Text(
                          "Requests",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ))),
                        Expanded(
                            child: Center(
                                child: Text("Accepted",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500)))),
                        Expanded(
                            child: Center(
                                child: Text("Referred",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500)))),
                        Expanded(
                            child: Center(
                                child: Text("Interviews",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500)))),
                        Expanded(
                            child: Center(
                                child: Text("Hired",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500)))),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 5,
                                    color: Colors.yellow[800])
                              ]),
                          child: Center(
                              child: FittedBox(
                            child: Text(
                              "30",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  foreground: UIUtil.getTextGradient()),
                            ),
                          )),
                        )),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 5,
                                    color: Colors.yellow[500])
                              ]),
                          child: Center(
                              child: FittedBox(
                            child: Text(
                              "30",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  foreground: UIUtil.getTextGradient()),
                            ),
                          )),
                        )),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 5,
                                    color: Colors.green[200])
                              ]),
                          child: Center(
                              child: FittedBox(
                            child: Text(
                              "30",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  foreground: UIUtil.getTextGradient()),
                            ),
                          )),
                        )),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 5,
                                    color: Colors.green[500])
                              ]),
                          child: Center(
                              child: FittedBox(
                            child: Text(
                              "30",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  foreground: UIUtil.getTextGradient()),
                            ),
                          )),
                        )),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                    color: Colors.green[800])
                              ]),
                          child: Center(
                              child: FittedBox(
                            child: Text(
                              "30",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  foreground: UIUtil.getTextGradient()),
                            ),
                          )),
                        )),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: LinearGradient(
                              colors: [Colors.red[500], Colors.red[200]]),
                          borderRadius: BorderRadius.circular(10)),
                      child: RichText(
                          text: TextSpan(children: [
                        WidgetSpan(
                            child: Icon(
                          LineAwesomeIcons.info_circle,
                          color: Colors.white,
                          size: 18,
                        )),
                        TextSpan(
                            text: " 14 pending actions. ",
                            style: TextStyle(color: Colors.white)),
                        TextSpan(
                            text: "Review now!",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.cyan[800]))
                      ])),
                    )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                if (!viewPage)
                  InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        CustomButton(
                          shadow: false,
                          label: "View requests",
                          icon: LineAwesomeIcons.angle_right,
                          onTap: () {
                            Util.navigate(
                                context,
                                ViewReferralScreen(
                                  referralModel: referralModel,
                                ));
                          },
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                    widget.referralModel
                            .getModel[ReferralConstants.NUM_COMMENTS]
                            .toString() +
                        " Queries • " +
                        widget.referralModel
                            .getModel[ReferralConstants.NUM_SHARES]
                            .toString() +
                        " Shares",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey[500]))
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () {
                    Util.navigate(
                        context, Comments(referralModel: widget.referralModel));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[100])),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: ShaderMask(
                                blendMode: BlendMode.srcATop,
                                shaderCallback: (bounds) => RadialGradient(
                                  center: Alignment.center,
                                  radius: 0.5,
                                  colors: [Util.getColor1(), Util.getColor2()],
                                  tileMode: TileMode.mirror,
                                ).createShader(bounds),
                                child: Icon(
                                  Icons.question_answer,
                                  size: 28.0,
                                  color: Colors.cyan,
                                ),
                              ),
                            ),
                            TextSpan(
                                text: " Queries",
                                style: TextStyle(
                                    fontSize: 18,
                                    foreground: UIUtil.getTextGradient())),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(15)),
                      border: Border.all(color: Colors.grey[100])),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: ShaderMask(
                              blendMode: BlendMode.srcATop,
                              shaderCallback: (bounds) => RadialGradient(
                                center: Alignment.center,
                                radius: 0.5,
                                colors: [Util.getColor1(), Util.getColor2()],
                                tileMode: TileMode.mirror,
                              ).createShader(bounds),
                              child: Icon(
                                LineAwesomeIcons.share,
                                size: 28.0,
                                color: Colors.cyan,
                              ),
                            ),
                          ),
                          TextSpan(
                              text: " Share",
                              style: TextStyle(
                                  fontSize: 18,
                                  foreground: UIUtil.getTextGradient())),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
