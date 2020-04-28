import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:getreferred/ProfilePage.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/helper/UiUtilt.dart';
import 'package:getreferred/helper/Util.dart';
import 'package:getreferred/model/ProfileModel.dart';
import 'package:getreferred/profileCreationPage.dart';
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
            style: TextStyle(
                fontSize: 20, height: 1.38, fontWeight: FontWeight.w500),
          ),
          Text(
            _profile.getModel[ProfileConstants.HEADLINE],
            style: TextStyle(
              fontSize: 16,
              height: 1.38,
              color: Colors.grey,
            ),
          ),
          Row(
            children: <Widget>[
              UIUtil.getMasked(LineAwesomeIcons.map_marker, size: 12),
              SizedBox(
                width: 5,
              ),
              Text(
                _profile.getModel[ProfileConstants.CURRENT_LOCATION],
                style: TextStyle(
                  fontSize: 12,
                  height: 1.38,
                  color: Colors.grey,
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
              Text("Personal",
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            foreground: UIUtil.getTextGradient()),
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
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            foreground: UIUtil.getTextGradient()),
                      )),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {})
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
              style: TextStyle(
                  fontSize: 16, height: 1.38, fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  companies[index][ProfileConstants.COMPANY_POSITION] +
                      " • `" +
                      companies[index][ProfileConstants.COMPANY_EMPLOYE_TYPE],
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.38,
                      fontWeight: FontWeight.w500),
                ),
                Row(
                  children: <Widget>[
                    Text(
                        companies[index][ProfileConstants.COMPANY_FROM] +
                            " - " +
                            companies[index][ProfileConstants.COMPANY_TO],
                        style: TextStyle(
                            fontSize: 14,
                            height: 1.38,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500))
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
                        style: TextStyle(
                            fontSize: 12,
                            height: 1.38,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500))
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
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            foreground: UIUtil.getTextGradient()),
                      )),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {})
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
              style: TextStyle(
                  fontSize: 16, height: 1.38, fontWeight: FontWeight.w500),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if (languages[index][ProfileConstants.LANGUAGE_SPEAK])
                  Text("Speak ",
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.38,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500)),
                if (languages[index][ProfileConstants.LANGUAGE_READ])
                  Text("Read ",
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.38,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500)),
                if (languages[index][ProfileConstants.LANGUAGE_WRITE])
                  Text("Write ",
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.38,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500)),
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
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            foreground: UIUtil.getTextGradient()),
                      )),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {})
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
                              style:
                                  TextStyle(height: 1.38, color: Colors.grey)),
                          Text(
                            _profile.getModel[ProfileConstants.ADDITIONAL_INFO]
                                [ProfileConstants.HANDLED_TEAM],
                            style: TextStyle(
                                height: 1.38,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ])),
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Are you willing to work 6 days a week?",
                              style:
                                  TextStyle(height: 1.38, color: Colors.grey)),
                          Text(
                              _profile.getModel[
                                      ProfileConstants.ADDITIONAL_INFO]
                                  [ProfileConstants.SIX_DAYS_WEEK],
                              style: TextStyle(
                                  height: 1.38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ])),
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Are you willing to relocate?",
                              style:
                                  TextStyle(height: 1.38, color: Colors.grey)),
                          Text(
                              _profile.getModel[ProfileConstants
                                  .ADDITIONAL_INFO][ProfileConstants.RELOCATE],
                              style: TextStyle(
                                  height: 1.38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ])),
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                              "Are you open to joining an early stage start-up?",
                              style:
                                  TextStyle(height: 1.38, color: Colors.grey)),
                          Text(
                              _profile.getModel[
                                      ProfileConstants.ADDITIONAL_INFO]
                                  [ProfileConstants.EARLY_STAGE_STARTUP],
                              style: TextStyle(
                                  height: 1.38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ])),
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Willingness to Travel?",
                              style:
                                  TextStyle(height: 1.38, color: Colors.grey)),
                          Text(
                              _profile.getModel[
                                      ProfileConstants.ADDITIONAL_INFO]
                                  [ProfileConstants.TRAVEL_WILLINGNESS],
                              style: TextStyle(
                                  height: 1.38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ])),
                Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Work Permit for USA",
                              style:
                                  TextStyle(height: 1.38, color: Colors.grey)),
                          Text(
                              _profile.getModel[
                                      ProfileConstants.ADDITIONAL_INFO]
                                  [ProfileConstants.USA_PREMIT],
                              style: TextStyle(
                                  height: 1.38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
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
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            foreground: UIUtil.getTextGradient()),
                      )),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {})
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
                          "No resume attached!",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
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
                                style: TextStyle(
                                    color: Colors.cyan,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16),
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
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(
                            fontWeight: FontWeight.bold,
                            foreground: UIUtil.getTextGradient()),
                      )),
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.cyan,
                  ),
                  onPressed: () {})
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
              style: TextStyle(
                  fontSize: 16, height: 1.38, fontWeight: FontWeight.w500),
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
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.38,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                    colleges[index][ProfileConstants.COLLEGE_FROM] +
                        " - " +
                        colleges[index][ProfileConstants.COLLEGE_TO],
                    style: TextStyle(
                        fontSize: 14,
                        height: 1.38,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500))
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
              style: TextStyle(
                fontSize: 16,
                height: 1.38,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              label,
              style: TextStyle(
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
    final _profile = Provider.of<ProfileModel>(context);
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

    Future uploadPic(BuildContext context, File img) async {
      StorageReference storageReference = FirebaseStorage.instance.ref().child(
          "profilePictures/" +
              Provider.of<ProfileModel>(context, listen: false)
                  .model[ProfileConstants.USERNAME]);
      final StorageUploadTask uploadTask = storageReference.putFile(img);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());
      Provider.of<ProfileModel>(context, listen: false)
          .setValue(ProfileConstants.PROFILE_PIC_URL, url);
      print("URL is $url");
    }

    Future getImage() async {
      ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
        if (image != null)
          _cropImage(image).then((img) {
            if (img != null) {
              uploadPic(context, img);
              print('Image Path $img');
            }
          });
      });
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
        body: SafeArea(
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
                child: AnimatedContainer(
                  curve: Curves.linear,
                  alignment: _align,
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: !profview
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _profile.getModel[ProfileConstants.NAME]
                                      [ProfileConstants.FIRST_NAME] +
                                  " " +
                                  _profile.getModel[ProfileConstants.NAME]
                                      [ProfileConstants.LAST_NAME],
                              style: TextStyle(
                                  fontSize: 16,
                                  height: 1.38,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              _profile.getModel[ProfileConstants.HEADLINE],
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.38,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ),
                preferredSize: Size(20, 10)),
            backgroundColor: Colors.white,
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
                background: Image.asset(
                  'assets/images/banner.jpg',
                  fit: BoxFit.cover,
                )),
          ),
          new SliverList(delegate: new SliverChildListDelegate(_buildList(50))),
        ],
      ),
    ));
  }
}
