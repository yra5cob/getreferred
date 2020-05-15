import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ReferAll/AuthorMessageView.dart';
import 'package:ReferAll/BLoc/MyReferralFeedProvider.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/constants/ReferralRequestConstants.dart';
import 'package:random_color/random_color.dart';
import 'package:ReferAll/helper/Util.dart';
import 'package:ReferAll/model/ReferralRequestModel.dart';
import 'package:ReferAll/my_flutter_app_icons.dart';
import 'package:ReferAll/widget/CustomButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReferralStatusItemNew extends StatefulWidget {
  final ReferralRequestModel referralRequestModel;
  ReferralStatusItemNew({Key key, this.referralRequestModel}) : super(key: key);

  @override
  _ReferralStatusItemNewState createState() =>
      _ReferralStatusItemNewState(referralRequestModel);
}

class _ReferralStatusItemNewState extends State<ReferralStatusItemNew> {
  final ReferralRequestModel referralRequestModel;
  RandomColor _randomColor = RandomColor();
  _ReferralStatusItemNewState(this.referralRequestModel);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    var myReferralFeedProvider = Provider.of<MyReferralFeedProvider>(context);
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            width: itemWidth,
            height: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, blurRadius: 5, offset: Offset(0, 5))
              ],
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 120,
                ),
                Material(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        referralRequestModel.getModel[ReferralRequestConstants
                                    .REQUESTER][ProfileConstants.NAME]
                                [ProfileConstants.FIRST_NAME] +
                            " " +
                            referralRequestModel.getModel[
                                        ReferralRequestConstants.REQUESTER]
                                    [ProfileConstants.NAME]
                                [ProfileConstants.LAST_NAME],
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        referralRequestModel
                                .getModel[ReferralRequestConstants.REQUESTER]
                            [ProfileConstants.HEADLINE],
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[500]),
                      ),
                      Text(
                        Util.readTimestamp(referralRequestModel.getModel[
                            ReferralRequestConstants.REQUEST_DATETIME]),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Wrap(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(MyFlutterApp.envelope),
                                onPressed: () {
                                  Util.navigate(
                                      context,
                                      AuthorMessageView(
                                        referralRequestModel:
                                            referralRequestModel,
                                      ));
                                }),
                            if (referralRequestModel.getAuthorUnreadMessage() >
                                0)
                              Positioned(
                                child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      referralRequestModel
                                          .getAuthorUnreadMessage()
                                          .toString(),
                                      style: TextStyle(color: Colors.white),
                                    )),
                              )
                          ],
                        ),
                        IconButton(
                            icon: Icon(MyFlutterApp.user_tie_solid),
                            onPressed: () {}),
                        IconButton(
                            icon: Icon(MyFlutterApp.file_pdf_solid),
                            onPressed: () {}),
                      ],
                    ),
                  ],
                ),
                if (referralRequestModel
                        .getModel[ReferralRequestConstants.CURRENT_STAGE] ==
                    ReferralRequestConstants.STAGE_REQUEST_REFERRAL_ACCEPTED)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.cyan)),
                      child: InkWell(
                        onTap: () {
                          var data = {
                            ReferralRequestConstants.STAGE:
                                ReferralRequestConstants.STAGE_REQUEST_REFERRED,
                            ReferralRequestConstants.MESSAGE: '',
                            ReferralRequestConstants.ACTION_DATETIME:
                                Timestamp.now(),
                            ReferralRequestConstants.ATTACHMENT_URL: null,
                            ReferralRequestConstants.IS_ATTACHMENT: false,
                            ReferralRequestConstants.ACTION_BY:
                                ReferralRequestConstants.ACTION_BY_AUTHOR,
                            ReferralRequestConstants.ACTION_SEEN: false,
                          };
                          referralRequestModel
                              .getModel[ReferralRequestConstants.ACTIONS]
                              .add(data);
                          referralRequestModel.getModel[
                              ReferralRequestConstants.LAST_ACTION] = data;
                          referralRequestModel.getModel[
                                  ReferralRequestConstants.CURRENT_STAGE] =
                              ReferralRequestConstants.STAGE_REQUEST_REFERRED;
                          myReferralFeedProvider
                              .saveReferralRequest(referralRequestModel);
                        },
                        splashColor: Colors.cyan[50],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text("Mark Referred"),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (referralRequestModel
                        .getModel[ReferralRequestConstants.CURRENT_STAGE] ==
                    ReferralRequestConstants.STAGE_REQUEST_SENT)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.cyan)),
                      child: InkWell(
                        onTap: () {
                          var data = {
                            ReferralRequestConstants.STAGE:
                                ReferralRequestConstants
                                    .STAGE_REQUEST_REFERRAL_ACCEPTED,
                            ReferralRequestConstants.MESSAGE: '',
                            ReferralRequestConstants.ACTION_DATETIME:
                                Timestamp.now(),
                            ReferralRequestConstants.ATTACHMENT_URL: null,
                            ReferralRequestConstants.IS_ATTACHMENT: false,
                            ReferralRequestConstants.ACTION_BY:
                                ReferralRequestConstants.ACTION_BY_AUTHOR,
                            ReferralRequestConstants.ACTION_SEEN: false,
                          };
                          referralRequestModel
                              .getModel[ReferralRequestConstants.ACTIONS]
                              .add(data);
                          referralRequestModel.getModel[
                              ReferralRequestConstants.LAST_ACTION] = data;
                          referralRequestModel.getModel[
                                  ReferralRequestConstants.CURRENT_STAGE] =
                              ReferralRequestConstants
                                  .STAGE_REQUEST_REFERRAL_ACCEPTED;
                          myReferralFeedProvider
                              .saveReferralRequest(referralRequestModel);
                        },
                        splashColor: Colors.cyan[50],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text("Accept"),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (referralRequestModel
                        .getModel[ReferralRequestConstants.CURRENT_STAGE] ==
                    ReferralRequestConstants.STAGE_REQUEST_REFERRED)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 150,
                          child: Text(
                            "Referral confirmation pending",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                if (referralRequestModel
                        .getModel[ReferralRequestConstants.CURRENT_STAGE] ==
                    ReferralRequestConstants.STAGE_REQUEST_REFERRED)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 150,
                          child: Text(
                            "Referral confirmed",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              color: Colors.cyan,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                if (referralRequestModel
                        .getModel[ReferralRequestConstants.CURRENT_STAGE] ==
                    ReferralRequestConstants.STAGE_IN_PROCESS)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 150,
                          child: Text(
                            "in Process",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              color: Colors.cyan,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                if (referralRequestModel
                        .getModel[ReferralRequestConstants.CURRENT_STAGE] ==
                    ReferralRequestConstants.STAGE_HIRED)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 150,
                          child: Text(
                            "Hired",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              color: Colors.green,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                if (!referralRequestModel
                    .getModel[ReferralRequestConstants.IS_ACTIVE])
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 150,
                          child: Text(
                            "Process ended: " +
                                referralRequestModel.getModel[
                                    ReferralRequestConstants.CLOSE_REASON],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                if (referralRequestModel
                            .getModel[ReferralRequestConstants.CURRENT_STAGE] ==
                        ReferralRequestConstants
                            .STAGE_REQUEST_REFERRAL_ACCEPTED ||
                    referralRequestModel
                            .getModel[ReferralRequestConstants.CURRENT_STAGE] ==
                        ReferralRequestConstants.STAGE_REQUEST_SENT)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.cyan)),
                      child: InkWell(
                        splashColor: Colors.cyan[50],
                        onTap: () {
                          var data = {
                            ReferralRequestConstants.STAGE:
                                ReferralRequestConstants.STAGE_NOT_SUITABLE,
                            ReferralRequestConstants.MESSAGE: '',
                            ReferralRequestConstants.ACTION_DATETIME:
                                Timestamp.now(),
                            ReferralRequestConstants.ATTACHMENT_URL: null,
                            ReferralRequestConstants.IS_ATTACHMENT: false,
                            ReferralRequestConstants.ACTION_BY:
                                ReferralRequestConstants.ACTION_BY_AUTHOR,
                            ReferralRequestConstants.ACTION_SEEN: false,
                          };
                          referralRequestModel
                              .getModel[ReferralRequestConstants.ACTIONS]
                              .add(data);
                          referralRequestModel.getModel[
                              ReferralRequestConstants.LAST_ACTION] = data;
                          referralRequestModel.getModel[
                                  ReferralRequestConstants.CLOSE_REASON] =
                              ReferralRequestConstants
                                  .CLOSE_REASON_CODE_NOT_SUITABLE;
                          referralRequestModel.getModel[ReferralRequestConstants
                              .CLOSE_DATE] = Timestamp.now();
                          referralRequestModel.getModel[
                              ReferralRequestConstants.IS_ACTIVE] = false;
                          referralRequestModel.getModel[
                                  ReferralRequestConstants.CURRENT_STAGE] =
                              ReferralRequestConstants.STAGE_NOT_SUITABLE;
                          myReferralFeedProvider
                              .saveReferralRequest(referralRequestModel);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text("Not Suitable"),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: itemWidth - 25,
              height: 75,
              decoration: BoxDecoration(
                color: Colors.cyan[100],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 5, offset: Offset(0, 5))
                ],
              ),
            ),
          ),
          Positioned(
            top: 45,
            left: (itemWidth / 2) - 40,
            child: CircleAvatar(
              backgroundColor: Colors.cyan,
              radius: 30,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: referralRequestModel
                          .getModel[ReferralRequestConstants.REQUESTER]
                      [ProfileConstants.PROFILE_PIC_URL],
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                  width: 60.0,
                  height: 60.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
