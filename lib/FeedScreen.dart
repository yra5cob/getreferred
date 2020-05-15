import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ReferAll/BLoc/FeedProvider.dart';
import 'package:ReferAll/BLoc/ProfileProvider.dart';
import 'package:ReferAll/ReferralItem.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/constants/ReferralConstants.dart';
import 'package:ReferAll/helper/UiUtilt.dart';
import 'package:ReferAll/helper/Util.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:ReferAll/my_flutter_app_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:line_icons/line_icons.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  final storage = new FlutterSecureStorage();
  Map<String, dynamic> _referralfeed;
  TabController _feedTabController;
  List feedTabs;
  int _feedTabIndex;
  FeedProvider _feedProvider;
  ProfileModel _profile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feedTabs = ["Recent", "Saved"];
    _feedTabController = TabController(length: feedTabs.length, vsync: this);
    _feedTabController.addListener(_handleTabControllerTick);
    _feedTabIndex = 0;
  }

  void _handleTabControllerTick() {
    setState(() {
      _feedTabIndex = _feedTabController.index;
    });
  }

  _feedTabContent() {
    if (_feedTabIndex == 0) {
      return _referralFeed();
    } else {
      return Container(
        child: Text("data"),
      );
    }
  }

  Widget _referralFeed() {
    ProfileModel _profile =
        Provider.of<ProfileProvider>(context, listen: false).getProfile();
    return FutureBuilder(
        future:
            _feedProvider.getFeed(_profile.getModel[ProfileConstants.USERNAME]),
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
                      "No referrals",
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
                      child: Image.asset("assets/images/empty_feed6.png"),
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

  Widget _bookmarkedReferralFeed() {
    ProfileModel _profile =
        Provider.of<ProfileProvider>(context, listen: false).getProfile();
    return FutureBuilder(
        future: _feedProvider
            .getBookmarkedFeed(_profile.getModel[ProfileConstants.USERNAME]),
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
                      "Nothing Saved",
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
                        "Help from a stranger is better than sympathy from a relative",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.merge(
                            GoogleFonts.lato(fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Center(
                      child: Image.asset("assets/images/empty_feed2.png"),
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

  @override
  Widget build(BuildContext context) {
    _feedProvider = Provider.of<FeedProvider>(context);
    _profile = Provider.of<ProfileProvider>(context).getProfile();
    return DefaultTabController(
      length: feedTabs.length,
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
                      Tab(text: "Recent"),
                      Tab(text: "Saved"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
              children: [_referralFeed(), _bookmarkedReferralFeed()])),
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
