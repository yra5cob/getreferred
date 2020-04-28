import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getreferred/BLoc/MyReferralFeedProvider.dart';
import 'package:getreferred/MyReferralItem.dart';

import 'package:getreferred/ReferralItem.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/helper/UiUtilt.dart';
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
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            title: Text(
              "My Referrals",
              style: Theme.of(context).textTheme.headline.merge(TextStyle(
                  fontWeight: FontWeight.bold,
                  foreground: UIUtil.getTextGradient())),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            centerTitle: false,
            expandedHeight: 105.0,
            pinned: true,
            floating: true,
            snap: true,
            elevation: 5,
            flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.none,
                background: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 45,
                      ),
                      TabBar(
                        tabs: myReferralTabs
                            .map((f) => Container(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    f,
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                ))
                            .toList(),
                        controller: _myReferralTabController,
                        indicatorColor: Colors.cyan[500],
                        indicatorWeight: 5,
                        labelColor: Colors.black,
                        unselectedLabelColor: Theme.of(context).splashColor,
                      ),
                    ],
                  ),
                )),
          )
        ];
      },
      body: Container(color: Colors.transparent, child: _feedTabContent()),
    );
  }
}
