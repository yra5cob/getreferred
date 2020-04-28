import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getreferred/RequestMoreInfoDialog.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/constants/ReferralRequestConstants.dart';
import 'package:getreferred/helper/UiUtilt.dart';
import 'package:getreferred/helper/Util.dart';
import 'package:getreferred/model/ReferralModel.dart';
import 'package:getreferred/model/ReferralRequestModel.dart';
import 'package:getreferred/widget/CustomButton.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class ReferralStatusItem extends StatefulWidget {
  final ReferralRequestModel referralRequestModel;
  final bool messageBox;
  final bool spcial;

  const ReferralStatusItem(
      {Key key,
      this.referralRequestModel,
      this.messageBox = false,
      this.spcial = false})
      : super(key: key);

  @override
  _ReferralStatusItemState createState() =>
      _ReferralStatusItemState(referralRequestModel, messageBox, spcial);
}

class _ReferralStatusItemState extends State<ReferralStatusItem> {
  final ReferralRequestModel referralRequestModel;
  final bool messageBox;
  final bool spcial;
  _ReferralStatusItemState(
      this.referralRequestModel, this.messageBox, this.spcial);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              blurRadius: 2, offset: Offset(0, 5), color: Colors.grey[400]),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.green[800],
                radius: 25,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: "",
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      referralRequestModel.getModel[ReferralRequestConstants
                                  .REQUESTER][ProfileConstants.NAME]
                              [ProfileConstants.FIRST_NAME] +
                          " " +
                          referralRequestModel.getModel[ReferralRequestConstants
                                  .REQUESTER][ProfileConstants.NAME]
                              [ProfileConstants.LAST_NAME],
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                      Util.readTimestamp(referralRequestModel
                          .getModel[ReferralRequestConstants.REQUEST_DATETIME]),
                      style: TextStyle(
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
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.cyan[50],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(0),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Material(
                          color: Colors.transparent,
                          child: Text(
                            referralRequestModel.getModel[
                                    ReferralRequestConstants.LAST_ACTION]
                                [ReferralRequestConstants.MESSAGE],
                            style: TextStyle(
                              height: 1.38,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return RequestMoreInfo();
                            }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          UIUtil.getMasked(Icons.reply, size: 20),
                          Text(
                            " Request more information",
                            style: TextStyle(
                                fontSize: 14,
                                foreground: UIUtil.getTextGradient()),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          if (messageBox)
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[200],
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Type your reply...",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                  UIUtil.getMasked(Icons.send)
                ],
              ),
            ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Container(
                child: CustomButton(
                  label: "Profile ",
                  icon: LineAwesomeIcons.user,
                ),
              ),
              Container(
                child: CustomButton(
                  label: "Resume ",
                  icon: LineAwesomeIcons.file,
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Material(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
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
                                    colors: [
                                      Util.getColor1(),
                                      Util.getColor2()
                                    ],
                                    tileMode: TileMode.mirror,
                                  ).createShader(bounds),
                                  child: Icon(
                                    Icons.check,
                                    size: 28.0,
                                    color: Colors.cyan,
                                  ),
                                ),
                              ),
                              TextSpan(
                                  text: " Accept",
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
              ),
              Expanded(
                child: Material(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
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
                                    colors: [
                                      Util.getColor1(),
                                      Util.getColor2()
                                    ],
                                    tileMode: TileMode.mirror,
                                  ).createShader(bounds),
                                  child: Icon(
                                    Icons.close,
                                    size: 28.0,
                                    color: Colors.cyan,
                                  ),
                                ),
                              ),
                              TextSpan(
                                  text: " Not suitable",
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
              )
            ],
          )
        ],
      ),
    );
  }
}
