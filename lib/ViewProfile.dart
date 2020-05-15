import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ReferAll/BLoc/ProfileProvider.dart';
import 'package:ReferAll/ProfilePage.dart';
import 'package:ReferAll/constants/ProfileConstants.dart';
import 'package:ReferAll/helper/UiUtilt.dart';
import 'package:ReferAll/helper/Util.dart';
import 'package:ReferAll/model/ProfileModel.dart';
import 'package:ReferAll/profileCreationPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ViewProfile extends StatefulWidget {
  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  ScrollController _scrollController;
  double scrollOffset = 0.0;
  double _fontSize = 20;
  Alignment _align = Alignment.center;
  bool profview = true;
  final kExpandedHeight = 300;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = new ScrollController(initialScrollOffset: scrollOffset);
    _scrollController.addListener(listen);
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  void listen() {
    double nfs;
    if (_scrollController.offset > 150.0) {
      setState(() {
        if (profview) {
          profview = false;
          _fontSize = 15;
          _align = Alignment.bottomLeft;
        }
      });
    } else {
      setState(() {
        if (!profview) {
          profview = true;
          _fontSize = 30;
          _align = Alignment.center;
        }
      });
    }
  }

  Widget _getPersonal(ProfileModel _profile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _profile.getModel[ProfileConstants.NAME]
                    [ProfileConstants.FIRST_NAME] +
                " " +
                _profile.getModel[ProfileConstants.NAME]
                    [ProfileConstants.LAST_NAME],
            style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            _profile.getModel[ProfileConstants.HEADLINE],
            style: GoogleFonts.lato(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Row(
            children: <Widget>[
              UIUtil.getMasked(LineAwesomeIcons.map_marker, size: 14),
              SizedBox(
                width: 5,
              ),
              Text(
                _profile.getModel[ProfileConstants.CURRENT_LOCATION],
                style: GoogleFonts.lato(
                  fontSize: 14,
                  height: 1.38,
                  color: Colors.grey[500],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Personal", style: UIUtil.getTitleStyle(context)),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileCreationPage(
                                isedit: true,
                              )),
                    );
                  })
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _getPersonalInfoItem(LineAwesomeIcons.envelope,
              _profile.getModel[ProfileConstants.EMAIL], "Email"),
          SizedBox(
            height: 10,
          ),
          _getPersonalInfoItem(LineAwesomeIcons.phone,
              _profile.getModel[ProfileConstants.PHONE], "Phone"),
          SizedBox(
            height: 10,
          ),
          _getPersonalInfoItem(LineAwesomeIcons.user,
              _profile.getModel[ProfileConstants.GENDER], "Gender"),
          SizedBox(
            height: 10,
          ),
          _getPersonalInfoItem(
              LineAwesomeIcons.map_signs,
              _profile.getModel[ProfileConstants.PREFERRED_LOCATION],
              "Location Preferrence"),
          SizedBox(
            height: 10,
          ),
          _getPersonalInfoItem(LineAwesomeIcons.industry,
              _profile.getModel[ProfileConstants.INDUSTRY], "Industry"),
          SizedBox(
            height: 10,
          ),
          _getPersonalInfoItem(
              LineAwesomeIcons.gears,
              _profile.getModel[ProfileConstants.FUNCTIONAL_AREA],
              "Functional Area"),
        ],
      ),
    );
  }

  Widget _getCareer(ProfileModel _profile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Experience",
                  style: Theme.of(context).textTheme.headline6.merge(
                        GoogleFonts.lato(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileCreationPage(
                                isedit: true,
                              )),
                    );
                  })
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _profile.getModel[ProfileConstants.CAREER].length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext ctxt, int index) {
                return _company(
                    index, _profile.getModel[ProfileConstants.CAREER]);
              }),
        ]),
      ),
    );
  }

  Widget _company(int index, List companies) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            leading: UIUtil.getMasked(LineAwesomeIcons.briefcase, size: 40),
            title: Text(
              companies[index][ProfileConstants.COMPANY_NAME],
              style: GoogleFonts.lato(
                  fontSize: 16, height: 1.38, fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  companies[index][ProfileConstants.COMPANY_POSITION] +
                      " • `" +
                      companies[index][ProfileConstants.COMPANY_EMPLOYE_TYPE],
                  style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.38,
                      fontWeight: FontWeight.w600),
                ),
                Row(
                  children: <Widget>[
                    Text(
                        companies[index][ProfileConstants.COMPANY_FROM] +
                            " - " +
                            companies[index][ProfileConstants.COMPANY_TO],
                        style: GoogleFonts.lato(
                            fontSize: 14,
                            height: 1.38,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    UIUtil.getMasked(LineAwesomeIcons.map_marker, size: 14),
                    Text(
                        companies[index][ProfileConstants.COMPANY_LOCATION]
                            .toString(),
                        style: GoogleFonts.lato(
                            fontSize: 12,
                            height: 1.38,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600))
                  ],
                )
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  Widget _getLanguage(ProfileModel _profile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Language",
                  style: Theme.of(context).textTheme.headline6.merge(
                        GoogleFonts.lato(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileCreationPage(
                                isedit: true,
                              )),
                    );
                  })
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _profile.getModel[ProfileConstants.LANGUAGE].length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext ctxt, int index) {
                return _language(
                    index, _profile.getModel[ProfileConstants.LANGUAGE]);
              }),
        ]),
      ),
    );
  }

  Widget _language(int index, List languages) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            leading: UIUtil.getMasked(LineAwesomeIcons.language, size: 40),
            title: Text(
              languages[index][ProfileConstants.LANGUAGE_NAME],
              style: GoogleFonts.lato(
                  fontSize: 16, height: 1.38, fontWeight: FontWeight.w600),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if (languages[index][ProfileConstants.LANGUAGE_SPEAK])
                  Text("Speak ",
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          height: 1.38,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600)),
                if (languages[index][ProfileConstants.LANGUAGE_READ])
                  Text("Read ",
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          height: 1.38,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600)),
                if (languages[index][ProfileConstants.LANGUAGE_WRITE])
                  Text("Write ",
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          height: 1.38,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  Widget _getAdditionalInfo(ProfileModel _profile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Additional Information",
                  style: Theme.of(context).textTheme.headline6.merge(
                        GoogleFonts.lato(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileCreationPage(
                                isedit: true,
                              )),
                    );
                  })
            ],
          ),
          ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Have you handled a team?",
                              style: GoogleFonts.lato(
                                  height: 1.38, color: Colors.grey)),
                          Text(
                            _profile.getModel[ProfileConstants.ADDITIONAL_INFO]
                                [ProfileConstants.HANDLED_TEAM],
                            style: GoogleFonts.lato(
                                height: 1.38,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ])),
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Are you willing to work 6 days a week?",
                              style: GoogleFonts.lato(
                                  height: 1.38, color: Colors.grey)),
                          Text(
                              _profile.getModel[
                                      ProfileConstants.ADDITIONAL_INFO]
                                  [ProfileConstants.SIX_DAYS_WEEK],
                              style: GoogleFonts.lato(
                                  height: 1.38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ])),
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Are you willing to relocate?",
                              style: GoogleFonts.lato(
                                  height: 1.38, color: Colors.grey)),
                          Text(
                              _profile.getModel[ProfileConstants
                                  .ADDITIONAL_INFO][ProfileConstants.RELOCATE],
                              style: GoogleFonts.lato(
                                  height: 1.38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ])),
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                              "Are you open to joining an early stage start-up?",
                              style: GoogleFonts.lato(
                                  height: 1.38, color: Colors.grey)),
                          Text(
                              _profile.getModel[
                                      ProfileConstants.ADDITIONAL_INFO]
                                  [ProfileConstants.EARLY_STAGE_STARTUP],
                              style: GoogleFonts.lato(
                                  height: 1.38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ])),
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Willingness to Travel?",
                              style: GoogleFonts.lato(
                                  height: 1.38, color: Colors.grey)),
                          Text(
                              _profile.getModel[
                                      ProfileConstants.ADDITIONAL_INFO]
                                  [ProfileConstants.TRAVEL_WILLINGNESS],
                              style: GoogleFonts.lato(
                                  height: 1.38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ])),
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Work Permit for USA",
                              style: GoogleFonts.lato(
                                  height: 1.38, color: Colors.grey)),
                          Text(
                              _profile.getModel[
                                      ProfileConstants.ADDITIONAL_INFO]
                                  [ProfileConstants.USA_PREMIT],
                              style: GoogleFonts.lato(
                                  height: 1.38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ])),
              ]),
        ],
      ),
    );
  }

  Widget _resume(ProfileModel _profile) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Resume",
                  style: Theme.of(context).textTheme.headline6.merge(
                        GoogleFonts.lato(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileCreationPage(
                                isedit: true,
                              )),
                    );
                  })
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _profile.getModel[ProfileConstants.RESUME] == ''
                    ? Container(
                        child: Center(
                            child: Text(
                          "No resume attached",
                          style: GoogleFonts.lato(
                              color: Colors.grey, fontSize: 16),
                        )),
                      )
                    : Container(
                        child: Material(
                          child: InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Text(
                                _profile.getModel[ProfileConstants.RESUME],
                                style: GoogleFonts.lato(
                                    color: Colors.cyan, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEducation(ProfileModel _profile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Education",
                  style: Theme.of(context).textTheme.headline6.merge(
                        GoogleFonts.lato(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileCreationPage(
                                isedit: true,
                              )),
                    );
                  })
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _profile.getModel[ProfileConstants.ACADEMICS].length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext ctxt, int index) {
                return _college(
                    index, _profile.getModel[ProfileConstants.ACADEMICS]);
              }),
        ]),
      ),
    );
  }

  Widget _college(int index, List colleges) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            leading:
                UIUtil.getMasked(LineAwesomeIcons.graduation_cap, size: 40),
            title: Text(
              colleges[index][ProfileConstants.COLLEGE_NAME],
              style: GoogleFonts.lato(
                  fontSize: 16, height: 1.38, fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  colleges[index][ProfileConstants.COLLEGE_DEGREE] +
                      " " +
                      colleges[index][ProfileConstants.COLLEGE_FIELD_OF_STUDY] +
                      " [" +
                      colleges[index][ProfileConstants.COLLEGE_COURSE_TYPE] +
                      "]",
                  style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.38,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                    colleges[index][ProfileConstants.COLLEGE_FROM] +
                        " - " +
                        colleges[index][ProfileConstants.COLLEGE_TO],
                    style: GoogleFonts.lato(
                        fontSize: 14,
                        height: 1.38,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600))
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  _getPersonalInfoItem(IconData icon, String data, String label) {
    return Row(
      children: <Widget>[
        UIUtil.getMasked(icon),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              data,
              style: GoogleFonts.lato(
                fontSize: 16,
                height: 1.38,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 12,
                height: 1.38,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _profile = Provider.of<ProfileProvider>(context).getProfile();
    String getSafeValue(item) {
      return item == null ? '' : item;
    }

    Future<File> _cropImage(File img) async {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: img.path,
          aspectRatioPresets: Platform.isAndroid
              ? [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ]
              : [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio5x3,
                  CropAspectRatioPreset.ratio5x4,
                  CropAspectRatioPreset.ratio7x5,
                  CropAspectRatioPreset.ratio16x9
                ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.green[800],
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            title: 'Crop image',
          ));
      if (croppedFile != null) {
        return croppedFile;
      } else {
        return null;
      }
    }

    List _buildList(int count) {
      List<Widget> listItems = List();
      listItems.addAll([
        _getPersonal(_profile),
        _getEducation(_profile),
        _getCareer(_profile),
        _getLanguage(_profile),
        _getAdditionalInfo(_profile),
        _resume(_profile)
      ]);
      return listItems;
    }

    return Scaffold(
        primary: true,
        backgroundColor: Colors.cyan,
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  stretch: true,
                  centerTitle: false,
                  expandedHeight: 150.0,
                  floating: false,
                  pinned: true,
                  snap: false,
                  elevation: 5,
                  bottom: PreferredSize(
                      child: Row(
                        children: <Widget>[
                          !profview
                              ? BackButton(
                                  color: Colors.cyan,
                                )
                              : Container(),
                          Expanded(
                            child: AnimatedContainer(
                              curve: Curves.linear,
                              alignment: _align,
                              duration: const Duration(milliseconds: 300),
                              padding: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              child: !profview
                                  ? Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor: Colors.cyan,
                                          radius: 18,
                                          child: Hero(
                                              tag: "profilePic",
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: _profile.getModel[
                                                      ProfileConstants
                                                          .PROFILE_PIC_URL],
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                  width: 36.0,
                                                  height: 36.0,
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              _profile.getModel[
                                                          ProfileConstants.NAME]
                                                      [ProfileConstants
                                                          .FIRST_NAME] +
                                                  " " +
                                                  _profile.getModel[
                                                          ProfileConstants.NAME]
                                                      [ProfileConstants
                                                          .LAST_NAME],
                                              style: GoogleFonts.lato(
                                                  fontSize: 16,
                                                  height: 1.38,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              _profile.getModel[
                                                  ProfileConstants.HEADLINE],
                                              style: GoogleFonts.lato(
                                                fontSize: 14,
                                                height: 1.38,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ),
                          ),
                        ],
                      ),
                      preferredSize: Size(20, 10)),
                  backgroundColor: Colors.white,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 2,
                      width: 2,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                      stretchModes: [StretchMode.zoomBackground],
                      centerTitle: true,
                      collapseMode: CollapseMode.parallax,
                      title: profview
                          ? Container(
                              child: Wrap(
                              direction: Axis.vertical,
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.cyan,
                                  radius: 30,
                                  child: Hero(
                                      tag: "profilePic",
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: _profile.getModel[
                                              ProfileConstants.PROFILE_PIC_URL],
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit.cover,
                                          width: 60.0,
                                          height: 60.0,
                                        ),
                                      )),
                                )
                              ],
                            ))
                          : null,
                      background: _profile
                                      .getModel[ProfileConstants.COVER_URL] ==
                                  '' ||
                              _profile.getModel[ProfileConstants.COVER_URL] ==
                                  null
                          ? Image.asset(
                              'assets/images/banner.jpg',
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl:
                                  _profile.getModel[ProfileConstants.COVER_URL],
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                            )),
                ),
                new SliverList(
                    delegate: new SliverChildListDelegate(_buildList(50))),
              ],
            ),
          ),
        ));
  }
}
