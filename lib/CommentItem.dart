import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getreferred/constants/CommentsConstant.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/helper/Util.dart';
import 'package:getreferred/model/CommentModel.dart';
import 'package:intl/intl.dart';

class CommentItem extends StatelessWidget {
  CommentModel commentModel;
  final DocumentSnapshot doc;

  CommentItem({Key key, this.doc, this.commentModel}) {
    if (this.commentModel == null) {
      this.commentModel = new CommentModel();
    } else if (doc != null) commentModel.setAll(doc.data);
  }

  factory CommentItem.fromDocument(DocumentSnapshot document) {
    return CommentItem(
      doc: document,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.green[800],
            radius: 25,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: commentModel.getModel[CommentsConstant.USER]
                    [ProfileConstants.PROFILE_PIC_URL],
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                width: 50.0,
                height: 50.0,
              ),
            ),
          ),
          Expanded(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          color: Colors.blueGrey[50]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            commentModel.getModel[CommentsConstant.USER]
                                        [ProfileConstants.NAME]
                                    [ProfileConstants.FIRST_NAME] +
                                " " +
                                commentModel.getModel[CommentsConstant.USER]
                                        [ProfileConstants.NAME]
                                    [ProfileConstants.LAST_NAME],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            commentModel.getModel[CommentsConstant.USER]
                                [ProfileConstants.HEADLINE],
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          ),
                          Text(
                            Util.readTimestamp(commentModel
                                .getModel[CommentsConstant.DATETIME]),
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            commentModel.getModel[CommentsConstant.COMMENT],
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(Icons.comment, size: 14),
                              ),
                              TextSpan(
                                  text: " • " +
                                      commentModel.getModel[
                                              CommentsConstant.NUM_REPLIES]
                                          .toString() +
                                      " replies",
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        if (commentModel
                                .getModel[CommentsConstant.NUM_REPLIES] >
                            0)
                          Text(
                            "Show previous replies...",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (commentModel.getModel[CommentsConstant.NUM_REPLIES] > 0)
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.green[800],
                              radius: 25,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: commentModel.getModel[
                                              CommentsConstant.LAST_REPLY]
                                          [CommentsConstant.USER]
                                      [ProfileConstants.PROFILE_PIC_URL],
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  width: 50.0,
                                  height: 50.0,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                          color: Colors.blueGrey[50]),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Text(
                                            commentModel.getModel[CommentsConstant.LAST_REPLY]
                                                            [CommentsConstant.USER]
                                                        [ProfileConstants.NAME][
                                                    ProfileConstants
                                                        .FIRST_NAME] +
                                                " " +
                                                commentModel.getModel[
                                                                CommentsConstant
                                                                    .LAST_REPLY]
                                                            [CommentsConstant.USER]
                                                        [ProfileConstants.NAME]
                                                    [ProfileConstants.LAST_NAME],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            commentModel.getModel[
                                                        CommentsConstant
                                                            .LAST_REPLY]
                                                    [CommentsConstant.USER]
                                                [ProfileConstants.HEADLINE],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            Util.readTimestamp(commentModel
                                                        .getModel[
                                                    CommentsConstant.USER]
                                                [CommentsConstant.DATETIME]),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            commentModel.getModel[
                                                    CommentsConstant.LAST_REPLY]
                                                [CommentsConstant.COMMENT],
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 10,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Icon(Icons.comment,
                                                    size: 14),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ])
                  ])))
        ],
      ),
    );
  }
}
