import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ReferAll/BLoc/FeedProvider.dart';
import 'package:ReferAll/BLoc/MyReferralFeedProvider.dart';
import 'package:ReferAll/BLoc/ProfileProvider.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/constants/ReferralConstants.dart';
import 'package:ReferAll/constants/ReferralRequestConstants.dart';
import 'package:ReferAll/helper/UiUtilt.dart';
import 'package:ReferAll/helper/Util.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:ReferAll/model/ReferralModel.dart';
import 'package:ReferAll/model/ReferralRequestModel.dart';
import 'package:ReferAll/my_flutter_app_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class RequesterMessageVIew extends StatefulWidget {
  final ReferralModel referralModel;
  RequesterMessageVIew({Key key, this.referralModel}) : super(key: key);

  @override
  _RequesterMessageVIewState createState() =>
      _RequesterMessageVIewState(referralModel);
}

class _RequesterMessageVIewState extends State<RequesterMessageVIew> {
  ReferralRequestModel referralRequestModel;
  ReferralModel referralModel;
  ProfileModel _profile;
  FeedProvider feedProvider;
  TextEditingController replyController;
  MyReferralFeedProvider myReferralFeedProvider;
  var formatter = new DateFormat('dd MMMM, yyyy');
  String currentDate;
  _RequesterMessageVIewState(
    this.referralModel,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    referralRequestModel = referralModel.getMyRequest;
    replyController = new TextEditingController();
    feedProvider = Provider.of<FeedProvider>(context, listen: false);
    referralRequestModel.clearRequesterUnreadMEssages();
    feedProvider.saveReferralRequest(referralRequestModel);
  }

