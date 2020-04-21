import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getreferred/MultiSelectAutocompletion.dart';
import 'package:getreferred/autocompeletescreen.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/constants/ReferralConstants.dart';
import 'package:notus/notus.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:convert';
import 'package:getreferred/widget/RichEditor.dart';
import 'package:provider/provider.dart';
import 'package:zefyr/zefyr.dart';
import 'package:getreferred/model/ProfileModel.dart';
import 'package:getreferred/widget/CustomButton.dart';
import 'package:getreferred/widget/CustomDropDown.dart';
import 'package:notus/convert.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:getreferred/widget/CustomTextField.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:getreferred/widget/CustomTouchSearch.dart';

class PostReferral extends StatefulWidget {
  @override
  _PostReferralState createState() => _PostReferralState();
}

class _PostReferralState extends State<PostReferral> {
  TextEditingController roleCtrl;
  TextEditingController companyCtrl;
  TextEditingController levelCtrl;
  TextEditingController ctcCtrl;
  TextEditingController expCtrl;
  String _jddata = '';
  final controller = ScrollController();
  File files;
  Travel_type travel_req;
  List<String> college_req = [];
  List<String> graduation_req = [];
  String jd_type;
  TextEditingController authorNotesCtrls;

  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument() {
    // For simplicity we hardcode a simple document with one line of text
    // saying "Zefyr Quick Start".
    // (Note that delta must always end with newline.)
    final Delta delta = Delta()..insert("Zefyr Quick Start\n");
    return NotusDocument.fromDelta(delta);
  }

  Future<String> getClipBoardData() async {
    Map<String, dynamic> result =
        await SystemChannels.platform.invokeMethod('Clipboard.getData');
    if (result != null) {
      return result['text'].toString();
    }
    return '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
    roleCtrl = new TextEditingController(text: '');
    companyCtrl = new TextEditingController(text: '');
    levelCtrl = new TextEditingController(text: '');
    ctcCtrl = new TextEditingController(text: '');
    expCtrl = new TextEditingController(text: '');
    authorNotesCtrls = new TextEditingController(text: '');
  }

