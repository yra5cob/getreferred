import 'package:flutter/material.dart';
import 'package:getreferred/BLoc/CommentsBloc.dart';
import 'package:getreferred/BLoc/CommentsProvider.dart';
import 'package:getreferred/BLoc/FeedProvider.dart';
import 'package:getreferred/BLoc/MyReferralFeedProvider.dart';
import 'package:getreferred/LoadingScreen.dart';
import 'package:getreferred/helper/Util.dart';
import 'package:getreferred/model/ProfileModel.dart';
import 'LoginPage.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ProfileModel()),
          ChangeNotifierProvider(create: (context) => FeedProvider()),
          ChangeNotifierProvider(create: (context) => MyReferralFeedProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
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
