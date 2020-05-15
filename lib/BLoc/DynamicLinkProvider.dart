import 'dart:async';

import 'package:ReferAll/BLoc/FeedProvider.dart';
import 'package:ReferAll/globals.dart';
import '';
import 'package:ReferAll/BLoc/ProfileProvider.dart';
import 'package:ReferAll/Comments.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/helper/Util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DynamicLinkProvider extends ChangeNotifier {
  BuildContext context;
  Globals globals = new Globals();

  void initDynamicLinks(BuildContext context) async {
    // final PendingDynamicLinkData data =
    //     await FirebaseDynamicLinks.instance.getInitialLink();
    // final Uri deepLink = data?.link;

    // if (deepLink != null) {
    //   Navigator.pushNamed(context, deepLink.path);
    // }
    this.context = context;
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      final String path = deepLink.path;
      var pathArray = path.split('/');
      if (pathArray[1] == "referral") {
        try {
          Map<String, dynamic> data = {"referralId": pathArray[2]};
          globals.navigatorKey.currentState
              .pushNamed('/comments', arguments: data);
        } catch (e) {
          print(e);
        }
      }
    }, onError: (PlatformException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  Future<String> createDynamicLink(
      bool short, String prefix, String title, String description) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://referrall.page.link',
      link: Uri.parse('https://referrall.page.link/' + prefix),
      socialMetaTagParameters:
          SocialMetaTagParameters(description: description, title: title),
      androidParameters: AndroidParameters(
        packageName: 'com.hygriv.referrall',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
        minimumVersion: '0',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }
    return url.toString();
  }
}
