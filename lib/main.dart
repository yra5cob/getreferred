import 'package:ReferAll/BLoc/DynamicLinkProvider.dart';
import 'package:ReferAll/Comments.dart';
import 'package:flutter/material.dart';
import 'package:ReferAll/BLoc/FeedProvider.dart';
import 'package:ReferAll/BLoc/MyReferralFeedProvider.dart';
import 'package:ReferAll/BLoc/NotificationProvider.dart';
import 'package:ReferAll/BLoc/ProfileProvider.dart';
import 'package:ReferAll/LoadingScreen.dart';
import 'package:ReferAll/helper/Util.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:get/get.dart';
import 'LoginPage.dart';
import 'package:provider/provider.dart';
import 'globals.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Globals globals = new Globals();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => FeedProvider()),
          ChangeNotifierProvider(create: (context) => MyReferralFeedProvider()),
          ChangeNotifierProvider(create: (context) => NotificationProvider()),
          ChangeNotifierProvider(create: (context) => ProfileProvider()),
          ChangeNotifierProvider(create: (context) => DynamicLinkProvider()),
        ],
        child: GetMaterialApp(
          navigatorKey: globals.navigatorKey,
          debugShowCheckedModeBanner: false,
          routes: {
            '/comments': (context) => Comments(),
          },
          title: 'ReferAll',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.cyan,
          ),
          home: LoadingScreen(),
        ));
  }
}
