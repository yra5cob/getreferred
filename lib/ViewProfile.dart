import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:getreferred/constants/ProfileConstants.dart';
import 'package:getreferred/model/ProfileModel.dart';
import 'package:getreferred/profileCreationPage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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

  @override
  Widget build(BuildContext context) {
    final _profile = Provider.of<ProfileModel>(context);

    Widget getColleges() {
      List<Widget> list = new List<Widget>();
      if (_profile.getModel[ProfileConstants.ACADEMICS].length > 0)
        _profile.getModel[ProfileConstants.ACADEMICS].forEach((c) {
          list.add(Container(
              padding: EdgeInsets.all(10),
              child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  c[ProfileConstants.COLLEGE_NAME],
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .merge(TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  c[ProfileConstants.COLLEGE_DEGREE] +
                                      " " +
                                      c[ProfileConstants
                                          .COLLEGE_FIELD_OF_STUDY] +
                                      " [" +
                                      c[ProfileConstants.COLLEGE_COURSE_TYPE] +
                                      "]",
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .merge(TextStyle(
                                          fontWeight: FontWeight.w400)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    c[ProfileConstants.COLLEGE_FROM] +
                                        " - " +
                                        c[ProfileConstants.COLLEGE_TO],
                                    style: Theme.of(context)
                                        .textTheme
                                        .subhead
                                        .merge(TextStyle(
                                            fontWeight: FontWeight.w400))),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ])))));
        });
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: list,
      );
    }

    Widget _getEducation() {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Education",
                  style: Theme.of(context).textTheme.headline,
                )),
            getColleges()
          ]);
    }

    String getSafeValue(item) {
      return item == null ? '' : item;
    }

    Widget _getPersonal() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Personal",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.green[800],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileCreationPage()),
                          );
                        })
                  ])),
          Card(
            elevation: 3,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text("Email:", style: Theme.of(context).textTheme.title),
                    SizedBox(
                      width: 10,
                    ),
                    Text(getSafeValue(
                        _profile.getModel[ProfileConstants.EMAIL])),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Phone:", style: Theme.of(context).textTheme.title),
                    SizedBox(
                      width: 10,
                    ),
                    Text(getSafeValue(
                        _profile.getModel[ProfileConstants.PHONE])),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Gender:", style: Theme.of(context).textTheme.title),
                    SizedBox(
                      width: 10,
                    ),
                    Text(getSafeValue(
                        _profile.getModel[ProfileConstants.GENDER])),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Date of birth:",
                        style: Theme.of(context).textTheme.title),
                    SizedBox(
                      width: 10,
                    ),
                    Text(getSafeValue(_profile.getModel[ProfileConstants.DOB])),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Curren location:",
                        style: Theme.of(context).textTheme.title),
                    SizedBox(
                      width: 10,
                    ),
                    Text(getSafeValue(
                        _profile.getModel[ProfileConstants.CURRENT_LOCATION])),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Preferred Location:",
                        style: Theme.of(context).textTheme.title),
                    SizedBox(
                      width: 10,
                    ),
                    Text(getSafeValue(_profile
                        .getModel[ProfileConstants.PREFERRED_LOCATION])),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Industry:", style: Theme.of(context).textTheme.title),
                    SizedBox(
                      width: 10,
                    ),
                    Text(getSafeValue(
                        _profile.getModel[ProfileConstants.INDUSTRY])),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Functional Area:",
                        style: Theme.of(context).textTheme.title),
                    SizedBox(
                      width: 10,
                    ),
                    Text(getSafeValue(
                        _profile.getModel[ProfileConstants.FUNCTIONAL_AREA])),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Headline:", style: Theme.of(context).textTheme.title),
                    SizedBox(
                      width: 10,
                    ),
                    Text(getSafeValue(
                        _profile.getModel[ProfileConstants.HEADLINE])),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )),
          )
        ],
      );
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
        _getPersonal(),
        _getEducation(),
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
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            snap: false,
            elevation: 50,
            bottom: PreferredSize(
                child: AnimatedContainer(
                  curve: Curves.linear,
                  alignment: _align,
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Yeswanth Kumar",
                    style: TextStyle(
                        fontSize: _fontSize,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                preferredSize: Size(20, 10)),
            backgroundColor: Colors.green[800],
            flexibleSpace: FlexibleSpaceBar(
                stretchModes: [StretchMode.zoomBackground],
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
                title: profview
                    ? Container(
                        padding: EdgeInsets.only(bottom: 30),
                        child: Wrap(
                          direction: Axis.vertical,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.green[800],
                              radius: 50,
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
                                      width: 100.0,
                                      height: 100.0,
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
