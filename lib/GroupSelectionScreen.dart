import 'package:ReferAll/CreateGroupPage.dart';
import 'package:ReferAll/Home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupSelectionScreen extends StatefulWidget {
  GroupSelectionScreen({Key key}) : super(key: key);

  @override
  _GroupSelectionScreenState createState() => _GroupSelectionScreenState();
}

class _GroupSelectionScreenState extends State<GroupSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.cyan,
          ),
          title: Text("Join a Referral Group",
              style: Theme.of(context).textTheme.headline6.merge(
                  GoogleFonts.lato(
                      fontWeight: FontWeight.bold, color: Colors.black54))),
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    child: InkWell(
                      onTap: () {
                        Get.off(Home());
                      },
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Skip",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .merge(GoogleFonts.lato(color: Colors.cyan)),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 20, color: Colors.cyan)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        border: Border.all(color: Colors.grey[200]),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text("Search groups",
                                style: GoogleFonts.lato(color: Colors.grey)),
                          ),
                          Icon(Icons.search)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateGroupPage()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Create new group",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .merge(GoogleFonts.lato(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.cyan)),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.cyan,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text("Popular groups",
                        style: Theme.of(context).textTheme.headline6.merge(
                            GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
