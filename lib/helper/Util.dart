import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
//import
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

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

  static Future<String> getFileNameWithExtension(File file) async {
    if (await file.exists()) {
      //To get file name without extension
      //path.basenameWithoutExtension(file.path);

      //return file with file extension
      return path.basename(file.path);
    } else {
      return null;
    }
  }

  static Color getColor1() {
    return Util.hexToColor("#2fc3cf");
  }

  static Color getColor2() {
    return Util.hexToColor("#2d91ce");
  }

// //write to app path
//   static Future<void> writeToFile(String assetPath, String filename) async {
//     //read and write
//     var bytes = await rootBundle.load(assetPath);
//     String dir = (await getApplicationDocumentsDirectory()).path;
//     final buffer = bytes.buffer;
//     return new File('$dir/$filename').writeAsBytes(
//         buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
//   }

  static Future<void> saveFileLocally(
      String networkPath, String filename) async {
    //read and write
    File file = await DefaultCacheManager().getSingleFile(networkPath);
    var bytes = file.readAsBytesSync();
    String dir = (await getApplicationDocumentsDirectory()).path;
    final buffer = bytes.buffer;
    return new File('$dir/$filename').writeAsBytes(
        buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
  }

  static DateTime TimeStampToDateTime(Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(
        timestamp.millisecondsSinceEpoch);
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
