import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getreferred/BLoc/FeedProvider.dart';
import 'package:getreferred/ReferralItem.dart';
import 'package:getreferred/constants/ReferralConstants.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  int _feedTabIndex;
  final storage = new FlutterSecureStorage();
  Map<String, dynamic> _referralfeed;
  TabController _feedTabController;
  List feedTabs;
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
    return FutureBuilder(
        future: _feedProvider.getFeed(),
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
    _feedProvider = Provider.of<FeedProvider>(context);
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
                    "Referral Feed",
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
                          tabs: feedTabs
                              .map((f) => Tab(
                                    text: f,
                                  ))
                              .toList(),
                          controller: _feedTabController,
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
