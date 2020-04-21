import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:getreferred/Comments.dart';
import 'package:getreferred/ReferralRequestView.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/constants/ReferralConstants.dart';
import 'package:getreferred/helper/Util.dart';
import 'package:getreferred/model/ReferralModel.dart';
import 'package:getreferred/model/ReferralModel.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: commentPage ? EdgeInsets.all(0) : EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          boxShadow: [
            if (!commentPage)
              BoxShadow(
                  color: Colors.grey, offset: Offset(1, 1), blurRadius: 3),
          ],
          color: Colors.white,
          borderRadius: commentPage
              ? BorderRadius.circular(0)
              : BorderRadius.circular(15)),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.green[800],
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
                          width: 50.0,
                          height: 50.0,
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
                          referralModel.getModel[ReferralConstants
                                  .REFERRAL_AUTHOR][ProfileConstants.NAME]
                              [ProfileConstants.FIRST_NAME],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          referralModel
                                  .getModel[ReferralConstants.REFERRAL_AUTHOR]
                              [ProfileConstants.HEADLINE],
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 12),
                        ),
                        Text(
                          Util.readTimestamp(referralModel
                              .getModel[ReferralConstants.POST_DATE]),
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 12),
                        )
                      ],
                    ),
                    Spacer(),
                    IconButton(
                        icon: Icon(Icons.arrow_drop_down), onPressed: () {})
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      referralModel.getModel[ReferralConstants.ROLE] +
                          " • " +
                          referralModel.getModel[ReferralConstants.COMPANY] +
                          " • " +
                          referralModel.getModel[ReferralConstants.LEVEL] +
                          " • " +
                          referralModel.getModel[ReferralConstants.CTC] +
                          " LPA",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      "Requirement",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Experience: " +
                        referralModel.getModel[ReferralConstants.EXPERIENCE] +
                        " Years"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Travel willingness: " +
                        referralModel.getModel[ReferralConstants.TRAVEL_REQ] +
                        ""),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Graduation year: "),
                    for (int i = 0;
                        i <
                            referralModel
                                .getModel[ReferralConstants.GRADUATION_REQ]
                                .length;
                        i++)
                      Text(referralModel
                          .getModel[ReferralConstants.GRADUATION_REQ][i])
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                    referralModel.getModel[ReferralConstants.NUM_COMMENTS]
                            .toString() +
                        " Queries • " +
                        referralModel.getModel[ReferralConstants.NUM_SHARES]
                            .toString() +
                        " Shares",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12))
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () {
                    Util.navigate(context,
                        ReferralRequestView(referralModel: referralModel));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(15)),
                        border: Border.all(color: Colors.grey[100])),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.done, size: 14),
                            ),
                            TextSpan(
                                text: " Request",
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Util.navigate(
                        context, Comments(referralModel: referralModel));
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
                              child: Icon(Icons.question_answer, size: 14),
                            ),
                            TextSpan(
                                text: " Queries",
                                style: TextStyle(color: Colors.black)),
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
                            child: Icon(Icons.share, size: 14),
                          ),
                          TextSpan(
                              text: " Share",
                              style: TextStyle(color: Colors.black)),
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

  factory ReferralItem.fromDocument(DocumentSnapshot document) {
    return ReferralItem(
      doc: document,
      commentPage: false,
    );
  }
}