  void showJdBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: new Container(
                    height: MediaQuery.of(context).size.height * 1.2,
                    padding: EdgeInsets.all(10),
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0))),
                    child: new Container(
                      child: FutureBuilder(
                        future: getClipBoardData(),
                        initialData: 'nothing',
                        builder: (context, snapShot) {
                          return Text(snapShot.data.toString());
                        },
                      ),
                    )));
          });
        });
  }

  String getSafeValue(item) {
    return item == null ? '' : item;
  }

  Future uploadFile(BuildContext context, String _rid) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("jd/" + _rid);
    final StorageUploadTask uploadTask = storageReference.putFile(files);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "New referral",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width),
        margin: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            CustomTouchSearch(
              hint: "Role",
              controller: roleCtrl,
              onResult: (s) {
                setState(() {
                  roleCtrl.text = s;
                });
              },
              readonly: true,
            ),
            CustomTouchSearch(
              hint: "Company",
              controller: companyCtrl,
              onResult: (s) {
                setState(() {
                  companyCtrl.text = s;
                });
              },
              readonly: true,
            ),
            CustomTextField(
              hint: "Level",
              controller: levelCtrl,
            ),
            CustomTextField(
              hint: "CTC",
              controller: ctcCtrl,
            ),
            CustomTextField(
              hint: "Experience",
              controller: expCtrl,
            ),
            CustomDropDown(
              hint: "Travel requirment",
              list: Travel_type.values,
              isEnum: true,
              value: travel_req,
              onChanged: (value) {
                setState(() {
                  travel_req = value;
                });
              },
            ),
            Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blueGrey[50],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "College requirement",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 12),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Wrap(
                          children: <Widget>[
                            for (int i = 0; i < college_req.length; i++)
                              Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blueGrey[100],
                                ),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  children: <Widget>[
                                    Container(
                                      child: Text(college_req[i]),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          college_req.removeAt(i);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blueGrey[50],
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: 15,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    onTap: () {
                      final r = Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiSelectAutoCompleteScreen(
                            lst: ['PSG', 'IIM'],
                            hint: "Search year",
                          ),
                        ),
                      );
                      r.then((r) {
                        List<String> s = r as List<String>;
                        setState(() {
                          college_req.addAll(s);
                        });
                      });
                    },
                    label: "+",
                    shadow: false,
                    backgroundColor: Colors.blueGrey,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blueGrey[50],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Graduate year",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 12),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Wrap(
                          children: <Widget>[
                            for (int i = 0; i < graduation_req.length; i++)
                              Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blueGrey[100],
                                ),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  children: <Widget>[
                                    Container(
                                      child: Text(graduation_req[i]),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          graduation_req.removeAt(i);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blueGrey[50],
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: 15,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    label: "+",
                    shadow: false,
                    backgroundColor: Colors.blueGrey,
                    onTap: () {
                      final r = Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiSelectAutoCompleteScreen(
                            lst: ['2020', '2021'],
                            hint: "Search year",
                          ),
                        ),
                      );
                      r.then((r) {
                        List<String> s = r as List<String>;
                        setState(() {
                          graduation_req.addAll(s);
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blueGrey[50],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Job Description",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 100,
                    child: Markdown(
                      controller: controller,
                      selectable: true,
                      data: _jddata,
                      imageDirectory: 'https://raw.githubusercontent.com',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CustomButton(
                        onTap: () {
                          var c = Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RichEditor(),
                            ),
                          );
                          c.then((onValue) {
                            jd_type = ReferralConstants.JD_TYPE_PASTE;
                            _controller = onValue as ZefyrController;
                            NotusDocument n = _controller.document;
                            setState(() {
                              _jddata = notusMarkdown.encode(n.toDelta());
                            });
                          });
                        },
                        label: "Text ",
                        fontSize: 10,
                        shadow: false,
                        icon: Icons.text_fields,
                        backgroundColor: Colors.blueGrey,
                      ),
                      CustomButton(
                        label: "Attach ",
                        onTap: () {
                          jd_type = ReferralConstants.JD_TYPE_LINK;
                          FilePicker.getFile(
                            type: FileType.custom,
                            allowedExtensions: ['pdf', 'doc'],
                          ).then((onValue) {
                            files = onValue;
                            setState(() {
                              _jddata = files.path;
                            });
                          });
                        },
                        fontSize: 10,
                        shadow: false,
                        icon: Icons.attach_file,
                        backgroundColor: Colors.blueGrey,
                      ),
                    ],
                  )
                ],
              ),
            ),
            CustomTextField(
              hint: "Author notes",
              lines: 4,
              controller: authorNotesCtrls,
            ),
            CustomButton(
              label: "Post",
              backgroundColor: Colors.green[800],
              onTap: () {
                final _profile =
                    Provider.of<ProfileModel>(context, listen: false);
                Map<String, dynamic> data = {
                  ReferralConstants.REFERRAL_AUTHOR: {
                    ProfileConstants.NAME: {
                      ProfileConstants.FIRST_NAME:
                          _profile.getModel[ProfileConstants.NAME]
                              [ProfileConstants.FIRST_NAME],
                      ProfileConstants.LAST_NAME:
                          _profile.getModel[ProfileConstants.NAME]
                              [ProfileConstants.LAST_NAME]
                    },
                    ProfileConstants.USERNAME:
                        _profile.getModel[ProfileConstants.USERNAME],
                    ProfileConstants.HEADLINE:
                        _profile.getModel[ProfileConstants.HEADLINE],
                    ProfileConstants.PROFILE_PIC_URL:
                        _profile.getModel[ProfileConstants.PROFILE_PIC_URL]
                  },
                  ReferralConstants.NUM_APPLIED: 0,
                  ReferralConstants.NUM_COMMENTS: 0,
                  ReferralConstants.NUM_SHARES: 0,
                  ReferralConstants.ROLE: roleCtrl.text,
                  ReferralConstants.COMPANY: companyCtrl.text,
                  ReferralConstants.LEVEL: levelCtrl.text,
                  ReferralConstants.CTC: ctcCtrl.text,
                  ReferralConstants.EXPERIENCE: expCtrl.text,
                  ReferralConstants.TRAVEL_REQ:
                      getSafeValue(EnumToString.parseCamelCase(travel_req)),
                  ReferralConstants.COLLEGE_REQ: college_req,
                  ReferralConstants.GRADUATION_REQ: graduation_req,
                  ReferralConstants.JD_TYPE: jd_type,
                  ReferralConstants.JD: _jddata,
                  ReferralConstants.AUTHOR_NOTE: authorNotesCtrls.text,
                  ReferralConstants.ACTIVE: true,
                  ReferralConstants.CLOSE_REASON: "",
                  ReferralConstants.POST_DATE: DateTime.now(),
                  ReferralConstants.CLOSE_DATE: null,
                  ReferralConstants.HIDE: false,
                };
                String id;
                Firestore.instance
                    .collection('referrals')
                    .add(data)
                    .then((DocumentReference doc) {
                  id = doc.documentID;

                  Map<String, dynamic> _rid = {
                    ReferralConstants.REFERRAL_ID: doc.documentID
                  };
                  doc.setData(_rid, merge: true).then((onValue) {
                    if (jd_type == ReferralConstants.JD_TYPE_LINK) {
                      uploadFile(context, id).then((onValue) {
                        Navigator.pop(context);
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  });
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
