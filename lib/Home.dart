import 'package:ReferAll/GroupSelectionScreen.dart';
import 'package:ReferAll/my_flutter_app_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ReferAll/BLoc/NotificationProvider.dart';
import 'package:ReferAll/BLoc/ProfileProvider.dart';
import 'package:ReferAll/FeedScreen.dart';
import 'package:ReferAll/LoginPage.dart';
import 'package:ReferAll/MyReferralScreen.dart';
import 'package:ReferAll/NotificationFeedScreen.dart';
import 'package:ReferAll/PostReferral.dart';
import 'package:ReferAll/ReferralItem.dart';
import 'package:ReferAll/ViewProfile.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/constants/ReferralConstants.dart';
import 'package:ReferAll/helper/UiUtilt.dart';
import 'package:ReferAll/helper/Util.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:ReferAll/widget/CustomAppBar.dart';
import 'package:ReferAll/widget/CustomTextField.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
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

  String notificationCount = "0";

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
    } else if (_mainTabIndex == 2) {
      return NotificationFeedScreen();
    } else if (_mainTabIndex == 3) {
      return GroupSelectionScreen();
    } else {
      return Container(
        child: Text("data"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _profile = Provider.of<ProfileProvider>(context).getProfile();
    Provider.of<NotificationProvider>(context)
        .getUnreadMessage(_profile.getModel[ProfileConstants.USERNAME])
        .then((onValue) {
      setState(() {
        notificationCount = onValue.toString();
      });
    });
    return Scaffold(
      key: _homeScaffoldKey,
      appBar: PreferredSize(
        preferredSize:
            Size(double.infinity, MediaQuery.of(context).padding.top + 50),
        child: Container(
          color: Colors.white,
          // decoration: BoxDecoration(boxShadow: [
          //   BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
          // ]),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).padding.top + 50,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Util.hexToColor("#2fc3cf"),
              Util.hexToColor("#2d91ce")
            ])),
            child: Container(
                padding: EdgeInsets.all(8),
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        _homeScaffoldKey.currentState.openDrawer();
                      },
                      child: Stack(children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15,
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
                                      height: 28,
                                      width: 28,
                                      fit: BoxFit.cover,
                                    )),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 15,
                              width: 15,
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.menu,
                                  size: 10,
                                  color: Colors.cyan,
                                ),
                              ),
                            ))
                      ]),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.search),
                              Text("Search"),
                              SizedBox(
                                height: 50,
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey[50],
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey[100],
      drawer: Container(
          color: Colors.white.withOpacity(0.8),
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
                                backgroundColor: Colors.cyan,
                                radius: 25,
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
                                    width: 48,
                                    height: 48,
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
                                  _profile.getModel[ProfileConstants.NAME]
                                          [ProfileConstants.FIRST_NAME] +
                                      " " +
                                      _profile.getModel[ProfileConstants.NAME]
                                          [ProfileConstants.LAST_NAME],
                                  style: GoogleFonts.lato(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Row(
                                  children: <Widget>[
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewProfile()),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                            "View Profile",
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                foreground:
                                                    UIUtil.getTextGradient()),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(" • "),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Provider.of<ProfileProvider>(context,
                                                  listen: false)
                                              .signOut();

                                          Get.off(LoginPage());
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                            "Log out",
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                foreground:
                                                    UIUtil.getTextGradient()),
                                          ),
                                        ),
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
                              color: Colors.grey[800],
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                    SizedBox(
                      height: 10,
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
                        style: GoogleFonts.lato(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // boxShadow: [
              //   BoxShadow(
              //       offset: Offset(0, 6),
              //       blurRadius: 6,
              //       color: Colors.grey[500])
              // ],
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: CircularNotchedRectangle(),
        child: Container(
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
                  height: 50,
                ),
                _mainTabController.index == 0
                    ? ShaderMask(
                        blendMode: BlendMode.srcATop,
                        shaderCallback: (bounds) => RadialGradient(
                          center: Alignment.center,
                          radius: 0.5,
                          colors: [Util.getColor1(), Util.getColor2()],
                          tileMode: TileMode.mirror,
                        ).createShader(bounds),
                        child: IconButton(
                          icon: Icon(Icons.home),
                          iconSize: 30,
                          color: _mainTabController.index == 0
                              ? Colors.green[800]
                              : Colors.green[200],
                          splashColor: Colors.cyan[50],
                          onPressed: () {
                            _mainTabController.index = 0;
                          },
                        ),
                      )
                    : IconButton(
                        icon: Icon(MyFlutterApp.home_solid),
                        color: Colors.grey[500],
                        iconSize: 30,
                        splashColor: Colors.cyan[50],
                        onPressed: () {
                          _mainTabController.index = 0;
                        },
                      ),
                _mainTabController.index == 1
                    ? ShaderMask(
                        blendMode: BlendMode.srcATop,
                        shaderCallback: (bounds) => RadialGradient(
                          center: Alignment.center,
                          radius: 0.5,
                          colors: [Util.getColor1(), Util.getColor2()],
                          tileMode: TileMode.mirror,
                        ).createShader(bounds),
                        child: IconButton(
                          icon: Icon(
                            Icons.insert_drive_file,
                            color: Colors.cyan,
                          ),
                          splashColor: Colors.cyan[50],
                          iconSize: 30,
                          onPressed: () {
                            _mainTabController.index = 1;
                          },
                        ),
                      )
                    : IconButton(
                        color: Colors.grey[500],
                        icon: Icon(
                          MyFlutterApp.file_solid,
                          color: Colors.grey[500],
                        ),
                        splashColor: Colors.cyan[50],
                        iconSize: 30,
                        onPressed: () {
                          _mainTabController.index = 1;
                        },
                      ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: Stack(
                    children: <Widget>[
                      _mainTabController.index == 2
                          ? ShaderMask(
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
                                iconSize: 30,
                                onPressed: () {
                                  _mainTabController.index = 2;
                                },
                              ),
                            )
                          : IconButton(
                              splashColor: Colors.cyan[50],
                              icon: Icon(
                                Icons.notifications_none,
                                color: Colors.grey[500],
                              ),
                              iconSize: 30,
                              onPressed: () {
                                _mainTabController.index = 2;
                              },
                            ),
                      notificationCount != '0'
                          ? Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  notificationCount,
                                  style: GoogleFonts.lato(color: Colors.white),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                _mainTabController.index == 3
                    ? ShaderMask(
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
                          icon: FaIcon(FontAwesomeIcons.users),
                          iconSize: 20,
                          onPressed: () {
                            _mainTabController.index = 3;
                          },
                        ),
                      )
                    : IconButton(
                        color: Colors.grey[500],
                        splashColor: Colors.cyan[50],
                        icon: Icon(MyFlutterApp.users_solid),
                        iconSize: 30,
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
        ),
      ),
    );
  }
}
