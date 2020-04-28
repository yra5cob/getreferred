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
import 'package:getreferred/helper/UiUtilt.dart';
import 'package:getreferred/helper/Util.dart';
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
          color: Colors.white,
          // decoration: BoxDecoration(boxShadow: [
          //   BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
          // ]),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).padding.top + 70,
          child: Container(
            // decoration: BoxDecoration(
            //     gradient: LinearGradient(colors: [
            //   Util.hexToColor("#2fc3cf"),
            //   Util.hexToColor("#2d91ce")
            // ])),
            child: Container(
                padding: EdgeInsets.all(10),
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                width: MediaQuery.of(context).size.width,
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
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: ClipOval(
                              child: _profile.getModel[
                                          ProfileConstants.PROFILE_PIC_URL] ==
                                      ""
                                  ? Image.asset("assets/images/profile.png")
                                  : CachedNetworkImage(
                                      imageUrl: "",
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      height: 38,
                                      width: 38,
                                      fit: BoxFit.cover,
                                    )),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 20,
                              width: 20,
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.menu,
                                  size: 15,
                                  color: Colors.cyan,
                                ),
                              ),
                            ))
                      ]),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.search,
                          size: 30,
                        ),
                        onPressed: () {})
                  ],
                )),
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey[100],
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
                                backgroundColor: Util.hexToColor("#3ea4f0"),
                                radius: 25,
                                child: Hero(
                                  tag: "profilePic",
                                  child: ClipOval(
                                      child: CachedNetworkImage(
                                    imageUrl: "",
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,
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
                                  "Yeswanth Kumar Rajakumaran",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
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
                                        "View Profile",
                                        style: TextStyle(
                                            fontSize: 14,
                                            foreground:
                                                UIUtil.getTextGradient()),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(" • "),
                                    SizedBox(
                                      width: 5,
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
                                            fontSize: 14,
                                            foreground:
                                                UIUtil.getTextGradient()),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )),
                        IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 35,
                              color: Colors.black,
                            ),
                            onPressed: () {})
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
                decoration: BoxDecoration(color: Colors.blueGrey[50]),
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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 6), blurRadius: 6, color: Colors.grey[500])
            ],
            gradient:
                LinearGradient(colors: [Util.getColor1(), Util.getColor2()]),
          ),
          child: IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostReferral()),
              );
            },
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.grey[400], blurRadius: 1)]),
        child: BottomAppBar(
          elevation: 50,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 10,
                height: 80,
              ),
              ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (bounds) => RadialGradient(
                  center: Alignment.center,
                  radius: 0.5,
                  colors: [Util.getColor1(), Util.getColor2()],
                  tileMode: TileMode.mirror,
                ).createShader(bounds),
                child: IconButton(
                  icon: Icon(Icons.home),
                  iconSize: 40,
                  color: _mainTabController.index == 0
                      ? Colors.green[800]
                      : Colors.green[200],
                  splashColor: Colors.cyan[50],
                  onPressed: () {
                    _mainTabController.index = 0;
                  },
                ),
              ),
              ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (bounds) => RadialGradient(
                  center: Alignment.center,
                  radius: 0.5,
                  colors: [Util.getColor1(), Util.getColor2()],
                  tileMode: TileMode.mirror,
                ).createShader(bounds),
                child: IconButton(
                  color: _mainTabController.index == 1
                      ? Colors.green[800]
                      : Colors.green[200],
                  icon: Icon(Icons.insert_drive_file),
                  splashColor: Colors.cyan[50],
                  iconSize: 40,
                  onPressed: () {
                    _mainTabController.index = 1;
                  },
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Container(
                height: 50,
                width: 50,
                child: Stack(
                  children: <Widget>[
                    ShaderMask(
                      blendMode: BlendMode.srcATop,
                      shaderCallback: (bounds) => RadialGradient(
                        center: Alignment.center,
                        radius: 0.5,
                        colors: [Util.getColor1(), Util.getColor2()],
                        tileMode: TileMode.mirror,
                      ).createShader(bounds),
                      child: IconButton(
                        color: _mainTabController.index == 2
                            ? Colors.green[800]
                            : Colors.green[200],
                        splashColor: Colors.cyan[50],
                        icon: Icon(Icons.notifications),
                        iconSize: 40,
                        onPressed: () {
                          _mainTabController.index = 2;
                        },
                      ),
                    ),
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          "2",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (bounds) => RadialGradient(
                  center: Alignment.center,
                  radius: 0.5,
                  colors: [Util.getColor1(), Util.getColor2()],
                  tileMode: TileMode.mirror,
                ).createShader(bounds),
                child: IconButton(
                  color: _mainTabController.index == 3
                      ? Colors.green[800]
                      : Colors.green[200],
                  splashColor: Colors.cyan[50],
                  icon: Icon(Icons.settings),
                  iconSize: 40,
                  onPressed: () {
                    _mainTabController.index = 3;
                  },
                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