  Widget authorMessage(String time, String message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.cyan,
                  radius: 20,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: referralModel
                              .getModel[ReferralConstants.REFERRAL_AUTHOR]
                          [ProfileConstants.PROFILE_PIC_URL],
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: 40.0,
                      height: 40.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          referralModel.getModel[ReferralConstants
                                      .REFERRAL_AUTHOR][ProfileConstants.NAME]
                                  [ProfileConstants.FIRST_NAME] +
                              " " +
                              referralRequestModel.getModel[
                                          ReferralRequestConstants.REQUESTER]
                                      [ProfileConstants.NAME]
                                  [ProfileConstants.LAST_NAME],
                          style: GoogleFonts.lato(
                              fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          " • " + time,
                          style: GoogleFonts.lato(
                              color: Colors.grey, fontSize: 12, height: 1.38),
                        )
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        message,
                        style: GoogleFonts.lato(
                            color: Colors.black, fontSize: 14, height: 1.38),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget requesterMessage(String time, String message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Material(
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.cyan,
                    radius: 20,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: referralRequestModel
                                .getModel[ReferralRequestConstants.REQUESTER]
                            [ProfileConstants.PROFILE_PIC_URL],
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                        width: 40.0,
                        height: 40.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            referralRequestModel.getModel[
                                            ReferralRequestConstants.REQUESTER]
                                        [ProfileConstants.NAME]
                                    [ProfileConstants.FIRST_NAME] +
                                " " +
                                referralRequestModel.getModel[
                                            ReferralRequestConstants.REQUESTER]
                                        [ProfileConstants.NAME]
                                    [ProfileConstants.LAST_NAME],
                            style: GoogleFonts.lato(
                                fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            " • " + time,
                            style: GoogleFonts.lato(
                                color: Colors.grey, fontSize: 12, height: 1.38),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          message,
                          style: GoogleFonts.lato(
                              color: Colors.black, fontSize: 14, height: 1.38),
                        ),
                      ),
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _profile = Provider.of<ProfileProvider>(context).getProfile();
    feedProvider = Provider.of<FeedProvider>(context);
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          leading: BackButton(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      referralModel.getModel[ReferralConstants.REFERRAL_AUTHOR]
                                  [ProfileConstants.NAME]
                              [ProfileConstants.FIRST_NAME] +
                          " " +
                          referralModel.getModel[ReferralConstants
                                  .REFERRAL_AUTHOR][ProfileConstants.NAME]
                              [ProfileConstants.LAST_NAME],
                      style: GoogleFonts.lato(
                          fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      referralModel.getModel[ReferralConstants.REFERRAL_AUTHOR]
                          [ProfileConstants.HEADLINE],
                      style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Material(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                            referralModel.getModel[ReferralConstants.LOCATION],
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
                            referralModel.getModel[ReferralConstants.CTC],
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
                        if (referralModel.getModel[ReferralConstants.EXPERIENCE]
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
                        if (referralModel
                            .getModel[ReferralConstants.COLLEGE_REQ].isNotEmpty)
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
                                    referralModel
                                        .getModel[ReferralConstants.COLLEGE_REQ]
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
                        if (referralModel.getModel[ReferralConstants.TRAVEL_REQ]
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
                                    referralModel
                                        .getModel[ReferralConstants.TRAVEL_REQ]
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
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: referralRequestModel
                      .getModel[ReferralRequestConstants.ACTIONS].length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext ctxt, int i) {
                    var reversedList = new List.from(referralRequestModel
                        .getModel[ReferralRequestConstants.ACTIONS].reversed);

                    Widget date = Container();
                    if (currentDate == null) {
                      currentDate = formatter.format(Util.TimeStampToDateTime(
                          reversedList[i]
                              [ReferralRequestConstants.ACTION_DATETIME]));
                    }

                    if (currentDate !=
                        formatter.format(Util.TimeStampToDateTime(
                            reversedList[i]
                                [ReferralRequestConstants.ACTION_DATETIME]))) {
                      final st = currentDate;
                      date = Row(children: [
                        Expanded(
                            child: Divider(
                          color: Colors.grey,
                        )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(currentDate),
                        ),
                        Expanded(
                            child: Divider(
                          color: Colors.grey,
                        ))
                      ]);
                      currentDate = formatter.format(Util.TimeStampToDateTime(
                          reversedList[i]
                              [ReferralRequestConstants.ACTION_DATETIME]));
                    }
                    if (i == reversedList.length - 1) {
                      date = Row(children: [
                        Expanded(
                            child: Divider(
                          color: Colors.grey,
                        )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(currentDate),
                        ),
                        Expanded(
                            child: Divider(
                          color: Colors.grey,
                        ))
                      ]);
                    }
                    if (reversedList[i][ReferralRequestConstants.ACTION_BY] ==
                        ReferralRequestConstants.ACTION_BY_REQUESTER)
                      return Column(
                        children: <Widget>[
                          requesterMessage(
                              Util.readTimestamp(reversedList[i]
                                  [ReferralRequestConstants.ACTION_DATETIME]),
                              reversedList[i]
                                  [ReferralRequestConstants.MESSAGE]),
                          date,
                        ],
                      );
                    else
                      return Column(children: <Widget>[
                        authorMessage(
                            Util.readTimestamp(reversedList[i]
                                [ReferralRequestConstants.ACTION_DATETIME]),
                            reversedList[i][ReferralRequestConstants.MESSAGE]),
                        date,
                      ]);
                  }),
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                border: Border.all(color: Colors.grey[200]),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        controller: replyController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            hintText: "Type your message...",
                            border: InputBorder.none),
                      ),
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
                        ReferralRequestConstants.STAGE: referralRequestModel
                            .getModel[ReferralRequestConstants.CURRENT_STAGE],
                        ReferralRequestConstants.MESSAGE: replyController.text,
                        ReferralRequestConstants.ACTION_DATETIME:
                            Timestamp.now(),
                        ReferralRequestConstants.ATTACHMENT_URL: null,
                        ReferralRequestConstants.IS_ATTACHMENT: false,
                        ReferralRequestConstants.ACTION_SEEN: false,
                        ReferralRequestConstants.ACTION_BY:
                            ReferralRequestConstants.ACTION_BY_REQUESTER,
                      };
                      referralRequestModel
                          .getModel[ReferralRequestConstants.ACTIONS]
                          .add(action);
                      referralRequestModel
                              .getModel[ReferralRequestConstants.LAST_ACTION] =
                          action;
                      replyController.text = '';
                      feedProvider
                          .saveMyReferralRequest(referralRequestModel)
                          .then((onValue) {});
                    },
                    child: UIUtil.getMasked(LineAwesomeIcons.send, size: 40),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
