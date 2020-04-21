import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getreferred/BLoc/MyReferralFeedProvider.dart';

import 'package:getreferred/ReferralItem.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/model/ProfileModel.dart';
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
      return Container(
        child: Text("data"),
      );
    }
  }

  Widget _referralFeed() {
    _myReferralFeedProvider = Provider.of<MyReferralFeedProvider>(context);
    _profile = Provider.of<ProfileModel>(context);
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
            return ListView(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  for (var k in snapshot.data.keys)
                    ReferralItem(
                      referralModel: snapshot.data[k],
                      commentPage: false,
                    ),
                ]);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
              title: null,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              centerTitle: true,
              expandedHeight: 120.0,
              floating: true,
              pinned: true,
              snap: false,
              elevation: 5,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: [StretchMode.zoomBackground],
                centerTitle: false,
                titlePadding: EdgeInsets.all(0),
                collapseMode: CollapseMode.parallax,
                title: Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 0),
                  child: Text(
                    "My Referrals",
                    style: Theme.of(context).textTheme.title.merge(TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green[900])),
                  ),
                ),
              ),
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(100),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        TabBar(
                          tabs: myReferralTabs
                              .map((f) => Tab(
                                    text: f,
                                  ))
                              .toList(),
                          controller: _myReferralTabController,
                          indicatorColor: Colors.green[800],
                          labelColor: Colors.black,
                          unselectedLabelColor: Theme.of(context).splashColor,
                        ),
                      ],
                    ),
                  )))
        ];
      },
      body: Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(bottom: 50),
          child: _feedTabContent()),
    );
  }
}
