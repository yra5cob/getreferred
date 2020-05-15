import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ReferAll/BLoc/MyReferralFeedProvider.dart';
import 'package:ReferAll/BLoc/ProfileProvider.dart';
import 'package:ReferAll/MyReferralItem.dart';

import 'package:ReferAll/ReferralItem.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/helper/UiUtilt.dart';
import 'package:ReferAll/helper/Util.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyReferralScreen extends StatefulWidget {
  @override
  _MyReferralScreenState createState() => _MyReferralScreenState();
}

class _MyReferralScreenState extends State<MyReferralScreen>
    with SingleTickerProviderStateMixin {
  int _myReferralTabIndex;
  final storage = new FlutterSecureStorage();
  Map<String, dynamic> _myReferralfeed;
  TabController _myReferralTabController;
  List myReferralTabs;
  MyReferralFeedProvider _myReferralFeedProvider;
  ProfileModel _profile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myReferralTabs = ["Posted", "Requested"];
    _myReferralTabController =
        TabController(length: myReferralTabs.length, vsync: this);
    _myReferralTabController.addListener(_handleTabControllerTick);
    _myReferralTabIndex = 0;
  }

  void _handleTabControllerTick() {
    setState(() {
      _myReferralTabIndex = _myReferralTabController.index;
    });
  }

  _feedTabContent() {
    if (_myReferralTabIndex == 0) {
      return _referralFeed();
    } else {
      return _requestedReferralFeed();
    }
  }

  Widget _requestedReferralFeed() {
    ProfileModel _profile =
        Provider.of<ProfileProvider>(context, listen: false).getProfile();
    return FutureBuilder(
        future: _myReferralFeedProvider
            .getRequestedFeed(_profile.getModel[ProfileConstants.USERNAME]),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                padding: const EdgeInsets.only(top: 10.0),
                child: CircularProgressIndicator());
          else {
            if (snapshot.data.keys.length == 0) {
              return Container(
                color: Colors.white60,
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Text(
                      "No referral request",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .merge(GoogleFonts.lato(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        "There is no exercise better for the heart than reaching down and lifting people up",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.merge(
                            GoogleFonts.lato(fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Center(
                      child: Image.asset("assets/images/empty_feed4.png"),
                    ),
                    Spacer(),
                  ],
                ),
              );
            }
            return ListView(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  for (var k in snapshot.data.keys)
                    ReferralItem(
                      referralModel: snapshot.data[k],
                      commentPage: false,
                    ),
                  SizedBox(
                    height: 40,
                  )
                ]);
          }
        });
  }

  Widget _referralFeed() {
    _myReferralFeedProvider = Provider.of<MyReferralFeedProvider>(context);
    _profile = Provider.of<ProfileProvider>(context).getProfile();
    return FutureBuilder(
        future: _myReferralFeedProvider
            .getMyReferralFeed(_profile.getModel[ProfileConstants.USERNAME]),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                padding: const EdgeInsets.only(top: 10.0),
                child: CircularProgressIndicator());
          else {
            if (snapshot.data.keys.length == 0) {
              return Container(
                color: Colors.white60,
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Text(
                      "No referral posted",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .merge(GoogleFonts.lato(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        "There is no exercise better for the heart than reaching down and lifting people up",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.merge(
                            GoogleFonts.lato(fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Center(
                      child: Image.asset("assets/images/empty_feed5.png"),
                    ),
                    Spacer(),
                  ],
                ),
              );
            }
            return ListView(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  for (var k in snapshot.data.keys)
                    MyReferralItem(
                      referralModel: snapshot.data[k],
                    ),
                  SizedBox(
                    height: 50,
                  )
                ]);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myReferralTabs.length,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  indicatorColor: Util.getColor2(),
                  indicatorWeight: 3,
                  labelColor: Util.getColor2(),
                  unselectedLabelColor: Theme.of(context).splashColor,
                  tabs: [
                    Tab(text: "Posted"),
                    Tab(text: "Requested"),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(children: [
          Container(color: Colors.transparent, child: _referralFeed()),
          Container(color: Colors.transparent, child: _requestedReferralFeed()),
        ]),
      ),
    );
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
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
