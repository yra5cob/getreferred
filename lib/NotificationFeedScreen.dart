import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ReferAll/BLoc/FeedProvider.dart';
import 'package:ReferAll/BLoc/NotificationProvider.dart';
import 'package:ReferAll/BLoc/ProfileProvider.dart';
import 'package:ReferAll/ReferralItem.dart';
import 'package:ReferAll/constants/NotificationConstants.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/constants/ReferralConstants.dart';
import 'package:ReferAll/helper/UiUtilt.dart';
import 'package:ReferAll/helper/Util.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:ReferAll/my_flutter_app_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:line_icons/line_icons.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class NotificationFeedScreen extends StatefulWidget {
  @override
  _NotificationFeedScreenState createState() => _NotificationFeedScreenState();
}

class _NotificationFeedScreenState extends State<NotificationFeedScreen>
    with RouteAware, SingleTickerProviderStateMixin {
  NotificationProvider notificationProvider;
  @override
  void didPush() {
    // Route was pushed onto navigator and is now topmost route.
    print("push");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    notificationProvider.clearNotification();
    super.dispose();
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
    print("pop");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget _notificationFeed() {
    ProfileModel _profile =
        Provider.of<ProfileProvider>(context, listen: false).getProfile();
    return FutureBuilder(
        future: notificationProvider
            .getNotificationFeed(_profile.getModel[ProfileConstants.USERNAME]),
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
                      "No notification",
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
                      child: Image.asset("assets/images/empty_feed.png"),
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
                    Material(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey[100])),
                      color: snapshot
                              .data[k].getModel[NotificationConstants.IS_READ]
                          ? Colors.white
                          : Colors.cyan[50],
                      child: ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          backgroundColor: Colors.cyan,
                          radius: 20,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data[k]
                                  .getModel[NotificationConstants.ICON_URL],
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                              width: 38.0,
                              height: 38.0,
                            ),
                          ),
                        ),
                        title: Text(
                          snapshot
                              .data[k].getModel[NotificationConstants.TITLE],
                          style: GoogleFonts.lato(
                              fontSize: 14, fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          snapshot.data[k].getModel[NotificationConstants.BODY],
                          style: GoogleFonts.lato(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        trailing: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              Util.readTimestamp(snapshot.data[k].getModel[
                                  NotificationConstants.NOTIFICATION_TIME]),
                              style: GoogleFonts.lato(
                                  fontSize: 10, fontWeight: FontWeight.w300),
                            ),
                            IconButton(
                                icon: Icon(MyFlutterApp.ellipsis_v_solid),
                                onPressed: () {}),
                          ],
                        ),
                      ),
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
    notificationProvider = Provider.of<NotificationProvider>(context);
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[];
        },
        body: _notificationFeed());
  }
}
