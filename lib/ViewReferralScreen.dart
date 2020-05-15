import 'package:flutter/material.dart';
import 'package:ReferAll/BLoc/MyReferralFeedProvider.dart';
import 'package:ReferAll/MyReferralItem.dart';
import 'package:ReferAll/ReferralStatusItemNew.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:ReferAll/helper/Util.dart';
import 'package:ReferAll/constants/ReferralConstants.dart';
import 'package:ReferAll/constants/ReferralRequestConstants.dart';
import 'package:ReferAll/model/ReferralModel.dart';
import 'package:provider/provider.dart';

class ViewReferralScreen extends StatefulWidget {
  final ReferralModel referralModel;

  const ViewReferralScreen({Key key, this.referralModel}) : super(key: key);
  @override
  _ViewReferralScreenState createState() =>
      _ViewReferralScreenState(referralModel);
}

class _ViewReferralScreenState extends State<ViewReferralScreen> {
  final ReferralModel referralModel2;
  ReferralModel referralModel;

  MyReferralFeedProvider _myReferralFeedProvider;

  _ViewReferralScreenState(this.referralModel2);

  @override
  Widget build(BuildContext context) {
    _myReferralFeedProvider = Provider.of<MyReferralFeedProvider>(context);
    referralModel = _myReferralFeedProvider.getReferralModel(
        referralModel2.getModel[ReferralConstants.REFERRAL_ID]);
    var size = MediaQuery.of(context).size;
    final double itemHeight = 350;
    final double itemWidth = size.width / 2;
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Requests"),
          leading: BackButton(),
        ),
        backgroundColor: Colors.blueGrey[50],
        body: DefaultTabController(
            length: 6,
            child: SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
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
                                referralModel
                                    .getModel[ReferralConstants.COMPANY],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          referralModel.getModel[
                                                  ReferralConstants
                                                      .EXPERIENCE] +
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          referralModel.getModel[
                                                  ReferralConstants
                                                      .GRADUATION_REQ]
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                        ],
                      ),
                    ),
                    TabBar(
                      labelColor: Colors.cyan,
                      indicatorColor: Colors.cyan,
                      isScrollable: true,
                      labelStyle: TextStyle(fontSize: 14),
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(
                          text: "Requests",
                        ),
                        Tab(
                          text: "Accepted",
                        ),
                        Tab(
                          text: "Referred",
                        ),
                        Tab(
                          text: "In Process",
                        ),
                        Tab(
                          text: "Hired",
                        ),
                        Tab(
                          text: "Closed",
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(children: [
                        GridView.count(
                            primary: false,
                            padding: const EdgeInsets.all(20),
                            childAspectRatio: (itemWidth / itemHeight),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            children: _getRequestItem()),
                        GridView.count(
                            primary: false,
                            padding: const EdgeInsets.all(20),
                            childAspectRatio: (itemWidth / itemHeight),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            children: _getAcceptedItems()),
                        GridView.count(
                            primary: false,
                            padding: const EdgeInsets.all(20),
                            childAspectRatio: (itemWidth / itemHeight),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            children: _getReferredItems()),
                        GridView.count(
                            primary: false,
                            padding: const EdgeInsets.all(20),
                            childAspectRatio: (itemWidth / itemHeight),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            children: _getInProcessItems()),
                        GridView.count(
                            primary: false,
                            padding: const EdgeInsets.all(20),
                            childAspectRatio: (itemWidth / itemHeight),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            children: _getHiredItem()),
                        GridView.count(
                            primary: false,
                            padding: const EdgeInsets.all(20),
                            childAspectRatio: (itemWidth / itemHeight),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            children: _getClosedItem()),
                      ]),
                    ),
                  ]),
            )),
      ),
    );
  }

  List<Widget> _getRequestItem() {
    List<Widget> items = [];
    referralModel.getRequests.keys.forEach((f) {
      if (referralModel.getRequests[f]
              .getModel[ReferralRequestConstants.CURRENT_STAGE] ==
          ReferralRequestConstants.STAGE_REQUEST_SENT) {
        items.add(ReferralStatusItemNew(
          referralRequestModel: referralModel.getRequests[f],
        ));
      }
    });

    return items;
  }

  List<Widget> _getAcceptedItems() {
    List<Widget> items = [];
    referralModel.getRequests.keys.forEach((f) {
      if (referralModel.getRequests[f]
              .getModel[ReferralRequestConstants.CURRENT_STAGE] ==
          ReferralRequestConstants.STAGE_REQUEST_REFERRAL_ACCEPTED) {
        items.add(ReferralStatusItemNew(
          referralRequestModel: referralModel.getRequests[f],
        ));
      }
    });
    return items;
  }

  List<Widget> _getReferredItems() {
    List<Widget> items = [];
    referralModel.getRequests.keys.forEach((f) {
      if (referralModel.getRequests[f]
                  .getModel[ReferralRequestConstants.CURRENT_STAGE] ==
              ReferralRequestConstants.STAGE_REQUEST_REFERRED ||
          referralModel.getRequests[f]
                  .getModel[ReferralRequestConstants.CURRENT_STAGE] ==
              ReferralRequestConstants.STAGE_REQUEST_REFERRED) {
        items.add(ReferralStatusItemNew(
          referralRequestModel: referralModel.getRequests[f],
        ));
      }
    });
    return items;
  }

  List<Widget> _getInProcessItems() {
    List<Widget> items = [];
    referralModel.getRequests.keys.forEach((f) {
      if (referralModel.getRequests[f]
              .getModel[ReferralRequestConstants.CURRENT_STAGE] ==
          ReferralRequestConstants.STAGE_IN_PROCESS) {
        items.add(ReferralStatusItemNew(
          referralRequestModel: referralModel.getRequests[f],
        ));
      }
    });
    return items;
  }

  List<Widget> _getClosedItem() {
    List<Widget> items = [];
    referralModel.getRequests.keys.forEach((f) {
      if (!referralModel
          .getRequests[f].getModel[ReferralRequestConstants.IS_ACTIVE]) {
        items.add(ReferralStatusItemNew(
          referralRequestModel: referralModel.getRequests[f],
        ));
      }
    });
    return items;
  }

  List<Widget> _getHiredItem() {
    List<Widget> items = [];
    referralModel.getRequests.keys.forEach((f) {
      if (referralModel.getRequests[f]
              .getModel[ReferralRequestConstants.CURRENT_STAGE] ==
          ReferralRequestConstants.STAGE_HIRED) {
        items.add(ReferralStatusItemNew(
          referralRequestModel: referralModel.getRequests[f],
        ));
      }
    });
    return items;
  }
}
