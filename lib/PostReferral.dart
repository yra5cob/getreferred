import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ReferAll/BLoc/FeedProvider.dart';
import 'package:ReferAll/BLoc/ProfileProvider.dart';
import 'package:ReferAll/MultiSelectAutocompletion.dart';
import 'package:ReferAll/autocompeletescreen.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/constants/ReferralConstants.dart';
import 'package:ReferAll/helper/UiUtilt.dart';
import 'package:ReferAll/helper/Util.dart';
import 'package:ReferAll/model/ReferralModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:notus/notus.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:convert';
import 'package:ReferAll/widget/RichEditor.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:zefyr/zefyr.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:ReferAll/widget/CustomButton.dart';
import 'package:ReferAll/widget/CustomDropDown.dart';
import 'package:notus/convert.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:ReferAll/widget/CustomTextField.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:ReferAll/widget/CustomTouchSearch.dart';

class PostReferral extends StatefulWidget {
  @override
  _PostReferralState createState() => _PostReferralState();
}

class _PostReferralState extends State<PostReferral> {
  TextEditingController roleCtrl;
  TextEditingController companyCtrl;
  ProgressHUD _progressHUD;
  bool _loading = false;
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
  FeedProvider _feedProvider;

  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  TextEditingController locationCtrl;

  final ReferralModel referralModel = new ReferralModel();

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

  void dismissProgressHUD() {
    setState(() {
      if (_loading) {
        _progressHUD.state.dismiss();
      } else {
        _progressHUD.state.show();
      }

      _loading = !_loading;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _progressHUD = new ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.cyan,
      containerColor: Colors.white,
      borderRadius: 5.0,
      loading: false,
      text: "Posting...",
    );

    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
    roleCtrl = new TextEditingController(text: '');
    companyCtrl = new TextEditingController(text: '');

    ctcCtrl = new TextEditingController(text: '');
    expCtrl = new TextEditingController(text: '');
    authorNotesCtrls = new TextEditingController(text: '');
    locationCtrl = new TextEditingController(text: '');
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

  Future<String> uploadFile(BuildContext context, String _rid) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("jd/" + _rid);
    final StorageUploadTask uploadTask = storageReference.putFile(files);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return url;
  }

  @override
  Widget build(BuildContext context) {
    _feedProvider = Provider.of<FeedProvider>(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text("New Referral",
                style: Theme.of(context).textTheme.headline6.merge(
                    GoogleFonts.lato(
                        fontWeight: FontWeight.bold, color: Colors.black54))),
            leading: BackButton(
              color: Colors.cyan,
            ),
          ),
          floatingActionButton: Container(),
          body: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
                maxWidth: MediaQuery.of(context).size.width),
            margin: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text("Role", style: UIUtil.getTitleStyle(context)),
                      ),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Company",
                          style: UIUtil.getTitleStyle(context),
                        ),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Location",
                          style: UIUtil.getTitleStyle(context),
                        ),
                      ),
                      CustomTouchSearch(
                        hint: "Location",
                        controller: locationCtrl,
                        onResult: (s) {
                          setState(() {
                            locationCtrl.text = s;
                          });
                        },
                        readonly: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "CTC",
                          style: UIUtil.getTitleStyle(context),
                        ),
                      ),
                      CustomTextField(
                        hint: "CTC",
                        controller: ctcCtrl,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Experience",
                          style: UIUtil.getTitleStyle(context),
                        ),
                      ),
                      CustomTextField(
                        hint: "Experience",
                        controller: expCtrl,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Travel Requirments",
                          style: UIUtil.getTitleStyle(context),
                        ),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "College Requirement",
                          style: UIUtil.getTitleStyle(context),
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
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Wrap(
                                    children: <Widget>[
                                      for (int i = 0;
                                          i < college_req.length;
                                          i++)
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          padding: EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 10,
                                              right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
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
                                    builder: (context) =>
                                        MultiSelectAutoCompleteScreen(
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
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Graduation year requirement",
                          style: UIUtil.getTitleStyle(context),
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
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Wrap(
                                    children: <Widget>[
                                      for (int i = 0;
                                          i < graduation_req.length;
                                          i++)
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          padding: EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 10,
                                              right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
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
                              onTap: () {
                                final r = Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MultiSelectAutoCompleteScreen(
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Job Description",
                          style: UIUtil.getTitleStyle(context),
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
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 100,
                              child: Markdown(
                                controller: controller,
                                selectable: true,
                                data: _jddata,
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
                                        _jddata =
                                            notusMarkdown.encode(n.toDelta());
                                      });
                                    });
                                  },
                                  label: "Text ",
                                  fontSize: 10,
                                  shadow: false,
                                  icon: Icons.text_fields,
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
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Additional Notes",
                          style: UIUtil.getTitleStyle(context),
                        ),
                      ),
                      CustomTextField(
                        hint: "Author notes",
                        lines: 4,
                        controller: authorNotesCtrls,
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  label: "Post",
                  onTap: () {
                    dismissProgressHUD();
                    final _profile =
                        Provider.of<ProfileProvider>(context, listen: false)
                            .getProfile();
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
                        ProfileConstants.PUSH_TOKEN:
                            _profile.getModel[ProfileConstants.PUSH_TOKEN],
                        ProfileConstants.PROFILE_PIC_URL:
                            _profile.getModel[ProfileConstants.PROFILE_PIC_URL]
                      },
                      ReferralConstants.NUM_COMMENTS: 0,
                      ReferralConstants.NUM_SHARES: 0,
                      ReferralConstants.ROLE: roleCtrl.text,
                      ReferralConstants.COMPANY: companyCtrl.text,
                      ReferralConstants.CTC: ctcCtrl.text,
                      ReferralConstants.EXPERIENCE: expCtrl.text,
                      ReferralConstants.BOOKMARKS: [],
                      ReferralConstants.REQUESTER_IDS: [],
                      ReferralConstants.LOCATION: locationCtrl.text,
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
                      ReferralConstants.REQUESTS_NUM: 0,
                      ReferralConstants.ACCEPTED_NUM: 0,
                      ReferralConstants.REFERRED_NUM: 0,
                      ReferralConstants.INTERVIEWED_NUM: 0,
                      ReferralConstants.CLOSED_NUM: 0,
                      ReferralConstants.HIRED_NUM: 0,
                      ReferralConstants.PENDING_ACTION_NUM: 0,
                    };

                    referralModel.setAll(data);

                    _feedProvider.postReferral(referralModel).then((onValue) {
                      if (jd_type == ReferralConstants.JD_TYPE_LINK) {
                        _feedProvider
                            .uploadJD(files, referralModel)
                            .then((onValue) {
                          referralModel
                                  .getModel[ReferralConstants.JD_TYPE_LINK] =
                              onValue;
                          _feedProvider
                              .updateReferral(referralModel)
                              .then((onValue) {
                            dismissProgressHUD();
                            Navigator.pop(context);
                          });
                        });
                      } else {
                        dismissProgressHUD();
                        Navigator.pop(context);
                      }
                    });
                  },
                )
              ],
            ),
          ),
        ),
        _progressHUD,
      ],
    );
  }
}
