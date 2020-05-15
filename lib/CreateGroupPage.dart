import 'package:ReferAll/my_flutter_app_icons.dart';
import 'package:ReferAll/widget/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateGroupPage extends StatefulWidget {
  CreateGroupPage({Key key}) : super(key: key);

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  int privacy;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.cyan,
          ),
          elevation: 0,
          title: Text("Create referral group",
              style: Theme.of(context).textTheme.headline6.merge(
                  GoogleFonts.lato(
                      fontWeight: FontWeight.bold, color: Colors.black54))),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text("Group name",
                            style: Theme.of(context).textTheme.headline6.merge(
                                GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[200]),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: "Name your group",
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text("Group description",
                            style: Theme.of(context).textTheme.headline6.merge(
                                GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[200]),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              maxLines: 5,
                              decoration: InputDecoration(
                                  hintText: "Type your description",
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text("Cover picture",
                            style: Theme.of(context).textTheme.headline6.merge(
                                GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.image,
                                      size: 30,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Add cover photo",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text("Privacy",
                            style: Theme.of(context).textTheme.headline6.merge(
                                GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.public,
                                    size: 30,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Public",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        Text(
                                          "Anyone can find the group and join",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Radio(
                                  value: 1,
                                  groupValue: privacy,
                                  onChanged: (int value) {
                                    setState(() {
                                      privacy = value;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: <Widget>[
                                      Icon(
                                        Icons.public,
                                        color: Colors.grey,
                                        size: 30,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Icon(
                                          Icons.lock,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Semi-private",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        Text(
                                          "Anyone can find the group and join through request",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Radio(
                                  value: 2,
                                  groupValue: privacy,
                                  onChanged: (int value) {
                                    setState(() {
                                      privacy = value;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.lock,
                                    size: 30,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Private",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        Text(
                                          "Only invited members can see the groups",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Radio(
                                  value: 3,
                                  groupValue: privacy,
                                  onChanged: (int value) {
                                    setState(() {
                                      privacy = value;
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: CustomButton(
                      label: "Create group",
                    ),
                  )
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
