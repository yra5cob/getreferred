import 'package:flutter/material.dart';
import 'package:getreferred/MyReferralItem.dart';
import 'package:getreferred/ReferralStatusItem.dart';
import 'package:getreferred/constants/ReferralRequestConstants.dart';
import 'package:getreferred/model/ReferralModel.dart';

class ViewReferralScreen extends StatefulWidget {
  final ReferralModel referralModel;

  const ViewReferralScreen({Key key, this.referralModel}) : super(key: key);
  @override
  _ViewReferralScreenState createState() =>
      _ViewReferralScreenState(referralModel);
}

class _ViewReferralScreenState extends State<ViewReferralScreen> {
  final ReferralModel referralModel;

  _ViewReferralScreenState(this.referralModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: DefaultTabController(
        length: 5,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.cyan,
                expandedHeight: 520.0,
                floating: false,
                pinned: true,
                leading: Container(),
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Container(),
                    background: SafeArea(
                      child: MyReferralItem(
                        referralModel: referralModel,
                      ),
                    )),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.cyan,
                    indicatorColor: Colors.cyan,
                    isScrollable: true,
                    labelStyle: TextStyle(fontSize: 14),
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: "Requests"),
                      Tab(text: "Accepted"),
                      Tab(text: "Referred"),
                      Tab(text: "Interviewed"),
                      Tab(text: "Hired"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(children: [
            SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _getRequestItem()),
            ),
            Text("on2"),
            Text("o3"),
            Text("o4"),
            Text("5"),
          ]),
        ),
      ),
    );
  }

  List<Widget> _getRequestItem() {
    List<Widget> items = [];
    referralModel.getRequests.keys.forEach((f) {
      if (referralModel.getRequests[f]
              .getModel[ReferralRequestConstants.CURRENT_STAGE] ==
          ReferralRequestConstants.STAGE_REQUEST_SENT) {
        items.add(ReferralStatusItem(
          referralRequestModel: referralModel.getRequests[f],
        ));
      }
    });
    return items;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(offset: Offset(0, 1), color: Colors.grey, blurRadius: 4)
            ],
          ),
          child: _tabBar),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
