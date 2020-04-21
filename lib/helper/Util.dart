import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Util {
  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static navigate(context, page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static String readTimestamp(Timestamp timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds > 0 &&
        diff.inMinutes == 0 &&
        diff.inHours == 0 &&
        diff.inDays == 0) {
      time = diff.inSeconds.toString() + "sec ago";
    } else if (diff.inMinutes > 0 && diff.inHours == 0 && diff.inDays == 0) {
      time = diff.inMinutes.toString() + "min ago";
    } else if (diff.inHours > 0 && diff.inDays == 0) {
      time = diff.inHours.toString() + "h ago";
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      time = diff.inDays.toString() + 'd ago';
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + 'w ago';
      } else {
        time = (diff.inDays / 7).floor().toString() + 'w ago';
      }
    }

    return time;
  }
}
