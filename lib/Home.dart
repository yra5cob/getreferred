import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getreferred/FeedScreen.dart';
import 'package:getreferred/LoginPage.dart';
import 'package:getreferred/MyReferralScreen.dart';
import 'package:getreferred/PostReferral.dart';
import 'package:getreferred/ReferralItem.dart';
import 'package:getreferred/ViewProfile.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/constants/ReferralConstants.dart';
import 'package:getreferred/model/ProfileModel.dart';
import 'package:getreferred/widget/CustomAppBar.dart';
import 'package:getreferred/widget/CustomTextField.dart';
import 'package:provider/provider.dart';

final _homeScaffoldKey = GlobalKey<ScaffoldState>();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _mainTabIndex;
  final storage = new FlutterSecureStorage();
  TabController _mainTabController;
  List mainTabs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainTabIndex = 0;

    _mainTabController = TabController(length: 4, vsync: this);
    _mainTabController.addListener(_handleMainTabControllerTick);
  }

  _handleMainTabControllerTick() {
    setState(() {
      _mainTabIndex = _mainTabController.index;
    });
  }

  _mainTabContent() {
    if (_mainTabIndex == 0) {
      return FeedScreen();
    } else if (_mainTabIndex == 1) {
      return MyReferralScreen();
    } else {
      return Container(
        child: Text("data"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _profile = Provider.of<ProfileModel>(context);
    return Scaffold(
      key: _homeScaffoldKey,
      appBar: PreferredSize(
        preferredSize:
            Size(double.infinity, MediaQuery.of(context).padding.top + 100),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
          ]),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).padding.top + 70,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green[800],
            ),
            child: Container(
                padding: EdgeInsets.all(10),
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          _homeScaffoldKey.currentState.openDrawer();
                        },
                        child: Stack(children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 20,
                            child: ClipOval(
                                child: _profile.getModel[
                                            ProfileConstants.PROFILE_PIC_URL] ==
                                        ""
                                    ? Image.asset("assets/images/profile.png")
                                    : CachedNetworkImage(
                                        imageUrl: _profile.getModel[
                                            ProfileConstants.PROFILE_PIC_URL],
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      )),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.menu,
                                  size: 15,
                                  color: Colors.green[800],
                                ),
                              ))
                        ]),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        height: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Search"),
                            Icon(Icons.search)
                          ],
                        ),
                      ),
                      Icon(
                        Icons.navigate_before,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
      drawer: Container(
          color: Colors.white,
          margin: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.30,
              top: MediaQuery.of(context).padding.top),
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.all(0),
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 40,
                                child: Hero(
                                  tag: "profilePic",
                                  child: ClipOval(
                                      child: CachedNetworkImage(
                                    imageUrl: _profile.getModel[
                                        ProfileConstants.PROFILE_PIC_URL],
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.cover,
                                    width: 70,
                                    height: 70,
                                  )),
                                ))),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Yeswanth Kumar",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewProfile()),
                                        );
                                      },
                                      child: Text(
                                        "View profile",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.green[800]),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        storage
                                            .delete(
                                                key: ProfileConstants.USERNAME)
                                            .then((s) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage(),
                                              ),
                                              ModalRoute.withName("/Home"));
                                        });
                                      },
                                      child: Text(
                                        "Log out",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.green[800]),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ))
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                ),
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.settings),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Settings",
                        style: TextStyle(
                          fontSize: 20,
                        ))
                  ],
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          )),
      body: _mainTabContent(),
      floatingActionButton: Container(
        height: 80.0,
        width: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.green[800],
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostReferral()),
                );
              }),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 15,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 10,
              height: 80,
            ),
            IconButton(
              icon: Icon(Icons.home),
              iconSize: 40,
              color: _mainTabController.index == 0
                  ? Colors.green[800]
                  : Colors.green[200],
              onPressed: () {
                _mainTabController.index = 0;
              },
            ),
            IconButton(
              color: _mainTabController.index == 1
                  ? Colors.green[800]
                  : Colors.green[200],
              icon: Icon(Icons.insert_drive_file),
              iconSize: 40,
              onPressed: () {
                _mainTabController.index = 1;
              },
            ),
            SizedBox(
              width: 30,
            ),
            IconButton(
              color: _mainTabController.index == 2
                  ? Colors.green[800]
                  : Colors.green[200],
              icon: Icon(Icons.notifications),
              iconSize: 40,
              onPressed: () {
                _mainTabController.index = 2;
              },
            ),
            IconButton(
              color: _mainTabController.index == 3
                  ? Colors.green[800]
                  : Colors.green[200],
              icon: Icon(Icons.sms),
              iconSize: 40,
              onPressed: () {
                _mainTabController.index = 3;
              },
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }
}
