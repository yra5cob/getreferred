import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getreferred/BLoc/FeedProvider.dart';
import 'package:getreferred/ReferralItem.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/constants/ReferralConstants.dart';
import 'package:getreferred/helper/UiUtilt.dart';
import 'package:getreferred/helper/Util.dart';
import 'package:getreferred/model/ProfileModel.dart';
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
    ProfileModel _profile = Provider.of<ProfileModel>(context, listen: false);
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
    return DefaultTabController(
      length: feedTabs.length,
      child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text(
                  "Referral Feed",
                  style: Theme.of(context).textTheme.headline.merge(TextStyle(
                      fontWeight: FontWeight.bold, color: Util.getColor2())),
                ),
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                centerTitle: false,
                expandedHeight: 100.0,
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
                            tabs: feedTabs
                                .map((f) => Container(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        f,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                .toList(),
                            indicatorColor: Util.getColor2(),
                            indicatorWeight: 3,
                            labelColor: Util.getColor2(),
                            unselectedLabelColor: Theme.of(context).splashColor,
                          ),
                        ],
                      ),
                    )),
              )
            ];
          },
          body: TabBarView(children: [
            _referralFeed(),
            Text("on2"),
          ])),
    );
  }
}
